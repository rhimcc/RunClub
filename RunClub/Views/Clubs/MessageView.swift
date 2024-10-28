//
//  MessageView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 28/10/2024.
//

import SwiftUI

struct MessageView: View {
    let dateFormatter = DateFormatterService()
    var message: Chat
    var body: some View {
        HStack {
            if (message.senderId == User.getCurrentUserId()) {
                Text(dateFormatter.getTimeString(date: message.timeSent))
                    .font(.system(size: 15))
                    .foregroundStyle(.gray)
            }
                Text(message.messageContent)
                    .padding(10)
                    .foregroundStyle(.white)
                    .background(message.senderId == User.getCurrentUserId() ? Color.mossGreen : Color.lightGreen)
                    .cornerRadius(20)
            
            if (message.receiverId == User.getCurrentUserId()) {
                Text(dateFormatter.getTimeString(date: message.timeSent))
                    .font(.system(size: 15))
                    .foregroundStyle(.gray)
            }
        }.padding(.bottom, 5)
        .frame(maxWidth: .infinity, alignment: message.senderId == User.getCurrentUserId() ? .trailing : .leading)
    }
}

//#Preview {
//    MessageView()
//}
