//
//  EventDetailView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 28/10/2024.
//

import SwiftUI
import MapKit

struct EventDetailView: View {
    let firestore = FirestoreService()
    let dateFormatter = DateFormatterService()
    var event: Event
    @State var runs: [Run] = []
    @State private var region = MKCoordinateRegion(
           center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
           span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
       )

    var body: some View {
        ScrollView {
            Spacer()
                if let startPoint = event.startPoint {
                    Map(
                        coordinateRegion: $region,
                        interactionModes: .all,
                        annotationItems: [
                            MapPin(coordinate: CLLocationCoordinate2D(
                                latitude: startPoint.latitude,
                                longitude: startPoint.longitude
                            ))
                        ]
                    ) { location in
                        MapMarker(coordinate: location.coordinate)
                    }
                    .frame(maxWidth: .infinity)
                    .aspectRatio(1, contentMode: .fill)
                    .padding(.top, 50)
                }
            Text(event.name)
                .font(.title)
            HStack {
                Text(dateFormatter.getDateString(date: event.date))
                Text(dateFormatter.getTimeString(date: event.date))
            }.padding(.bottom, 20)
            
            Text("Results (\(runs.count))")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            ForEach(Array(runs.enumerated()), id: \.element.id) { index, run in
                ResultRow(run: run, index: index)
            }
        }.padding(.horizontal)
        .onAppear {
            loadResults()
            updateRegion()
        }
    }
    
    func loadResults() {
        if let id = event.id {
            firestore.getAllRunsForEvent(eventId: id) { runs, error in
                DispatchQueue.main.async {
                    if let runs = runs {
                        self.runs = runs.sorted(by: {$0.elapsedTime < $1.elapsedTime})
                    }
                }
                    
            }
        }
    }
    
    private func updateRegion() {
           if let startPoint = event.startPoint {
               let newRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: startPoint.latitude, longitude: startPoint.longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
               region = newRegion // Update the region safely
           }
       }
}

//#Preview {
//    EventDetailView()
//}
