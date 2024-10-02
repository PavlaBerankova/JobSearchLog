//
//  SettingsView.swift
//  JobSearchLog
//
//  Created by Pavla Beránková on 15.09.2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @Binding var isAuthenticated: Bool

    @State private var showSheetForm = false
    @State private var currentPassword = String()
    @State private var newPassword = String()

    var body: some View {
        List {
            Button {
                Task {
                    do {
                        try appState.logOut()
                        self.isAuthenticated = false
                        logger.log("You have been sign out.")
                    } catch {
                        logger.error("Sign Out error: \(error)")
                    }
                }
            } label: {
                Text("Log Out")
            }

            Section {
                Button {
                    Task {
                        do {
                            try await appState.resetPassword()
                        }
                    }
                } label: {
                    Text("Reset password")
                }

                Button {
                    showSheetForm.toggle()
                } label: {
                    Text("Change password")
                }
            } header: {
                Text("Email functions")
            }
        }
        .sheet(isPresented: $showSheetForm) {
            Form {
                SecureField("Current password", text: $currentPassword)
                SecureField("New password", text: $newPassword)
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView(isAuthenticated: .constant(false))
    }
    .environmentObject(AppState())
}
