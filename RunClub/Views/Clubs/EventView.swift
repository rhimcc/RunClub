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
        ScrollViewReader { scrollProxy in // Use ScrollViewReader
            ScrollView {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            clubViewModel.addEventSheet.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 20))
                        }
                        .sheet(isPresented: $clubViewModel.addEventSheet, onDismiss: dismissEventSheet) {
                            AddEventView(clubViewModel: clubViewModel, club: club)
                        }.presentationDragIndicator(.automatic)
                            .presentationDetents([.height(200)])
                        
                    }
                    
                    ForEach(events) { event in
                        EventRow(event: event)
                            .padding( )
                    }
                }
            }
                .onAppear {
                    fetchEvents() {
                        scrollToCurrentEvent(using: scrollProxy)
                    }
                }
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
        clubViewModel.addEventSheet = false
    }
    
    private func scrollToCurrentEvent(using proxy: ScrollViewProxy) {
        let today = Date()
        if let index = events.firstIndex(where: { $0.date >= today }) {
            print(index)
            withAnimation {
                proxy.scrollTo(index, anchor: .top) // Scroll to the index
            }
        }
    }
}

//#Preview {
//    EventView()
//}
