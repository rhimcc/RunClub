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
    @Published var isLoading = false
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

    func signIn(withEmail email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                strongSelf.isLoading = false
                
                if let error = error {
                    strongSelf.errorMessage = error.localizedDescription
                    return
                }
                strongSelf.isSignedIn = true
            }
        }
    }
    
    func createAccount(withEmail email: String, password: String, firstName: String, lastName: String, phoneNumber: String, username: String) {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                
                if let error = error {
                    strongSelf.isLoading = false
                    strongSelf.errorMessage = error.localizedDescription
                    return
                }
                
                if let uid = authResult?.user.uid {
                    let user = User(id: uid, firstName: firstName, lastName: lastName, email: email, friendIds: [], clubIds: [], phoneNumber: phoneNumber, username: username, runIds: [], pendingFriendIds: [])
                    strongSelf.firestore.storeNewUser(user: user) { error in
                        DispatchQueue.main.async {
                            strongSelf.isLoading = false
                            if let error = error {
                                strongSelf.errorMessage = error.localizedDescription
                                return
                            }
                            strongSelf.isSignedIn = true
                        }
                    }
                }
            }
        }
    }
    
    @MainActor
    func signOut() {
        do {
            isSignedIn = false
            try Auth.auth().signOut()
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
