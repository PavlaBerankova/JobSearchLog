//
//  SettingsViewModel.swift
//  JobSearchLog
//
//  Created by Pavla Beránková on 15.09.2024.
//

import Foundation
import FirebaseAuth

// @MainActor zajišťuje, že kód, který interaguje s uživatelským rozhraním (UI), běží na hlavním vlákně.
@MainActor
final class SettingsViewModel: ObservableObject {
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
}
