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
  final DateTime? selectedDate;
  final List<String> timeSlots;
  final String? selectedTime;

  const DoctorDetailsState({
    this.status = DoctorDetailsStatus.initial,
    this.selectedDoctor,
    this.userRate,
    this.errorMessage,
    this.selectedDate ,
    this.timeSlots = const [],
    this.selectedTime,
  });

  DoctorDetailsState copyWith({
    DoctorDetailsStatus? status,
    DoctorModel? selectedDoctor,
    int? userRate,
     DateTime? selectedDate,
   List<String>? timeSlots,
   String? selectedTime,
    String? errorMessage,
  }) {
    return DoctorDetailsState(
      status: status ?? this.status,
      selectedDoctor: selectedDoctor ?? this.selectedDoctor,
      userRate: userRate ?? this.userRate,
      selectedDate: selectedDate?? this.selectedDate,
      timeSlots: timeSlots?? this.timeSlots,
      selectedTime: selectedTime?? this.selectedTime,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  

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