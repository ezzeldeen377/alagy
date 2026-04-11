import 'package:alagy/core/constants/firebase_collections.dart';
import 'package:alagy/core/utils/try_and_catch.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

abstract class HomeRemoteDataSource {
  Future<List<Map<String, dynamic>>> getVipDoctors();

  Future<List<Map<String, dynamic>>> getTopRatedDoctors();

  Future<List<Map<String, dynamic>>> getDoctorCategories(String category);

  Future<List<Map<String, dynamic>>> searchDoctors(String query);
  Future<List<Map<String, dynamic>>> getReservation(String userId);

  Future<void> addDoctorToFavourite(DoctorModel doctor, String userId);
  Future<void> removeDoctorFromFavourite(DoctorModel doctor, String userId);
  Stream<List<String>> getAllFavouriteDoctorId(String userId);
  Stream<List<Map<String, dynamic>>> getAllFavouriteDoctors(String userId);
}

@Injectable(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final firestore = FirebaseFirestore.instance;
  CollectionReference get userCollection =>
      firestore.collection(FirebaseCollections.usersCollection);
  CollectionReference get favourite =>
      firestore.collection(FirebaseCollections.favouriteCollection);

  @override
  Future<List<Map<String, dynamic>>> getDoctorCategories(String category) {
    return executeTryAndCatchForDataLayer(() async {
      final snapshot = await userCollection
          .where("specialization", isEqualTo: category)
          .where("isAccepted", isEqualTo: true)
          .get();
      final data =
          snapshot.docs.map((e) => e.data() as Map<String, dynamic>).toList();
      return data;
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getTopRatedDoctors() {
    return executeTryAndCatchForDataLayer(() async {
      final snapshot = await userCollection
          .orderBy("rating", descending: true)
          .where("isAccepted", isEqualTo: true)
          .get();
      final data =
          snapshot.docs.map((e) => e.data() as Map<String, dynamic>).toList();
      return data;
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getVipDoctors() {
    return executeTryAndCatchForDataLayer(() async {
      final snapshot =
          await userCollection.where("isVip", isEqualTo: true).get();
      final data =
          snapshot.docs.map((e) => e.data() as Map<String, dynamic>).toList();
      return data;
    });
  }

  @override
  Future<List<Map<String, dynamic>>> searchDoctors(String query) {
    return executeTryAndCatchForDataLayer(() async {
      final lowerQuery = query.toLowerCase();
      if (query.isEmpty) {
        return [];
      }
      final snapshot = await userCollection
          .where('type', isEqualTo: 'doctor')
          .where('keyword', arrayContains: lowerQuery)
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  @override
  Future<void> addDoctorToFavourite(DoctorModel doctor, String userId) {
    return executeTryAndCatchForDataLayer(() async {
      await userCollection
          .doc(userId)
          .collection(FirebaseCollections.favouriteCollection)
          .doc(doctor.uid)
          .set(doctor.toMap());
    });
  }

  @override
  Future<void> removeDoctorFromFavourite(DoctorModel doctor, String userId) {
    return executeTryAndCatchForDataLayer(() async {
      await userCollection
          .doc(userId)
          .collection(FirebaseCollections.favouriteCollection)
          .doc(doctor.uid)
          .delete();
    });
  }

  @override
  Stream<List<String>> getAllFavouriteDoctorId(String userId) {
    try {
      return userCollection
          .doc(userId)
          .collection(FirebaseCollections.favouriteCollection)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((e) => e.id).toList());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<Map<String, dynamic>>> getAllFavouriteDoctors(String userId) {
    try {
      return userCollection
          .doc(userId)
          .collection(FirebaseCollections.favouriteCollection)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((e) => e.data()).toList());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getReservation(String userId) {
    return executeTryAndCatchForDataLayer(() async {
      final snapshot = await userCollection
          .doc(userId)
          .collection(FirebaseCollections.appointmentsCollection)
          .orderBy("appointmentDate", descending: true)
          .get();
      final data = snapshot.docs.map((e) {
        final map = Map<String, dynamic>.from(e.data());
        if (map['id'] == null) {
          map['id'] = e.id;
        }
        return map;
      }).toList();
      return data;
    });
  }
}
