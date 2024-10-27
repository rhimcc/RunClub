//
//  ClubMessagesView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 24/10/2024.
//

import SwiftUI

struct ClubMessagesView: View {
    let firestore = FirestoreService()
    let dateFormatter = DateFormatterService()
    var club: Club
    @State private var daysPosted: [String] = []
    @State var message: String = ""
    @State var messages: [Message] = []
    var body: some View {
        ScrollView {
            HStack {
                TextField("Post Something...", text: $message)
                    .textFieldStyle(.roundedBorder)
                Button {
                     if let id = club.id {
                        let newMessage = Message(messageContent: message, posterId: User.getCurrentUserId(), clubId: id)
                        firestore.storeMessage(message: newMessage)
                        messages.append(newMessage)
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundStyle(.white)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(RoundedRectangle(cornerRadius: 20).fill(.mossGreen))
                }
            }.padding(.horizontal)
            .padding(.bottom, 20)
            
            ForEach(daysPosted.sorted().reversed(), id: \.self) { day in
                Text(day)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(RoundedRectangle(cornerRadius: 20).fill(.lighterGreen))
                    .foregroundStyle(.black)
                ForEach(messages.sorted(by: { $0.timePosted < $1.timePosted }).filter({ dateFormatter.getDateString(date: $0.timePosted) == day}), id: \.id) { message in
                    MessageView(message: message)
                        .padding(.bottom, 10)
                }
            }
            
        }
        .onAppear {
            loadMessages()
        }
    }
    func loadMessages() {
        if let id = club.id {
            firestore.getAllMessagesForClub(clubId: id) { fetchedPosts, error in
                DispatchQueue.main.async {
                    if let fetchedPosts = fetchedPosts {
                        self.messages = fetchedPosts
                        getDaysPosted()
                    }
                }
                
            }
        }
    }
    
    func getDaysPosted() {
        for message in messages {
            if (!daysPosted.contains(message.getDateString())) {
                daysPosted.append(message.getDateString())
            }
        }
    }
}

//#Preview {
//    ClubMessagesView()
//}
