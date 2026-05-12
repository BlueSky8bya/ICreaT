import Flutter
import UIKit
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
    application.registerForRemoteNotifications()
    
    let fvc =  window?.rootViewController as! FlutterViewController
    _ = BluetoothChannel(controller: fvc)

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    // override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    //     Messaging.messaging().apnsToken = deviceToken
    //     super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    // }
}
