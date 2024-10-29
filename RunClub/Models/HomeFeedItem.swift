//
//  HomeFeedItem.swift
//  RunClub
//
//  Created by Alex Fogg on 29/10/2024.
//

import SwiftUI

enum HomeFeedItem: Identifiable {
    case run(Run, User)
    case event(Event)
    case weeklyStats(User, [Run])
    case comparison(User, User, [Run], [Run])
    
    var id: String {
        switch self {
        case .run(let run, _):
            return "run_\(run.id ?? UUID().uuidString)"
        case .event(let event):
            return "event_\(event.id ?? UUID().uuidString)"
        case .weeklyStats(let user, _):
            return "weekly_\(user.id ?? UUID().uuidString)"
        case .comparison(let user1, let user2, _, _):
            return "comparison_\(user1.id ?? UUID().uuidString)_\(user2.id ?? UUID().uuidString)"
        }
    }
    
    var date: Date {
        switch self {
        case .run(let run, _):
            return run.startTime
        case .event(let event):
            return event.date
        case .weeklyStats(_, let runs):
            return runs.map { $0.startTime }.max() ?? Date()
        case .comparison(_, _, let runs1, let runs2):
            let dates = (runs1 + runs2).map { $0.startTime }
            return dates.max() ?? Date()
        }
    }
}
