import 'dart:developer';

import 'package:alagy/features/doctor/data/repositories/doctor_dashboard_repository.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_appointment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'doctor_dashboard_state.dart';

@injectable
class DoctorDashboardCubit extends Cubit<DoctorDashboardState> {
  final DoctorDashboardRepository _repository;

  DoctorDashboardCubit(this._repository) : super(DoctorDashboardInitial());

  Future<void> loadDashboardData(String doctorId) async {
    emit(DoctorDashboardLoading());

    try {
      // Load statistics
      final statisticsResult = await _repository.getDoctorStatistics(doctorId);

      // Load today's appointments
      final todayAppointmentsResult =
          await _repository.getTodayAppointments(doctorId);

      // Load pending requests
      final pendingRequestsResult =
          await _repository.getPendingRequests(doctorId);

      statisticsResult.fold(
        (failure) => emit(DoctorDashboardError(failure.message)),
        (statistics) {
          todayAppointmentsResult.fold(
            (failure) => emit(DoctorDashboardError(failure.message)),
            (todayAppointments) {
              pendingRequestsResult.fold(
                (failure) => emit(DoctorDashboardError(failure.message)),
                (pendingRequests) {
                  emit(DoctorDashboardLoaded(
                    statistics: statistics,
                    todayAppointments: todayAppointments,
                    pendingRequests: pendingRequests,
                  ));
                },
              );
            },
          );
        },
      );
    } catch (e) {
      emit(DoctorDashboardError(e.toString()));
    }
  }

  Future<void> acceptAppointment(String appointmentId) async {
    final currentState = state;
    if (currentState is DoctorDashboardLoaded) {
      final result = await _repository.updateAppointmentStatus(
          appointmentId, AppointmentStatus.confirmed);

      result.fold(
        (failure) => emit(DoctorDashboardError(failure.message)),
        (_) {
          // Remove from pending requests and add to today's appointments if it's today
          final updatedPendingRequests = currentState.pendingRequests
              .where((appointment) => appointment.id != appointmentId)
              .toList();

          emit(currentState.copyWith(pendingRequests: updatedPendingRequests));
        },
      );
    }
  }

  Future<void> rejectAppointment(String appointmentId) async {
    final currentState = state;
    if (currentState is DoctorDashboardLoaded) {
      final result = await _repository.updateAppointmentStatus(
          appointmentId, AppointmentStatus.cancelled);

      result.fold(
        (failure) => emit(DoctorDashboardError(failure.message)),
        (_) {
          // Remove from pending requests
          final updatedPendingRequests = currentState.pendingRequests
              .where((appointment) => appointment.id != appointmentId)
              .toList();

          emit(currentState.copyWith(pendingRequests: updatedPendingRequests));
        },
      );
    }
  }

  Future<void> loadAllAppointments(String doctorId) async {
    emit(DoctorDashboardLoading());

    final result = await _repository.getAllAppointments(doctorId);

    result.fold(
      (failure) => emit(DoctorDashboardError(failure.message)),
      (appointments) => emit(DoctorDashboardAppointmentsLoaded(appointments)),
    );
  }

  Future<void> loadPendingAppointments(String doctorId) async {
    emit(DoctorDashboardLoading());

    final result = await _repository.getPendingAppointments(doctorId);

    result.fold(
      (failure) => emit(DoctorDashboardError(failure.message)),
      (appointments) {
        log("pending appointments: $appointments");
        emit(DoctorDashboardPendingAppointmentsLoaded(appointments));
      },
    );
  }

  Future<void> loadCompletedAppointments(String doctorId) async {
    emit(DoctorDashboardLoading());

    final result = await _repository.getCompletedAppointments(doctorId);

    result.fold(
      (failure) => emit(DoctorDashboardError(failure.message)),
      (appointments) {
        log("completed appointments: $appointments");
        emit(DoctorDashboardCompletedAppointmentsLoaded(appointments));
      },
    );
  }
}
