import Foundation
import FirebaseAuth
import FirebaseFirestore
import UserNotifications

class ClubViewModel: ObservableObject {
    
    @Published var club: Club?
    private var clubListener: ListenerRegistration?
    private let firestore = FirestoreService()
    private var currentUser: User? = nil
    
    init() {
        loadCurrentUser() {
            self.startListeningForUsersClubEvents()
        }
    }
    
    func loadCurrentUser(completion: @escaping () -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        firestore.getUserByID(id: userId) { currentUser in
            DispatchQueue.main.async {
                self.currentUser = currentUser
                completion()
            }
        }
    }
    
    func startListeningForUsersClubEvents() {
        guard Auth.auth().currentUser != nil else { 
            clubListener?.remove() // Remove any existing listener
            clubListener = nil
            return 
        }
        
        let eventsCollection = Firestore.firestore().collection("events")
        clubListener = eventsCollection.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            
            // Check authentication status again in callback
            guard Auth.auth().currentUser != nil else {
                self.clubListener?.remove()
                self.clubListener = nil
                return
            }
            
            if let error = error {
                print("Error fetching events: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else {
                print("No event documents found")
                return
            }
            
            for document in documents {
                if let event = try? document.data(as: Event.self) {
                    if let currentUser = currentUser, let clubIds = currentUser.clubIds {
                        if (clubIds.contains(event.clubId)) {
                            checkIfNotification(event: event)
                        }
                    }
                }
            }
        }
    }

    func getClubNameFromId(id: String, completion: @escaping (String?) -> Void) {
        guard Auth.auth().currentUser != nil else {
            completion(nil)
            return
        }
        
        Firestore.firestore().collection("clubs").document(id)
            .getDocument { document, error in
                if let error = error {
                    print("Error fetching club name: \(error.localizedDescription)")
                    completion(nil)
                } else {
                    let clubName = document?.data()?["name"] as? String
                    completion(clubName)
                }
            }
    }

    
    deinit {
        clubListener?.remove()
    }
    

    func checkIfNotification(event: Event) {
        let notificationId = event.id ?? UUID().uuidString
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            if !requests.contains(where: { $0.identifier == notificationId }) {
                self.scheduleEventNotification(event: event)
            } else {
                print("Notification already scheduled for event: \(event.name)")
            }
        }
    }

    
    func scheduleEventNotification(event: Event) {
        getClubNameFromId(id: event.clubId) { name in
            DispatchQueue.main.async {
                if let name = name {
                    let content = UNMutableNotificationContent()
                    content.title = "\(event.name) starts in an hour!"
                    content.body = "Grab your running shoes and join your friends in \"\(name)\""
                    content.sound = .default
                    
                    let triggerDate = Calendar.current.date(byAdding: .hour, value: -1, to: event.date) // 1 hour before
                    
                    if let triggerDate = triggerDate {
                        let triggerTimeInterval = triggerDate.timeIntervalSinceNow
                        guard triggerTimeInterval > 0 else {
                            print("Trigger time is in the past for event: \(event.name)")
                            return
                        }
                        
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerTimeInterval, repeats: false)
                        let request = UNNotificationRequest(identifier: event.id ?? UUID().uuidString, content: content, trigger: trigger)
                        
                        UNUserNotificationCenter.current().add(request) { error in
                            if let error = error {
                                print("Error scheduling notification: \(error)")
                            } else {
                                print("Added notification for event: \(event.name) with trigger time interval: \(triggerTimeInterval)")
                            }
                        }
                    } else {
                        print("Invalid trigger date for event: \(event.name)")
                    }
                }
            }
        }
        
    }
    
}

