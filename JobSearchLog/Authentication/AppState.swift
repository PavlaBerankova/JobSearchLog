//
//  SignInEmailViewModel.swift
//  JobSearchLog
//
//  Created by Pavla Beránková on 15.09.2024.
//

import FirebaseAuth
import Foundation
import SwiftUI


@MainActor
final class AppState: ObservableObject {
    @Published var email = String()
    @Published var isAuthenticated = false
    private let keychainService = KeychainService.shared

    init() {
        checkAuthenticationStatus()
    }

    func checkAuthenticationStatus() {
        if keychainService.getIDTokenFromKeychain(email: email) != nil {
            // Token byl nalezen v Keychainu, uživatel je autentizován
            self.isAuthenticated = true
            logger.log("User authenticated with token from Keychain")
        } else {
            // Token nebyl nalezen nebo uživatel není přihlášen
            self.isAuthenticated = false
            logger.log("User not authenticated")
        }
    }

    func signUp(inputPassword: String) {
        var password = inputPassword

        guard !email.isEmpty, !password.isEmpty && password.count > 6 else {
            logger.log("No email or password found")
            return
        }

        Task {
            do {
                let returnedUserData =  try await AuthenticationManager.shared.createUser(email: email, password: password)
                logger.log("Successful registration")

                if keychainService.savePasswordToKeychain(email: email, password: password) {
                    logger.log("Password has been saved to Keychain")
                } else {
                    logger.log("Failed to save password to Keychain")
                }

                // Získáme ID token po vytvoření účtu
                let idToken = try await returnedUserData.getIDToken()

                guard let idToken = idToken else {
                    logger.log("Failed to retrieve ID token")
                    return
                }

                // Uložení ID tokenu do Keychain po úspěšné registraci
                if keychainService.saveIDTokenToKeychain(email: email, idToken: idToken) {
                    if keychainService.deletePasswordFromKeychain(email: email) {
                        logger.log("Password has been deleted from Keychain")
                    } else {
                        logger.log("Failed to delete password from Keychain")
                    }
                    logger.log("ID token has been saved to Keychain")
                } else {
                    logger.log("Failed to save ID token to Keychain")
                }
            } catch {
                logger.log("Error retrieving ID token: \(error)")
            }

            // Vymažeme heslo z paměti
            password = String()
        }
    }

    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()

        guard let email = authUser.email else {
            logger.log("Error: \(Error.self)")
            return
        }

        try await AuthenticationManager.shared.resetPassword(email: email)
        print("Your password has been reset")
    }

    func changePassword(newPassword: String) async throws {
        let newPassword = newPassword
        do {
            try await AuthenticationManager.shared.changePassword(password: newPassword)
        } catch {
            logger.log("Error with change password: \(error)")
        }
    }

//    func updateEmail(newEmail: String) async throws {
//        let newEmail = newEmail
//        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
//
//        guard let currentEmail = authUser.email else {
//            print("Wrong user Email")
//            return
//        }
//
//        do {
//            try await AuthenticationManager.shared.changeEmail(newEmail: newEmail, password: pass)
//        } catch {
//            logger.log("Error with change email: \(error)")
//        }
//    }

    func logIn(email: String, password: String) async throws {
        guard !email.isEmpty, !password.isEmpty && password.count > 6 else {
            print("No email or password found")
            return
        }

        try await AuthenticationManager.shared.logInUser(email: email, password: password)
        self.isAuthenticated = true
        print("You have been logged")


        // Debug: Zkontroluj, zda se isAuthenticated mění
        print("User logged out. isAuthenticated: \(self.isAuthenticated)") // Přidáno pro debug
    }

    func logOut() throws {
        try AuthenticationManager.shared.signOut()
        // Při odhlášení smažeme ID token z Keychainu
        if keychainService.deleteIDTokenFromKeychain(email: email) {
            logger.log("ID token deleted from Keychain")
        } else {
            logger.log("Failed to delete ID token from Keychain")
        }


           // Debug: Zkontroluj, zda se isAuthenticated mění
           self.isAuthenticated = false
           print("User logged out. isAuthenticated: \(self.isAuthenticated)") // Přidáno pro debug
    }
}
