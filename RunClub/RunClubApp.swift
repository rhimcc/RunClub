//
//  RunClubApp.swift
//  RunClub
//
//  Created by Rhianna McCormack on 14/10/2024.
//

// hi
// hello

import SwiftUI
import SwiftData
import FirebaseCore

@main
struct YourApp: App {
  // register app delegate for Firebase setup
    init() {
        FirebaseApp.configure()
    }

  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
      }
    }
  }
}
