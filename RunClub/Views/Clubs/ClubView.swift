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
    @State var showingAddEventSheet = false
    @State private var newMessage = ""
    let firestore = FirestoreService()
    @State var member: Bool = false
    @FocusState private var textFieldFocused: Bool
    @State private var feedItems: [FeedItem] = []
    @State private var upcomingEvents: [Event] = []
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 16) {
                    Circle()
                        .fill(Color("MossGreen"))
                        .frame(width: 70, height: 70)
                        .overlay(
                            Text(club.name.prefix(1).uppercased())
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            if isOwner && editMode {
                                TextField("Club Name", text: $clubName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .font(.title2.bold())
                                    .focused($textFieldFocused)
                                
                                Button("Save") {
                                    club.name = clubName
                                    firestore.createClub(club: club)
                                    textFieldFocused = false
                                    editMode = false
                                }
                                .foregroundStyle(Color("MossGreen"))
                            } else {
                                Text(club.name)
                                    .font(.title2.bold())
                                
                                if isOwner {
                                    Button {
                                        editMode = true
                                        clubName = club.name
                                    } label: {
                                        Image(systemName: "pencil")
                                            .foregroundStyle(Color("MossGreen"))
                                    }
                                }
                            }
                        }
                        
                        if let owner = owner {
                            Text("Created by \(owner.firstName ?? "Unknown")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                }
                
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "person.2")
                            .foregroundColor(.gray)
                        Text("\(club.memberIds.count)")
                            .foregroundColor(.gray)
                        Text("members")
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    if isOwner {
                        Text("Owner")
                            .foregroundColor(Color("MossGreen"))
                    }
                }
            }
            .padding()
            
            HStack(spacing: 0) {
                Button {
                    withAnimation {
                        clubTab = 0
                    }
                } label: {
                    VStack(spacing: 8) {
                        Text("Feed")
                            .foregroundColor(clubTab == 0 ? Color("MossGreen") : .gray)
                        Rectangle()
                            .fill(clubTab == 0 ? Color("MossGreen") : .clear)
                            .frame(height: 2)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                Button {
                    withAnimation {
                        clubTab = 1
                    }
                } label: {
                    VStack(spacing: 8) {
                        Text("Upcoming Events")
                            .foregroundColor(clubTab == 1 ? Color("MossGreen") : .gray)
                        Rectangle()
                            .fill(clubTab == 1 ? Color("MossGreen") : .clear)
                            .frame(height: 2)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            
            // Content
            if clubTab == 0 {
                // Message Input Field
                HStack(spacing: 12) {
                    TextField("Write a message...", text: $newMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button {
                        sendMessage()
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(newMessage.isEmpty ? .gray : Color("MossGreen"))
                    }
                    .disabled(newMessage.isEmpty)
                }
                .padding()
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        
                        ForEach(feedItems) { item in
                            switch item {
                            case .message(let message):
                                PostView(message: message)
                            case .event(let event):
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Past event")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .padding(.horizontal)
                                    
                                    EventRow(event: event)
                                }
                            }
                        }
                    }
                }
            } else {
                Button {
                    showingAddEventSheet = true
                } label: {
                    HStack {
                        Text("Add Event")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "plus.circle.fill")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("MossGreen"))
                    .cornerRadius(8)
                }
                .padding()
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(upcomingEvents) { event in
                            EventRow(event: event)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddEventSheet) {
            AddEventView(clubViewModel: ClubViewModel(), club: club)
        }
        .onAppear {
            getOwner()
            member = club.memberIds.contains(User.getCurrentUserId())
            loadFeedContent()
            loadUpcomingEvents()
        }
    }
    
    private func sendMessage() {
        guard !newMessage.isEmpty, let clubId = club.id else { return }
        
        let message = Message(
            messageContent: newMessage,
            posterId: User.getCurrentUserId(),
            clubId: clubId
        )
        
        firestore.storeMessage(message: message)
        newMessage = ""
        
        // Reload feed after sending message
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            loadFeedContent()
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
    
    private func loadFeedContent() {
        var items: [FeedItem] = []
        
        if let clubId = club.id {
            firestore.getAllMessagesForClub(clubId: clubId) { messages, error in
                if let messages = messages {
                    let messageItems = messages.map { FeedItem.message($0) }
                    items.append(contentsOf: messageItems)
                }
                
                firestore.getAllEventsForClub(clubId: clubId) { events, error in
                    if let events = events {
                        let pastEvents = events.filter { $0.date < Date() }
                        let eventItems = pastEvents.map { FeedItem.event($0) }
                        items.append(contentsOf: eventItems)
                        
                        self.feedItems = items.sorted(by: { $0.date > $1.date })
                    }
                }
            }
        }
    }
    
    private func loadUpcomingEvents() {
        if let clubId = club.id {
            firestore.getAllEventsForClub(clubId: clubId) { events, error in
                if let events = events {
                    self.upcomingEvents = events
                        .filter { $0.date > Date() }
                        .sorted(by: { $0.date < $1.date })
                }
            }
        }
    }
}

//#Preview {
//    ClubView(club: Club(name: "", ownerId: User.getCurrentUserId(), memberIds: [], eventIds: [], messageIds: []), editMode: false)
//}
