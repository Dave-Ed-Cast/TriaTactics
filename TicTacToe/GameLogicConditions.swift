//
//  GameLogicConditions.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/05/24.
//

import Foundation

extension GameLogic {
    
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
    
    func removeFirstMove(of player: Player) {

        guard let firstMoveIndex = board.firstIndex(where: { $0 == player }) else {
            return
        }
        
        board[firstMoveIndex] = nil
        
        if player == .X {
            moveCountX -= 1
        } else {
            moveCountO -= 1
        }
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
