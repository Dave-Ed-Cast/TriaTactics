//
//  PlayView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 20/06/24.
//

import SwiftUI

struct PlayView: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var matchManager: MatchManager
    @EnvironmentObject var changeViewTo: Navigation

    @State private var isOffline: Bool = false
    @State private var showGameView: Bool = false

    var body: some View {
        Spacer()
        VStack(spacing: 30) {
            PrimaryButton(label: "Play Online", action: {
                matchManager.startMatchmaking()
                if matchManager.inGame && matchManager.autheticationState == .authenticated {
                    changeViewTo.value = .online
                }
            })
            .opacity(matchManager.autheticationState != .authenticated ? 0.5 : 1)
            .disabled(matchManager.autheticationState != .authenticated)

            // TODO: Provide a back button for this view
            PrimaryButton(label: "Play Offline", action: { changeViewTo.value = .offline })

        }
        .padding(.top, 100)
        .onAppear {
            matchManager.authenticateUser()
        }
        Spacer()
        SecondaryButton(label: "Menu", action: { changeViewTo.value = .main })

    }
}

#Preview {
    PlayView()
        .environmentObject(MatchManager())
        .environmentObject(Navigation.shared)
}
