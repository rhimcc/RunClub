//
//  MainView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 15/10/2024.
//

import SwiftUI

struct MainView: View {
    @State var tabSelection: Int = 2
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
                RecordRunView()
                    .tabItem {
                        VStack {
                            Image(systemName: "figure.run")
                            Text("Run")
                        }
                    }.tag(1)
                HomeView(authViewModel: authViewModel)
                    .tabItem {
                        VStack {
                            Image(systemName: "house")
                            Text("Home")
                        }
                    }.tag(2)
                FriendsView()
                    .tabItem {
                        VStack {
                            Image(systemName: "person.2.fill")
                            Text("Friends")
                        }
                    }.tag(3)
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
