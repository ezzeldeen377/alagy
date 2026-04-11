import 'dart:developer' as developer;
import 'package:alagy/core/common/enities/view_status.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_appointment.dart';
import 'package:alagy/features/wallet/data/models/withdraw_request_model.dart';
import 'package:alagy/features/wallet/data/repositories/wallet_repository.dart';
import 'package:alagy/features/wallet/presentation/cubit/wallet_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class WalletCubit extends Cubit<WalletState> {
  final WalletRepository _walletRepository;

  WalletCubit(this._walletRepository) : super(const WalletState());

  Future<void> loadWallet(String userId, double currentBalance) async {
    emit(state.copyWith(
      status: ViewStatus.loading,
      balance: currentBalance,
      refundedAmount: null,
      withdrawnAmount: null,
    ));

    final transactionsResult =
        await _walletRepository.getWalletTransactions(userId);

    if (isClosed) return;

    transactionsResult.fold(
      (l) => emit(
          state.copyWith(status: ViewStatus.failure, errorMessage: l.message)),
      (transactions) {
        emit(state.copyWith(
          status: ViewStatus.success,
          transactions: transactions,
        ));
      },
    );
  }

  Future<void> requestWithdraw(
      WithdrawRequestModel request, double currentBalance) async {
    emit(state.copyWith(
      status: ViewStatus.loading,
      refundedAmount: null,
      withdrawnAmount: null,
    ));

    final result =
        await _walletRepository.requestWithdraw(request, currentBalance);

    if (isClosed) return;

    await result.fold(
      (l) async => emit(
          state.copyWith(status: ViewStatus.failure, errorMessage: l.message)),
      (_) async {
        await loadWallet(request.userId, currentBalance - request.amount);
        if (isClosed) return;
        emit(state.copyWith(
          status: ViewStatus.success,
          withdrawnAmount: request.amount,
        ));
      },
    );
  }

  Future<void> cancelAppointment(DoctorAppointment appointment, String reason,
      String userId, double currentBalance) async {
    if (appointment.id == null) {
      developer.log("❌ Cannot cancel appointment: Appointment ID is null.");
      emit(state.copyWith(
        status: ViewStatus.failure,
        errorMessage: "Cannot cancel appointment: missing information",
      ));
      return;
    }

    emit(state.copyWith(
      status: ViewStatus.loading,
      refundedAmount: null,
      withdrawnAmount: null,
    ));

    final result = await _walletRepository.cancelAppointment(
      userId,
      appointment.id!,
      appointment.appointmentDate,
      appointment.startTime,
      appointment.price,
      reason,
      currentBalance,
    );

    if (isClosed) return;

    result.fold(
      (l) => emit(
          state.copyWith(status: ViewStatus.failure, errorMessage: l.message)),
      (refundedAmount) {
        emit(state.copyWith(
          status: ViewStatus.success,
          refundedAmount: refundedAmount,
        ));
      },
    );
  }
}
