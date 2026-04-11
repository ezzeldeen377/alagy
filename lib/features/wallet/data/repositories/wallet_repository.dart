import 'dart:developer';

import 'package:alagy/core/error/failure.dart';
import 'package:alagy/core/utils/try_and_catch.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_appointment.dart';
import 'package:alagy/features/wallet/data/datasources/wallet_remote_data_source.dart';
import 'package:alagy/features/wallet/data/models/wallet_transaction_model.dart';
import 'package:alagy/features/wallet/data/models/withdraw_request_model.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

abstract class WalletRepository {
  Future<Either<Failure, List<WalletTransactionModel>>> getWalletTransactions(
      String userId);
  Future<Either<Failure, List<WithdrawRequestModel>>> getUserWithdrawRequests(
      String userId);
  Future<Either<Failure, Unit>> requestWithdraw(
      WithdrawRequestModel request, double currentBalance);
  Future<Either<Failure, Unit>> payWithWallet(String userId, double amount,
      String appointmentId, double currentBalance);
  Future<Either<Failure, double>> cancelAppointment(
    String userId,
    String appointmentId,
    DateTime appointmentDate,
    TimeSlot startTime,
    double price,
    String reason,
    double currentBalance,
  );
}

@Injectable(as: WalletRepository)
class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource _dataSource;
  final Uuid _uuid = const Uuid();

  WalletRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<WalletTransactionModel>>> getWalletTransactions(
      String userId) {
    return executeTryAndCatchForRepository(
        () => _dataSource.getWalletTransactions(userId));
  }

  @override
  Future<Either<Failure, List<WithdrawRequestModel>>> getUserWithdrawRequests(
      String userId) {
    return executeTryAndCatchForRepository(
        () => _dataSource.getUserWithdrawRequests(userId));
  }

  @override
  Future<Either<Failure, Unit>> requestWithdraw(
      WithdrawRequestModel request, double currentBalance) {
    return executeTryAndCatchForRepository(() async {
      if (request.amount > currentBalance) {
        throw Exception('Insufficient balance');
      }

      await _dataSource.createWithdrawRequest(request);

      // Deduct balance and create transaction
      final newBalance = currentBalance - request.amount;
      await _dataSource.updateWalletBalance(request.userId, newBalance);

      final transactionId = request.transactionId ?? _uuid.v4();
      final transaction = WalletTransactionModel(
        id: transactionId,
        userId: request.userId,
        amount: request.amount,
        type: WalletTransactionType.withdraw,
        status: WalletTransactionStatus.pending,
        description: 'withdrawDescriptionArg:${request.method.name}',
        createdAt: DateTime.now(),
      );

      await _dataSource.addWalletTransaction(transaction);

      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> payWithWallet(
    String userId,
    double amount,
    String appointmentId,
    double currentBalance,
  ) {
    return executeTryAndCatchForRepository(() async {
      if (amount > currentBalance) {
        throw Exception('Insufficient balance');
      }

      final newBalance = currentBalance - amount;
      await _dataSource.updateWalletBalance(userId, newBalance);

      final transactionId = _uuid.v4();
      final transaction = WalletTransactionModel(
        id: transactionId,
        userId: userId,
        amount: amount,
        type: WalletTransactionType.payment,
        status: WalletTransactionStatus.completed,
        description: 'paymentDescriptionArg:$appointmentId',
        relatedAppointmentId: appointmentId,
        createdAt: DateTime.now(),
      );

      await _dataSource.addWalletTransaction(transaction);

      return unit;
    });
  }

  @override
  Future<Either<Failure, double>> cancelAppointment(
    String userId,
    String appointmentId,
    DateTime appointmentDate,
    TimeSlot startTime,
    double price,
    String reason,
    double currentBalance,
  ) {
    return executeTryAndCatchForRepository(() async {
      // Calculate time remaining
      final now = DateTime.now();

      // Wait, startTime.toDateTime() assumes today's date based on TimeSlotFormatting extension.
      // We need to construct the actual appointment datetime
      final timeData = startTime.toDateTime();
      final realAppointmentDateTime = DateTime(
        appointmentDate.year,
        appointmentDate.month,
        appointmentDate.day,
        timeData.hour,
        timeData.minute,
      );

      final difference = realAppointmentDateTime.difference(now);
      final minutesRemaining = difference.inMinutes;
      // 2. Cancellation logic: >3 hr (180 min) = 100%, <3 hr (180 min) = 50%
      double refundAmount = 0.0;
      if (minutesRemaining > 180) {
        refundAmount = price;
      } else if (minutesRemaining >= 0) {
        refundAmount = price * 0.5;
      } else {
        refundAmount = 0.0; // Past appointment
      }
      log("${refundAmount}");
      // 3. Update appointment
      final cancelledAt = DateTime.now();
      await _dataSource.updateAppointmentCancellation(
        userId,
        appointmentId,
        AppointmentStatus.cancelled,
        refundAmount > 0
            ? AppointmentPaymentStatus.refunded
            : AppointmentPaymentStatus.paid,
        reason,
        cancelledAt,
      );

      // 4. Refund to wallet if amount > 0
      if (refundAmount > 0) {
        final newBalance = currentBalance + refundAmount;
        await _dataSource.updateWalletBalance(userId, newBalance);

        final transactionId = _uuid.v4();
        final transaction = WalletTransactionModel(
          id: transactionId,
          userId: userId,
          amount: refundAmount,
          type: WalletTransactionType.refund,
          status: WalletTransactionStatus.completed,
          description: 'refundDescription',
          relatedAppointmentId: appointmentId,
          createdAt: DateTime.now(),
        );

        await _dataSource.addWalletTransaction(transaction);
      }

      return refundAmount;
    });
  }
}
