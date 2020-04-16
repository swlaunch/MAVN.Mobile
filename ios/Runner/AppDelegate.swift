import UIKit
import Flutter

@UIApplicationMain
class AppDelegate: FlutterAppDelegate {
    
    
  private var notificationTappedFromAppKilledStateCustomPayload: String?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    guard let controller = window?.rootViewController as? FlutterViewController else {
        fatalError("rootViewController is not type FlutterViewController")
    }
    
    let methodChannel = FlutterMethodChannel.init(name: "INFOBIP_CHANNEL", binaryMessenger:controller.binaryMessenger)
    
    
    if let remoteNotificationPayload = (launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String: Any]) {
        if let customPayload = remoteNotificationPayload["customPayload"] as? [String : Any] {
            let jsonData = try? JSONSerialization.data(withJSONObject: customPayload)
            let jsonString = String(data: jsonData!, encoding: .utf8)
            notificationTappedFromAppKilledStateCustomPayload = jsonString
        }
    }
    
    methodChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: FlutterResult) -> Void in
        if (call.method == "start") {
            guard let args = call.arguments as? [String: String] else {
                result("iOS could not recognize flutter arguments in method: (sendParams)")
                return
            }
            guard let apiKey = args["infobipApiKey"] else {
                return
            }
        }
        if (call.method == "getNotificationTappedFromAppKilledStateCustomPayload") {
            result(self.notificationTappedFromAppKilledStateCustomPayload)
            self.notificationTappedFromAppKilledStateCustomPayload = nil
        }
    })
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
    
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        

    }
    
    override func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
    }
}
