//
//  ClubView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import SwiftUI

struct ClubView: View {
    @State var clubTab: Int = 0
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    Circle()
                        .fill(.lightGreen)
                        .frame(width: 120)
                    
                    VStack {
                        Spacer()
                        Text("Club name")
                            .font(.title)
                            .bold()
                        Text("Owner: owner")
                            .font(.headline)
                            .padding(.bottom, 10)
                        HStack {
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.lightGreen)
                                Text("100 members")
                            }
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.lightGreen)
                                Text("Join/Joined")
                            }
                            Spacer()
                            
                        }
                        
                    }
                    
                }

                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Button("Feed") {
                        clubTab = 0
                    }
                    Button("Events") {
                        clubTab = 1
                    }
                    Button("Members") {
                        clubTab = 2
                    }
                }
                TabView (selection: $clubTab){
                    ClubFeed()
                        .tabItem {
                            Text("Feed")
                        }.tag(0)
                    EventView()
                        .tabItem {
                            Text("Events")
                        }.tag(1)
                    MembersView()
                        .tabItem {
                            Text("Members")
                        }.tag(2)
                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)

    }
}

#Preview {
    ClubView()
}
