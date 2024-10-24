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

