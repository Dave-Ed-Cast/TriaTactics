//
//  GameLogic.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 17/05/24.
//

import Foundation

/// One player gets assigned one symbol
enum Player: String {
    case X
    case O
}

/** 
 This is the class that takes care of the game behaviour.
 It is indipendent from the match manager for mantainability, scalability, and testing purposes.
 */
class GameLogic: ObservableObject {

    // these variables are all needed for the management of the game logic
    @Published var grid: [Player?] = Array(repeating: nil, count: 9)
    @Published var activePlayer: Player = .X
    @Published var winner: Player?
    @Published var isGameOver: Bool?
    @Published var isOffline: Bool = true
    @Published var xScore: Int = 0
    @Published var oScore: Int = 0

    // there needs to be a reference of the MatchManager
    var matchManager: MatchManager?

    var playerHistory: [Player: [Int]] = [.X: [], .O: []]
    var moveCountX: Int = 0
    var moveCountO: Int = 0
    var totalMoves: Int = 0
    var rotate: Bool = false
    var degrees: Double = 0.0
    var offsetPosition: CGSize = CGSize.zero
}
