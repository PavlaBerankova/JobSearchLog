//
//  AuthenticationManager.swift
//  JobSearchLog
//
//  Created by Pavla Beránková on 14.09.2024.
//

import Foundation
import FirebaseAuth

// @MainActor zajišťuje, že kód, který interaguje s uživatelským rozhraním (UI), běží na hlavním vlákně.
@MainActor
final class AuthenticationManager: ObservableObject {

    // Singleton - jediná instance v aplikaci, proto může být init jako private
    static let shared = AuthenticationManager()
    private init() { }

    // Tato metoda není async, což je důležité, neosloví server, zkontroluje ověřeného uživatele lokálně, kontroluje synchronně před načtením celé aplikace
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }

    @discardableResult
    // víme, že z funkce se vrací nějaká hodnota (AuthDataResultModel), ale nemusíme ji vždy použít, takže je v pořádku pokud ji zahodíme a nepoužijeme
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }

    @discardableResult
    func logInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }

    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }

    func changePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.notConnectedToInternet)
        }

        try await user.updatePassword(to: password)
    }

    func changeEmail(newEmail: String, password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.notConnectedToInternet)
        }

        // Přihlašovací údaje uživatele (e-mail a heslo)
        let credential = EmailAuthProvider.credential(withEmail: user.email ?? "", password: password)

        // Re-autentizace uživatele
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            user.reauthenticate(with: credential) { authResult, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }

        // Pokud je re-autentizace úspěšná, můžeme změnit e-mail
        try await user.updateEmail(to: newEmail)
        logger.log("Email has been successfully updated to: \(newEmail)")
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }
}
