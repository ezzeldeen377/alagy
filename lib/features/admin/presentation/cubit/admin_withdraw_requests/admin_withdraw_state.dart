import 'package:alagy/core/common/enities/view_status.dart';
import 'package:alagy/features/wallet/data/models/withdraw_request_model.dart';

class AdminWithdrawState {
  final ViewStatus status;
  final List<WithdrawRequestModel> requests;
  final String? errorMessage;

  const AdminWithdrawState({
    this.status = ViewStatus.initial,
    this.requests = const [],
    this.errorMessage,
  });

  AdminWithdrawState copyWith({
    ViewStatus? status,
    List<WithdrawRequestModel>? requests,
    String? errorMessage,
  }) {
    return AdminWithdrawState(
      status: status ?? this.status,
      requests: requests ?? this.requests,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'AdminWithdrawState(status: $status, requests: $requests, errorMessage: $errorMessage)';
  }
}
