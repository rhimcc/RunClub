//
//  MessageStream.swift
//  RunClub
//
//  Created by Rhianna McCormack on 28/10/2024.
//

import SwiftUI

struct MessageStream: View {
    @ObservedObject var chatViewModel: ChatViewModel
    let dateFormatter = DateFormatterService()
    var friend: User

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ForEach(chatViewModel.daysPosted.sorted().reversed(), id: \.self) { day in
                    // Ensure messagesForDay returns [Chat]
                    let messagesForDay = chatViewModel.getMessagesForDay(day: day)

                    MessageDayView(day: day, messages: messagesForDay, dateFormatter: dateFormatter)
                }
            }
            .onAppear {
                initialiseMessageViews(using: proxy)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    chatViewModel.scrollToLastMessage(using: proxy)
                }
            }
            .onChange(of: chatViewModel.messages) { _, _ in
                chatViewModel.scrollToLastMessage(using: proxy)
                chatViewModel.updateDaysPosted()
            }
        }
        .onDisappear {
            chatViewModel.stopListening()
        }
    }
    
    func initialiseMessageViews(using proxy: ScrollViewProxy) {
        if let id = friend.id {
            chatViewModel.startListening(user1Id: User.getCurrentUserId(), user2Id: id)
        }
       
        if let lastMessage = chatViewModel.messages.last {
            proxy.scrollTo(lastMessage.id, anchor: .bottom)
        } // snaps the view to the last sent message
    }
}


//#Preview {
//    MessageStream()
//}
