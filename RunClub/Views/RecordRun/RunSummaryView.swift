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
                    ForEach(clubs, id: \.self) { club in
                        Text(club.name)
                            .foregroundStyle(Color.white)
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color.black))
                    }
                }
            }
            HStack {
                Text("Event")
                Spacer()
                Picker("Events", selection: $selectedEvent) {
                    ForEach(events.filter { $0.clubId == selectedClub?.id }, id: \.id) { event in
                         Text(event.name)
                             .foregroundStyle(Color.white)
                             .background(RoundedRectangle(cornerRadius: 16).fill(Color.black))
                     }
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
}

//#Preview {
//    RunSummaryView()
//}
