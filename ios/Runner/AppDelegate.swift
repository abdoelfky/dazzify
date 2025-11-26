import Flutter
import UIKit
import GoogleMaps
import flutter_local_notifications
import app_links
import restart
import TikTokBusinessSDK
import AVFoundation
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
    
    // Configure audio session for proper playback, especially when launching from TikTok ads
    configureAudioSession()
    
    // Initialize TikTok Business SDK for ad tracking
        // Note: Access token can be empty initially and updated later via TikTokBusiness.updateAccessToken()
        // Get your TikTok Access Token from TikTok Ads Manager -> Tools -> Events
        let tiktokAccessToken = ""  // TODO: Add your TikTok Access Token here
        
        let config = TikTokConfig(
            accessToken: tiktokAccessToken,
            appId: "TTUFZa4Lvs1ki2OHnNKwytyRdKXyzwUF",
            tiktokAppId: "7565017967432450049"
        )
        
        // Enable debug mode for testing (disable in production)
        TikTokBusiness.setDebugMode(true)
        TikTokBusiness.initializeSdk(config)
        
        print("TikTok Business SDK initialized with App ID: 7565017967432450049")
    
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
                  
                  // Log event to TikTok Business SDK
                  TikTokBusiness.trackEvent(eventName, withProperties: parameters ?? [:])
                  print("TikTok Event tracked: \(eventName) with properties: \(parameters ?? [:])")
                  result(true)
              } else {
                  result(FlutterError(code: "INVALID_ARGUMENT",
                                     message: "Event name is required",
                                     details: nil))
              }
          case "updateAccessToken":
              if let args = call.arguments as? [String: Any],
                 let accessToken = args["accessToken"] as? String {
                  // Update TikTok Access Token dynamically
                  TikTokBusiness.updateAccessToken(accessToken)
                  print("TikTok Access Token updated successfully")
                  result(true)
              } else {
                  result(FlutterError(code: "INVALID_ARGUMENT",
                                     message: "Access token is required",
                                     details: nil))
              }
          default:
              result(FlutterMethodNotImplemented)
          }
      }
  }
  
  private func configureAudioSession() {
      do {
          let audioSession = AVAudioSession.sharedInstance()
          // Set category to playback to ensure audio plays even when coming from TikTok ads
          // This allows video sound to play and mix with other audio if needed
          try audioSession.setCategory(.playback, mode: .moviePlayback, options: [.mixWithOthers])
          try audioSession.setActive(true)
          
          print("Audio session configured successfully for TikTok ad launches")
      } catch {
          print("Failed to configure audio session: \(error.localizedDescription)")
      }
  }
  
  override func applicationDidBecomeActive(_ application: UIApplication) {
      super.applicationDidBecomeActive(application)
      // Reconfigure audio session when app becomes active (e.g., returning from TikTok)
      configureAudioSession()
  }
}
