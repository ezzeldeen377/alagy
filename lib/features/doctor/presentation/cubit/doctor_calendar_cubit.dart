import 'package:alagy/features/doctor_details/data/models/doctor_appointment.dart';
import 'package:alagy/features/doctor_details/data/repositories/doctor_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'doctor_calendar_state.dart';

@injectable
class DoctorCalendarCubit extends Cubit<DoctorCalendarState> {
  final DoctorRepository _doctorRepository;

  DoctorCalendarCubit(this._doctorRepository) : super(DoctorCalendarInitial());

  Future<void> loadAppointmentsForDate(String doctorId, DateTime selectedDate) async {
    emit(DoctorCalendarLoading());
    
    try {
      final result = await _doctorRepository.getDoctorAppointmentsAtDate(doctorId, selectedDate);
      
      result.fold(
        (failure) => emit(DoctorCalendarError(failure.message)),
        (appointments) {
          // Create events map with normalized dates as keys
          final events = <DateTime, List<DoctorAppointment>>{};
          final normalizedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
          events[normalizedDate] = appointments;
          
          emit(DoctorCalendarLoaded(
            events: events,
            selectedDayAppointments: appointments,
            selectedDate: normalizedDate,
          ));
        },
      );
    } catch (e) {
      emit(DoctorCalendarError('Failed to load appointments: $e'));
    }
  }

  Future<void> loadAppointmentsForMonth(String doctorId, DateTime month) async {
    emit(DoctorCalendarLoading());
    
    try {
      // Get all days in the month
      final firstDay = DateTime(month.year, month.month, 1);
      final lastDay = DateTime(month.year, month.month + 1, 0);
      
      final events = <DateTime, List<DoctorAppointment>>{};
      
      // Load appointments for each day of the month
      for (int day = 1; day <= lastDay.day; day++) {
        final currentDate = DateTime(month.year, month.month, day);
        final result = await _doctorRepository.getDoctorAppointmentsAtDate(doctorId, currentDate);
        
        result.fold(
          (failure) => {}, // Skip failed days
          (appointments) {
            if (appointments.isNotEmpty) {
              final normalizedDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
              events[normalizedDate] = appointments;
            }
          },
        );
      }
      
      final today = DateTime.now();
      final normalizedToday = DateTime(today.year, today.month, today.day);
      
      emit(DoctorCalendarLoaded(
        events: events,
        selectedDayAppointments: events[normalizedToday] ?? [],
        selectedDate: normalizedToday,
      ));
    } catch (e) {
      emit(DoctorCalendarError('Failed to load monthly appointments: $e'));
    }
  }

  void selectDate(DateTime selectedDate) {
    final currentState = state;
    if (currentState is DoctorCalendarLoaded) {
      final normalizedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      final appointmentsForDay = currentState.events[normalizedDate] ?? [];
      
      emit(currentState.copyWith(
        selectedDate: normalizedDate,
        selectedDayAppointments: appointmentsForDay,
      ));
    }
  }
}