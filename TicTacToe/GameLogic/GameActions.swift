//
//  GameActions.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 21/05/24.
//

import Foundation

extension GameLogic {
    
    /// Everytime the button on the grid is pressed, we give an image to it
    /// - Parameter index: the index is the pressed spot on the grid
    func buttonTap(index: Int) {
        
        //supposing the game is still ongoing
        guard grid[index] == nil && winner == nil else {
            return
        }
        
        if !isOffline! {
            guard matchManager!.currentlyPlaying else {
                print("Not your turn!")
                return
            }
        }
        
        //occupy that grid portion to the active player
        grid[index] = activePlayer
        print("Player \(activePlayer) moved at index \(index)")
        
        //do some stuff
        gameActions(index: index)
        
        if !isOffline! {
            matchManager?.sendMove(index: index, player: activePlayer)
        }
        
        if checkWinner() {
            winner = activePlayer
            isGameOver = true
        } else {
            if !isOffline! {
                matchManager!.currentlyPlaying = false
            }
            activePlayer = (activePlayer == .X) ? .O : .X
        }
    }
    
    func receiveMove(index: Int, player: Player) {
        if !isOffline! {
            guard grid[index] == nil && winner == nil else {
                return
            }
            
            grid[index] = player
            print("Received move from player \(player) at index \(index)")
            
            gameActions(index: index)
            
            if checkWinner() {
                winner = player
                isGameOver = true
            } else {
                matchManager!.currentlyPlaying = !(matchManager!.currentlyPlaying)
                activePlayer = (activePlayer == .X) ? .O : .X
                print("Next player: \(activePlayer), currentlyPlaying: \(matchManager!.currentlyPlaying)")
                
            }
        }
    }
    //which player touched that grid spot? Give me their name
    func buttonLabel(index: Int) -> String {
        if let player = grid[index] {
            return player == .X ? "X" : "O"
        }
        return ""
        
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
        
        //MARK: future implementation for difficulty
        if totalMoves > 14 {
            rotate = true
        }
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
