part of 'payment_cubit.dart';
enum PaymentStatus{
initial,
error,
success,
loading,
appointmentCreated
}
extension PaymentStateX on PaymentState {
  bool get isInitial => status == PaymentStatus.initial;
  bool get isError => status == PaymentStatus.error;
  bool get isSuccess => status == PaymentStatus.success;
  bool get isLoading => status == PaymentStatus.loading;
  bool get isAppointmentCreated => status == PaymentStatus.appointmentCreated;
}

class PaymentState {
  final PaymentStatus status;
  final PaymentType? selectedOption;
  final String? errorMessage;
  final String? paymentKey;
  final DoctorAppointment? appointment;
  

  const PaymentState({
    this.status = PaymentStatus.initial,
   this.selectedOption,
   this.errorMessage,
   this.paymentKey,
   this.appointment
  });


  PaymentState copyWith({
    PaymentStatus? status,
    PaymentType? selectedOption,
    String? errorMessage,
    String? paymentKey,
    DoctorAppointment? appointment
  }) {
    return PaymentState(
      status: status ?? this.status,
      selectedOption: selectedOption ?? this.selectedOption,
      paymentKey: paymentKey??this.paymentKey,
      errorMessage: errorMessage??this.errorMessage,
      appointment: appointment??this.appointment
    );
  }
  @override
  String toString() {
    return 'PaymentState(status: $status, selectedOption: $selectedOption  errorMessage: $errorMessage)';
  }
}

