//
//  UpcomingEventsView.swift
//  RunClub
//
//  Created by Alex Fogg on 28/10/2024.
//

import SwiftUI

struct UpcomingEventsView: View {
    var events: [Event]
    
    var body: some View {
        LazyVStack(spacing: 12) {
            ForEach(events) { event in
                EventRow(event: event)
            }
        }
        .padding(.top)
    }
}
