//
//  FeedView.swift
//  RunClub
//
//  Created by Alex Fogg on 28/10/2024.
//

import SwiftUI

struct FeedView: View {
    var feedItems: [FeedItem]
    
    var body: some View {
        LazyVStack(spacing: 12) {
            ForEach(feedItems) { item in
                switch item {
                case .message(let message):
                    PostView(message: message)
                case .event(let event):
                    EventRow(event: event)
                }
            }
        }
        .padding(.top)
    }
}
