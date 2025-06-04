import Flutter
import UIKit
import GoogleSignIn

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
        #if targetEnvironment(simulator)
    // Configure for debugging.
    // See: https://developers.google.com/identity/sign-in/ios/appcheck/debug-provider
    #else
    GIDSignIn.sharedInstance.configure { error in
      if let error {
        print("Error configuring `GIDSignIn` for Firebase App Check: \(error)")
      }
    }
    #endif
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
