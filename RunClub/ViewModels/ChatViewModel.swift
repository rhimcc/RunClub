//
//  ChatViewModel.swift
//  RunClub
//
//  Created by Rhianna McCormack on 28/10/2024.
//

import Foundation
import FirebaseFirestore

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    private var listener: ListenerRegistration?

    
    func startListening(user1Id: String, user2Id: String) {
        listener = Firestore.firestore().collection("messages")
            .whereField("senderId", in: [user1Id, user2Id])
            .whereField("receiverId", in: [user1Id, user2Id])
            .order(by: "timeSent")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("No messages")
                    return
                }
                self?.messages = documents.compactMap { doc in
                    try? doc.data(as: Message.self)
                }
            }
    }
    
    
    func stopListening() { // removes the listener, to stop listening
        listener?.remove()
    }
    
}
