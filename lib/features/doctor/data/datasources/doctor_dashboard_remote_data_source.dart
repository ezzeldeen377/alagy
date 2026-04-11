import 'package:alagy/core/constants/firebase_collections.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_appointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

enum StatisticsPeriod { today, thisWeek, thisMonth, allTime }

abstract class DoctorDashboardRemoteDataSource {
  Future<Map<String, int>> getDoctorStatistics(String doctorId, StatisticsPeriod period);
  Future<List<Map<String, dynamic>>> getTodayAppointments(String doctorId);
  Future<List<Map<String, dynamic>>> getPendingRequests(String doctorId);
  Future<List<Map<String, dynamic>>> getAllAppointments(String doctorId);
  Future<List<Map<String, dynamic>>> getPendingAppointments(String doctorId);
  Future<List<Map<String, dynamic>>> getCompletedAppointments(String doctorId);
  Future<Map<String, dynamic>> getAppointmentSummary(String doctorId);
  Future<void> updateAppointmentStatus(String appointmentId, AppointmentStatus status);
}

@Injectable(as: DoctorDashboardRemoteDataSource)
class DoctorDashboardRemoteDataSourceImpl implements DoctorDashboardRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Map<String, int>> getDoctorStatistics(String doctorId, StatisticsPeriod period) async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));

      // Determine the start date based on the period
      DateTime? startDate;
      switch (period) {
        case StatisticsPeriod.today:
          startDate = today;
          break;
        case StatisticsPeriod.thisWeek:
          startDate = today.subtract(Duration(days: today.weekday - 1));
          break;
        case StatisticsPeriod.thisMonth:
          startDate = DateTime(now.year, now.month, 1);
          break;
        case StatisticsPeriod.allTime:
          startDate = null;
          break;
      }

      // Get all appointments for this doctor
      final allAppointmentsQuery = await _firestore
          .collectionGroup(FirebaseCollections.appointmentsCollection)
          .where('doctorId', isEqualTo: doctorId)
          .get();

      final allAppointmentsRaw = allAppointmentsQuery.docs;

      // Filter appointments by date if startDate is not null
      final allAppointments = startDate == null 
        ? allAppointmentsRaw 
        : allAppointmentsRaw.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final appointmentDate = DateTime.parse(data['appointmentDate']);
          return appointmentDate.isAfter(startDate!.subtract(const Duration(seconds: 1)));
        }).toList();

      // Today's appointments (always keep today's context for that specific stat if needed, or filter it too)
      // Actually, let's filter everything by period for consistency, except maybe 'todaysAppointments' if the user wants that specific card to stay today.
      // But the request says "with each one get the statics", so all 4 cards should reflect the period.

      // Get pending requests
      final pendingRequests = allAppointments.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['status'] == 'pending';
      }).toList();

      // Get completed appointments
      final completedInPeriod = allAppointments.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['status'] == 'completed';
      }).toList();

      // Get unique patients count
      final uniquePatients = allAppointments
          .map((doc) => (doc.data())['patientId'])
          .toSet()
          .length;

      // For 'todayAppointments' card, if period is 'today', it's today. If 'allTime', it's total count? 
      // Usually these dashboards show "Upcoming" for the period.
      final upcomingInPeriod = allAppointments.where((doc) {
        final data = doc.data();
        return data['status'] == 'confirmed'; // Confirmed in this period
      }).toList();

      return {
        'totalPatients': uniquePatients,
        'todayAppointments': period == StatisticsPeriod.today 
            ? allAppointments.where((doc) {
                final data = doc.data();
                final appointmentDate = DateTime.parse(data['appointmentDate']);
                return appointmentDate.isAfter(today.subtract(const Duration(seconds: 1))) &&
                       appointmentDate.isBefore(tomorrow);
              }).length
            : upcomingInPeriod.length,
        'pendingRequests': pendingRequests.length,
        'completedToday': completedInPeriod.length,
      };
    } catch (e) {
      throw Exception('Failed to get doctor statistics: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getTodayAppointments(String doctorId) async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));

      final querySnapshot = await _firestore
          .collectionGroup(FirebaseCollections.appointmentsCollection)
          .where('doctorId', isEqualTo: doctorId)
          .where('appointmentDate', isGreaterThanOrEqualTo: today.toIso8601String())
          .where('appointmentDate', isLessThan: tomorrow.toIso8601String())
          .where('status', whereIn: ['confirmed', 'pending'])
          .orderBy('appointmentDate')
          .orderBy('startTime.time')
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get today appointments: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingRequests(String doctorId) async {
    try {
      final querySnapshot = await _firestore
          .collectionGroup(FirebaseCollections.appointmentsCollection)
          .where('doctorId', isEqualTo: doctorId)
          .where('status', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .limit(10)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get pending requests: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllAppointments(String doctorId) async {
    try {
      final querySnapshot = await _firestore
          .collectionGroup(FirebaseCollections.appointmentsCollection)
          .where('doctorId', isEqualTo: doctorId)
          .where('status', whereIn: ['pending', 'completed'])
          .orderBy('appointmentDate', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get all appointments: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingAppointments(String doctorId) async {
    try {
      final now = DateTime.now();
      final querySnapshot = await _firestore
          .collectionGroup(FirebaseCollections.appointmentsCollection)
          .where('doctorId', isEqualTo: doctorId)
          .where('status', isEqualTo: "pending")
          .orderBy('appointmentDate')
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get pending appointments: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCompletedAppointments(String doctorId) async {
    try {
      final querySnapshot = await _firestore
          .collectionGroup(FirebaseCollections.appointmentsCollection)
          .where('doctorId', isEqualTo: doctorId)
          .where('status', isEqualTo: 'completed')
          .orderBy('appointmentDate', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get completed appointments: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getAppointmentSummary(String doctorId) async {
    try {
      final querySnapshot = await _firestore
          .collectionGroup(FirebaseCollections.appointmentsCollection)
          .where('doctorId', isEqualTo: doctorId)
          .get();

      int pending = 0;
      int completed = 0;
      double revenue = 0;

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final status = data['status'];
        final price = (data['price'] as num?)?.toDouble() ?? 0.0;

        if (status == 'pending' || status == 'confirmed') {
          pending++;
        } else if (status == 'completed') {
          completed++;
          revenue += price;
        }
      }

      return {
        'pendingCount': pending,
        'completedCount': completed,
        'totalRevenue': revenue,
      };
    } catch (e) {
      throw Exception('Failed to get appointment summary: $e');
    }
  }

  @override
  Future<void> updateAppointmentStatus(String appointmentId, AppointmentStatus status) async {
    try {
      // Find the appointment document across all users
      final querySnapshot = await _firestore
          .collectionGroup(FirebaseCollections.appointmentsCollection)
          .where('id', isEqualTo: appointmentId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        await doc.reference.update({
          'status': status.name,
          'updatedAt': DateTime.now().toIso8601String(),
        });
      } else {
        throw Exception('Appointment not found');
      }
    } catch (e) {
      throw Exception('Failed to update appointment status: $e');
    }
  }
}