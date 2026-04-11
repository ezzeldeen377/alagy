part of 'doctor_dashboard_cubit.dart';

enum DoctorDashboardStatus { initial, loading, success, error }

class DoctorDashboardState {
  final DoctorDashboardStatus status;
  final List<DoctorAppointment> appointments;
  final List<DoctorAppointment> todayAppointments;
  final List<DoctorAppointment> pendingRequests;
  final Map<String, int> statistics;
  final Map<String, dynamic> summary;
  final StatisticsPeriod selectedPeriod;
  final String? errorMessage;
  final String? loadingAppointmentId;

  const DoctorDashboardState({
    this.status = DoctorDashboardStatus.initial,
    this.appointments = const [],
    this.todayAppointments = const [],
    this.pendingRequests = const [],
    this.statistics = const {},
    this.summary = const {},
    this.selectedPeriod = StatisticsPeriod.allTime,
    this.errorMessage,
    this.loadingAppointmentId,
  });

  DoctorDashboardState copyWith({
    DoctorDashboardStatus? status,
    List<DoctorAppointment>? appointments,
    List<DoctorAppointment>? todayAppointments,
    List<DoctorAppointment>? pendingRequests,
    Map<String, int>? statistics,
    Map<String, dynamic>? summary,
    StatisticsPeriod? selectedPeriod,
    String? errorMessage,
    String? loadingAppointmentId,
  }) {
    return DoctorDashboardState(
      status: status ?? this.status,
      appointments: appointments ?? this.appointments,
      todayAppointments: todayAppointments ?? this.todayAppointments,
      pendingRequests: pendingRequests ?? this.pendingRequests,
      statistics: statistics ?? this.statistics,
      summary: summary ?? this.summary,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      errorMessage: errorMessage ?? this.errorMessage,
      loadingAppointmentId: loadingAppointmentId,
    );
  }

  // Helper getters for UI
  int get pendingCount => (summary['pendingCount'] as int?) ?? 0;
  int get completedCount => (summary['completedCount'] as int?) ?? 0;
  double get totalRevenue => (summary['totalRevenue'] as num?)?.toDouble() ?? 0.0;
}