//
//  AddEventView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 20/10/2024.
//

import SwiftUI


struct AddEventView: View {
    @State var date: Date = Date()
    @State var startExpanded: Bool = false
    @State var endExpanded: Bool = false

    @State var name: String = ""
    var clubViewModel: ClubViewModel
    var club: Club
    let firestore = FirestoreService()
    @State var rectHeight: Int = 0
    var event: Event?
    @State var distance: String = ""
    @ObservedObject var eventViewModel: EventViewModel = EventViewModel()
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    Text("Add an event")
                    Text("Date")
                    DatePicker(
                        "",
                        selection: $date,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    
                    Text("Name")
                    TextField("Name", text: $name)
//                    VStack {
//                        Text("Start Point")
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                        LocationPicker(getting: "startPoint", eventViewModel: eventViewModel)
//                    }
                    
                    Text("Distance")
                    TextField("Distance", text: $distance)
                }
            }// toggle km or miles
            
            Button("Create") {
                if let id = club.id {
                    firestore.storeEvent(event: Event(date: date, name: name, startPoint: nil, clubId: club.id ?? "", distance: Double(distance) ?? 0))
                }
                clubViewModel.addEventSheet = false
            }
        }.padding()
            .onAppear {
                UIDatePicker.appearance().minuteInterval = 10
            }
    }
}

//#Preview {
//    AddEventView()
//}
