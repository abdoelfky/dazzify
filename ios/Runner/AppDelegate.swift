import Flutter
import UIKit
import GoogleMaps
import flutter_local_notifications
import app_links
import restart
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
          RestartPlugin.generatedPluginRegistrantRegisterCallback = { [weak self] in
              GeneratedPluginRegistrant.register(with: self!)
          }
  if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      }
    // This is required to make any communication available in the action isolate.
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
      GeneratedPluginRegistrant.register(with: registry)
    }
    GMSServices.provideAPIKey("AIzaSyBFsVXmS0RqDzHJB5aH-mi7vxcLbfCWswc")
    GeneratedPluginRegistrant.register(with: self)
    // Retrieve the link from parameters
          if let url = AppLinks.shared.getLink(launchOptions: launchOptions) {
            // We have a link, propagate it to your Flutter app or not
            AppLinks.shared.handleLink(url: url)
            return true // Returning true will stop the propagation to other packages
          }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
