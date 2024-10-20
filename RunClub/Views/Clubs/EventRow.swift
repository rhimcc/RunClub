//
//  EventRow.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import SwiftUI

struct EventRow: View {
    var event: Event
    var body: some View {
        HStack {
            Text("In \(event.getDaysUntilEvent()) \ndays")
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
            Spacer()
            Text(event.name)
            Spacer()
            HStack {
                Image(systemName: "mappin.and.ellipse")
                Text("Location")
            }
            
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 10)
        .background(RoundedRectangle(cornerRadius: 20).stroke(.gray, lineWidth: 3))
    }
}

//#Preview {
//    EventRow()
//}
