//
//  MatchManager.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 22/05/24.
//

import Foundation

class MatchManager: ObservableObject {
    
    @Published var inGame: Bool = false
    @Published var isGameOver: Bool = false
    @Published var autheticationState: PlayerAuthState = PlayerAuthState.authenticating
    
    @Published var currentlyPlaying: Bool = false
    @Published var score: Int = 0
//    @Published var remainingTime: Int = maxTimeRemaining
}
