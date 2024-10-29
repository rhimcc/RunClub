//
//  FeedItemView.swift
//  RunClub
//
//  Created by Alex Fogg on 30/10/2024.
//

import SwiftUI

struct FeedItemView: View {
    let item: HomeFeedItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                switch item {
                case .run(_, let user):
                    Text("\(user.username)'s Run")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                case .event(let event):
                    Text(event.date > Date() ? "Upcoming Event" : "Past Event")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                case .weeklyStats(let user, _):
                    Text("\(user.username)'s Weekly Highlights")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                case .comparison(_, _, _, _):
                    Text("Running Battle")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding(.horizontal)
            
            // Content
            switch item {
            case .run(let run, _):
                RunRow(run: run, onProfile: false)
            case .event(let event):
                EventRow(event: event)
            case .weeklyStats(let user, let runs):
                WeeklyStatsCard(user: user, runs: runs)
                    .padding(.horizontal)
            case .comparison(let user1, let user2, let runs1, let runs2):
                HeadToHeadCard(user1: user1, user2: user2, runs1: runs1, runs2: runs2)
                    .padding(.horizontal)
            }
        }
    }
}
