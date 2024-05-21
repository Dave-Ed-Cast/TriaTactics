//
//  GameLogic.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 17/05/24.
//

import Foundation

class GameLogic: ObservableObject {
        
    @Published var grid: [Player?] = Array(repeating: nil, count: 9)
    @Published var activePlayer: Player = .X
    @Published var winner: Player? = nil
    @Published var isGameOver: Bool? = nil
    
    var playerHistory: [Player: [Int]] = [.X: [], .O: []]
    var moveCountX: Int = 0
    var moveCountO: Int = 0
    var totalMoves: Int = 0
    var winningIndices: [Int]? = nil
    var rotate: Bool = false
    var degrees: Double = 0
    var offsetPosition: CGSize = CGSize.zero
    
    //set winning indices
    func setWinningIndices(indices: [Int]) {
        self.winningIndices = indices
    }
    
    enum Player {
        case X
        case O
    }
}
