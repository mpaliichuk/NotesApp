//
//  EmailPassLoginApp.swift
//  EmailPassLogin
//
//  Created by Marian Paliichuk on 03.08.2024.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import FirebaseFirestore

@main
struct YourAppNameApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
