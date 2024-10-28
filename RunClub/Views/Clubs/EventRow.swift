//
//  EventRow.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import SwiftUI
import MapKit

struct EventRow: View {
    let firestore = FirestoreService()
    let dateFormatter = DateFormatterService()
    var event: Event
//    @State private var region : MKCoordinateRegion?
    @State private var region = MKCoordinateRegion(
           center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
           span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
       )

    var body: some View {
        VStack {
            Text(event.name)
            Text(event.getDaysString())
                .font(.system(size: 20))
                .bold()
                .multilineTextAlignment(.center)
        
            if let startPoint = event.startPoint {
                          Map(
                              coordinateRegion: $region,
                              interactionModes: [],
                              annotationItems: [
                                  Location(coordinate: CLLocationCoordinate2D(
                                    latitude: startPoint.latitude,
                                    longitude: startPoint.longitude
                                  ))
                              ]
                          ) { location in
                              MapMarker(coordinate: location.coordinate)
                          }
                          .frame(height: 200)
                      }
            
            HStack {
                Text(dateFormatter.getDateString(date: event.date))
                Text(dateFormatter.getTimeString(date: event.date))
            }
            Text("Distance: \(String(format: "%.1f", Double(event.distance)))km")
        }.foregroundStyle(.black)
        .padding()
            .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 25)
            .fill(.white)
            .shadow(color: .black.opacity(0.2), radius: 5)
        )
        .onAppear {
//            loadResults()
            updateRegion()
        }
    }
    
    private func updateRegion() {
           if let startPoint = event.startPoint {
               let newRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: startPoint.latitude, longitude: startPoint.longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
               region = newRegion // Update the region safely
           }
       }
    
   
}

public struct Location: Identifiable {
    public let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

//#Preview {
//    EventRow()
//}
