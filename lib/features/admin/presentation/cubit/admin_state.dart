import 'package:alagy/features/admin/data/models/admin_statistics.dart';
import 'package:alagy/features/admin/data/models/date_filter.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_model.dart';

enum AdminStatus {
  initial,
  loading,
  success,
  error,
  doctorApproved,
  doctorRejected,
}

class AdminState {
  final AdminStatus status;
  final List<DoctorModel> pendingDoctors;
  final List<DoctorModel> approvedDoctors;
  final List<DoctorModel> rejectedDoctors;
  final AdminStatistics? statistics;
  final DateFilter currentFilter;
  final String? errorMessage;

  const AdminState({
    this.status = AdminStatus.initial,
    this.pendingDoctors = const [],
    this.approvedDoctors = const [],
    this.rejectedDoctors = const [],
    this.statistics,
    this.currentFilter = DateFilter.allTime,
    this.errorMessage,
  });

  AdminState copyWith({
    AdminStatus? status,
    List<DoctorModel>? pendingDoctors,
    List<DoctorModel>? approvedDoctors,
    List<DoctorModel>? rejectedDoctors,
    AdminStatistics? statistics,
    DateFilter? currentFilter,
    String? errorMessage,
  }) {
    return AdminState(
      status: status ?? this.status,
      pendingDoctors: pendingDoctors ?? this.pendingDoctors,
      approvedDoctors: approvedDoctors ?? this.approvedDoctors,
      rejectedDoctors: rejectedDoctors ?? this.rejectedDoctors,
      statistics: statistics ?? this.statistics,
      currentFilter: currentFilter ?? this.currentFilter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isLoading => status == AdminStatus.loading;
  bool get isSuccess => status == AdminStatus.success;
  bool get isError => status == AdminStatus.error;
  bool get isDoctorApproved => status == AdminStatus.doctorApproved;
  bool get isDoctorRejected => status == AdminStatus.doctorRejected;
}