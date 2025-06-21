import 'dart:convert';
import 'dart:io';

import 'package:alagy/core/constants/firebase_collections.dart';
import 'package:alagy/core/utils/try_and_catch.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

abstract class DoctorRemoteDataSource {
  Future<Unit> addDoctor(DoctorModel doctor);
  Future<Map<String, dynamic>> getDoctor(String uid);
  Future<String> uploadProfilePicture(File image);
  Future<Map<String, dynamic>> addReview(Review review, double avgRate);
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
    // Load API key from .env
    const String apiKey = "97f289ace0e894cab662370ed9f08f63";
    if (apiKey.isEmpty) {
      throw Exception('ImgBB API key not found in .env');
    }

    const String imgbbUrl = 'https://api.imgbb.com/1/upload';

    // Validate file size (ImgBB free tier limit: 32MB)
    if (image.lengthSync() > 32 * 1024 * 1024) {
      throw Exception('Image size exceeds 32MB limit');
    }

    // Create a multipart request
    final request = http.MultipartRequest('POST', Uri.parse(imgbbUrl))
      ..fields['key'] = apiKey
      ..files.add(await http.MultipartFile.fromPath('image', image.path));

    // Send the request
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    // Check the response status
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(responseBody);
      if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
        final imageUrl = jsonResponse['data']['url'] as String;
        print('Image uploaded to ImgBB: $imageUrl');
        return imageUrl;
      } else {
        throw Exception('ImgBB upload failed: ${jsonResponse['error']['message'] ?? 'Unknown error'}');
      }
    } else {
      throw Exception('ImgBB upload failed with status ${response.statusCode}: $responseBody');
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
}
