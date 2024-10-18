//
//  Firestore.swift
//  RunClub
//
//  Created by Rhianna McCormack on 17/10/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class FirestoreService {
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
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
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
            
            let data = document.data() // creates data from the document
            if let firstName = data?["firstName"] as? String,
               let lastName = data?["lastName"] as? String,
               let email = data?["email"] as? String {
                let user = User(id: id, firstName: firstName, lastName: lastName, email: email, friendIds: nil) // creates user from the user data
                completion(user)
            } else {
                print("Failed to parse user data")
                completion(nil)
            }
        }
    }
    
    
}
