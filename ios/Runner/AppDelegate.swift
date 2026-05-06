import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyDfZ9Tane13TmbMuudVbqaV0DJvOxcxmq0")
    GeneratedPluginRegistrant.register(with: self)
    // Explicitly register with APNs so Firebase Messaging receives the
    // device token via swizzled didRegisterForRemoteNotificationsWithDeviceToken.
    // This must happen before Firebase tries to get an FCM token.
    application.registerForRemoteNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
