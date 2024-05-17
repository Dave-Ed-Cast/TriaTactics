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
    
    func gameActions() {
        
        if activePlayer == .X {
            moveCountX += 1
        } else {
            moveCountO += 1
        }
        
        if (activePlayer == .X && moveCountX == 4) || (activePlayer == .O && moveCountO == 4) {
            removeFirstMove(of: activePlayer)
        }
        
        totalMoves = moveCountX + moveCountO
        
        if totalMoves > 10 {
            rotate = true
        }
        print("count x: \(moveCountX), count o: \(moveCountO)")
    }
    func resetGame() {
        board = Array(repeating: nil, count: 9)
        activePlayer = .X
        winner = nil
        moveCountX = 0
        moveCountO = 0
        totalMoves = 0
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
    
    func removeFirstMove(of player: Player) {
        // Find the index of the first move made by the player
        guard let firstMoveIndex = board.firstIndex(where: { $0 == player }) else {
            return
        }
        
        // Remove the first move of the player
        board[firstMoveIndex] = nil
        
        // Decrement move count for the player
        if player == .X {
            moveCountX -= 1
        } else {
            moveCountO -= 1
        }
    }
}
