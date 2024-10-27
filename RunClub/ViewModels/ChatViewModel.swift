import Foundation
import FirebaseFirestore

class ChatViewModel: ObservableObject {
    @Published var messages: [Chat] = []
    private var listener: ListenerRegistration?

    func startListening(user1Id: String, user2Id: String) {
        stopListening()
        
        let messagesCollection = Firestore.firestore().collection("messages")
        listener = messagesCollection
            .order(by: "timeSent")
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print("Error listening for messages: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No messages")
                    return
                }
                
                DispatchQueue.main.async {
                    // Filter messages client-side temporarily
                    self?.messages = documents.compactMap { doc -> Chat? in
                        guard let chat = try? doc.data(as: Chat.self) else { return nil }
                        
                        // Only include messages between these two users
                        let isValidMessage = (chat.senderId == user1Id && chat.receiverId == user2Id) ||
                                           (chat.senderId == user2Id && chat.receiverId == user1Id)
                        return isValidMessage ? chat : nil
                    }
                }
            }
    }

    func stopListening() {
        listener?.remove()
        listener = nil
    }
    
    deinit {
        stopListening()
    }
}
