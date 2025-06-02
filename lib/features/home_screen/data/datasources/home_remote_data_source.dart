import 'package:alagy/core/constants/firebase_collections.dart';
import 'package:alagy/core/utils/try_and_catch.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:injectable/injectable.dart';

abstract class HomeRemoteDataSource {
  Future<List<Map<String, dynamic>>> getVipDoctors();

  Future<List<Map<String, dynamic>>> getTopRatedDoctors();

  Future<List<Map<String, dynamic>>> getDoctorCategories(String category);

  Future<List<Map<String, dynamic>>> searchDoctors(String query);

  Future<void> addDoctorToFavourite(DoctorModel doctor, String userId);
  Future<void> removeDoctorFromFavourite(DoctorModel doctor, String userId);
  Stream<List<String>> getAllFavouriteDoctorId( String userId);

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
          .get();
      final data =
          snapshot.docs.map((e) => e.data() as Map<String, dynamic>).toList();
      return data;
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getTopRatedDoctors() {
    return executeTryAndCatchForDataLayer(() async {
      final snapshot =
          await userCollection.orderBy("rating", descending: true).get();
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
      final nameFuture = userCollection
          .where('type', isEqualTo: 'doctor')
          .where('nameLower', isGreaterThanOrEqualTo: lowerQuery)
          .where('nameLower', isLessThanOrEqualTo: '$lowerQuery\uf8ff')
          .get();

      final addressFuture = userCollection
          .where('type', isEqualTo: 'doctor')
          .where('cityLower', isGreaterThanOrEqualTo: lowerQuery)
          .where('cityLower', isLessThanOrEqualTo: '$lowerQuery\uf8ff')
          .get();

      final categoryFuture = userCollection
          .where('type', isEqualTo: 'doctor')
          .where('specialization', isGreaterThanOrEqualTo: lowerQuery)
          .where('specialization', isLessThanOrEqualTo: '$lowerQuery\uf8ff')
          .get();

      // Wait for all 3 queries in parallel
      final results =
          await Future.wait([nameFuture, addressFuture, categoryFuture]);

      // Combine and deduplicate documents
      final allDocs = results.expand((snapshot) => snapshot.docs).toList();
      final uniqueDocsMap = <String, Map<String, dynamic>>{};

      for (var doc in allDocs) {
        uniqueDocsMap[doc.id] =
            doc.data() as Map<String, dynamic>; // Each is Map<String, dynamic>
      }
      print(" length : ${uniqueDocsMap.length}");
      return uniqueDocsMap.values.toList(); // List<Map<String, dynamic>>
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
  return userCollection
      .doc(userId)
      .collection(FirebaseCollections.favouriteCollection)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((e) => e.id).toList());
}


  }
