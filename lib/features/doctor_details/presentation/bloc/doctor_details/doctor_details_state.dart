// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alagy/features/doctor_details/data/models/doctor_appointment.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_model.dart';

enum DoctorDetailsStatus {
  initial,
  loading,
  success,
  appointmentAdded,
  getDoctorAppointmentsAtDate,
  error,
}
class DoctorDetailsState {
  final DoctorDetailsStatus status;
  final DoctorModel? selectedDoctor;
  final int? userRate;
  final String? errorMessage;
  final DateTime? selectedDate;
  final List<TimeSlot>? timeSlots;
  final TimeSlot? selectedTime;
  final List<DoctorAppointment>? doctorAppointmentsAtDate;

  const DoctorDetailsState({
    this.status = DoctorDetailsStatus.initial,
    this.selectedDoctor,
    this.userRate,this.doctorAppointmentsAtDate,
    this.errorMessage,
    this.selectedDate ,
    this.timeSlots = const [],
    this.selectedTime,
  });
  static const _unset = Object();

DoctorDetailsState copyWith({
  DoctorDetailsStatus? status,
  DoctorModel? selectedDoctor,
  int? userRate,
  DateTime? selectedDate,
  Object? timeSlots = _unset,
  Object? doctorAppointmentsAtDate = _unset,
  Object? selectedTime = _unset,
  String? errorMessage,
}) {
  return DoctorDetailsState(
    status: status ?? this.status,
    selectedDoctor: selectedDoctor ?? this.selectedDoctor,
    userRate: userRate ?? this.userRate,
    selectedDate: selectedDate ?? this.selectedDate,
    timeSlots: timeSlots != _unset ? timeSlots as List<TimeSlot>? : this.timeSlots,
    doctorAppointmentsAtDate: doctorAppointmentsAtDate != _unset
        ? doctorAppointmentsAtDate as List<DoctorAppointment>?
        : this.doctorAppointmentsAtDate,
    selectedTime:
        selectedTime != _unset ? selectedTime as TimeSlot? : this.selectedTime,
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
  bool get isAppointmentAdded => status == DoctorDetailsStatus.appointmentAdded;
  bool get isGetDoctorAppointmentsAtDate => status == DoctorDetailsStatus.getDoctorAppointmentsAtDate;
}