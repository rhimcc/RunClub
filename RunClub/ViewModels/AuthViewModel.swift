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
    
    init() {
        checkSignIn()
    }
    
    func checkSignIn() {
        if let user = Auth.auth().currentUser {
            isSignedIn = true
        } else {
            isSignedIn = false
        }
    }

    func signIn(withEmail email: String, password: String) { // facilitates the sign in
        // sttempt to sign in using firebase authentication
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
    
    func createAccount(withEmail email: String, password: String) { // allows the user to create an account
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
        }
    }
}
