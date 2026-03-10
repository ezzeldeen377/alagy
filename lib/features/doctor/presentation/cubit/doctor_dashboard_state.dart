part of 'doctor_dashboard_cubit.dart';

abstract class DoctorDashboardState  {
  const DoctorDashboardState();

  @override
  List<Object> get props => [];
}

class DoctorDashboardInitial extends DoctorDashboardState {}

class DoctorDashboardLoading extends DoctorDashboardState {}

class DoctorDashboardLoaded extends DoctorDashboardState {
  final Map<String, int> statistics;
  final List<DoctorAppointment> todayAppointments;
  final List<DoctorAppointment> pendingRequests;

  DoctorDashboardLoaded({
    required this.statistics,
    required this.todayAppointments,
    required this.pendingRequests,
  });

  DoctorDashboardLoaded copyWith({
    Map<String, int>? statistics,
    List<DoctorAppointment>? todayAppointments,
    List<DoctorAppointment>? pendingRequests,
  }) {
    return DoctorDashboardLoaded(
      statistics: statistics ?? this.statistics,
      todayAppointments: todayAppointments ?? this.todayAppointments,
      pendingRequests: pendingRequests ?? this.pendingRequests,
    );
  }
}

class DoctorDashboardAppointmentsLoaded extends DoctorDashboardState {
  final List<DoctorAppointment> appointments;

  const DoctorDashboardAppointmentsLoaded(this.appointments);

  @override
  List<Object> get props => [appointments];
}

class DoctorDashboardPendingAppointmentsLoaded extends DoctorDashboardState {
  final List<DoctorAppointment> appointments;

  const DoctorDashboardPendingAppointmentsLoaded(this.appointments);

  @override
  List<Object> get props => [appointments];
}

class DoctorDashboardCompletedAppointmentsLoaded extends DoctorDashboardState {
  final List<DoctorAppointment> appointments;

  const DoctorDashboardCompletedAppointmentsLoaded(this.appointments);

  @override
  List<Object> get props => [appointments];
}

class DoctorDashboardError extends DoctorDashboardState {
  final String message;

  DoctorDashboardError(this.message);
}