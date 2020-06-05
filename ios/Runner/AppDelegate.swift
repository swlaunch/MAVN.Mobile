import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
class AppDelegate: FlutterAppDelegate {
    

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    GMSServices.provideAPIKey("AIzaSyBM_AC_HyKaVw7nmZaroNr6Yu5EOeUFo3w")
    

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

}