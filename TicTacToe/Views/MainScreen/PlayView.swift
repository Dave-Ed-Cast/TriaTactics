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
    @EnvironmentObject var gameLogic: GameLogic

    @State private var isOffline: Bool = false
    @State private var showGameView: Bool = false

    var body: some View {
            VStack(spacing: 30) {
                Spacer()
                viewManagerView
                Spacer()

                VStack {
                    SecondaryButton(showSomething: .constant(true), buttonText: "Menu", action: { dismiss() })
                }
            }
            .onAppear {
                matchManager.authenticateUser()
            }
            .fullScreenCover(isPresented: $showGameView) {
                if isOffline {
                    GameView(isOffline: .constant(true))
                }
            }
        }

    var viewManagerView: some View {
        Group {
            if matchManager.inGame && matchManager.autheticationState == .authenticated {
                GameView(matchManager: matchManager, gameLogic: gameLogic, isOffline: .constant(false))
            } else {
                Spacer()
                PrimaryButton(showSomething: .constant(false), buttonText: "Play Online") {
                    isOffline = false
                    matchManager.startMatchmaking()
                    print("matchmanager")
                    if matchManager.matchFound {
                        showGameView = true
                    }
                }
                .onTapGesture {
                    matchManager.startMatchmaking()
                    print("ontap")
                }
                .opacity(matchManager.autheticationState != .authenticated ? 0.5 : 1)
                .disabled(matchManager.autheticationState != .authenticated)

                PrimaryButton(showSomething: $showGameView, buttonText: "Play Offline") {
                    isOffline = true
                }
            }
        }
    }
}

#Preview {
    PlayView()
        .environmentObject(MatchManager())
        .environmentObject(GameLogic())
}
