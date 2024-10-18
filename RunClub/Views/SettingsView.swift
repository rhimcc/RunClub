//
//  SettingsView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 18/10/2024.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
        Button ("SIGN OUT"){
            authViewModel.signOut()
            authViewModel.isSignedIn = false
        }
    }
}

#Preview {
    SettingsView(authViewModel: AuthViewModel())
}
