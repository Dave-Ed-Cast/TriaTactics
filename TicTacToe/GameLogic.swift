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

class TicTacToe: ObservableObject {
    
    @Published var board: [Player?] = Array(repeating: nil, count: 9)
    @Published var activePlayer: Player = .X
    @Published var winner: Player? = nil
    
    func buttonTap(index: Int) {
        
        guard board[index] == nil && winner == nil else {
            return
        }
        
        board[index] = activePlayer
        
        if checkWinner() {
            winner = activePlayer
            print("\(activePlayer) won. Congratulations!")
        } else {
            activePlayer = (activePlayer == .X) ? .O : .X
        }
        
        print("\(activePlayer) has won the game")
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
    }
    
    func checkWinner() -> Bool {
        
        for index in stride(from: 0, to: 9, by: 3) {
            if board[index] == activePlayer &&
                board[index + 1] == activePlayer &&
                board[index + 2] == activePlayer {
                return true
            }
            
        }
        
        for index in 0..<3 {
            if board[index] == activePlayer &&
                board[index + 3] == activePlayer &&
                board[index + 6] == activePlayer {
                return true
            }
        }
        
        if board[0] == activePlayer && board[4] == activePlayer && board[8] == activePlayer {
            return true
        }
        
        if board[2] == activePlayer && board[4] == activePlayer && board[6] == activePlayer {
            return true
        }
        
        return false
    }
}
