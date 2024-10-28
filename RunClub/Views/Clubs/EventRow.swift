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
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var isExpanded = false
    @State private var runs: [Run] = []
    @State private var runCount: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 16) {

                VStack(alignment: .leading, spacing: 4) {
                    Text(event.name)
                        .font(.headline)
                        .foregroundColor(Color("MossGreen"))
                    Text(dateFormatter.getDateString(date: event.date))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "figure.run")
                            .foregroundColor(Color("MossGreen"))
                        Text(String(format: "%.1f km", event.distance))
                            .foregroundColor(.primary)
                    }
                    .padding(.top, 2)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "clock")
                            .foregroundColor(Color("MossGreen"))
                        Text(event.getFormattedEstimatedTime())
                            .foregroundColor(.primary)
                    }
                    
                    HStack(spacing: 6) {
                        Image(systemName: "speedometer")
                            .foregroundColor(Color("MossGreen"))
                        Text(event.getEstimatedPace())
                            .foregroundColor(.primary)
                    }
                }
                
                Spacer()
                
                if let startPoint = event.startPoint {
                    Map(
                        coordinateRegion: $region,
                        interactionModes: [],
                        annotationItems: [
                            MapPin(coordinate: CLLocationCoordinate2D(
                                latitude: startPoint.latitude,
                                longitude: startPoint.longitude
                            ))
                        ]
                    ) { point in
                        MapAnnotation(coordinate: point.coordinate) {
                            Circle()
                                .fill(Color("MossGreen"))
                                .frame(width: 10, height: 10)
                        }
                    }
                    .frame(width: 180, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            
            // Attendees section
            if runCount > 0 {
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                        if isExpanded && runs.isEmpty {
                            loadDetailedResults()
                        }
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "person.2")
                            .foregroundColor(Color("MossGreen"))
                        Text("Results (\(runCount))")
                            .foregroundColor(.primary)
                            .font(.headline)
                        Spacer()
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(Color("MossGreen"))
                    }
                }
                .padding(.top, 8)
                
                if isExpanded {
                    VStack(spacing: 8) {
                        ForEach(Array(runs.enumerated()), id: \.element.id) { index, run in
                            RunRow(run: run, index: index)
                        }
                    }
                    .padding(.top, 8)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("lightGreen").opacity(0.1))
        )
//        .padding(.horizontal)
        .onAppear {
            updateRegion()
            loadRunsCount()
        }
    }
    
    private func loadRunsCount() {
        if let id = event.id {
            firestore.getAllRunsForEvent(eventId: id) { runs, error in
                DispatchQueue.main.async {
                    if let runs = runs {
                        self.runCount = runs.count
                    }
                }
            }
        }
    }
    
    private func loadDetailedResults() {
        if let id = event.id {
            firestore.getAllRunsForEvent(eventId: id) { runs, error in
                DispatchQueue.main.async {
                    if let runs = runs {
                        self.runs = runs.sorted(by: { $0.elapsedTime < $1.elapsedTime })
                    }
                }
            }
        }
    }
    
    private func updateRegion() {
        if let startPoint = event.startPoint {
            let newRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: startPoint.latitude,
                    longitude: startPoint.longitude
                ),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            region = newRegion
        }
    }
}
