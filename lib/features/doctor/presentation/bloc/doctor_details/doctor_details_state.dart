// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alagy/features/doctor/data/models/doctor_model.dart';

enum DoctorDetailsStatus {
  initial,
  loading,
  success,
  error,
}
class DoctorDetailsState {
  final DoctorDetailsStatus status;
  final DoctorModel? selectedDoctor;
  final int? userRate;
  final String? errorMessage;

  const DoctorDetailsState({
    this.status = DoctorDetailsStatus.initial,
    this.selectedDoctor,
    this.userRate,
    this.errorMessage,
  });

  DoctorDetailsState copyWith({
    DoctorDetailsStatus? status,
    DoctorModel? selectedDoctor,
    int? userRate,
    String? errorMessage,
  }) {
    return DoctorDetailsState(
      status: status ?? this.status,
      selectedDoctor: selectedDoctor ?? this.selectedDoctor,
      userRate: userRate ?? this.userRate,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  
  List<Object?> get props => [status, errorMessage];

  @override
  String toString() {
    return 'DoctorDetailsState(status: $status, selectedDoctor: $selectedDoctor, userRate: $userRate, errorMessage: $errorMessage)';
  }
}

extension DoctorDetailsStateX on DoctorDetailsState {
  bool get isInitial => status == DoctorDetailsStatus.initial;
  bool get isLoading => status == DoctorDetailsStatus.loading;
  bool get isSuccess => status == DoctorDetailsStatus.success;
  bool get isError => status == DoctorDetailsStatus.error;
}