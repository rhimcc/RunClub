//
//  HomeView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 15/10/2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Run Club")
                        .font(.title)
                    Spacer()
                    NavigationLink {
                        SearchView()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.lightGreen)
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.white)
                            
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
    HomeView()
}
