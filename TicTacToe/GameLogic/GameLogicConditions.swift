//
//  GameLogicConditions.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/05/24.
//

import Foundation

extension GameLogic {

    /// This function checks all the possible winning combinations.
    /// It counts the elements corresponding to the rule of Tic Tac Toe
    /// It also tells at which degree (in the diagonals) to rotate the animation in the view
    /// - Returns: returns the "winner" status
    func checkWinner() -> Bool {

        // this is on rows
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

        // this is columns
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

        // and these are the diagonals
        if grid[4] == activePlayer {
            if grid[0] == activePlayer && grid[8] == activePlayer {
                degrees = -45.0
                offsetPosition = CGSize(width: 0, height: 10)
                return true
            } else if grid[2] == activePlayer && grid[6] == activePlayer {
                degrees = 45.0
                offsetPosition = CGSize(width: 0, height: -10)
                return true
            }
        }

        // *outer wilds* nobody won yet
        return false
    }
}
