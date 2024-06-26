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
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
}


@main
struct UNCHILOGApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject private var rootEnvironment = RootEnvironment.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ZStack {
                    RootView()
                    // アプリにロックがかけてあれば表示
                    if rootEnvironment.appLocked {
                        AppLockView()
                    }
                }
            }
        }
    }
}
