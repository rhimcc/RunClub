//
//  RunSummaryView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 27/10/2024.
//

import SwiftUI

struct RunSummaryView: View {
    let firestore = FirestoreService()
    var locationManager: LocationService
    var run: Run
    @State var clubs: [Club] = []
    @State var events: [Event] = []
    @State var selectedClub: Club? = nil
    @State var selectedEvent: Event? = nil
    
    var body: some View {
        VStack {
            Text("Your Run")
                .font(.title)
            let size = UIScreen.main.bounds.width - 40
            RouteMapView(showUserLocation: false, locationManager: locationManager)
                .frame(width: size, height: size)
            RunMetricsView(locationManager: locationManager, buttonShown: false)
            
            HStack {
                Text("Club:")
                Spacer()
                Picker("Clubs", selection: $selectedClub) {
                    Text("No Club").tag(nil as Club?)
                    ForEach(clubs.filter {$0.eventIds.count > 0}, id: \.self) { club in
                        Text(club.name)
                            .foregroundStyle(Color.white)
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color.black))
                            .tag(club as Club?)
                    }.onChange(of: selectedClub) {
                        loadEventsForSelectedClub()
                    }
                }
            }
            HStack {
                Text("Event")
                Spacer()
                Picker("Events", selection: $selectedEvent) {
                    Text("No Event").tag(nil as Event?)
                    ForEach(events, id: \.id) { event in
                        Text(event.name)
                            .foregroundStyle(Color.white)
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color.black))
                            .tag(event as Event?)
                    }
                }
            }
            Button("Save Run"){
                if let event = selectedEvent, let id = event.id {
                    let run = Run(eventId: id, locations: locationManager.locations, startTime: locationManager.startTime, elapsedTime: locationManager.elapsedTime)
                    firestore.storeRun(run: run)
                }
            }
        }.padding(20)
        
            .navigationBarBackButtonHidden(true)
            .onAppear {
                firestore.getUsersClubs(userId: User.getCurrentUserId()) { clubs, error in
                    DispatchQueue.main.async {
                        if let clubs = clubs  {
                            self.clubs = clubs
                        }
                    }
                }
                firestore.getClubsUserOwns(userId: User.getCurrentUserId()) { clubs, error in
                    DispatchQueue.main.async {
                        if let clubs = clubs  {
                            self.clubs = self.clubs + clubs
                        }
                    }
                }
            }
    }
    
    private func loadEventsForSelectedClub() {
          guard let clubId = selectedClub?.id else {
              events = [] // Clear events if no club is selected
              return
          }

          firestore.getAllEventsForClub(clubId: clubId) { events, error in
              DispatchQueue.main.async {
                  if let events = events {
                      self.events = events
                  }
              }
          }
      }
    
}

//#Preview {
//    RunSummaryView()
//}
