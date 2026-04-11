import 'package:alagy/core/constants/firebase_collections.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_appointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

abstract class DoctorDashboardRemoteDataSource {
  Future<Map<String, int>> getDoctorStatistics(String doctorId);
  Future<List<Map<String, dynamic>>> getTodayAppointments(String doctorId);
  Future<List<Map<String, dynamic>>> getPendingRequests(String doctorId);
  Future<List<Map<String, dynamic>>> getAllAppointments(String doctorId);
  Future<List<Map<String, dynamic>>> getPendingAppointments(String doctorId);
  Future<List<Map<String, dynamic>>> getCompletedAppointments(String doctorId);
  Future<void> updateAppointmentStatus(String appointmentId, AppointmentStatus status);
}

@Injectable(as: DoctorDashboardRemoteDataSource)
class DoctorDashboardRemoteDataSourceImpl implements DoctorDashboardRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Map<String, int>> getDoctorStatistics(String doctorId) async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));

      // Get all appointments for this doctor
      final allAppointmentsQuery = await _firestore
          .collectionGroup(FirebaseCollections.appointmentsCollection)
          .where('doctorId', isEqualTo: doctorId)
          .get();

      final allAppointments = allAppointmentsQuery.docs;

      // Get today's appointments
      final todayAppointments = allAppointments.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final appointmentDate = DateTime.parse(data['appointmentDate']);
        return appointmentDate.isAfter(today.subtract(const Duration(days: 1))) &&
               appointmentDate.isBefore(tomorrow);
      }).toList();

      // Get pending requests
      final pendingRequests = allAppointments.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['status'] == 'pending';
      }).toList();

      // Get completed appointments today
      final completedToday = todayAppointments.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['status'] == 'completed';
      }).toList();

      // Get unique patients count
      final uniquePatients = allAppointments
          .map((doc) => (doc.data() as Map<String, dynamic>)['patientId'])
          .toSet()
          .length;

      return {
        'totalPatients': uniquePatients,
        'todayAppointments': todayAppointments.length,
        'pendingRequests': pendingRequests.length,
        'completedToday': completedToday.length,
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
        final data = doc.data() as Map<String, dynamic>;
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
        final data = doc.data() as Map<String, dynamic>;
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
        final data = doc.data() as Map<String, dynamic>;
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
        final data = doc.data() as Map<String, dynamic>;
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