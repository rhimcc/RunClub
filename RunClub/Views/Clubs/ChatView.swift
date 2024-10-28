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
    let dateFormatter = DateFormatterService()
    var body: some View {
        VStack {
            if let firstName = friend.firstName, let lastName = friend.lastName {
                Text(firstName + " " + lastName)
                    .font(.headline)
            }
            MessageStream(chatViewModel: chatViewModel, friend: friend)
            


            HStack {
                TextField("Message...", text: $chatViewModel.message)
                    .textFieldStyle(.roundedBorder)
                Button {
                    if let id = friend.id {
                        chatViewModel.sendMessage(friendId: id)
                    }
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
                chatViewModel.updateDaysPosted()
                loadAllMessages()
            }
    }
    
    func loadAllMessages() {
        if let id = friend.id {
            firestore.loadMessages(with: id) { messages, error in
                DispatchQueue.main.async {
                    if let messages = messages {
                        chatViewModel.messages = messages
                    }
                }
            }
            
        }
    }
    
    
    

    
   

}

//#Preview {
//    ChatView()
//}



