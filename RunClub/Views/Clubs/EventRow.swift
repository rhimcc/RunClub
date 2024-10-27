//
//  EventRow.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import SwiftUI

struct EventRow: View {
    let firestore = FirestoreService()
    let dateFormatter = DateFormatterService()
    var event: Event
    @State var showResults: Bool = false
    @State var runs: [Run] = []
    var body: some View {
        VStack {
            Text(event.getDaysString())
                .font(.system(size: 20))
                .bold()
                .multilineTextAlignment(.center)
            //MAP
            
            HStack {
                Text(dateFormatter.getDateString(date: event.date))
                Text(dateFormatter.getTimeString(date: event.date))
            }
            Text("Distance: \(String(format: "%.1f", Double(event.distance)))km")
            if (event.runIds.count > 0) {
                Button("View results") {
                    showResults = true
                }
                if (showResults) {
                    
                }
            }
        }
        .padding()
            .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 25)
            .fill(.white)
            .shadow(color: .black.opacity(0.2), radius: 5)
        )
        .onAppear {
            loadResults()
        }
    }
    
    func loadResults() {
        if let id = event.id {
            firestore.getAllRunsForEvent(eventId: id) { runs, error in
                DispatchQueue.main.async {
                    if let runs = runs {
                        self.runs = runs
                    }
                }
                    
            }
        }
    }
}

//#Preview {
//    EventRow()
//}
