//
//  OnlineView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 25/05/24.
//

import SwiftUI

struct OnlineView: View {

    @StateObject var matchManager: MatchManager
    @StateObject var gameLogic: GameLogic

    @Binding var showLottieAnimation: Bool
    @Binding var isOffline: Bool
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Group {
            if matchManager.autheticationState == .authenticated {
                if matchManager.inGame {
                    Text("entered the if")
                    GameView(matchManager: matchManager, gameLogic: gameLogic, isOffline: .constant(false))
                } else {
                    Text("main")
                    MainView()
                        .onChange(of: matchManager.inGame) { _ in
                            dismiss()
                        }
                }
            }
        }
        .onAppear {
            if !matchManager.inGame {
                matchManager.startMatchmaking()
            }
        }
    }
}

#Preview {
    OnlineView(matchManager: MatchManager(), gameLogic: GameLogic(), showLottieAnimation: .constant(true), isOffline: .constant(false))
}
