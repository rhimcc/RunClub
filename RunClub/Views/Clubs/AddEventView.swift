import SwiftUI
import CoreLocation

struct AddEventView: View {
    @State private var date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @State private var name = ""
    @State private var distance = ""
    @State private var estimatedTime = ""
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State private var showingValidationAlert = false
    @State private var validationMessage = ""
    
    var clubViewModel: ClubViewModel
    var club: Club
    let firestore = FirestoreService()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    private var isFormValid: Bool {
        guard !name.isEmpty,
              !distance.isEmpty,
              !estimatedTime.isEmpty,
              let _ = selectedLocation,
              date > Date() else {
            return false
        }
        return true
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Add an Event")
                    .font(.title)
                    .foregroundColor(Color("MossGreen"))
                    .padding(.bottom, 10)
                
                VStack(alignment: .leading) {
                    Text("Date & Time")
                        .font(.headline)
                        .foregroundColor(Color("MossGreen"))
                    DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.graphical)
                        .tint(Color("MossGreen"))
                }
                .padding()
                .background(Color("lightGreen").opacity(0.1))
                .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Event Details")
                        .font(.headline)
                        .foregroundColor(Color("MossGreen"))
                    
                    TextField("Event Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Distance (km)", text: $distance)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                    
                    TextField("Estimated Time (minutes)", text: $estimatedTime)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                .padding()
                .background(Color("lightGreen").opacity(0.1))
                .cornerRadius(12)
                
                VStack(alignment: .leading) {
                    Text("Start Location")
                        .font(.headline)
                        .foregroundColor(Color("MossGreen"))

                    LocationPickerView(selectedLocation: $selectedLocation)
                }
                .padding()
                .background(Color("lightGreen").opacity(0.1))
                .cornerRadius(12)
                
                Button(action: createEvent) {
                    Text("Create Event")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color("MossGreen") : Color.gray)
                        .cornerRadius(12)
                }
                .disabled(!isFormValid)
                .padding(.top)
            }
            .padding()
        }
        .onAppear {
            UIDatePicker.appearance().minuteInterval = 5
        }
        .alert("Missing Information", isPresented: $showingValidationAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(validationMessage)
        }
    }
    
    private func validateForm() -> String? {
        if name.isEmpty {
            return "Please enter an event name"
        }
        if distance.isEmpty {
            return "Please enter a distance"
        }
        if estimatedTime.isEmpty {
            return "Please enter an estimated time"
        }
        if selectedLocation == nil {
            return "Please select a start location"
        }
        if date <= Date() {
            return "Event date must be in the future"
        }
        return nil
    }
    
    private func createEvent() {
        if let errorMessage = validateForm() {
        validationMessage = errorMessage
        showingValidationAlert = true
        return
    }

    guard let clubId = club.id,
          let locationCoordinate = selectedLocation else {
        return
    }

    let newEvent = Event(
        date: date,
        name: name,
        startPoint: locationCoordinate,
        clubId: clubId,
        distance: Double(distance) ?? 0,
        estimatedTime: Int(estimatedTime) ?? 0,
        runIds: []
    )

    firestore.storeEvent(event: newEvent)
    clubViewModel.addEventSheet = false
    }
}
