//
//  ClubView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import SwiftUI

struct ClubView: View {
    @State var club: Club
    @State var clubTab: Int = 0
    @State var editMode: Bool
    @State var isOwner: Bool = false
    @State var clubName: String = ""
    @State var owner: User?
    let firestore = FirestoreService()
    @State var member: Bool = false
    @FocusState private var textFieldFocused: Bool
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    Circle()
                        .fill(.lightGreen)
                        .frame(width: 100)
                        .padding(.horizontal, 5)
                    
                    VStack {
                        Spacer()
                        HStack {
                            
                            if (isOwner) {
                                if (editMode) {
                                    HStack {
                                        TextField("Club Name", text: $clubName)
                                            .textFieldStyle(.roundedBorder)
                                            .font(.title)
                                            .focused($textFieldFocused)
                                            .padding(3)
                                        
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
                            } else {
                                VStack (alignment: .leading){
                                    Text("\(club.name)")
                                        .font(.title)
                                        .bold()
                                    if let owner = owner, let firstName = owner.firstName {
                                        Text("Owned By: \(String(describing: firstName))")
                                            .font(.headline)
                                            .padding(.bottom, 10)
                                    }
                                }
                                Spacer()
                            }
                        }
                        
                        HStack {
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.lightGreen)
                                Text("\(club.memberIds.count)")
                            }
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.lightGreen)
                                if (isOwner) {
                                    Text("Owner")
                                        .foregroundStyle(.black)
                                        .bold()
                                } else if (member){
                                    Button("Member") {
                                        if let id = club.id {
                                            firestore.leaveClub(clubId: id)
                                        }
                                        member = false
                                        if let index = club.memberIds.firstIndex(of: User.getCurrentUserId()) {
                                            club.memberIds.remove(at: index)
                                        }
                                    }.foregroundStyle(.black)
                                        .bold()
                                } else {
                                    Button("Join") {
                                        if let id = club.id {
                                            firestore.joinClub(clubId: id)
                                        }
                                        member = true
                                        club.memberIds.append(User.getCurrentUserId())
                                    }.foregroundStyle(.black)
                                        .bold()
                                }
                            }
                            Spacer()
                            
                        }
                        
                    }
                    
                }
                
                .frame(maxWidth: .infinity, alignment: .leading)
                Line()

                HStack {
                    Spacer()

                    Button("Events") {
                        clubTab = 0
                    }.bold(clubTab == 0)
                        .foregroundStyle(.black)
                    Spacer()
                    Spacer()
                    Button("Messages") {
                        clubTab = 1
                    }.bold(clubTab == 1)
                        .foregroundStyle(.black)

                    Spacer()
                }
                Line()
            }
            
            if (clubTab == 0) {
                EventView(club: club)
            }
            if (clubTab == 1) {
                ClubMessagesView(club: club)
            }
        }
        .onAppear {
            getOwner()
            member = club.memberIds.contains(User.getCurrentUserId())
        }
    }
    
    func getOwner() {
        firestore.getUserByID(id: club.ownerId) { user in
            DispatchQueue.main.async {
                self.owner = user
            }
        }
        isOwner = club.ownerId == User.getCurrentUserId()
    }
    
}

#Preview {
    ClubView(club: Club(name: "", ownerId: User.getCurrentUserId(), memberIds: [], eventIds: [], postIds: []), editMode: false)
}
