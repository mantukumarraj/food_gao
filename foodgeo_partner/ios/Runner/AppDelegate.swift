import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool{
              GMSServices.provideAPIKey("AIzaSyD50bVj-AIzaSyCiJLymeCL0CTqTmcmPJ5T0lkLwA02OxWg")
               GeneratedPluginRegistrant.register(with: self)
               return super.application(application, didFinishLaunchingWithOptions: launchOptions)
             }
}
