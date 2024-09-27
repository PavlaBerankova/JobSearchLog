//
//  KeyChainService.swift
//  JobSearchLog
//
//  Created by Pavla Beránková on 21.09.2024.
//

import Foundation
import Security

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}

final class KeychainService {
    static let shared = KeychainService()

    // MARK: - PASSWORD
    func savePasswordToKeychain(email: String, password: String) -> Bool {
        guard let passwordData = password.data(using: .utf8) else {
            logger.log("Error: Unable to convert password to Data")
            return false
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email,
            kSecValueData as String: passwordData
        ]

        SecItemDelete(query as CFDictionary) // Smažeme případný starý záznam
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    func deletePasswordFromKeychain(email: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email
        ]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }

    // MARK: - ID TOKEN
    func saveIDTokenToKeychain(email: String, idToken: String) -> Bool {
        guard let tokenData = idToken.data(using: .utf8) else {
            logger.log("Error: Unable to convert ID token to Data")
            return false
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email,
            kSecValueData as String: tokenData
        ]

        // Smažeme případný starý záznam s daným emailem
        SecItemDelete(query as CFDictionary)

        // Uložíme nový záznam
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    func getIDTokenFromKeychain(email: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess, let tokenData = dataTypeRef as? Data {
            return String(data: tokenData, encoding: .utf8)
        }
        return nil
    }

    func deleteIDTokenFromKeychain(email: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email
        ]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}
