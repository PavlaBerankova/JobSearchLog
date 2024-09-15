//
//  SignInEmailViewModel.swift
//  JobSearchLog
//
//  Created by Pavla Beránková on 15.09.2024.
//

import Foundation
import FirebaseAuth

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""

    func signIn() {
        // TODO: Check if email and password are valid and strong
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }

        Task {
            do {
                let returnedUserData =  try await AuthenticationManager.shared.createUser(email: email, password: password)
                print("Succefull")
                print("\(returnedUserData)")
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
