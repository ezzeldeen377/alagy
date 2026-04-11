import 'package:alagy/features/doctor/data/datasources/doctor_dashboard_remote_data_source.dart';
import 'package:alagy/features/doctor/data/repositories/doctor_dashboard_repository.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_appointment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'doctor_dashboard_state.dart';

@injectable
class DoctorDashboardCubit extends Cubit<DoctorDashboardState> {
  final DoctorDashboardRepository _repository;

  DoctorDashboardCubit(this._repository) : super(const DoctorDashboardState());

  Future<void> loadDashboardData(String doctorId, {StatisticsPeriod? period}) async {
    final selectedPeriod = period ?? state.selectedPeriod;
    emit(state.copyWith(status: DoctorDashboardStatus.loading, selectedPeriod: selectedPeriod));

    try {
      final statisticsResult = await _repository.getDoctorStatistics(doctorId, selectedPeriod);
      final todayAppointmentsResult = await _repository.getTodayAppointments(doctorId);
      final pendingRequestsResult = await _repository.getPendingRequests(doctorId);

      statisticsResult.fold(
        (failure) => emit(state.copyWith(status: DoctorDashboardStatus.error, errorMessage: failure.message)),
        (statistics) {
          todayAppointmentsResult.fold(
            (failure) => emit(state.copyWith(status: DoctorDashboardStatus.error, errorMessage: failure.message)),
            (todayAppointments) {
              pendingRequestsResult.fold(
                (failure) => emit(state.copyWith(status: DoctorDashboardStatus.error, errorMessage: failure.message)),
                (pendingRequests) {
                  emit(state.copyWith(
                    status: DoctorDashboardStatus.success,
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
      emit(state.copyWith(status: DoctorDashboardStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> acceptAppointment(String appointmentId) async {
    final result = await _repository.updateAppointmentStatus(
        appointmentId, AppointmentStatus.confirmed);

    result.fold(
      (failure) => emit(state.copyWith(status: DoctorDashboardStatus.error, errorMessage: failure.message)),
      (_) {
        final updatedPendingRequests = state.pendingRequests
            .where((appointment) => appointment.id != appointmentId)
            .toList();
        
        emit(state.copyWith(pendingRequests: updatedPendingRequests));
      },
    );
  }

  Future<void> rejectAppointment(String appointmentId) async {
    final result = await _repository.updateAppointmentStatus(
        appointmentId, AppointmentStatus.cancelled);

    result.fold(
      (failure) => emit(state.copyWith(status: DoctorDashboardStatus.error, errorMessage: failure.message)),
      (_) {
        final updatedPendingRequests = state.pendingRequests
            .where((appointment) => appointment.id != appointmentId)
            .toList();
        
        emit(state.copyWith(pendingRequests: updatedPendingRequests));
      },
    );
  }

  Future<void> loadSummary(String doctorId) async {
    final result = await _repository.getAppointmentSummary(doctorId);
    result.fold(
      (failure) => null, // Silent fail for summary in background
      (summary) => emit(state.copyWith(summary: summary)),
    );
  }

  Future<void> loadPendingAppointments(String doctorId) async {
    emit(state.copyWith(status: DoctorDashboardStatus.loading));
    
    // Load summary in parallel
    loadSummary(doctorId);

    final result = await _repository.getPendingAppointments(doctorId);

    result.fold(
      (failure) => emit(state.copyWith(status: DoctorDashboardStatus.error, errorMessage: failure.message)),
      (appointments) {
        emit(state.copyWith(
          status: DoctorDashboardStatus.success,
          appointments: appointments,
        ));
      },
    );
  }

  Future<void> loadCompletedAppointments(String doctorId) async {
    emit(state.copyWith(status: DoctorDashboardStatus.loading));
    
    // Load summary in parallel
    loadSummary(doctorId);

    final result = await _repository.getCompletedAppointments(doctorId);

    result.fold(
      (failure) => emit(state.copyWith(status: DoctorDashboardStatus.error, errorMessage: failure.message)),
      (appointments) {
        emit(state.copyWith(
          status: DoctorDashboardStatus.success,
          appointments: appointments,
        ));
      },
    );
  }

  Future<void> completeAppointment(String appointmentId) async {
    // Set loading for this specific appointment
    emit(state.copyWith(loadingAppointmentId: appointmentId));

    final result = await _repository.updateAppointmentStatus(
        appointmentId, AppointmentStatus.completed);

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: DoctorDashboardStatus.error, 
          errorMessage: failure.message,
          loadingAppointmentId: null,
        ));
      },
      (_) {
        // Clear loading ID
        emit(state.copyWith(loadingAppointmentId: null));
        // Note: Refreshing will be handled by the UI calling re-load
      },
    );
  }
}
