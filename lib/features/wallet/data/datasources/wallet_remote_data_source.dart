import 'package:alagy/core/constants/firebase_collections.dart';
import 'package:alagy/core/utils/try_and_catch.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_appointment.dart';
import 'package:alagy/features/wallet/data/models/wallet_transaction_model.dart';
import 'package:alagy/features/wallet/data/models/withdraw_request_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

abstract class WalletRemoteDataSource {
  Future<List<WalletTransactionModel>> getWalletTransactions(String userId);
  Future<void> addWalletTransaction(WalletTransactionModel transaction);
  Future<void> updateWalletBalance(String userId, double newBalance);
  Future<List<WithdrawRequestModel>> getUserWithdrawRequests(String userId);
  Future<void> createWithdrawRequest(WithdrawRequestModel request);
  Future<void> updateAppointmentCancellation(
    String userId,
    String appointmentId,
    AppointmentStatus status,
    AppointmentPaymentStatus paymentStatus,
    String cancellationReason,
    DateTime cancelledAt,
  );
}

@Injectable(as: WalletRemoteDataSource)
class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<WalletTransactionModel>> getWalletTransactions(String userId) {
    return executeTryAndCatchForDataLayer(() async {
      final snapshot = await _firestore
          .collection(FirebaseCollections.usersCollection)
          .doc(userId)
          .collection(FirebaseCollections.walletTransactionsCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => WalletTransactionModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  @override
  Future<void> addWalletTransaction(WalletTransactionModel transaction) {
    return executeTryAndCatchForDataLayer(() async {
      await _firestore
          .collection(FirebaseCollections.usersCollection)
          .doc(transaction.userId)
          .collection(FirebaseCollections.walletTransactionsCollection)
          .doc(transaction.id)
          .set(transaction.toMap());
    });
  }

  @override
  Future<void> updateWalletBalance(String userId, double newBalance) {
    return executeTryAndCatchForDataLayer(() async {
      await _firestore
          .collection(FirebaseCollections.usersCollection)
          .doc(userId)
          .update({'walletBalance': newBalance});
    });
  }

  @override
  Future<List<WithdrawRequestModel>> getUserWithdrawRequests(String userId) {
    return executeTryAndCatchForDataLayer(() async {
      final snapshot = await _firestore
          .collection(FirebaseCollections.withdrawRequestsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => WithdrawRequestModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  @override
  Future<void> createWithdrawRequest(WithdrawRequestModel request) {
    return executeTryAndCatchForDataLayer(() async {
      await _firestore
          .collection(FirebaseCollections.withdrawRequestsCollection)
          .doc(request.id)
          .set(request.toMap());
    });
  }

  @override
  Future<void> updateAppointmentCancellation(
    String userId,
    String appointmentId,
    AppointmentStatus status,
    AppointmentPaymentStatus paymentStatus,
    String cancellationReason,
    DateTime cancelledAt,
  ) {
    return executeTryAndCatchForDataLayer(() async {
      await _firestore
          .collection(FirebaseCollections.usersCollection)
          .doc(userId)
          .collection(FirebaseCollections.appointmentsCollection)
          .doc(appointmentId)
          .update({
        'status': status.name,
        'paymentStatus': paymentStatus.name,
        'cancellationReason': cancellationReason,
        'cancelledAt': Timestamp.fromDate(cancelledAt),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    });
  }
}
