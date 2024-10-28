//
//  FeedItem.swift
//  RunClub
//
//  Created by Alex Fogg on 28/10/2024.
//

import Foundation


enum FeedItem: Identifiable {
    case message(Message)
    case event(Event)
    
    var id: String {
        switch self {
        case .message(let message):
            return message.id ?? UUID().uuidString
        case .event(let event):
            return event.id ?? UUID().uuidString
        }
    }
    
    var date: Date {
        switch self {
        case .message(let message):
            return message.timePosted
        case .event(let event):
            return event.date
        }
    }
}
