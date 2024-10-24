//
//  AuthViewModel.swift
//  RunClub
//
//  Created by Rhianna McCormack on 17/10/2024.
//

import Foundation
import FirebaseAuth


class AuthViewModel: ObservableObject {
    @Published var isSignedIn = false
    @Published var errorMessage: String?
    let firestore = FirestoreService()
    
    init() {
        checkSignIn()
        
    }
    
    func checkSignIn() {
        if Auth.auth().currentUser != nil {
            isSignedIn = true
        } else {
            isSignedIn = false
        }
    }

    func signIn(withEmail email: String, password: String) { // facilitates the sign in
        // attempts to sign in using firebase authentication
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            // capture a strong reference to self to avoid retain cycles
            guard let strongSelf = self else { return }
            
            //checks for errors
            if let error = error {
                strongSelf.errorMessage = error.localizedDescription
                return
            }
            //sets the signed in status to true
            strongSelf.isSignedIn = true
        }
    }
    
    func createAccount(withEmail email: String, password: String, firstName: String, lastName: String, phoneNumber: String, username: String) { // allows the user to create an account
        // create user with firebase authentication
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            // capture a strong reference to self to avoid retain cycles
            guard let strongSelf = self else { return }
            
            //checks for errors
            if let error = error {
                strongSelf.errorMessage = error.localizedDescription
                return
            }
            // sets signed in status to true
            strongSelf.isSignedIn = true
            //creates a new user from the data
            
            if let uid = authResult?.user.uid {
                let user = User(id: uid, firstName: firstName, lastName: lastName, email: email, friendIds: [], clubIds: [], phoneNumber: phoneNumber, username: username, runIds: [], pendingFriendIds: [])
                self?.firestore.storeNewUser(user: user)
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isSignedIn = false
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func passwordsMatch(password: String, confirmPassword: String) -> Bool { // checks if the passwords entered by the users match
        if password == confirmPassword {
            return true
        } else {
            errorMessage = "Passwords do not match"
            return false
        }
    }
}
