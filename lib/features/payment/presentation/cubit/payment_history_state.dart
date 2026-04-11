part of 'payment_history_cubit.dart';

abstract class PaymentHistoryState {}

class PaymentHistoryInitial extends PaymentHistoryState {}

class PaymentHistoryLoading extends PaymentHistoryState {}

class PaymentHistoryLoaded extends PaymentHistoryState {
  final List<PaymentModel> payments;
  PaymentHistoryLoaded(this.payments);
}

class PaymentHistoryEmpty extends PaymentHistoryState {}

class PaymentHistoryError extends PaymentHistoryState {
  final String message;
  PaymentHistoryError(this.message);
}
