import 'dart:io';

import 'package:alagy/core/constants/firebase_collections.dart';
import 'package:alagy/core/utils/try_and_catch.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DoctorRemoteDataSource {
  Future<Unit> addDoctor(DoctorModel doctor);
  Future<Map<String,dynamic>> getDoctor(String uid );
  Future<String> uploadProfilePicture(File image);
}

@Injectable(as: DoctorRemoteDataSource)
class DoctorRemoteDataSourceImpl extends DoctorRemoteDataSource {
  final supabase = Supabase.instance.client;
  final firestore = FirebaseFirestore.instance;
  CollectionReference get doctorCollection => firestore.collection(FirebaseCollections.doctorsCollection);
  CollectionReference get userCollection => firestore.collection(FirebaseCollections.usersCollection);

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

  @override
  Future<String> uploadProfilePicture(File image) async {
    return executeTryAndCatchForDataLayer(() async {
      final String fileName =
          'profile_pictures/${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload the file
      await supabase.storage.from('alagybucket').upload(fileName, image);

      // Get the public URL of the uploaded file
      return supabase.storage.from('alagybucket').getPublicUrl(fileName);
    });
  }
  
  @override
  Future<Map<String, dynamic>> getDoctor(String uid) async {
    return executeTryAndCatchForDataLayer(() async {
      final doctorDoc = await userCollection.doc(uid).get();

    return doctorDoc.data() as Map<String, dynamic>;
    });
  }
}
