//
//  OnlineView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 24/05/24.
//

import SwiftUI

struct OnlineView: View {
    
    @ObservedObject var matchManager: MatchManager
    @ObservedObject var gameLogic : GameLogic
    
    var body: some View {
        ZStack {
            VStack {
                if matchManager.autheticationState == .authenticated {
                    if matchManager.inGame {
                        // If in a game, show the GameView
                        GameView(gameLogic: gameLogic, matchManager: matchManager)
                    } else {
                        // If not in a game, show the appropriate message
                        if matchManager.isGameOver {
                            Text("Press restart to play again!")
                        } else if matchManager.match != nil {
                            Text("Match found!")
                        } else {
                            Text("Searching for opponents...")
                        }
                    }
                } else {
                    // If not authenticated, show authentication message
                    Text("You are not logged in Game Center!")
                }
            }
        }
        .onAppear {
            matchManager.startMatchmaking()
        }
    }
}

#Preview {
    OnlineView(matchManager: MatchManager(), gameLogic: GameLogic(), currentStep: .constant(0), skipOnboarding: .constant(false))
}
