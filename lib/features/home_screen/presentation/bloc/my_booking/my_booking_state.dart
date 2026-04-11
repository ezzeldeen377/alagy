import 'package:alagy/features/doctor_details/data/models/doctor_appointment.dart';


enum MyBookingStatus {
  initial,
  loading,
  success,
  error,
}

extension MyBookingStateX on MyBookingState {
  bool get isInitial => status == MyBookingStatus.initial;
  bool get isLoading => status == MyBookingStatus.loading;
  bool get isSuccess => status == MyBookingStatus.success;
  bool get isError => status == MyBookingStatus.error;
}

class MyBookingState {
  final MyBookingStatus status;
  final String? errorMessage;
  final List<DoctorAppointment> bookings;

  const MyBookingState({
    this.status = MyBookingStatus.initial,
    this.errorMessage,
    this.bookings = const [],
  });

  MyBookingState copyWith({
    MyBookingStatus? status,
    String? errorMessage,
    List<DoctorAppointment>? bookings,
  }) {
    return MyBookingState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      bookings: bookings ?? this.bookings,
    );
  }
}
