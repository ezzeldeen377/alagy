import 'package:alagy/features/doctor/data/models/doctor_model.dart';
enum DoctorsStatus {
  initial,
  loading,
  success,
  failure,
}
extension DoctorStatusX on DoctorsState {
  bool get isInitial => status == DoctorsStatus.initial;
  bool get isLoading => status == DoctorsStatus.loading;
  bool get isSuccess => status == DoctorsStatus.success;
  bool get isFailure => status == DoctorsStatus.failure;
}
class DoctorsState  {
  final DoctorsStatus status;
  final String? error;
  final String? category;
  final List<DoctorModel>? doctors;

  const DoctorsState({
     this.status=DoctorsStatus.initial,
    this.error,
    this.category,
    this.doctors,
  });

  DoctorsState copyWith({
    DoctorsStatus? status,
    String? error,
    String? category,
    List<DoctorModel>? doctors,
  }) {
    return DoctorsState(
      status: status ?? this.status,
      error: error ?? this.error,
      category: category?? this.category,
      doctors: doctors ?? this.doctors,
    );
  }

}