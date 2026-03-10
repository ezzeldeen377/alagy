import 'dart:convert';

import 'package:alagy/core/common/enities/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class SecureStorageHelper {
  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  static const String _userKey = 'user_data';
  static const String _firstTime = 'first_time';
  static const String _ratingListKey = 'ratingList';
  static const String _themeKey = 'theme_mode';
  static const String _localeKey = 'locale_preference';
  static final _storage = FlutterSecureStorage(aOptions:  _getAndroidOptions(),
  );
  // Save user data
  static Future<Either<String, void>> saveUserData(UserModel user) async {
    try {
      await _storage.write(
        key: _userKey,
        value: user.toJson(),
      );
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  // Get user data
  static Future<Either<String, UserModel?>> getUserData() async {
    try {
      final userData = await _storage.read(key: _userKey);
      if (userData != null) {
        return Right(UserModel.fromJson(userData));
      }
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  // Remove user data
  static Future<Either<String, void>> removeUserData() async {
    try {
      await _storage.delete(key: _userKey);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  // Check if user is logged in
  static Future<Either<String, UserModel>> isUserLoggedIn() async {
    try {
      final userData = await _storage.read(key: _userKey);
      if (userData != null) {
        return Right(UserModel.fromJson(userData));
      }
      return const Left('User is not logged in');
    } catch (e) {
      return Left(e.toString());
    }
  }

  static Future<Either<String, String?>> isFirstInstallation() async {
    try {
      final flag = await _storage.read(key: _firstTime);
      if (flag != null) {
        return Right(flag);
      }
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  static Future<Either<String, void>> saveInstalltionFlag() async {
    try {
      await _storage.write(
        key: _firstTime,
        value: 'installed',
      );
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
  static Future<void> saveStringList( List<String> list) async {
  final jsonString = jsonEncode(list);
  await _storage.write(key: _ratingListKey, value: jsonString,);
}

static Future<List<String>> getStringList() async {
  final jsonString = await _storage.read(key: _ratingListKey);
  if (jsonString != null) {
    return List<String>.from(jsonDecode(jsonString));
  }
  return [];
}

  // Save theme preference
  static Future<Either<String, void>> saveThemeMode(String themeMode) async {
    try {
      await _storage.write(
        key: _themeKey,
        value: themeMode,
      );
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  // Get theme preference
  static Future<Either<String, String?>> getThemeMode() async {
    try {
      final themeMode = await _storage.read(key: _themeKey);
      return Right(themeMode);
    } catch (e) {
      return Left(e.toString());
    }
  }

  // Save language preference
  static Future<Either<String, void>> saveLocale(String languageCode) async {
    try {
      await _storage.write(
        key: _localeKey,
        value: languageCode,
      );
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  // Get language preference
  static Future<Either<String, String?>> getLocale() async {
    try {
      final languageCode = await _storage.read(key: _localeKey);
      return Right(languageCode);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
