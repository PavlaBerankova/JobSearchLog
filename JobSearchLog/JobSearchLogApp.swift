//
//  JobSearchLogApp.swift
//  JobSearchLog
//
//  Created by Pavla Beránková on 06.09.2024.
//

import SwiftUI
import Firebase
import os

let logger = Logger()

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      logger.log("Firebase Configured")
    return true
  }
}

@main
struct JobSearchLogApp: App {
    // register app delegate for Firebase setup
      @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RootView()
            }
        }
    }
}
