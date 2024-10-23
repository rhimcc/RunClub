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
    
    
    
    func storeNewUser(user: User)  {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        do {
            let jsonData = try JSONEncoder().encode(user) // creates data from the user
            let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] // creates a dict from the data
            db.collection("users").document(userId).setData(jsonDict ?? [:]) { error in // sets the data for the user id with the dict
                if let error = error {
                    print("Error adding user: \(error.localizedDescription)")
                } else {
                    print("User successfully added")
                }
            }
        } catch {
            print("Error encoding user: \(error.localizedDescription)")
        }
    }
    
    func getUserByID(id: String, completion: @escaping (User?) -> Void) {
        
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
                let user = try document.data(as: User.self) // creates data from the document
                user.id = document.documentID
                completion(user)
            } catch {
                print("Failed to parse user data")
                completion(nil)
            }
        }
    }
    
    func createClub(club: Club) {
        
        do {
            let jsonData = try JSONEncoder().encode(club) // creates data from the user
            let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] // creates a dict from the data
            db.collection("clubs").addDocument(data: jsonDict ?? [:]) { error in // sets the data for the user id with the dict
                if let error = error {
                    print("Error adding club: \(error.localizedDescription)")
                } else {
                    print("Club successfully added")
                }
            }
        } catch {
            print("Error encoding club: \(error.localizedDescription)")
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
    
    func getPostByID(id: String, completion: @escaping (Post?) -> Void) {
        let docRef = db.collection("posts").document(id) // gets the document which has the userId, if it exists
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
                let post = try document.data(as: Post.self)
                completion(post)
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
    
    
    func storeEvent(event: Event) {
        do {
            let jsonData = try JSONEncoder().encode(event) // creates data from the user
            let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] // creates a dict from the data
            let docID = self.db.collection("events").document().documentID
            db.collection("events").document(docID).setData(jsonDict ?? [:]){ error in // sets the data for the user id with the dict
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
    }
    
    func storePost(post: Post) {
        do {
            let jsonData = try JSONEncoder().encode(post) // creates data from the user
            let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] // creates a dict from the data
            let docID = self.db.collection("posts").document().documentID
            db.collection("posts").document(docID).setData(jsonDict ?? [:]){ error in // sets the data for the user id with the dict
                if let error = error {
                    print("Error adding post: \(error.localizedDescription)")
                } else {
                    print("Post successfully added")
                }
                
                self.updateClubPostIds(clubId: post.clubId, postId: docID)
            }
        } catch {
            print("Error encoding post: \(error.localizedDescription)")
        }
        print("stored post")
    }
    
    private func updateClubPostIds(clubId: String, postId: String) {
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
            var postIds = document.data()?["postIds"] as? [String] ?? []
            
            // Add the new postId to the array
            postIds.append(postId)
            
            // Update the club document with the new postIds
            clubRef.updateData(["postIds": postIds]) { error in
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
    
    func getClubs(completion: @escaping ([Club]) -> Void) {
        db.collection("clubs").getDocuments { (snapshot, error) in // gets the club documents from the specified collection
            if let error = error {
                print("Error loading clubs: \(error.localizedDescription)")
                completion([])
                return
            }
            
            var clubs: [Club] = [] // initialising array to store clubs
            for document in snapshot!.documents { // iterates through the array to get each individual club document
                do {
                    
                    let club = try document.data(as: Club.self)
                    clubs.append(club)
                    
                } catch let error {
                    print("Error decoding club: \(error.localizedDescription)")
                }
            }
            completion(clubs) // returns the clubs on completion
        }
    }
    
    func getAllPostsForClub(clubId: String, completion: @escaping ([Post]?, Error?) -> Void) {
        db.collection("posts")
            .whereField("clubId", isEqualTo: clubId)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching posts: \(error)")
                    completion(nil, error)
                    return
                }
                
                let fetchedPosts = querySnapshot?.documents.compactMap { document -> Post? in
                    do {
                        var post = try document.data(as: Post.self)
                        post.id = document.documentID
                        return post
                    } catch {
                        print("Error decoding post: \(error)")
                        return nil
                    }
                } ?? []
                
                DispatchQueue.main.async {
                    completion(fetchedPosts, nil)
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
        // remove the id from the pending request from CURRENT USERS
        let userRef = db.collection("users").document(currentUserId)
        userRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting club document: \(error.localizedDescription)")
                return
            }

            var pendingFriendIds = document?.data()?["pendingFriendIds"] as? [String] ?? [] // gets the current pending friend ids from the firestore
            if let index = self.getIndexOfId(id: userId, array: pendingFriendIds) {
                pendingFriendIds.remove(at: index) // removes the id of the user which has just been accepted
            }
            userRef.updateData(["pendingFriendIds" : pendingFriendIds]) // updates the data to the array after removing the id

            var friendIds = document?.data()?["friendIds"] as? [String] ?? [] // gets the current friend ids from the firestore
            friendIds.append(userId)
            userRef.updateData(["friendIds" : friendIds]) // updates the data to the array after adding the id

        }

        let otherUserRef = db.collection("users").document(userId)
        otherUserRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting club document: \(error.localizedDescription)")
                return
            }
            print("6")

            var friendIds = document?.data()?["friendIds"] as? [String] ?? [] // gets the current friend ids from the firestore
            friendIds.append(currentUserId)
            otherUserRef.updateData(["friendIds" : friendIds]) // updates the data to the array after adding the id
            
            
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
}
        
    
    

    
    

