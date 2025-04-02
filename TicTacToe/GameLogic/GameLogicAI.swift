//
//  GameLogicAI.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 03/07/24.
//

/**
 This AI uses the Minimax algorithm, a recursive method for selecting the best move in a two-player game. How does it work?
 It simulates all possible moves, evaluates outcomes, and chooses the best move to maximize winning chances while minimizing the opponent’s chances.
 
 Key Concepts
 1.    Maximizing Player: Tries to maximize their score (the AI).
 2.    Minimizing Player: Tries to minimize the maximizing player’s score (the opponent).
 3.    Game Tree: Represents all possible moves from the current position.
 4.    Depth: Levels of the tree, representing future moves.
 5.    Evaluation Function: Assigns scores to terminal states (e.g., win, lose, draw).
 
 Steps:
 1.    Generate Game Tree: Simulate all possible moves.
 2.    Evaluate Terminal States: Score end-game states (+10 for win, -10 for loss, 0 for draw).
 3.    Recursion:
 •    Maximizing Player: Choose the highest score.
 •    Minimizing Player: Choose the lowest score.
 4.    Backpropagate Scores: Propagate scores up the tree to find the optimal move at the root.
 
 Let's put it in practice
 **/

import Foundation

extension GameLogic {

    /// Handles the AI strategic move.
    func computerMove() {
        guard !isGameOver!, activePlayer == .O else {
            return
        }

        guard moveCountO > 0 else {
            while true {
                let randomInt = Int.random(in: 0...8)
                if grid[randomInt] != .X {
                    makeMove(index: randomInt)
                }
                return
            }

        }

        if let bestMove = minimaxMove() {
            print("Minimax move for O")
            makeMove(index: bestMove)
            return
        }
    }

    /// Defines the difficulty cases
    /// - Returns: depth for difficulty
    private func maxDepthForDifficulty() -> Int {
        switch difficulty {
        case .medium:
            return 1
        case .hard:
            return 2
        default:
            return 0
        }

    }

    /// Makes the move based on the index
    /// - Parameter index: the index corresponds to the grid position
    private func makeMove(index: Int) {
        guard !isGameOver! else { return }

        grid[index] = activePlayer
        print("AI \(activePlayer) moved at index \(index)")

        finalizeMove(index: index)

        activePlayer = (activePlayer == .X ? .O : .X)
        isPlayerTurn = true
        print("Player turn: \(isPlayerTurn)")
    }

    /// For all the possible index (0 and 8), count how many are empty.
    /// Then, define the score if the AI were to put its value in each spot.
    /// - Returns: the move with the highest score
    private func minimaxMove() -> Int? {
        for index in 0..<grid.count where grid[index] == nil {
            grid[index] = activePlayer // Simulate AI's move
            if checkWinnerOnGrid() == activePlayer {
                grid[index] = nil // Undo move
                return index // Take the winning move
            }
            grid[index] = nil // Undo move
        }

        // 2. Check if the opponent can win in their next move
        let opponent = (activePlayer == .O ? Player.X : Player.O)
        for index in 0..<grid.count where grid[index] == nil {
            grid[index] = opponent // Simulate opponent's move
            if checkWinnerOnGrid() == opponent {
                grid[index] = nil // Undo move
                return index // Block the opponent's winning move
            }
            grid[index] = nil // Undo move
        }

        // 3. Proceed with Minimax if no immediate win/loss is found
        var bestScore = Int.min
        var move: Int?
        var alpha = Int.min
        let beta = Int.max

        for index in 0..<grid.count where grid[index] == nil {
            grid[index] = activePlayer
            let score = minimax(depth: 0, isMaximizing: false, alpha: alpha, beta: beta)
            grid[index] = nil
            if score > bestScore {
                bestScore = score
                move = index
            }
            alpha = max(alpha, bestScore) // Update alpha
            if beta <= alpha { break }   // Prune
        }

        return move
    }

    /// Recursively called, the minimax makes optimal decisions.
    /// - Parameters:
    ///   - depth: Tracks how many moves deep the current recursion level is.
    ///   - isMaximizing: A boolean indicating if the current move is for the maximizing player (AI, O) or the minimizing player (human, X)
    /// - Returns: the bestScore after evaluating all possible moves.
    private func minimax(depth: Int, isMaximizing: Bool, alpha: Int, beta: Int) -> Int {
        if let winner = checkWinnerOnGrid() {
            return winner == .O ? (10 - depth) : (depth - 10)
        }

        if depth >= maxDepthForDifficulty() {
            return 0
        }

        var alpha = alpha
        var beta = beta

        if isMaximizing {
            var bestScore = Int.min
            for index in 0..<grid.count where grid[index] == nil {
                grid[index] = .O
                let score = minimax(depth: depth + 1, isMaximizing: false, alpha: alpha, beta: beta)
                grid[index] = nil
                bestScore = max(score, bestScore)
                alpha = max(alpha, bestScore)
                if beta <= alpha { break }
            }
            return bestScore
        } else {
            var bestScore = Int.max
            for index in 0..<grid.count where grid[index] == nil {
                grid[index] = .X
                let score = minimax(depth: depth + 1, isMaximizing: true, alpha: alpha, beta: beta)
                grid[index] = nil
                bestScore = min(score, bestScore)
                beta = min(beta, bestScore)
                if beta <= alpha { break }
            }
            return bestScore
        }
    }

    /// Checks winning indices
    /// - Returns: the player that wins
    private func checkWinnerOnGrid() -> Player? {
        let winPatterns: [[Int]] = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
            [0, 4, 8], [2, 4, 6]             // Diagonals
        ]

        for pattern in winPatterns {
            if let player = grid[pattern[0]], grid[pattern[1]] == player, grid[pattern[2]] == player {
                return player
            }
        }

        return nil
    }
}
