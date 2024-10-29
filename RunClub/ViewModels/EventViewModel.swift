//
//  EventViewModel.swift
//  RunClub
//
//  Created by Rhianna McCormack on 25/10/2024.
//

import Foundation
import MapKit

class EventViewModel: ObservableObject {
    @Published var addEventSheet: Bool = false
    let firestore = FirestoreService()
    @Published var upcomingEvents: [Event] = []
    var club: Club? = nil
    
    func loadUpcomingEvents() {
        if let clubId = club?.id {
            firestore.getAllEventsForClub(clubId: clubId) { events, error in
                if let events = events {
                    self.upcomingEvents = events
                        .filter { $0.date > Date() }
                        .sorted(by: { $0.date < $1.date })
                }
            }
        }
    }
    
    func dismissSheet() {
        addEventSheet = false
        loadUpcomingEvents()
    }
}
