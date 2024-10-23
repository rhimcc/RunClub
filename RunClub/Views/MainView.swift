//
//  MainView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 15/10/2024.
//

import SwiftUI

struct MainView: View {
    @State var tabSelection: Int = 1
    @ObservedObject var authViewModel: AuthViewModel
    let firestore = FirestoreService()
    var body: some View {
        NavigationStack {
            TabView(selection: $tabSelection){
                ProfileView(authViewModel: authViewModel)
                    .tabItem {
                        VStack {
                            Image(systemName: "person")
                            Text("Profile")
                        }
                    }.tag(0)
                HomeView(authViewModel: authViewModel)
                    .tabItem {
                        VStack {
                            Image(systemName: "house")
                            Text("Home")
                        }
                    }.tag(1)
                ClubList()
                    .tabItem {
                        VStack {
                            Image(systemName: "shoe")
                            Text("Clubs")
                        }
                    }.tag(2)
                
            }.tint(.mossGreen)
        }
    }
}

#Preview {
    MainView(authViewModel: AuthViewModel())
}
