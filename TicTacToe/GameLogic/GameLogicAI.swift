//
//  GameLogicAI.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 03/07/24.
//

import Foundation

extension GameLogic {

    func computerMove() {
        guard !isGameOver!, activePlayer == .O else {
            return
        }

            // Check for winning move
        if let winMove = nextWinningMove(for: .O) {
            print("Winning move for O")
            makeMove(index: winMove)
            return
        }

            // Check for blocking opponent's winning move
        if let blockMove = nextWinningMove(for: .X) {
            print("Winning move for X")
            makeMove(index: blockMove)
            return
        }

            // Check for fork opportunities
        if let forkMove = forkMove(for: .O) {
            print("Fork move for O")
            makeMove(index: forkMove)
            return
        }

            // Block opponent's forks
        if let blockForkMove = forkMove(for: .X) {
            print("Fork move for X")
            makeMove(index: blockForkMove)
            return
        }

            // Take the center if available
        if grid[4] == nil {
            print("Taking center position")
            makeMove(index: 4)
            return
        }

            // Take opposite corner if opponent took a corner
        if let oppositeCornerMove = oppositeCornerMove() {
            print("Taking opposite corner")
            makeMove(index: oppositeCornerMove)
            return
        }

            // Take any empty corner
        if let cornerMove = emptyCornerMove() {
            print("Taking empty corner")
            makeMove(index: cornerMove)
            return
        }

            // Take any empty side
        if let sideMove = emptySideMove() {
            print("Taking empty side")
            makeMove(index: sideMove)
            return
        }

            // If all else fails, make a random move (though this should rarely happen)
        makeRandomMove()
    }

    private func makeMove(index: Int) {
        guard !isGameOver! else { return }
        grid[index] = activePlayer
        print("AI \(activePlayer) moved at index \(index)")
        finalizeMove(index: index)
        activePlayer = (activePlayer == .X ? .O : .X)
        isPlayerTurn = true // Switch back to player's turn
        print("Player turn: \(isPlayerTurn)")
    }

    private func nextWinningMove(for player: Player) -> Int? {
        // Check rows
        for index in stride(from: 0, to: 9, by: 3) {
            if grid[index] == player && grid[index + 1] == player && grid[index + 2] == nil {
                return index + 2
            }
            if grid[index] == player && grid[index + 1] == nil && grid[index + 2] == player {
                return index + 1
            }
            if grid[index] == nil && grid[index + 1] == player && grid[index + 2] == player {
                return index
            }
        }

        // Check columns
        for index in 0..<3 {
            if grid[index] == player && grid[index + 3] == player && grid[index + 6] == nil {
                return index + 6
            }
            if grid[index] == player && grid[index + 3] == nil && grid[index + 6] == player {
                return index + 3
            }
            if grid[index] == nil && grid[index + 3] == player && grid[index + 6] == player {
                return index
            }
        }

        // Check diagonals
        if grid[0] == player && grid[4] == player && grid[8] == nil {
            return 8
        }
        if grid[0] == player && grid[4] == nil && grid[8] == player {
            return 4
        }
        if grid[0] == nil && grid[4] == player && grid[8] == player {
            return 0
        }
        if grid[2] == player && grid[4] == player && grid[6] == nil {
            return 6
        }
        if grid[2] == player && grid[4] == nil && grid[6] == player {
            return 4
        }
        if grid[2] == nil && grid[4] == player && grid[6] == player {
            return 2
        }

        return nil
    }

    private func forkMove(for player: Player) -> Int? {
        // Check each empty spot if it creates a fork
        for index in 0..<grid.count {
            if grid[index] == nil {
                // Temporarily place player's symbol
                grid[index] = player

                // Check if this move creates a fork
                var isFork = false
                for nextIndex in 0..<grid.count {
                    if grid[nextIndex] == nil {
                        // Temporarily place player's symbol
                        grid[nextIndex] = player

                        // Check if there are multiple winning paths
                        let multiplePaths = nextWinningMoveCount(for: player) >= 2
                        grid[nextIndex] = nil

                        if multiplePaths {
                            isFork = true
                            break
                        }
                    }
                }

                // Undo the move
                grid[index] = nil

                // Return the index if it creates a fork
                if isFork {
                    return index
                }
            }
        }

        return nil
    }

    private func nextWinningMoveCount(for player: Player) -> Int {
        var count = 0

        // Check rows
        for index in stride(from: 0, to: 9, by: 3) {
            if grid[index] == player && grid[index + 1] == player && grid[index + 2] == nil {
                count += 1
            }
            if grid[index] == player && grid[index + 1] == nil && grid[index + 2] == player {
                count += 1
            }
            if grid[index] == nil && grid[index + 1] == player && grid[index + 2] == player {
                count += 1
            }
        }

        // Check columns
        for index in 0..<3 {
            if grid[index] == player && grid[index + 3] == player && grid[index + 6] == nil {
                count += 1
            }
            if grid[index] == player && grid[index + 3] == nil && grid[index + 6] == player {
                count += 1
            }
            if grid[index] == nil && grid[index + 3] == player && grid[index + 6] == player {
                count += 1
            }
        }

        // Check diagonals
        if grid[0] == player && grid[4] == player && grid[8] == nil {
            count += 1
        }
        if grid[0] == player && grid[4] == nil && grid[8] == player {
            count += 1
        }
        if grid[0] == nil && grid[4] == player && grid[8] == player {
            count += 1
        }
        if grid[2] == player && grid[4] == player && grid[6] == nil {
            count += 1
        }
        if grid[2] == player && grid[4] == nil && grid[6] == player {
            count += 1
        }
        if grid[2] == nil && grid[4] == player && grid[6] == player {
            count += 1
        }

        return count
    }

    private func oppositeCornerMove() -> Int? {
        let corners: [Int] = [0, 2, 6, 8] // Indices of corners (top-left, top-right, bottom-left, bottom-right)
        let oppositeCorners: [(Int, Int)] = [(0, 8), (2, 6), (6, 2), (8, 0)] // Pairs of opposite corners

        for (first, second) in oppositeCorners {
            if grid[first] == .X && grid[second] == nil {
                return second
            }
            if grid[second] == .X && grid[first] == nil {
                return first
            }
        }

        return nil
    }

    private func emptyCornerMove() -> Int? {
        let corners: [Int] = [0, 2, 6, 8] // Indices of corners (top-left, top-right, bottom-left, bottom-right)

        for corner in corners {
            if grid[corner] == nil {
                return corner
            }
        }

        return nil
    }

    private func emptySideMove() -> Int? {
        let sides: [Int] = [1, 3, 5, 7] // Indices of side spots (top, left, right, bottom)

        for side in sides {
            if grid[side] == nil {
                return side
            }
        }

        return nil
    }
}
