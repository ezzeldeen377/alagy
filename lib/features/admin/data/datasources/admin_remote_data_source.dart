import 'dart:developer';

import 'package:alagy/features/admin/data/models/admin_statistics.dart';
import 'package:alagy/features/admin/data/models/date_filter.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_model.dart';
import 'package:alagy/features/wallet/data/models/withdraw_request_model.dart';
import 'package:alagy/core/constants/firebase_collections.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

abstract interface class AdminRemoteDataSource {
  Future<List<DoctorModel>> getPendingDoctors();
  Future<List<DoctorModel>> getApprovedDoctors();
  Future<List<DoctorModel>> getRejectedDoctors();
  Future<void> updateDoctorStatus(String doctorId, bool isAccepted);
  Future<void> updateDoctorVipStatus(String doctorId, bool isVip);
  Future<AdminStatistics> getStatistics(DateFilter filter);
  Future<List<WithdrawRequestModel>> getPendingWithdrawRequests();
  Future<void> reviewWithdrawRequest(String requestId, bool approved,
      String? adminNote, String userId, double amount);
}

@LazySingleton(as: AdminRemoteDataSource)
class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AdminRemoteDataSourceImpl();

  @override
  Future<List<DoctorModel>> getPendingDoctors() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('isAccepted', isNull: true)
          .get();

      return querySnapshot.docs
          .map((doc) => DoctorModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get pending doctors: $e');
    }
  }

  @override
  Future<List<DoctorModel>> getApprovedDoctors() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('isAccepted', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) => DoctorModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get approved doctors: $e');
    }
  }

  @override
  Future<List<DoctorModel>> getRejectedDoctors() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('isAccepted', isEqualTo: false)
          .get();

      return querySnapshot.docs
          .map((doc) => DoctorModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get rejected doctors: $e');
    }
  }

  @override
  Future<void> updateDoctorStatus(String doctorId, bool isAccepted) async {
    try {
      await _firestore
          .collection('users')
          .doc(doctorId)
          .update({'isAccepted': isAccepted});
    } catch (e) {
      throw Exception('Failed to update doctor status: $e');
    }
  }

  @override
  Future<void> updateDoctorVipStatus(String doctorId, bool isVip) async {
    try {
      await _firestore
          .collection('users')
          .doc(doctorId)
          .update({'isVip': isVip});
    } catch (e) {
      throw Exception('Failed to update doctor VIP status: $e');
    }
  }

  @override
  Future<AdminStatistics> getStatistics(DateFilter filter) async {
    try {
      // Get total doctors
      final doctorsSnapshot = await _firestore
          .collection('users')
          .where("type", isEqualTo: "doctor")
          .get();
      final totalDoctors = doctorsSnapshot.docs.length;

      // Get pending doctors
      final pendingSnapshot = await _firestore
          .collection('users')
          .where('isAccepted', isNull: true)
          .get();
      final pendingDoctors = pendingSnapshot.docs.length;

      // Get approved doctors
      final approvedSnapshot = await _firestore
          .collection('users')
          .where('isAccepted', isEqualTo: true)
          .get();
      final approvedDoctors = approvedSnapshot.docs.length;

      // Get rejected doctors
      final rejectedSnapshot = await _firestore
          .collection('users')
          .where('isAccepted', isEqualTo: false)
          .get();
      final rejectedDoctors = rejectedSnapshot.docs.length;

      // Get total patients
      final patientsSnapshot = await _firestore
          .collection('users')
          .where('type', isEqualTo: 'patient')
          .get();
      final totalPatients = patientsSnapshot.docs.length;

      // Get appointments with date filtering
      Query appointmentsQuery = _firestore.collectionGroup('appointments');

      if (filter.startDate != null && filter.endDate != null) {
        appointmentsQuery = appointmentsQuery
            .where('createdAt',
                isGreaterThanOrEqualTo:
                    filter.startDate!.millisecondsSinceEpoch)
            .where('createdAt',
                isLessThanOrEqualTo: filter.endDate!.millisecondsSinceEpoch);
      }

      final appointmentsSnapshot = await appointmentsQuery.get();
      final totalAppointments = appointmentsSnapshot.docs.length;

      // Calculate revenue with date filtering
      double revenue = 0.0;
      for (var doc in appointmentsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        revenue += (data['price'] ?? 0.0).toDouble();
      }

      return AdminStatistics(
        totalDoctors: totalDoctors,
        totalPatients: totalPatients,
        totalAppointments: totalAppointments,
        monthlyRevenue: revenue,
        pendingDoctors: pendingDoctors,
        approvedDoctors: approvedDoctors,
        rejectedDoctors: rejectedDoctors,
      );
    } catch (e) {
      throw Exception('Failed to get statistics: $e');
    }
  }

  @override
  Future<List<WithdrawRequestModel>> getPendingWithdrawRequests() async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseCollections.withdrawRequestsCollection)
          .where('status', isEqualTo: WithdrawStatus.pending.name)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => WithdrawRequestModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get pending withdraw requests: $e');
    }
  }

  @override
  Future<void> reviewWithdrawRequest(String requestId, bool approved,
      String? adminNote, String userId, double amount) async {
    try {
      final status = approved
          ? WithdrawStatus.approved.name
          : WithdrawStatus.declined.name;

      await _firestore.runTransaction((transaction) async {
        final requestRef = _firestore
            .collection(FirebaseCollections.withdrawRequestsCollection)
            .doc(requestId);
        final userRef = _firestore
            .collection(FirebaseCollections.usersCollection)
            .doc(userId);

        // 1. PERFORM ALL READS FIRST
        final requestDoc = await transaction.get(requestRef);
        final userDoc = await transaction.get(userRef);

        final transactionId = requestDoc.data()?['transactionId'] as String?;

        // 2. PERFORM ALL WRITES SECOND
        transaction.update(requestRef, {
          'status': status,
          'adminNote': adminNote,
          'reviewedAt': FieldValue.serverTimestamp(),
        });

        // Update transaction status if transactionId exists
        if (transactionId != null) {
          final transactionRef = userRef
              .collection(FirebaseCollections.walletTransactionsCollection)
              .doc(transactionId);

          transaction.update(transactionRef, {
            'status': approved ? 'completed' : 'declined',
          });
        }

        if (!approved) {
          final currentBalance =
              (userDoc.data()?['walletBalance'] as num?)?.toDouble() ?? 0.0;
          transaction.update(userRef, {
            'walletBalance': currentBalance + amount,
          });
        }
      });
    } catch (e) {
      throw Exception('Failed to review withdraw request: $e');
    }
  }
}
