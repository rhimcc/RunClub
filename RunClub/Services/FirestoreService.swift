//
//  Firestore.swift
//  RunClub
//
//  Created by Rhianna McCormack on 17/10/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import CoreLocation

class FirestoreService {
    let db = Firestore.firestore()
    
    
    
    func storeNewUser(user: User, completion: @escaping (Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"]))
            return
        }
        
        do {
            let jsonData = try JSONEncoder().encode(user)
            let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            
            db.collection("users").document(userId).setData(jsonDict ?? [:]) { error in
                if let error = error {
                    print("Error adding user: \(error.localizedDescription)")
                    completion(error)
                } else {
                    print("User successfully added")
                    completion(nil)
                }
            }
        } catch {
            print("Error encoding user: \(error.localizedDescription)")
            completion(error)
        }
    }
    
    func getUserByID(id: String, completion: @escaping (User?) -> Void) {
        if (id == "") {
            completion(nil)
            return
        }
        
        do {
            let docRef = db.collection("users").document(id)
            
            // Check if ID is empty before proceeding
            guard !id.isEmpty else {
                print("Error: Document ID cannot be empty")
                completion(nil)
                return
            }
            
            docRef.getDocument { (document, error) in
                if let error = error {
                    print("Error getting document: \(error)")
                    completion(nil)
                    //
                    return
                }
                
                guard let document = document, document.exists else {
                    print("Document does not exist")
                    completion(nil)
                    return
                }
                
                docRef.getDocument { (document, error) in
                    if let error = error {
                        print("Error getting document: \(error)")
                        completion(nil)
                        return
                    }
                    
                    guard let document = document, document.exists else { // checks for errors with the document
                        print("Document does not exist")
                        completion(nil)
                        return
                    }
                    do {
                        let user = try document.data(as: User.self) // creates data from the document
                        user.id = document.documentID
                        completion(user)
                    } catch {
                        print("Failed to parse user data")
                        completion(nil)
                    }
                }
            }
        } catch {
            print("Error: \(error)")
            completion(nil)
            return
        }
    }
    
    func createClub(club: Club) {
        var club = club
        print("creating club")
        do {
            let jsonData = try JSONEncoder().encode(club) // creates data from the user
            let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] // creates a dict from the data
            let docRef = db.collection("clubs").addDocument(data: jsonDict ?? [:]) { error in // sets the data for the user id with the dict
                if let error = error {
                    print("Error adding club: \(error.localizedDescription)")
                } else {
                    print("Club successfully added")
                }
            }
            club.id = docRef.documentID
        } catch {
            print("Error encoding club: \(error.localizedDescription)")
        }
        //add club id to owners club ids
        addClubIdToOwner(club: club)
    }
    
    func addClubIdToOwner(club: Club) {
        print("adding club id to owner")
        let userRef = db.collection("users").document(club.ownerId)
        
        userRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting club document: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists else {
                print("Club document does not exist")
                return
            }
            
            // Retrieve the current postIds, if they exist
            var clubIds = document.data()?["clubIds"] as? [String] ?? []
            
            // Add the new postId to the array
            if let id = club.id {
                clubIds.append(id)
            }
            
            // Update the club document with the new postIds
            userRef.updateData(["clubIds": clubIds]) { error in
                if let error = error {
                    print("Error updating club eventIds: \(error.localizedDescription)")
                } else {
                    print("Club eventIds successfully updated")
                }
            }
        }
    }
    
    func deleteClub(club: Club) async -> Bool {
        do {
            if let id = club.id {
                try await db.collection("clubs").document(id).delete()
                print("Document successfully removed!")
            }
        } catch {
            print("Error removing document: \(error)")
            return false
        }
        return true
    }
    
    func createID(for collection: String) -> String {
        let newClubRef = db.collection(collection).document()
        return newClubRef.documentID
    }
    
    func getMessageByID(id: String, completion: @escaping (Message?) -> Void) {
        let docRef = db.collection("messages").document(id) // gets the document which has the userId, if it exists
        docRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting document: \(error)")
                completion(nil)
                return
            }
            
            guard let document = document, document.exists else { // checks for errors with the document
                print("Document does not exist")
                completion(nil)
                return
            }
            
            do {
                let message = try document.data(as: Message.self)
                completion(message)
            } catch {
                print("Failed to parse post data")
                completion(nil)
            }
        }
    }
    
    func getEventById(id: String, completion: @escaping (Event?) -> Void) {
        let docRef = db.collection("events").document(id) // gets the document which has the userId, if it exists
        docRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting document: \(error)")
                completion(nil)
                return
            }
            
            guard let document = document, document.exists else { // checks for errors with the document
                print("Document does not exist")
                completion(nil)
                return
            }
            
            do {
                let event = try document.data(as: Event.self) // try to decode the document into an Event
                completion(event)
            } catch {
                print("Error decoding document: \(error)") // handle the decoding error
                completion(nil)
            }
        }
    }
    
    
    func storeEvent(event: Event, completion: @escaping () -> Void) {
        do {
            let docID = self.db.collection("events").document().documentID
            try db.collection("events").document(docID).setData(from: event){ error in // sets the data for the user id with the dict
                if let error = error {
                    print("Error adding event: \(error.localizedDescription)")
                } else {
                    print("event successfully added")
                }
                
                self.updateClubEventIds(clubId: event.clubId, eventId: docID)
            }
            
        } catch {
            print("Error encoding event: \(error.localizedDescription)")
        }
        completion()
    }
    
    func storeMessage(message: Message) {
        do {
            let docID = self.db.collection("messages").document().documentID
            try db.collection("messages").document(docID).setData(from: message){ error in // sets the data for the user id with the dict
                if let error = error {
                    print("Error adding post: \(error.localizedDescription)")
                } else {
                    print("Post successfully added")
                }
                
                self.updateClubMessageIds(clubId: message.clubId, messageId: docID)
            }
        } catch {
            print("Error encoding post: \(error.localizedDescription)")
        }
    }
    
    private func updateClubMessageIds(clubId: String, messageId: String) {
        let clubRef = db.collection("clubs").document(clubId)
        
        clubRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting club document: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists else {
                print("Club document does not exist")
                return
            }
            
            // Retrieve the current postIds, if they exist
            var messageIds = document.data()?["messageIds"] as? [String] ?? []
            
            // Add the new postId to the array
            messageIds.append(messageId)
            
            // Update the club document with the new postIds
            clubRef.updateData(["messageIds": messageIds]) { error in
                if let error = error {
                    print("Error updating club postIds: \(error.localizedDescription)")
                } else {
                    print("Club postIds successfully updated")
                }
            }
        }
    }
    private func updateClubEventIds(clubId: String, eventId: String) {
        let clubRef = db.collection("clubs").document(clubId)
        
        clubRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting club document: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists else {
                print("Club document does not exist")
                return
            }
            
            // Retrieve the current postIds, if they exist
            var eventIds = document.data()?["eventIds"] as? [String] ?? []
            
            // Add the new postId to the array
            eventIds.append(eventId)
            
            // Update the club document with the new postIds
            clubRef.updateData(["eventIds": eventIds]) { error in
                if let error = error {
                    print("Error updating club eventIds: \(error.localizedDescription)")
                } else {
                    print("Club eventIds successfully updated")
                }
            }
        }
    }
    
    func getAllMessagesForClub(clubId: String, completion: @escaping ([Message]?, Error?) -> Void) {
        db.collection("messages")
            .whereField("clubId", isEqualTo: clubId)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching messages: \(error)")
                    completion(nil, error)
                    return
                }
                
                let fetchedmessages = querySnapshot?.documents.compactMap { document -> Message? in
                    do {
                        var message = try document.data(as: Message.self)
                        message.id = document.documentID
                        return message
                    } catch {
                        print("Error decoding post: \(error)")
                        return nil
                    }
                } ?? []
                
                DispatchQueue.main.async {
                    completion(fetchedmessages, nil)
                }
            }
    }
    
    func loadAllUsers(completion: @escaping ([User]?, Error?) -> Void) {
        db.collection("users").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching users: \(error)")
                completion(nil, error)
                return
            }
            
            let fetchedUsers = querySnapshot?.documents.compactMap { document -> User? in
                do {
                    var user = try document.data(as: User.self)
                    user.id = document.documentID
                    return user
                } catch {
                    print("Error decoding post: \(error)")
                    return nil
                }
            } ?? []
            
            DispatchQueue.main.async {
                completion(fetchedUsers, nil)
            }
            
        }
    }
    
    func sendFriendRequest(to user: User) {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        if let id = user.id {
            let userRef = db.collection("users").document(id)
            
            
            userRef.getDocument { (document, error) in
                if let error = error {
                    print("Error getting club document: \(error.localizedDescription)")
                    return
                }
                
                guard let document = document, document.exists else {
                    print("User document does not exist")
                    return
                }
                
                // Retrieve the current postIds, if they exist
                var pendingFriendIds = document.data()?["pendingFriendIds"] as? [String] ?? []
                
                // Add the new postId to the array
                pendingFriendIds.append(userId)
                
                // Update the club document with the new postIds
                userRef.updateData(["pendingFriendIds": pendingFriendIds]) { error in
                    if let error = error {
                        print("Error updating club eventIds: \(error.localizedDescription)")
                    } else {
                        print("User pendingFriendIds successfully updated")
                    }
                }
            }
        }
        
    }
    func getFriendsOfUser(userId: String, completion: @escaping ([User]?, Error?) -> Void) {
        if (userId == "") {
            completion(nil, nil)
            return
        }
        
        let userRef = db.collection("users").document(userId)
        
        
        userRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting club document: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists else {
                print("User document does not exist")
                return
            }
            
            // Retrieve the current postIds, if they exist
            var friendIds = document.data()?["friendIds"] as? [String] ?? []
            if friendIds.isEmpty {
                completion([], nil)
                return
            }
            
            // Use DispatchGroup to wait for all async operations
            let dispatchGroup = DispatchGroup()
            var friends: [User] = []
            var fetchError: Error?
            
            for friendId in friendIds {
                dispatchGroup.enter() // Start async operation
                
                self.getUserByID(id: friendId) { fetchedUser in
                    DispatchQueue.main.async {
                        if let fetchedUser = fetchedUser {
                            friends.append(fetchedUser)
                        }
                    }
                    dispatchGroup.leave() // End async operation
                }
            }
            
            // When all user fetches are done
            dispatchGroup.notify(queue: .main) {
                if let error = fetchError {
                    completion(nil, error) // Return error if any occurred
                } else {
                    completion(friends, nil) // Return the list of friends
                }
            }
        }
    }
    
    func getPendingFriendsOfUser(userId: String, completion: @escaping ([User]?, Error?) -> Void) {
        let userRef = db.collection("users").document(userId)
        
        
        userRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting club document: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists else {
                print("User document does not exist")
                return
            }
            
            // Retrieve the current postIds, if they exist
            var pendingFriendIds = document.data()?["pendingFriendIds"] as? [String] ?? []
            if pendingFriendIds.isEmpty {
                completion([], nil)
                return
            }
            
            // Use DispatchGroup to wait for all async operations
            let dispatchGroup = DispatchGroup()
            var pendingFriends: [User] = []
            var fetchError: Error?
            
            for id in pendingFriendIds {
                dispatchGroup.enter() // Start async operation
                
                self.getUserByID(id: id) { fetchedUser in
                    DispatchQueue.main.async {
                        if let fetchedUser = fetchedUser {
                            pendingFriends.append(fetchedUser)
                        }
                    }
                    dispatchGroup.leave() // End async operation
                }
            }
            
            // When all user fetches are done
            dispatchGroup.notify(queue: .main) {
                if let error = fetchError {
                    completion(nil, error) // Return error if any occurred
                } else {
                    completion(pendingFriends, nil) // Return the list of friends
                }
            }
        }
    }
    
    func acceptFriendRequest(from userId: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        // remove the id from the pending requests from CURRENT USER
        let userRef = db.collection("users").document(currentUserId)
        userRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting user document: \(error.localizedDescription)")
                return
            }
            
            var pendingFriendIds = document?.data()?["pendingFriendIds"] as? [String] ?? [] // gets the current pending friend ids from the firestore
            if let index = self.getIndexOfId(id: userId, array: pendingFriendIds) {
                pendingFriendIds.remove(at: index) // removes the id of the user which has just been accepted
            }
            userRef.updateData(["pendingFriendIds" : pendingFriendIds]) { error in
                if let error = error {
                    print("Error updating pending friends: \(error.localizedDescription)")
                    return
                }
                
                var friendIds = document?.data()?["friendIds"] as? [String] ?? [] // gets the current friend ids from the firestore
                friendIds.append(userId)
                userRef.updateData(["friendIds" : friendIds]) { error in
                    if let error = error {
                        print("Error updating friends: \(error.localizedDescription)")
                        return
                    }
                    
                    // Add current user to other user's friends list
                    let otherUserRef = self.db.collection("users").document(userId)
                    otherUserRef.getDocument { (document, error) in
                        if let error = error {
                            print("Error getting other user document: \(error.localizedDescription)")
                            return
                        }
                        
                        var friendIds = document?.data()?["friendIds"] as? [String] ?? []
                        friendIds.append(currentUserId)
                        otherUserRef.updateData(["friendIds" : friendIds])
                    }
                }
            }
        }
    }
    
    func getIndexOfId(id: String, array: [String]) -> Int? {
        for i in array.indices {
            if (array[i] == id) {
                return i
            }
        }
        return nil
    }
    
    func joinClub(clubId: String) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let clubRef = db.collection("clubs").document(clubId)
        clubRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting club document: \(error.localizedDescription)")
                return
            }
            var clubMemberIds = document?.data()?["memberIds"] as? [String] ?? []
            clubMemberIds.append(userId)
            clubRef.updateData(["memberIds" : clubMemberIds])
            
        }
        
        let userRef = db.collection("users").document(userId)
        userRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting club document: \(error.localizedDescription)")
                return
            }
            var clubIds = document?.data()?["clubIds"] as? [String] ?? []
            clubIds.append(clubId)
            userRef.updateData(["clubIds" : clubIds])
            
        }
    }
    
    func leaveClub(clubId: String) {
        print("leaving club")
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let clubRef = db.collection("clubs").document(clubId)
        clubRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting club document: \(error.localizedDescription)")
                return
            }
            var clubMemberIds = document?.data()?["memberIds"] as? [String] ?? []
            if let index = self.getIndexOfId(id: userId, array: clubMemberIds) {
                print("removing club member")
                clubMemberIds.remove(at: index)
            }
            clubRef.updateData(["memberIds" : clubMemberIds])
            
        }
        
        let userRef = db.collection("users").document(userId)
        userRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting club document: \(error.localizedDescription)")
                return
            }
            var clubIds = document?.data()?["clubIds"] as? [String] ?? []
            if let index = self.getIndexOfId(id: clubId, array: clubIds) {
                clubIds.remove(at: index)
            }
            userRef.updateData(["clubIds" : clubIds])
        }
        
    }
    
    func loadAllClubs(completion: @escaping ([Club]?, Error?) -> Void) {
        db.collection("clubs").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching clubs: \(error)")
                completion(nil, error)
                return
            }
            
            let fetchedClubs = querySnapshot?.documents.compactMap { document -> Club? in
                do {
                    var club = try document.data(as: Club.self)
                    club.id = document.documentID
                    return club
                } catch {
                    print("Error decoding club: \(error)")
                    return nil
                }
            } ?? []
            
            DispatchQueue.main.async {
                completion(fetchedClubs, nil)
            }
            
        }
    }
    
    func getUsersClubs(userId: String, completion: @escaping ([Club]?, Error?) -> Void) {
        let clubsRef = db.collection("clubs")
        
        // Query clubs where the user's ID is in memberIds array
        clubsRef.whereField("memberIds", arrayContains: userId).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting clubs: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion([], nil)
                return
            }
            
            let clubs = documents.compactMap { document -> Club? in
                try? document.data(as: Club.self)
            }
            
            completion(clubs, nil)
        }
    }
    
    
    
    func getClubsUserOwns(userId: String, completion: @escaping ([Club]?, Error?) -> Void) {
        db.collection("clubs")
            .whereField("ownerId", isEqualTo: userId)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching clubs: \(error)")
                    completion(nil, error)
                    return
                }
                
                let fetchedClubs = querySnapshot?.documents.compactMap { document -> Club? in
                    do {
                        var club = try document.data(as: Club.self)
                        club.id = document.documentID
                        return club
                    } catch {
                        print("Error decoding club: \(error)")
                        return nil
                    }
                } ?? []
                
                DispatchQueue.main.async {
                    completion(fetchedClubs, nil)
                }
            }
    }
    
    func getClubById(id: String, completion: @escaping (Club?) -> Void) {
        db.collection("clubs").document(id)
        
        let docRef = db.collection("users").document(id) // gets the document which has the userId, if it exists
        docRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting document: \(error)")
                completion(nil)
                return
            }
            
            guard let document = document, document.exists else { // checks for errors with the document
                print("Document does not exist")
                completion(nil)
                return
            }
            do {
                var club = try document.data(as: Club.self) // creates data from the document
                club.id = document.documentID
                completion(club)
            } catch {
                print("Failed to parse club data")
                completion(nil)
            }
        }
    }
    
    func getRunById(id: String, completion: @escaping (Run?) -> Void) {
        let docRef = db.collection("runs").document(id) // gets the document which has the userId, if it exists
        docRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting document: \(error)")
                completion(nil)
                return
            }
            
            guard let document = document, document.exists else { // checks for errors with the document
                print("Document does not exist")
                completion(nil)
                return
            }
            do {
                var run = try document.data(as: Run.self) // creates data from the document
                run.id = document.documentID
                completion(run)
            } catch {
                print("Failed to parse club data")
                completion(nil)
            }
        }
    }
    
    func getAllRunsForEvent(eventId: String, completion: @escaping ([Run]?, Error?) -> Void) {
        db.collection("runs")
            .whereField("eventId", isEqualTo: eventId)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching messages: \(error)")
                    completion(nil, error)
                    return
                }
                
                let fetchedRuns = querySnapshot?.documents.compactMap { document -> Run? in
                    do {
                        var run = try document.data(as: Run.self)
                        run.id = document.documentID
                        return run
                    } catch {
                        print("Error decoding run: \(error)")
                        return nil
                    }
                } ?? []
                
                DispatchQueue.main.async {
                    completion(fetchedRuns, nil)
                }
            }
    }
    
    func getAllEventsForClub(clubId: String, completion: @escaping ([Event]?, Error?) -> Void) {
        db.collection("events")
            .whereField("clubId", isEqualTo: clubId)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching events: \(error)")
                    completion(nil, error)
                    return
                }
                
                let fetchedEvents = querySnapshot?.documents.compactMap { document -> Event? in
                    do {
                        var event = try document.data(as: Event.self)
                        event.id = document.documentID
                        return event
                    } catch {
                        print("Error decoding event: \(error)")
                        return nil
                    }
                } ?? []
                
                DispatchQueue.main.async {
                    completion(fetchedEvents, nil)
                }
            }
    }
    
    func storeRun(run: Run) {
        do {
            let docID = self.db.collection("runs").document().documentID
            try db.collection("runs").document(docID).setData(from: run){ error in
                if let error = error {
                    print("Error adding run: \(error.localizedDescription)")
                } else {
                    print("run successfully added")
                }
                if let eventId = run.eventId, eventId != "" {
                    self.updateEventRunIds(eventId: eventId, runId: docID)
                }
                self.updateUserRunIds(runId: run.runnerId)
            }
            
        } catch {
            print("Error encoding event: \(error.localizedDescription)")
        }
    }
    
    func updateEventRunIds(eventId: String, runId: String) {
        let eventRef = db.collection("events").document(eventId)
        
        eventRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting club document: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists else {
                print("Club document does not exist")
                return
            }
            
            // Retrieve the current postIds, if they exist
            var runIds = document.data()?["runIds"] as? [String] ?? []
            
            // Add the new postId to the array
            runIds.append(runId)
            
            // Update the club document with the new postIds
            eventRef.updateData(["runIds": runIds]) { error in
                if let error = error {
                    print("Error updating club postIds: \(error.localizedDescription)")
                } else {
                    print("Club postIds successfully updated")
                }
            }
        }
    }
    
    func loadMessages(with friendId: String, completion: @escaping ([Chat]?, Error?) -> Void) {
        let currentUserId = User.getCurrentUserId()
        
        let senderQuery = db.collection("messages")
            .whereField("senderId", isEqualTo: currentUserId)
            .whereField("receiverId", isEqualTo: friendId)
        
        let receiverQuery = db.collection("messages")
            .whereField("senderId", isEqualTo: friendId)
            .whereField("receiverId", isEqualTo: currentUserId)
        
        // Execute both queries separately
        senderQuery.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            var fetchedChats = querySnapshot?.documents.compactMap { document -> Chat? in
                var chat = try? document.data(as: Chat.self)
                chat?.id = document.documentID
                return chat
            } ?? []
            
            // After getting sender messages, fetch receiver messages
            receiverQuery.getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                let receiverChats = querySnapshot?.documents.compactMap { document -> Chat? in
                    var chat = try? document.data(as: Chat.self)
                    chat?.id = document.documentID
                    return chat
                } ?? []
                
                // Combine both results
                fetchedChats.append(contentsOf: receiverChats)
                fetchedChats.sort(by: { $0.timeSent < $1.timeSent })
                
                DispatchQueue.main.async {
                    completion(fetchedChats, nil)
                }
            }
        }
    }
    
    
    func sendMessage(to friendId: String, message: Chat) {
        do {
            let docID = self.db.collection("messages").document().documentID
            try db.collection("messages").document(docID).setData(from: message){ error in // sets the data for the user id with the dict
                if let error = error {
                    print("Error adding event: \(error.localizedDescription)")
                } else {
                    print("event successfully added")
                }
            }
            
        } catch {
            print("Error encoding event: \(error.localizedDescription)")
        }
    }
    
    func getRunsOfUser(userId: String, completion: @escaping ([Run]?, Error?) -> Void) {
        db.collection("runs")
            .whereField("runnerId", isEqualTo: userId)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching runs: \(error)")
                    completion(nil, error)
                    return
                }
                
                let fetchedRuns = querySnapshot?.documents.compactMap { document -> Run? in
                    do {
                        var run = try document.data(as: Run.self)
                        run.id = document.documentID
                        return run
                    } catch {
                        print("Error decoding run: \(error)")
                        return nil
                    }
                } ?? []
                
                DispatchQueue.main.async {
                    completion(fetchedRuns, nil)
                }
            }
    }
    
    func updateUserRunIds(runId: String) {
        let userRef = db.collection("users").document(User.getCurrentUserId())
        userRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting useer document: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists else {
                print("User document does not exist")
                return
            }
            
            // Retrieve the current postIds, if they exist
            var runIds = document.data()?["runIds"] as? [String] ?? []
            
            // Add the new postId to the array
            runIds.append(runId)
            
            // Update the club document with the new postIds
            userRef.updateData(["runIds": runIds]) { error in
                if let error = error {
                    print("Error updating user runIds: \(error.localizedDescription)")
                } else {
                    print("User runIds successfully updated")
                }
            }
        }
    }
    
    func unfriend(userId: String, friendId: String, completion: @escaping () -> Void) {
        let userRef = db.collection("users").document(userId)
        userRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting user document: \(error.localizedDescription)")
                return
            }
            
            var friendIds = document?.data()?["friendIds"] as? [String] ?? []
            if let index = self.getIndexOfId(id: friendId, array: friendIds) {
                friendIds.remove(at: index)
            }
            userRef.updateData(["friendIds": friendIds])
            
            let friendRef = self.db.collection("users").document(friendId)
            friendRef.getDocument { (document, error) in
                if let error = error {
                    print("Error getting friend document: \(error.localizedDescription)")
                    return
                }
                
                var otherFriendIds = document?.data()?["friendIds"] as? [String] ?? []
                if let index = self.getIndexOfId(id: userId, array: otherFriendIds) {
                    otherFriendIds.remove(at: index)
                }
                friendRef.updateData(["friendIds": otherFriendIds])
                completion()
            }
        }
    }
    
    func checkFriendshipStatus(userId: String, otherUserId: String, completion: @escaping (FriendshipStatus) -> Void) {
        getUserByID(id: userId) { currentUser in
            if let currentUser = currentUser {
                if currentUser.friendIds?.contains(otherUserId) ?? false {
                    completion(.friends)
                } else {
                    // Check if it's an incoming request (other user's ID is in our pending)
                    if currentUser.pendingFriendIds?.contains(otherUserId) ?? false {
                        completion(.pending)
                    } else {
                        // Check if it's an outgoing request (our ID is in their pending)
                        self.getUserByID(id: otherUserId) { otherUser in
                            if let otherUser = otherUser {
                                if otherUser.pendingFriendIds?.contains(userId) ?? false {
                                    completion(.pending)
                                } else {
                                    completion(.notFriends)
                                }
                            } else {
                                completion(.notFriends)
                            }
                        }
                    }
                }
            } else {
                completion(.notFriends)
            }
        }
    }
    
    func getClubsForUser(userId: String, completion: @escaping ([Club]?, Error?) -> Void) {
        
        if (userId == "") {
            completion(nil, nil)
            return
        }
        
        let userRef = db.collection("users").document(userId)
        
        userRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting user document: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            guard let document = document, document.exists else {
                print("User document does not exist")
                completion(nil, nil)
                return
            }
            
            let clubIds = document.data()?["clubIds"] as? [String] ?? []
            if clubIds.isEmpty {
                completion([], nil)
                return
            }
            
            let group = DispatchGroup()
            var clubs: [Club] = []
            var fetchError: Error?
            
            for clubId in clubIds {
                group.enter()
                let clubRef = self.db.collection("clubs").document(clubId)
                clubRef.getDocument { (document, error) in
                    defer { group.leave() }
                    
                    if let error = error {
                        fetchError = error
                        return
                    }
                    
                    guard let document = document, document.exists else {
                        return
                    }
                    
                    do {
                        var club = try document.data(as: Club.self)
                        club.id = document.documentID
                        clubs.append(club)
                    } catch {
                        fetchError = error
                    }
                }
            }
            
            group.notify(queue: .main) {
                completion(clubs, fetchError)
            }
        }
    }
    
    
    func getMostFollowedUsers(completion: @escaping ([User]?, Error?) -> Void) {
        db.collection("users")
            .order(by: "friendIds", descending: true)
            .limit(to: 20)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching most followed users: \(error)")
                    completion(nil, error)
                    return
                }
                
                let users = querySnapshot?.documents.compactMap { document -> User? in
                    do {
                        var user = try document.data(as: User.self)
                        user.id = document.documentID
                        return user
                    } catch {
                        print("Error decoding user: \(error)")
                        return nil
                    }
                } ?? []
                
                DispatchQueue.main.async {
                    completion(users.filter { $0.id != User.getCurrentUserId() }, nil)
                }
            }
    }
    
    func cancelFriendRequest(to userId: String, completion: @escaping () -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            completion()
            return
        }
        
        let userRef = db.collection("users").document(userId)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var pendingFriendIds = document.data()?["pendingFriendIds"] as? [String] ?? []
                pendingFriendIds.removeAll { $0 == currentUserId }
                
                userRef.updateData(["pendingFriendIds": pendingFriendIds]) { error in
                    completion()
                }
            } else {
                completion()
            }
        }
    }
    
    func sendFriendRequest(to user: User, completion: @escaping (Bool) -> Void = { _ in }) {
        guard let currentUserId = Auth.auth().currentUser?.uid,
              let targetUserId = user.id else {
            completion(false)
            return
        }
        
        // Get the target user's reference
        let userRef = db.collection("users").document(targetUserId)
        
        userRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting user document: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let document = document, document.exists else {
                print("User document does not exist")
                completion(false)
                return
            }
            
            // Get current pending requests
            let pendingFriendIds = document.data()?["pendingFriendIds"] as? [String] ?? []
            
            // Check if request already exists
            guard !pendingFriendIds.contains(currentUserId) else {
                completion(false)
                return
            }
            
            // Add new request
            var updatedPendingFriendIds = pendingFriendIds
            updatedPendingFriendIds.append(currentUserId)
            
            // Update the document
            userRef.updateData(["pendingFriendIds": updatedPendingFriendIds]) { error in
                if let error = error {
                    print("Error updating pending friend ids: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("Friend request successfully sent")
                    completion(true)
                }
            }
        }
    }
    
    func searchUsers(searchTerm: String, completion: @escaping ([User]?, Error?) -> Void) {
        let searchTermLower = searchTerm.lowercased()
        
        if searchTermLower.isEmpty {
            completion([], nil)
            return
        }
        
        db.collection("users")
            .whereField("username", isGreaterThanOrEqualTo: searchTermLower)
            .whereField("username", isLessThan: searchTermLower + "\u{f8ff}")
            .limit(to: 20)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error searching users: \(error)")
                    completion(nil, error)
                    return
                }
                
                let fetchedUsers = querySnapshot?.documents.compactMap { document -> User? in
                    do {
                        var user = try document.data(as: User.self)
                        user.id = document.documentID
                        return user
                    } catch {
                        print("Error decoding user: \(error)")
                        return nil
                    }
                } ?? []
                
                DispatchQueue.main.async {
                    completion(fetchedUsers.filter { $0.id != User.getCurrentUserId() }, nil)
                }
            }
    }
    
    func rejectFriendRequest(from userId: String, completion: @escaping () -> Void = {}) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            completion()
            return
        }
        
        // Get current user's reference
        let userRef = db.collection("users").document(currentUserId)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var pendingFriendIds = document.data()?["pendingFriendIds"] as? [String] ?? []
                pendingFriendIds.removeAll { $0 == userId }
                
                userRef.updateData(["pendingFriendIds": pendingFriendIds]) { error in
                    completion()
                }
            } else {
                completion()
            }
        }
    }
    
    
}
