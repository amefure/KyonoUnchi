//
//  UNCHILOGApp.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/24.
//

import SwiftUI
import FirebaseCore
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Firebase Analytics
        FirebaseApp.configure()
        // AdMob
        MobileAds.shared.start(completionHandler: nil)
        return true
    }
}


@main
struct UNCHILOGApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.rootEnvironment) private var rootEnvironment

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if rootEnvironment.state.appLocked {
                    AppLockView()
                } else {
                    RootView()
                }
            }
        }
    }
}
