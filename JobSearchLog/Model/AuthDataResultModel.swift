//
//  UserModel.swift
//  JobSearchLog
//
//  Created by Pavla Beránková on 14.09.2024.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?

    // Uložíme referenci na Firebase uživatele
    // bez uložení reference User by nebyl dostupný pro další metody. Například po inicializaci modelu by neměl přístup k Firebase metodám, jako je getIDToken(), protože objekt User není uložený.
    private let user: User

    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        self.user = user
    }

    // Funkce pro získání ID tokenu
       func getIDToken() async throws -> String? {
           return try await user.getIDToken()
       }
}
