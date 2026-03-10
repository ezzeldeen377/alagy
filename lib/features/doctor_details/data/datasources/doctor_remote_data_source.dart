import 'dart:convert';
import 'dart:developer' show log;
import 'dart:io';

import 'package:alagy/core/constants/firebase_collections.dart';
import 'package:alagy/core/utils/try_and_catch.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_appointment.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

abstract class DoctorRemoteDataSource {
  Future<Unit> addDoctor(DoctorModel doctor);
  Future<Map<String, dynamic>> getDoctor(String uid);
  Future<List<Map<String, dynamic>>> getDoctorAppointments(String doctorId);
  Future<void> updateAppointmentStatus(String appointmentId, AppointmentStatus status);
  Future<String> uploadProfilePicture(File image);
  Future<Map<String, dynamic>> addReview(Review review, double avgRate);
  Future<void> makeAppointment(DoctorAppointment appointment, String uid);
  Future<List<Map<String, dynamic>>> getDoctorAppointmentsAtDate(
      String uid, DateTime date);
}

@Injectable(as: DoctorRemoteDataSource)
class DoctorRemoteDataSourceImpl extends DoctorRemoteDataSource {
  final firestore = FirebaseFirestore.instance;
  CollectionReference get doctorCollection =>
      firestore.collection(FirebaseCollections.doctorsCollection);
  CollectionReference get userCollection =>
      firestore.collection(FirebaseCollections.usersCollection);

  @override
  Future<Unit> addDoctor(DoctorModel doctor) {
    return executeTryAndCatchForDataLayer(() async {
      final docRef = userCollection.doc(doctor.uid);
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        await docRef.set(doctor.toMap());
      } else {
        doctor = doctor.copyWith(uid: docRef.id);
        await docRef.set(doctor.toMap());
      }

      return Future.value(unit);
    });
  }

  Future<String> uploadProfilePicture(File image) async {
    return executeTryAndCatchForDataLayer(() async {
     const String uploadUrl = 'https://upload.imagekit.io/api/v1/files/upload';
  const String privateApiKey = 'private_5IRdPlZUqBEJqyVjw8LbZabAw8k='; // 🔒 DO NOT expose in frontend apps
  const String uploadFolder = '/doctorImage'; // optional

  final bytes = await image.readAsBytes();
  final base64Image = base64Encode(bytes);

  final response = await http.post(
    Uri.parse(uploadUrl),
    headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$privateApiKey:'))}',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'file': base64Image,
      'fileName': image.path.split('/').last,
      'folder': uploadFolder,
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    log('✅ Image uploaded: ${data['url']}');
    return data['url'];
  } else {
    log('❌ Failed to upload: ${response.body}');
    throw Exception('Failed to upload image');
  }
    });
  }

  @override
  Future<Map<String, dynamic>> getDoctor(String uid) async {
    return executeTryAndCatchForDataLayer(() async {
      final doctorDoc = await userCollection.doc(uid).get();

      return doctorDoc.data() as Map<String, dynamic>;
    });
  }

  @override
  Future<Map<String, dynamic>> addReview(Review review, double avgRate) {
    return executeTryAndCatchForDataLayer(() async {
      final avg = (avgRate + review.rating) / 2;
      await userCollection.doc(review.doctorId).update({
        'reviews': FieldValue.arrayUnion([review.toMap()]),
        'rating': avg,
      });

      final doctor = await getDoctor(review.doctorId!);
      return doctor;
    });
  }

  @override
  Future<void> makeAppointment(DoctorAppointment appointment, String uid) {
    return executeTryAndCatchForDataLayer(() async {
      final docRef =
          await userCollection.doc(uid).collection('appointments').doc();

      appointment = appointment.copyWith(id: docRef.id);
      await docRef.set(appointment.toMap());
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getDoctorAppointmentsAtDate(
      String doctorId, DateTime date) {
    return executeTryAndCatchForDataLayer(() async {
      print(date.normalizeDateOnly.toIso8601String());
      log("date :${ date.normalizeDateOnly}");
      final querySnapshot = await FirebaseFirestore.instance
          .collectionGroup('appointments')
          .where('doctorId', isEqualTo: doctorId)
          .where('appointmentDate',
              isEqualTo: date.normalizeDateOnly.toIso8601String())
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }
  
  @override
  Future<List<Map<String, dynamic>>> getDoctorAppointments(String doctorId) {
    // TODO: implement getDoctorAppointments
    throw UnimplementedError();
  }
  
  @override
  Future<void> updateAppointmentStatus(String appointmentId, AppointmentStatus status) {
    // TODO: implement updateAppointmentStatus
    throw UnimplementedError();
  }
}
