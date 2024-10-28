//
//  MessageDayView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 28/10/2024.
//

import SwiftUI

struct MessageDayView: View {
        var day: String
         var messages: [Chat]
         let dateFormatter: DateFormatterService

         var body: some View {
             Text(day)
                 .padding(.vertical, 5)
                 .padding(.horizontal, 10)
                 .background(RoundedRectangle(cornerRadius: 20).fill(.lighterGreen))
                 .foregroundStyle(.black)
             
             ForEach(messages, id: \.id) { message in
                 MessageView(message: message)
             }
         }
    }


//#Preview {
//    MessageDayView()
//}
