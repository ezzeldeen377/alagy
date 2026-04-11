import 'package:alagy/features/payment/data/models/payment_model.dart';
import 'package:alagy/features/payment/data/repositories/payment_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

part 'payment_history_state.dart';

@injectable
class PaymentHistoryCubit extends Cubit<PaymentHistoryState> {
  final PaymentRepository _paymentRepository;

  PaymentHistoryCubit(this._paymentRepository) : super(PaymentHistoryInitial());

  Future<void> getPaymentHistory(String userId) async {
    emit(PaymentHistoryLoading());
    try {
      final payments = await _paymentRepository.getPayments(userId);
      if (payments.isEmpty) {
        emit(PaymentHistoryEmpty());
      } else {
        emit(PaymentHistoryLoaded(payments));
      }
    } catch (e) {
      emit(PaymentHistoryError(e.toString()));
    }
  }
}
