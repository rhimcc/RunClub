//
//  EventRow.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import SwiftUI

struct EventRow: View {
    let dateFormatter = DateFormatterService()
    var event: Event
    var body: some View {
        VStack {
            Text(event.getDaysString())
                .font(.system(size: 20))
                .bold()
                .multilineTextAlignment(.center)
            //MAP
            
            HStack {
                Text(dateFormatter.getDateString(date: event.date))
                Text(dateFormatter.getTimeString(date: event.date))
            }
            Text("Distance: \(String(format: "%.1f", Double(event.distance)))km")
        
        }.padding()
        .background(RoundedRectangle(cornerRadius: 25)
            .shadow(color: .black.opacity(0.2), radius: 5)
        )
       
    }
}

//#Preview {
//    EventRow()
//}
