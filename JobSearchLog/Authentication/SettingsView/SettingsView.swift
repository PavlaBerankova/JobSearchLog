//
//  SettingsView.swift
//  JobSearchLog
//
//  Created by Pavla Beránková on 15.09.2024.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var model = SettingsViewModel()
    @Binding var showSignInView: Bool

    var body: some View {
        List {
            Button {
                Task {
                    do {
                        try model.signOut()
                        showSignInView.toggle()
                        logger.log("You have been sign out.")
                    } catch {
                        logger.error("Sign Out error: \(error)")
                    }
                }
            } label: {
                Text("Log Out")
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}
