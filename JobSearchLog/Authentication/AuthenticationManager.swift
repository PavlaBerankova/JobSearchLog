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

    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }
}
