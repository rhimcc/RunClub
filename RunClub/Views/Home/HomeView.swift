//
//  HomeView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 15/10/2024.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var authViewModel: AuthViewModel
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Run Club")
                        .font(.title)
                    Spacer()
                    NavigationLink {
                        SettingsView(authViewModel: authViewModel)
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.lightGreen)
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "gearshape")
                                .foregroundStyle(.white)
                                .bold()
                            
                        }
                    }
                    NavigationLink {
                        SearchView()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.lightGreen)
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.white)
                                .bold()
                            
                        }
                    }
                    NavigationLink {
                        //ChatView()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.lightGreen)
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "message")
                                .foregroundStyle(.white)
                                .bold()
                        }
                    }
                }.padding()
                ScrollView {
                    //ForEach() post postView
                }
            }
        }
    }
}

#Preview {
    HomeView(authViewModel: AuthViewModel())
}
