import UIKit
import Flutter
import GoogleMaps
import app_links
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
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
