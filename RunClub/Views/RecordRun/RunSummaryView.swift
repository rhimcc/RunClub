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
    var body: some View {
        VStack {
            Text("Your Run")
                .font(.title)
                .padding(.top, 20)
            let size = UIScreen.main.bounds.width - 40
            RouteMapView(showUserLocation: false, locationManager: locationManager)
                .frame(width: size, height: size)
            RunMetricsView(locationManager: locationManager, buttonShown: false)
            
            HStack {
                Text("Club")
                Spacer()
                Text("club")
                
            }
            HStack {
                Text("Event")
                Spacer()
                Text("Event")
            }
        }.padding(20)

        .navigationBarBackButtonHidden(true)
    }
}

//#Preview {
//    RunSummaryView()
//}
