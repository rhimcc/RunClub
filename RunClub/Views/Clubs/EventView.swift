//
//  EventView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import SwiftUI
import CoreLocation

struct EventView: View {
    @ObservedObject var clubViewModel: ClubViewModel = ClubViewModel()
    var club: Club
    @State var events: [Event] = []
    let firestore = FirestoreService()
    
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    clubViewModel.addEventSheet.toggle()
                    print(clubViewModel.addEventSheet)
                } label: {
                    Image(systemName: "plus")
                }.sheet(isPresented: $clubViewModel.addEventSheet, onDismiss: dismissEventSheet) {
                    AddEventView(clubViewModel: clubViewModel, club: club)
                }.presentationDragIndicator(.automatic)
                    .presentationDetents([.height(200)])
                
            }
            ScrollView {
                VStack {
                    ForEach(events) { event in
                        EventRow(event: event)
                    }
                }.padding()
            }.onAppear {
                fetchEvents()
            }
            
        }
    }
    
    private func fetchEvents() {
            // Assuming the club has eventIds that you want to use to fetch posts
            let eventIds = club.eventIds
            
            let group = DispatchGroup() // To manage multiple fetch requests
            var fetchedEvents: [Event] = []
            
            for eventId in eventIds {
                group.enter() // Enter the group for each fetch
                firestore.getEventById(id: eventId) { event in
                    if let event = event {
                        fetchedEvents.append(event)
                    }
                    group.leave() // Leave the group after the fetch completes
                }
            }
            
            group.notify(queue: .main) { // Notify when all fetch requests are done
                self.events = fetchedEvents
            }
        }
    func dismissEventSheet() {
        clubViewModel.addEventSheet = false
    }
}

//#Preview {
//    EventView()
//}
