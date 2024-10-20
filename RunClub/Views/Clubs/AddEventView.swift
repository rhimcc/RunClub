//
//  AddEventView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 20/10/2024.
//

import SwiftUI


struct AddEventView: View {
    @State var date: Date = Date()
    @State var name: String = ""
    var clubViewModel: ClubViewModel
    var club: Club
    let firestore = FirestoreService()
    var body: some View {
        VStack {
            Text("Add an event")
            DatePicker(
                "Date",
                selection: $date,
                displayedComponents: [.date]
            )
            HStack {
                Text("Name")
                Spacer()
                TextField("Name", text: $name)
            }
            Text("Location")
            Button("Create") {
                if let id = club.id {
                    firestore.storeEvent(event: Event(date: date, name: name, location: nil, timePosted: Date(), clubId: id))
                }
                clubViewModel.addEventSheet = false
            }
        }.padding()
    }
}

//#Preview {
//    AddEventView()
//}
