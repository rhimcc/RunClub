//
//  ReactionBar.swift
//  RunClub
//
//  Created by Alex Fogg on 29/10/2024.
//

import SwiftUI

struct ReactionBar: View {
    let itemId: String
    let reactions: [Reaction]
    let onReact: (String, Reaction.ReactionType) -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(Reaction.ReactionType.allCases, id: \.self) { type in
                Button(action: {
                    onReact(itemId, type)
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: reactionIcon(for: type))
                        Text("\(reactionCount(for: type))")
                            .font(.subheadline)
                    }
                    .foregroundColor(hasReacted(type: type) ? Color("MossGreen") : .gray)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 8)
    }
    
    private func reactionIcon(for type: Reaction.ReactionType) -> String {
        switch type {
        case .like: return "heart.fill"
        case .celebrate: return "star.fill"
        case .support: return "hands.sparkles.fill"
        case .thumbsDown: return "hand.thumbsdown.fill"
        case .shocked: return "face.dashed.fill"
        }
    }
    
    private func reactionCount(for type: Reaction.ReactionType) -> Int {
        reactions.filter { $0.type == type }.count
    }
    
    private func hasReacted(type: Reaction.ReactionType) -> Bool {
        reactions.contains { $0.type == type && $0.userId == User.getCurrentUserId() }
    }
}
