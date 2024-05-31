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
                    MainView()
                } else if matchManager.inGame {
                    GameView(matchManager: matchManager, gameLogic: gameLogic, isOffline: .constant(false))
                } else {
                    Text("I should not be here")
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
