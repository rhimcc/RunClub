//
//  RunRow.swift
//  RunClub
//
//  Created by Rhianna McCormack on 28/10/2024.
//

import SwiftUI

struct RunRow: View {
    let firestore = FirestoreService()
    var run: Run
    let dateFormatter = DateFormatterService()
    @State var runner: User? = nil
    let locationManager = LocationService()
    var onProfile: Bool
    var body: some View {
        VStack {
            if (!onProfile) {
                if let runner = runner, let firstName = runner.firstName {
                    Text(firstName)
                }
            }
            Text(dateFormatter.getTimeFromSeconds(seconds: Float(run.elapsedTime)))
            RouteMapView(showUserLocation: false, locationManager: locationManager)
               
        }.padding()
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: .black.opacity(0.2), radius: 5)
        }.padding(.horizontal, 10)
        .onAppear {
            loadRunner()
            locationManager.locations = run.locations
            print(locationManager.locations.count)
        }
    }
    
    func loadRunner() {
        if let id = run.runnerId {
            firestore.getUserByID(id: id) { runner in
                DispatchQueue.main.async {
                    self.runner = runner
                }
            }
        }
    }
}

//#Preview {
//    RunRow()
//}
