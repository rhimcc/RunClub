import SwiftUI
import CoreLocation

struct RunSummaryView: View {
    let firestore = FirestoreService()
    var locationManager: LocationService
    var run: Run
    @State var clubs: [Club] = []
    @State var events: [Event] = []
    @State var selectedClub: Club? = nil
    @State var selectedEvent: Event? = nil
    
    private let maxTimeOffsetMinutes: Double = 30
    private let maxDistanceMeters: Double = 500
    
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
                    }
                }
            }
            .onChange(of: selectedClub) { _ in
                loadEventsForSelectedClub()
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
                    let run = Run(eventId: selectedEvent?.id ?? "",
                                locations: locationManager.locations,
                                startTime: locationManager.startTime ?? Date(),
                                  elapsedTime: locationManager.elapsedTime, runnerId: User.getCurrentUserId())
                    firestore.storeRun(run: run)
            }
        }
        .padding(20)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            loadClubs()
        }
    }
    
    private func loadClubs() {
        firestore.getUsersClubs(userId: User.getCurrentUserId()) { clubs, error in
            if let clubs = clubs {
                DispatchQueue.main.async {
                    self.clubs = clubs
                    self.loadAllEventsAndAutoMatch(for: clubs)
                }
            }
        }
        
        firestore.getClubsUserOwns(userId: User.getCurrentUserId()) { clubs, error in
            if let clubs = clubs {
                DispatchQueue.main.async {
                    self.clubs += clubs
                    self.loadAllEventsAndAutoMatch(for: clubs)
                }
            }
        }
    }
    
    private func loadAllEventsAndAutoMatch(for clubs: [Club]) {
        let group = DispatchGroup()
        var allEvents: [Event] = []
        
        for club in clubs {
            group.enter()
            firestore.getAllEventsForClub(clubId: club.id ?? "") { events, error in
                if let events = events {
                    allEvents.append(contentsOf: events)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.autoMatchEventAndClub(events: allEvents)
        }
    }
    
    private func autoMatchEventAndClub(events: [Event]) {
        guard let runStartLocation = locationManager.locations.first?.coordinate else { return }
        let runStartTime = locationManager.startTime
        
        var bestMatch: (event: Event, club: Club, timeDiff: TimeInterval, distance: CLLocationDistance)?
        
        for event in events {
            guard let eventLocation = event.startPoint?.toCoordinate() else { continue }
            
            let timeDifference = abs((runStartTime ?? Date()).timeIntervalSince(event.date))
            let timeOffsetMinutes = timeDifference / 60
            
            let eventCLLocation = CLLocation(latitude: eventLocation.latitude, longitude: eventLocation.longitude)
            let runCLLocation = CLLocation(latitude: runStartLocation.latitude, longitude: runStartLocation.longitude)
            let distance = eventCLLocation.distance(from: runCLLocation)
            
            if timeOffsetMinutes <= maxTimeOffsetMinutes && distance <= maxDistanceMeters {
                if bestMatch == nil ||
                   (timeOffsetMinutes < (bestMatch!.timeDiff / 60) && distance < bestMatch!.distance) {
                    if let matchingClub = clubs.first(where: { $0.id == event.clubId }) {
                        bestMatch = (event, matchingClub, timeDifference, distance)
                    }
                }
            }
        }
        
        if let match = bestMatch {
            DispatchQueue.main.async {
                self.selectedClub = match.club
                loadEventsForSelectedClub()
                self.selectedEvent = match.event
            }
        }
    }
    
    private func loadEventsForSelectedClub() {
        guard let clubId = selectedClub?.id else {
            events = []
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
