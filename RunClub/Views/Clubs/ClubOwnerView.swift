//
//  ClubView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import SwiftUI

struct ClubOwnerView: View {
    let firestore = FirestoreService()
    @State var club: Club
    @State var editMode: Bool
    @State var clubName: String = ""
    @State var clubTab: Int = 0
    @State private var owner: User? = nil
    @FocusState private var textFieldFocused: Bool
//    @ObservedObject var clubViewModel: ClubViewModel
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Circle()
                        .fill(.gray)
                        .frame(width: 120)
                    Image(systemName: "camera")
                        .font(.system(size: 40))
                }.frame(width: 120)
                    .padding(5)
                
                VStack {
                    if (editMode) {
                        HStack {
                            TextField("Club Name", text: $clubName)
                                .textFieldStyle(.roundedBorder)
                                .font(.title)
                                .focused($textFieldFocused)
                                .padding(.vertical, 3)
                
                            Button("Save") {
                                club.name = clubName
                                firestore.createClub(club: club)
                                textFieldFocused = false
                                editMode = false
                            }.foregroundStyle(.mossGreen)
                        }
                        
                    } else {
                        HStack {
                            Text(club.name)
                                .font(.title)
                                .padding(.vertical, 8)
                            Button {
                                editMode = true
                            } label : {
                                Image(systemName: "pencil")
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                    if let owner = owner, let firstName = owner.firstName, let lastName = owner.lastName {
                        Text("Owner: \(firstName) \(lastName)")
                            .font(.headline)
                            .padding(.bottom, 10)
                    }
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.lightGreen)
                            Text("100 members")
                            
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.lightGreen)
                            Text("Owner")
                               
                        }
                    } .frame(height: 50)
                    
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
            
            Line()
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
                ClubFeed(club: club)
                    .tabItem {
                        Text("Feed")
                    }.tag(0)
                EventView(club: club)
                    .tabItem {
                        Text("Events")
                    }.tag(1)
                MembersView()
                    .tabItem {
                        Text("Members")
                    }.tag(2)
            }
             .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        }
        .onAppear {
            textFieldFocused = true
        }
        
        Button("Delete Club") {
            Task {
                let success = await firestore.deleteClub(club: club)
                    if success {
                        print("Club deleted successfully")
                    } else {
                    print("Failed to delete club")
                }
            }
        }
    }
       

    
    
    func getUserByID(id: String) {
        firestore.getUserByID(id: id) { user in
            DispatchQueue.main.async {
                if let user = user {
                    self.owner = user
                }
            }
        }
    }
    
}

#Preview {
    ClubOwnerView(club: Club(name: "", ownerId: "123", memberIds: [], eventIds: [], postIds: []), editMode: true)
}
