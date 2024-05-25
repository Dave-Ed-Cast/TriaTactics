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
    
    var body: some View {
        Group {
            if matchManager.autheticationState == .authenticated {
                if matchManager.isGameOver {
                    GameOver(matchManager: matchManager, gameLogic: gameLogic, showLottieAnimation: $showLottieAnimation)
                } else if matchManager.inGame {
                    GameView(matchManager: matchManager, gameLogic: gameLogic, isOffline: $isOffline)
                } else {
                    Text("I should not be here")
                }
            }
        }
        .onAppear {
            matchManager.startMatchmaking()
        }
    }
}

#Preview {
    OnlineView(matchManager: MatchManager(), gameLogic: GameLogic(), showLottieAnimation: .constant(true), isOffline: .constant(true))
}
