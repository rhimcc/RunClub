//
//  ChatView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 28/10/2024.
//

import SwiftUI

struct ChatView: View {
    let firestore = FirestoreService()
    var friend: User
    @ObservedObject var chatViewModel: ChatViewModel = ChatViewModel()
    @State var messages: [Chat] = []
    @State var message: String = ""
    var body: some View {
        VStack {
            if let firstName = friend.firstName, let lastName = friend.lastName {
                Text(firstName + " " + lastName)
                    .font(.headline)
            }
            
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(messages) { message in // show all messages
                        HStack {
                            if (message.senderId == User.getCurrentUserId()) { // user is sender
                                Spacer()
                                Text(message.messageContent)
                                    .padding(10)
                                    .foregroundStyle(.white)
                                    .background(Color.mossGreen)
                                    .cornerRadius(20)
                            } else {
                                Text(message.messageContent)
                                    .padding(10)
                                    .foregroundStyle(.white)
                                    .background(Color.lightGreen)
                                    .cornerRadius(20)
                                Spacer()
                            }
                        }
                    }
                }.onAppear {
                    if let id = friend.id {
                        print("start listening")
                        chatViewModel.startListening(user1Id: User.getCurrentUserId(), user2Id: id)
                    }
                   
                    if let lastMessage = messages.last {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    } // snaps the view to the last sent message
                }
                .onChange(of: messages) { _, _ in // snaps view to the last sent message
                    if let lastMessage = messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }.onDisappear {
                chatViewModel.stopListening() // Stop listening when the view disappears
            }

            HStack {
                TextField("Message...", text: $message)
                    .textFieldStyle(.roundedBorder)
                Button {
                    if let id = friend.id {
                        let message = Chat(messageContent: message, senderId: User.getCurrentUserId(), receiverId: id)
                        firestore.sendMessage(to: id, message: message)
                        messages.append(message)
                    }
                    message = ""
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.mossGreen)
                        .cornerRadius(20)

                }
            }
        }.padding()
            .onAppear {
                loadAllMessages()
            }
    }
    
    func loadAllMessages() {
        if let id = friend.id {
            firestore.loadMessages(with: id) { messages, error in
                DispatchQueue.main.async {
                    if let messages = messages {
                        self.messages = messages
                    }
                }
            }
            
        }
    }

}

//#Preview {
//    ChatView()
//}

