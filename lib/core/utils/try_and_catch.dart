import 'dart:async';
import 'dart:io';

import 'package:alagy/core/error/failure.dart';
import 'package:alagy/core/error/netowrk_exception.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';


Future<Either<Failure, T>> executeTryAndCatchForRepository<T>(
    Future<T> Function() action) async {
  try {
    final result = await action();
    return right(result);
  } on NoInternetException {
    return left(
        Failure("Network error. Please check your connection and try again."));
  } on FirebaseAuthException catch (e) {
    if (e.code == 'network-request-failed' ||
        e.message?.contains('network error') == true) {
      return left(Failure(
          'Network error. Please check your connection and try again.'));
    }

    switch (e.code) {
      case 'invalid-email':
        return left(Failure("Please enter a valid email address"));
      case 'user-disabled':
        return left(Failure("This account has been disabled"));
      case 'user-not-found':
        return left(
            Failure("Account not found. Please check your credentials"));
      case 'wrong-password':
        return left(Failure("Incorrect password"));
      case 'email-already-in-use':
        return left(Failure("This email is already registered"));
      case 'weak-password':
        return left(Failure("Please use a stronger password"));
      case 'invalid-credential':
        return left(Failure("Invalid email or password"));
      case 'too-many-requests':
        return left(Failure("Too many attempts. Please try again later."));
      case 'operation-not-allowed':
        return left(
            Failure("This operation is not allowed. Please try again later."));
      default:
        return left(Failure('Authentication failed. Please try again.'));
    }
  } on TimeoutException {
    return left(Failure(
        'Request timed out. Please check your connection and try again.'));
  } on SocketException {
    return left(
        Failure('Network error. Please check your connection and try again.'));
  } on FormatException {
    return left(Failure('Something went wrong. Please try again.'));
  } on FirebaseException catch (e) {
    if (e.code == 'network-request-failed' ||
        e.message?.contains('network error') == true) {
      return left(Failure(
          'Network error. Please check your connection and try again.'));
    }
            print('@@@@@@@@@@@@@@@@${e.toString()}');

    return left(
        Failure('Service temporarily unavailable. Please try again later.'));
  } catch (e) {
    if (e.toString().contains('network error') ||
        e.toString().contains('timeout') ||
        e.toString().contains('RecaptchaCallWrapper')) {
      return left(Failure(
          'Network error. Please check your connection and try again.'));
    }
        print('@@@@@@@@@@@@@@@@${e.toString()}');

    return left(Failure('Something went wrong. Please try again later.'));
  }
}

Future<T> executeTryAndCatchForDataLayer<T>(Future<T> Function() action) async {
  try {
    var check = await Connectivity().checkConnectivity();

    if (check.contains(ConnectivityResult.mobile) ||
        check.contains(ConnectivityResult.wifi)) {
      return await action();
    } else {
      throw NoInternetException(
          "Network error. Please check your internet connection.");
    }
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'invalid-credential':
        throw FirebaseAuthException(
            message: "Invalid email or password", code: e.code);
      case 'weak-password':
        throw FirebaseAuthException(
            message: "Please use a stronger password", code: e.code);
      case 'email-already-in-use':
        throw FirebaseAuthException(
            message: "This email is already registered", code: e.code);
      case 'wrong-password':
        throw FirebaseAuthException(
            message: "Incorrect password", code: e.code);
      case 'user-not-found':
        throw FirebaseAuthException(
            message: "Account not found. Please check your credentials",
            code: e.code);
      case 'user-disabled':
        throw FirebaseAuthException(
            message: "This account has been disabled", code: e.code);
      case 'invalid-email':
        throw FirebaseAuthException(
            message: "Please enter a valid email address", code: e.code);
      default:
        throw FirebaseAuthException(
            message: "Authentication failed. Please try again.", code: e.code);
    }
  } on FirebaseException {
    rethrow;
  } on TimeoutException {
    rethrow;
  } on SocketException {
    rethrow;
  } on FormatException {
    rethrow;
  } catch (e) {
    print('@@@@@@@@@@@@@@@@${e.toString()}');
    throw Exception('Something went wrong. Please try again later.');
  }
}



// for debug






// import 'dart:async';
// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fpdart/fpdart.dart';
// import '../erorr/faliure.dart';
// import '../erorr/netowrk_exception.dart';

// // Define a utility function to handle exceptions and return an Either type
// Future<Either<Faliure, T>> executeTryAndCatchForRepository<T>(
//     Future<T> Function() action) async {
//   try {
//     final result = await action();
//     return right(result);
//   } on FormatException catch (e) {
//     return left(Faliure('Error parsing data: ${e.message}'));
//   } on NoInternetException catch (e) {
//     return left(Faliure(e.message));
//   } on TypeError catch (e) {
//     return left(Faliure(
//         'Type error: ${e.toString()}. This might be due to incorrect data structure.'));
//   } on NoSuchMethodError catch (e) {
//     return left(Faliure(
//         'Method not found: ${e.toString()}. This might be due to missing fields in the data.'));
//   } on FirebaseAuthException catch (e) {
//     if (e.code == 'invalid-email') {
//       return left(Faliure("The email address is not valid."));
//     } else if (e.code == 'user-disabled') {
//       return left(Faliure("This user account has been disabled."));
//     } else if (e.code == 'user-not-found') {
//       return left(Faliure("No user found with this email."));
//     } else if (e.code == 'wrong-password') {
//       return left(Faliure("The password is incorrect."));
//     } else if (e.code == 'email-already-in-use') {
//       return left(Faliure("The email is already in use by another account."));
//     } else if (e.code == 'weak-password') {
//       return left(Faliure("The password is too weak."));
//     } else if (e.code == 'invalid-credential') {
//       return left(Faliure("Invalid email or password."));
//     } else {
//       return left(Faliure(
//           //e.message ??
//           'unExpected error occurred'));
//     }
//   } catch (e) {
//     print('Caught exception: ${e.hashCode} - ${e.toString()}');
//     if (e is FirebaseException) {
//       return left(Faliure(
//           'Firebase error: ${e.code} - ${e.message ?? 'An unknown Firebase error occurred'}'));
//     } else if (e is TimeoutException) {
//       return left(Faliure('Operation timed out: ${e.message}'));
//     } else if (e is SocketException) {
//       return left(Faliure('Network error: ${e.message}'));
//     } else {
//       return left(Faliure('an unexpected error occurred: ${e.toString()}'));
//     }
//   }
// }

// Future<T> executeTryAndCatchForDataLayer<T>(Future<T> Function() action) async {
//   try {
//     var check = await Connectivity().checkConnectivity();

//     if (check.contains(ConnectivityResult.mobile) ||
//         check.contains(ConnectivityResult.wifi)) {
//       return await action();
//     } else {
//       throw NoInternetException();
//     }
//   } on FirebaseAuthException catch (e) {
//     if (e.code == 'invalid-credential') {
//       throw FirebaseAuthException(
//           message: "Invalid email or password.", code: e.code);
//     } else if (e.code == 'weak-password') {
//       throw FirebaseAuthException(
//           message: "The password is too weak.", code: e.code);
//     } else if (e.code == 'email-already-in-use') {
//       throw FirebaseAuthException(
//           message: "The email is already in use by another account.",
//           code: e.code);
//     } else if (e.code == 'wrong-password') {
//       throw FirebaseAuthException(
//           message: "The password is incorrect.", code: e.code);
//     } else if (e.code == 'user-not-found') {
//       throw FirebaseAuthException(
//           message: "No user found with this email.", code: e.code);
//     } else if (e.code == 'user-disabled') {
//       throw FirebaseAuthException(
//           message: "This user account has been disabled.", code: e.code);
//     } else if (e.code == 'invalid-email') {
//       throw FirebaseAuthException(
//           message: "The email address is not valid.", code: e.code);
//     }
//     throw FirebaseAuthException(
//         message: e.message ?? 'An unknown Firebase error occurred',
//         code: e.code);
//   } on FirebaseException catch (e) {
//     throw FirebaseException(
//         message:
//             'Firebase error: ${e.code} - ${e.message ?? 'An unknown Firebase error occurred'}',
//         code: e.code,
//         plugin: e.plugin);
//   } on TimeoutException catch (e) {
//     throw Exception('Operation timed out: ${e.message}');
//   } on SocketException catch (e) {
//     throw Exception('Network error: ${e.message}');
//   } on FormatException catch (e) {
//     throw FormatException('Error parsing data: ${e.message}');
//   } catch (e) {
//     print('#########################${e.toString()}');
//     throw Exception('An unexpected error occurred: ${e.toString()}');
//   }
// }
