//
//  GameActions.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 21/05/24.
//

import Foundation
import SwiftUI

extension GameLogic {
    
    /// When the grid is tapped, the player assigns a symbol to that spot
    /// - Parameter index: the index is the pressed spot on the grid
    func buttonTap(index: Int) {
        
        //supposing the game is still ongoing
        guard grid[index] == nil && winner == nil else { return }
        
        guard index >= 0 && index < grid.count else {
            print("impossible index")
            return
        }
        
            if isOffline {
                handleMoveOffline(index: index)
            } else {
                handleMoveOnline(index: index)
            }
       
    }
    
    /// Defines the actions for an online match
    /// - Parameter index: the grid spot
    private func handleMoveOnline(index: Int) {
        guard let matchManager = matchManager else {
            print("match manager is nil")
            return
        }
        
        guard matchManager.currentlyPlaying else {
            print("not your turn")
            return
        }
        
        matchManager.sendMove(index: index, player: activePlayer)
        finalizeMove(index: index)
        
        if !checkWinner() {
            matchManager.localPlayerSymbol = activePlayer
            matchManager.currentlyPlaying = false
            matchManager.remainingTime = 10
            activePlayer = (activePlayer == .X) ? .O : .X
        } else {
            matchManager.sendString("winner")
            matchManager.localPlayerSymbol = activePlayer
            matchManager.stopTimer()
        }
    }
    
    /// Defines the actions for an offline match
    /// - Parameter index: the grid spot
    private func handleMoveOffline(index: Int) {
        finalizeMove(index: index)
        
        if !checkWinner() {
            activePlayer = (activePlayer == .X) ? .O : .X
        }
    }
    
    /// Finalizes the move in the grid
    /// - Parameter index: the grid spot
    private func finalizeMove(index: Int) {
        //this player occupied the grid at this index
        grid[index] = activePlayer
        print("Player \(activePlayer) moved at index \(index)")
        
        //the core of Tria Tactics
        gameActions(index: index)
        
        //did you win?
        if checkWinner() {
            winner = activePlayer
            isGameOver = true
        }
    }

    
    /// This is an exclusive function for online matches.
    /// The opponent receives the move
    /// - Parameters:
    ///   - index: the index we received
    ///   - player: the player that made the move
    func receiveMove(index: Int, player: Player) {
        if !isOffline {
            guard grid[index] == nil && winner == nil else {
                return
            }
            
            grid[index] = player
            print("Received move from player \(player) at index \(index)")
            
            gameActions(index: index)
            
            if checkWinner() {
                winner = player
                matchManager?.sendString("winner")
                isGameOver = true
            } else {
                matchManager!.currentlyPlaying = !(matchManager!.currentlyPlaying)
                activePlayer = (activePlayer == .X) ? .O : .X
                
                if matchManager!.currentlyPlaying {
                    matchManager?.remainingTime = 10
                }
            }
        }
    }
    
    /// This is the player that touched the label of the grid.
    /// It just tells which symbol to apply according to the player
    /// - Parameter index: index of touched label
    /// - Returns: the image name to be loaded in
    func buttonLabel(index: Int) -> String {
        if let player = grid[index] {
            return player == .X ? "X" : "O"
        }
        return ""
        
    }
    
    func buttonColor(index: Int) -> Color {
        if let player = grid[index] {
            return player == .X ? .red : .blue
        }
        return .black
        
    }
    /// The game action function describes the logic of counting and modifying the difficulty (future implementation) of the game
    /// - Parameter index: it takes an index that remembers the position on the grid
    func gameActions(index: Int) {
        if activePlayer == .X {
            moveCountX += 1
            playerHistory[.X]?.append(index)
        } else {
            moveCountO += 1
            playerHistory[.O]?.append(index)
        }
        
        //after understanding who hit their fourth move
        let currentPlayerMoveCount = activePlayer == .X ? moveCountX : moveCountO
        
        //we remove the first move of that player
        if currentPlayerMoveCount == 4 {
            removeFirstMove(of: activePlayer)
        }
        
        //we save the values for possible actions such as future implementations
        totalMoves = moveCountX + moveCountO
        
        //TODO: future implementation for difficulty
        if totalMoves > 14 {
            rotate = true
        }
    }
    
    /// prevent online stalling from someone not making a move
    func makeRandomMove() {
        guard !matchManager!.isGameOver else { return }
        
        if let index = grid.firstIndex(of: nil) {
            buttonTap(index: index)
        }
        matchManager?.currentlyPlaying = false
        matchManager?.remainingTime = 10
    }
    
    /// put everything back in place
    func resetGame() {
        grid = Array(repeating: nil, count: 9)
        activePlayer = .X
        winner = nil
        moveCountX = 0
        moveCountO = 0
        totalMoves = 0
        playerHistory[.X] = []
        playerHistory[.O] = []
        isGameOver = false
        degrees = 0.0
        offsetPosition = CGSize.zero
    }
    
}
