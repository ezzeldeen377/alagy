import 'package:alagy/core/common/enities/user_model.dart';
import 'package:alagy/core/constants/app_constants.dart';
import 'package:alagy/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/try_and_catch.dart';
import '../data_source/auth_remote_data_source.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserModel>> signUp({
    required String email,
    required String password,
    required String name,
    required String type,
  });
  // Future<Either<Failure, void>> sendVerificationEmail();
  Future<Either<Failure, void>> setUser({required UserModel userModel});
  Future<Either<Failure, void>> deleteUser({required String uid});
  Future<Either<Failure, String>> signIn(
      {required String email, required String password});
  Future<Either<Failure, UserModel>> getUser({required String uid});
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, UserModel>> googleAuth();
  Future<Either<Failure, bool>> checkUesrSignin();
  Future<Either<Failure, void>> updateUser(String uid,Map<String, dynamic> data);
  Stream<User?> get authStateChanges;
 Future<Either<Failure, void>> resetPassword({required String email}); 
}

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authDataSource;

  AuthRepositoryImpl({required AuthRemoteDataSource authDataSource})
      : _authDataSource = authDataSource;

  @override
  Stream<User?> get authStateChanges => _authDataSource.authStateChanges;
  @override
  Future<Either<Failure, UserModel>> signUp({
    required String email,
    required String password,
    required String name,
    required String type,
  }) async {
    return await executeTryAndCatchForRepository(() async {
      final userCredential = await _authDataSource.signUp(
        email: email,
        password: password,
        name: name,
      );

      final userModel = UserModel(
          uid: userCredential.user!.uid,
          profileImage: userCredential.user?.photoURL ??"https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg",          phoneNumber: userCredential.user?.phoneNumber,
          email: email,
          name: name,
          createdAt: DateTime.now(),
          type: type,);
    
      return userModel;
    });
  }
  // @override
  // Future<Either<Failure, void>> sendVerificationEmail() async {
  //   return await executeTryAndCatchForRepository(() async {
  //     await _authDataSource.sendVerificationEmail();
  //   });
  // }

  @override
  Future<Either<Failure, void>> setUser({required UserModel userModel}) async {
    return await executeTryAndCatchForRepository(() async {
      await _authDataSource.setUser(userModel: userModel);
    });
  }

  @override
  Future<Either<Failure, void>> deleteUser({required String uid}) async {
    return await executeTryAndCatchForRepository(() async {
      await _authDataSource.deleteUser(uid: uid);
    });
  }

  @override
  Future<Either<Failure, String>> signIn(
      {required String email, required String password}) async {
    return executeTryAndCatchForRepository(() async {
      final userCredential =
          await _authDataSource.signIn(email: email, password: password);
      return userCredential.user!.uid;
    });
  }

  @override
  Future<Either<Failure, UserModel>> getUser({required String uid}) async {
    return executeTryAndCatchForRepository(() async {
      final userData = await _authDataSource.getUserData(uid: uid);
      return UserModel.fromMap(userData!);
    });
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    return await executeTryAndCatchForRepository(() async {
      await _authDataSource.signOut();
    });
  }

  @override
  Future<Either<Failure, UserModel>> googleAuth() async {
    return await executeTryAndCatchForRepository(() async {
      final userCredential = await _authDataSource.googleAuth();
   
     
        final userModel = UserModel(
            type:Role.patient.name ,
            profileImage: userCredential.user?.photoURL,
            phoneNumber: userCredential.user?.phoneNumber,
            uid: userCredential.user!.uid,
            email: userCredential.user!.email!,
            name: userCredential.user!.displayName!,
            createdAt: DateTime.now(),
            );
        await _authDataSource.setUser(userModel: userModel);
        return userModel;
      
    });
  }



  @override
  Future<Either<Failure, bool>> checkUesrSignin() async {
    return await executeTryAndCatchForRepository(() async {
      return await _authDataSource.checkUesrSignin();
    });
  }

  @override
  Future<Either<Failure, void>> updateUser(String uid, Map<String, dynamic> data) async {
    return await executeTryAndCatchForRepository(() async {
      await _authDataSource.updateUser(uid, data);
    });
  }
  
  @override
  Future<Either<Failure, void>> resetPassword({required String email}) {
    return executeTryAndCatchForRepository(() async {
      await _authDataSource.resetPassword(email: email);
    });
  }
}
