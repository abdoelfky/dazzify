import Flutter
import UIKit
import GoogleMaps
import flutter_local_notifications
import app_links
import restart
import TikTokBusinessSDK
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
    
    // Initialize TikTok Business SDK
        let config = TikTokConfig(
            accessToken: "",  // Access token (can be empty or updated later via updateAccessToken)
            appId: "TTUFZa4Lvs1ki2OHnNKwytyRdKXyzwUF",
            tiktokAppId: "7565017967432450049"
        )
        TikTokBusiness.initializeSdk(config)
    
    GeneratedPluginRegistrant.register(with: self)
    
    // Setup TikTok Method Channel
    setupTikTokChannel()
    
    // Retrieve the link from parameters
          if let url = AppLinks.shared.getLink(launchOptions: launchOptions) {
            // We have a link, propagate it to your Flutter app or not
            AppLinks.shared.handleLink(url: url)
            return true // Returning true will stop the propagation to other packages
          }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handle deep links when app is already running
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    AppLinks.shared.handleLink(url: url)
    return true
  }
  
  // Handle universal links when app is already running
  override func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
  ) -> Bool {
    if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
       let url = userActivity.webpageURL {
      AppLinks.shared.handleLink(url: url)
      return true
    }
    return false
  }
  
  private func setupTikTokChannel() {
      guard let controller = window?.rootViewController as? FlutterViewController else {
          return
      }
      
      let channel = FlutterMethodChannel(name: "com.dazzify.app/tiktok",
                                         binaryMessenger: controller.binaryMessenger)
      
      channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
          switch call.method {
          case "initialize":
              result(true)
          case "logEvent":
              if let args = call.arguments as? [String: Any],
                 let eventName = args["eventName"] as? String {
                  let parameters = args["parameters"] as? [String: Any]
                  
                  // Log event to TikTok
                  TikTokBusiness.trackEvent(eventName, withProperties: parameters ?? [:])
                  result(true)
              } else {
                  result(FlutterError(code: "INVALID_ARGUMENT",
                                     message: "Event name is required",
                                     details: nil))
              }
          default:
              result(FlutterMethodNotImplemented)
          }
      }
  }
}
