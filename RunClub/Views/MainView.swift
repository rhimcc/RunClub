//
//  MainView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 15/10/2024.
//

import SwiftUI

struct MainView: View {
    @State var tabSelection: Int = 1
    var body: some View {
        NavigationStack {
            TabView(selection: $tabSelection){
                PersonalView()
                    .tabItem {
                        VStack {
                            Image(systemName: "person")
                            Text("Your stats")
                        }
                    }.tag(0)
                HomeView()
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
    MainView()
}
