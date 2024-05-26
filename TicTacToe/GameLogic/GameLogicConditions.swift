//
//  GameLogicConditions.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/05/24.
//

import Foundation

extension GameLogic {
    
    /// This is the function that delets the last move, it extracts the first element of this array.
    /// By its own construction it's always gonna remove the first element, and later another one is gonna be appended
    /// - Parameter player: it needs to know the player that is doing the move
    func removeFirstMove(of player: Player) {
        
        guard let firstMoveIndex = playerHistory[activePlayer]?.removeFirst() else {
            return
        }
        
        //delete that action of the player
        grid[firstMoveIndex] = nil
        
        //and decremenet their count, so that the algorithm works
        if player == .X {
            moveCountX -= 1
        } else {
            moveCountO -= 1
        }
    }
    
    /// This function checks all the possible winning combinations.
    /// It counts the elements corresponding to the rule of Tic Tac Toe
    /// - Returns: returns the "winner" status
    func checkWinner() -> Bool {
        
        //this is on rows
        for index in stride(from: 0, to: 9, by: 3) {
            if grid[index] == activePlayer &&
                grid[index + 1] == activePlayer &&
                grid[index + 2] == activePlayer {
                
                degrees = 90
                if index == 0 {
                    offsetPosition = CGSize(width: 0, height: -120)
                } else if index == 3 {
                    offsetPosition = CGSize(width: 0, height: -10)
                } else {
                    offsetPosition = CGSize(width: 0, height: 100)
                }
                return true
            }
            
        }
        
        //this is columns
        for index in 0..<3 {
            if grid[index] == activePlayer &&
                grid[index + 3] == activePlayer &&
                grid[index + 6] == activePlayer {
                
                if index == 0 {
                    offsetPosition = CGSize(width: -128, height: 0)
                } else if index == 1 {
                    offsetPosition = CGSize(width: -8, height: 0)
                } else {
                    offsetPosition = CGSize(width: 112, height: 0)
                }
                return true
            }
        }
        
        //and these are the diagonals
        if (grid[0] == activePlayer && grid[4] == activePlayer && grid[8] == activePlayer) || (grid[2] == activePlayer && grid[4] == activePlayer && grid[6] == activePlayer) {
            
            offsetPosition = grid[0] != nil ? CGSize(width: 0, height: 10) : CGSize(width: 0, height: -10)
            if grid[0] != nil {
                degrees = -45
            } else if grid[0] == nil && grid[2] != nil {
                degrees = 45
            }
            return true
        }
        
        //*outer wilds* nobody won yet
        return false
    }
}
