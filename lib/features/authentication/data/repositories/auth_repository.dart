import 'package:alagy/core/common/enities/user_model.dart';
import 'package:alagy/core/constants/app_constants.dart';
import 'package:alagy/core/error/failure.dart';
import 'package:dartz/dartz.dart';
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
  Future<Either<Failure, void>> sendVerificationEmail();
  Future<Either<Failure, void>> setUser({required UserModel userModel});
  Future<Either<Failure, void>> deleteUser({required String uid});
  Future<Either<Failure, String>> signIn(
      {required String email, required String password});
  Future<Either<Failure, UserModel>> getUser({required String uid});
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, UserModel>> googleAuth();
  Future<Either<Failure, bool>> checkUesrSignin();
  Future<Either<Failure, void>> updateUser(String uid,Map<String, dynamic> data);

}

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authDataSource;

  AuthRepositoryImpl({required AuthRemoteDataSource authDataSource})
      : _authDataSource = authDataSource;
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
          profileImage: userCredential.user?.photoURL ??
              'https://t3.ftcdn.net/jpg/05/87/76/66/360_F_587766653_PkBNyGx7mQh9l1XXPtCAq1lBgOsLl6xH.jpg',
          phoneNumber: userCredential.user?.phoneNumber,
          email: email,
          name: name,
          createdAt: DateTime.now(),
          type: type,);

      return userModel;
    });
  }
  @override
  Future<Either<Failure, void>> sendVerificationEmail() async {
    return await executeTryAndCatchForRepository(() async {
      await _authDataSource.sendVerificationEmail();
    });
  }

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
      final user =
          await _authDataSource.getUserData(uid: userCredential.user!.uid);
      if (user != null) {
        return UserModel.fromMap(user);
      } else {
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
      }
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
}
