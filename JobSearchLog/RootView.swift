//
//  RootView.swift
//  JobSearchLog
//
//  Created by Pavla Beránková on 14.09.2024.
//

import SwiftUI

struct RootView: View {
    @State var isAuthenticated: Bool = false

    var body: some View {
        ZStack {
                SettingsView(isAuthenticated: $isAuthenticated)
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.isAuthenticated = authUser == nil
        }
        .fullScreenCover(isPresented: $isAuthenticated) {
            NavigationStack {
                AuthenticationView(isAuthenticated: $isAuthenticated)
            }
        }
    }
}

#Preview {
    RootView()
}

//.onAppear {
//    let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
//    self.showSignInView = authUser == nil
//}
//.fullScreenCover(isPresented: $showSignInView) {
//    NavigationStack {
//        AuthenticationView(showSignInView: $showSignInView)
//    }
//}
