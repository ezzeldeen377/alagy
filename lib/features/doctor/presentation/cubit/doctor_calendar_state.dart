part of 'doctor_calendar_cubit.dart';


abstract class DoctorCalendarState {
  const DoctorCalendarState();

  @override
  List<Object> get props => [];
}

class DoctorCalendarInitial extends DoctorCalendarState {}

class DoctorCalendarLoading extends DoctorCalendarState {}

class DoctorCalendarLoaded extends DoctorCalendarState {
  final Map<DateTime, List<DoctorAppointment>> events;
  final List<DoctorAppointment> selectedDayAppointments;
  final DateTime selectedDate;

  const DoctorCalendarLoaded({
    required this.events,
    required this.selectedDayAppointments,
    required this.selectedDate,
  });

  DoctorCalendarLoaded copyWith({
    Map<DateTime, List<DoctorAppointment>>? events,
    List<DoctorAppointment>? selectedDayAppointments,
    DateTime? selectedDate,
  }) {
    return DoctorCalendarLoaded(
      events: events ?? this.events,
      selectedDayAppointments: selectedDayAppointments ?? this.selectedDayAppointments,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  @override
  List<Object> get props => [events, selectedDayAppointments, selectedDate];
}

class DoctorCalendarError extends DoctorCalendarState {
  final String message;

  const DoctorCalendarError(this.message);

  @override
  List<Object> get props => [message];
}