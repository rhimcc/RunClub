//
//  ChatView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 27/10/2024.
//

import SwiftUI

struct ChatView: View {
    let firestore = FirestoreService()
    var friend: User
    @State var message: String = ""
    @State var messages: [Chat] = []
    var body: some View {
        VStack {
            if let firstName = friend.firstName, let lastName = friend.lastName {
                Text(firstName + " " + lastName)
                
                ScrollView {
                    //                ForEach(messages)
                }
                HStack {
                    TextField("Message...", text: $message)
                        .textFieldStyle(.roundedBorder)
                    Button {
                        firestore.sendMessage(to: friend)
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                        
                            .background(RoundedRectangle(cornerRadius: 25.0).fill(.mossGreen))
                    }.disabled(message.isEmpty)
                }
            }
        }.onAppear {
            loadChat()
        }
    }
    
    func loadChat() {
        if let id = friend.id {
            firestore.loadMessagesSentToUser(from: id) { messages, error in
                DispatchQueue.main.async {
                    if let messages = messages {
                        self.messages = messages
                    }
                }
            }
            firestore.loadMessagesSentFromUser(to: id) { messages, error in
                DispatchQueue.main.async {
                    if let messages = messages {
                        self.messages += messages
                    }
                }
            }
        }
    }
}

//#Preview {
//    ChatView()
//}
