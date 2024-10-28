//
//  RunClubApp.swift
//  RunClub
//
//  Created by Rhianna McCormack on 14/10/2024.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseAuth

@main
struct YourApp: App {
    // register app delegate for Firebase setup
    let authViewModel: AuthViewModel
    init() {
        FirebaseApp.configure()
        authViewModel = AuthViewModel()
        // Request permission for notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Permission granted for notifications.")
            } else if let error = error {
                print("Failed to request authorization: \(error.localizedDescription)")
            }
        }
        
        // Register for remote notifications
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    var body: some Scene {
        WindowGroup {
            if (authViewModel.isSignedIn) {
                MainView(authViewModel: authViewModel)
            } else {
                ContentView(authViewModel: authViewModel)
            }
        }
    }
}

