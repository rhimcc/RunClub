//
//  EventView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import SwiftUI
import CoreLocation

struct EventView: View {
    @ObservedObject var eventViewModel: EventViewModel = EventViewModel()
    var club: Club
    @State var events: [Event] = []
    let firestore = FirestoreService()
    @State var eventPopUp: Bool = false
    @State var currentEvent: Event? = nil
    
    var body: some View {
        ScrollViewReader { scrollProxy in // Use ScrollViewReader
            ScrollView {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            eventViewModel.addEventSheet.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 20))
                        }
                        .sheet(isPresented: $eventViewModel.addEventSheet, onDismiss: dismissEventSheet) {
                                AddEventView(eventViewModel: eventViewModel, club: club)
                        }.presentationDragIndicator(.automatic)
                            .presentationDetents([.height(200)])
                        
                    }
                    
                    ForEach(events) { event in
                        Button {
                            currentEvent = event
                                eventPopUp = true
                        } label: {
                            EventRow(event: event)
                                .padding()
                        }
                 
                    }
                }
            }.onAppear {
                fetchEvents() {
                    scrollToCurrentEvent(using: scrollProxy)
                }
            }.sheet(item: $currentEvent, content: { event in
                EventDetailView(event: event)
             })
        }
    }
    
    
    private func fetchEvents(completion: @escaping () -> Void) {
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
                self.events = fetchedEvents.sorted(by: {$0.date < $1.date})
                completion()
            }
    }
    
    func dismissEventSheet() {
        fetchEvents() {}
        eventViewModel.addEventSheet = false
    }
    
    private func scrollToCurrentEvent(using proxy: ScrollViewProxy) {
        let today = Date()
        if let index = events.firstIndex(where: { $0.date >= today }) {
            withAnimation {
                proxy.scrollTo(index, anchor: .top) // Scroll to the index
            }
        }
    }
}

//#Preview {
//    EventView()
//}
