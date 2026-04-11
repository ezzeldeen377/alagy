import 'package:alagy/core/common/enities/view_status.dart';
import 'package:alagy/features/wallet/data/models/wallet_transaction_model.dart';

class WalletState {
  final ViewStatus status;
  final double balance;
  final List<WalletTransactionModel> transactions;
  final String? errorMessage;
  final double? refundedAmount;
  final double? withdrawnAmount;

  const WalletState({
    this.status = ViewStatus.initial,
    this.balance = 0.0,
    this.transactions = const [],
    this.errorMessage,
    this.refundedAmount,
    this.withdrawnAmount,
  });

  WalletState copyWith({
    ViewStatus? status,
    double? balance,
    List<WalletTransactionModel>? transactions,
    String? errorMessage,
    double? refundedAmount,
    double? withdrawnAmount,
  }) {
    return WalletState(
      status: status ?? this.status,
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage ?? this.errorMessage,
      refundedAmount: refundedAmount ?? this.refundedAmount,
      withdrawnAmount: withdrawnAmount ?? this.withdrawnAmount,
    );
  }

  @override
  String toString() {
    return 'WalletState(status: $status, balance: $balance, transactions: $transactions, errorMessage: $errorMessage, refundedAmount: $refundedAmount, withdrawnAmount: $withdrawnAmount)';
  }
}
