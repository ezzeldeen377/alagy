import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@singleton
class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    await _remoteConfig.setDefaults({
      'showOnlinePayment': 0, // Default to hidden (can be int or bool)
    });

    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: kDebugMode ? Duration.zero : const Duration(hours: 1),
    ));

    await fetchAndActivate();
  }

  Future<void> fetchAndActivate() async {
    try {
      final updated = await _remoteConfig.fetchAndActivate();
      print('Remote Config fetchAndActivate: $updated');
    } catch (e) {
      print('Remote Config fetch error: $e');
    }
  }

  bool get showOnlinePayment {
    final valueInt = _remoteConfig.getInt('showOnlinePayment');
    final valueBool = _remoteConfig.getBool('showOnlinePayment');
    print('showOnlinePayment (int): $valueInt');
    print('showOnlinePayment (bool): $valueBool');
    // Return true if either the int value is 1 or the bool value is true
    return valueInt == 1 || valueBool;
  }
}
