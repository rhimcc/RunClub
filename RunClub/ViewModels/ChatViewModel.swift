import Foundation
import FirebaseFirestore

class ChatViewModel: ObservableObject {
    @Published var messages: [Chat] = []
    private var listeners: [ListenerRegistration] = []

    func startListening(user1Id: String, user2Id: String) {
        let listener1 = Firestore.firestore().collection("messages")
            .whereField("senderId", isEqualTo: user1Id)
            .whereField("receiverId", isEqualTo: user2Id)
            .order(by: "timeSent")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("No messages")
                    return
                }
                let newMessages = documents.compactMap { doc in
                    try? doc.data(as: Chat.self)
                }
                self?.messages.append(contentsOf: newMessages)
                self?.messages.sort(by: { $0.timeSent < $1.timeSent })
            }
        
        let listener2 = Firestore.firestore().collection("messages")
            .whereField("senderId", isEqualTo: user2Id)
            .whereField("receiverId", isEqualTo: user1Id)
            .order(by: "timeSent")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("No messages")
                    return
                }
                let newMessages = documents.compactMap { doc in
                    try? doc.data(as: Chat.self)
                }
                self?.messages.append(contentsOf: newMessages)
                self?.messages.sort(by: { $0.timeSent < $1.timeSent })
            }

        // Store both listeners
        listeners.append(listener1)
        listeners.append(listener2)
    }

    func stopListening() {
        // Remove all listeners
        for listener in listeners {
            listener.remove()
        }
        listeners.removeAll()
    }
}
