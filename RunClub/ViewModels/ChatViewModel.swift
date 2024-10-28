import Foundation
import FirebaseFirestore
import SwiftUI

class ChatViewModel: ObservableObject {
    @Published var messages: [Chat] = []
    private var listener: ListenerRegistration?
    @Published var daysPosted: [String] = []
    @Published var message: String = ""
    let firestore = FirestoreService()
    let dateFormatter = DateFormatterService()


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
    
    func sendMessage(friendId: String) {
        let newMessageID = firestore.db.collection("messages").document().documentID
        let message = Chat(id: newMessageID, messageContent: message, senderId: User.getCurrentUserId(), receiverId: friendId)
        firestore.sendMessage(to: friendId, message: message)
        messages.append(message)
        self.message = ""
    }
    
     func scrollToLastMessage(using proxy: ScrollViewProxy) {
         if let lastMessage = messages.last {
             withAnimation {
                 proxy.scrollTo(lastMessage.id, anchor: .bottom)
             }
         }
     }
    
    func updateDaysPosted() {
        let uniqueDays = Set(messages.map { $0.getDateString() })
        daysPosted = Array(uniqueDays).sorted() // Sort the days after converting to array
    }
    
    func getMessagesForDay(day: String) -> [Chat] {
        return messages.filter({dateFormatter.getDateString(date: $0.timeSent) == day})
    }
    
    
}
