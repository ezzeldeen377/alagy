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
      minimumFetchInterval:
          const Duration(seconds: 0), // Force fetch for testing
    ));

    await fetchAndActivate();
  }

  Future<void> fetchAndActivate() async {
    try {
      final updated = await _remoteConfig.fetchAndActivate();
      print('Remote Config fetchAndActivate: $updated');
      final all = _remoteConfig.getAll();
      all.forEach((key, value) {
        print('Remote Config Key: $key, Value: ${value.asString()}');
      });
    } catch (e) {
      print('Remote Config fetch error: $e');
    }
  }

  bool get showOnlinePayment {
    final val = _remoteConfig.getValue('showOnlinePayment');
    final asString = val.asString();

    // Return true if the string is '1' or 'true' or int is 1
    if (asString == '1' || asString.toLowerCase() == 'true') return true;
    return val.asInt() == 1 || val.asBool();
  }
}
