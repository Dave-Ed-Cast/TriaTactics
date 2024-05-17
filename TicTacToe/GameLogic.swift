//
//  GameLogic.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 17/05/24.
//

import Foundation

enum Player {
    case X
    case O
}

class GameLogic: ObservableObject {
    
    @Published var board: [Player?] = Array(repeating: nil, count: 9)
    @Published var activePlayer: Player = .X
    @Published var winner: Player? = nil
    var moveCountX: Int = 0
    var moveCountO: Int = 0
    var totalMoves: Int = 0
    var rotate: Bool = false
    
    func buttonTap(index: Int) {
        
        guard board[index] == nil && winner == nil else {
            return
        }
        
        gameActions()
        
        board[index] = activePlayer
        
        if checkWinner() {
            winner = activePlayer
            print("\(activePlayer) won. GZ!")
        } else {
            activePlayer = (activePlayer == .X) ? .O : .X
        }
        
        print("\(activePlayer) won")
    }
    
    func buttonLabel(index: Int) -> String {
        if let player = board[index] {
            return player == .X ? "X" : "O"
        }
        return ""
        
    }
    
    func resetGame() {
        board = Array(repeating: nil, count: 9)
        activePlayer = .X
        winner = nil
        moveCountX = 0
        moveCountO = 0
        totalMoves = 0
    }
}
