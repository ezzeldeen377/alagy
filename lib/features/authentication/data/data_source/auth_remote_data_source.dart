import 'package:alagy/core/common/enities/user_model.dart';
import 'package:alagy/core/constants/firebase_collections.dart';
import 'package:alagy/core/utils/try_and_catch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserCredential> signUp(
      {required String email, required String password, required String name});
  // Future<void> sendVerificationEmail();
  Future<void> setUser({required UserModel userModel});
  Future<void> deleteUser({required String uid});
  Future<UserCredential> signIn(
      {required String email, required String password});
  Future<Map<String, dynamic>?> getUserData({required String uid});
  Future<void> signOut();
  Future<UserCredential> googleAuth();
  Future<bool> checkUesrSignin();
  Future<void> updateUser(String uid, Map<String, dynamic> data);
  Stream<User?> get authStateChanges;
  Future<void> resetPassword({required String email});
}

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _userCollection => firestore.collection(FirebaseCollections.usersCollection);
  
  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  @override
  Future<UserCredential> signUp(
      {required String email,
      required String password,
      required String name}) async {
    return await executeTryAndCatchForDataLayer(() async {
      // Create the user account
      final userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 60));

      if (userCredential.user == null) {
        throw FirebaseAuthException(
            message: "User creation failed", code: 'user-not-found');
      }
print("User logged in: ${userCredential.user?.emailVerified}");

      // Update display name
      await userCredential.user!.updateDisplayName(name);
      
      // Skip email verification
      return userCredential;
    });
  }

  // @override
  // Future<void> sendVerificationEmail() async {
  //   return await executeTryAndCatchForDataLayer(() async {
  //     await _auth.currentUser?.sendEmailVerification();
  //     await _auth.signOut();
  //   });
  //}

  @override
  Future<void> setUser({required UserModel userModel}) async {
    return await executeTryAndCatchForDataLayer(() async {
      await _userCollection.doc(userModel.uid).set(userModel.toMap());
    });
  }

  @override
  Future<void> deleteUser({required String uid}) async {
    return await executeTryAndCatchForDataLayer(() async {
      await _auth.currentUser?.delete();
      await _userCollection.doc(uid).delete();
    });
  }

  @override
  Future<UserCredential> signIn(
      {required String email, required String password}) async {
    return await executeTryAndCatchForDataLayer(() async {
      final userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 45));

      // Email verification check removed to allow immediate access

      return userCredential;
    });
  }

  @override
  Future<Map<String, dynamic>?> getUserData({required String uid}) async {
    return await executeTryAndCatchForDataLayer(() async {
      final doc = await _userCollection.doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    });
  }

  @override
  Future<void> signOut() async {
    return await executeTryAndCatchForDataLayer(() async {
      User? user = _auth.currentUser;
      if (user != null) {
        String? providerId;
        if (user.providerData.isNotEmpty) {
          providerId =
              user.providerData.first.providerId; // Get the first provider
          if (providerId == 'google.com') {
            // Sign out only from Google
            await GoogleSignIn().signOut();
            print('Signed out from Google');
          } else {
            // Sign out for other providers (e.g., email/password)
            await FirebaseAuth.instance.signOut();
            print('Signed out from Firebase');
          }

          _auth.signOut();
        }
      }
    });
  }

  @override
  Future<UserCredential> googleAuth() async {
    return await executeTryAndCatchForDataLayer(() async {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      return userCredential;
    });
  }

  @override
  Future<bool> checkUesrSignin() async {
    return await executeTryAndCatchForDataLayer(() async {
      return _auth.currentUser != null;
    });
  }

  @override
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    return await executeTryAndCatchForDataLayer(() async {
      await _userCollection.doc(uid).update(data);
    });
  }
  
  @override
  Future<void> resetPassword({required String email}) {
  return executeTryAndCatchForDataLayer(() async {
    await _auth.sendPasswordResetEmail(email: email);
  });
  }
}
