//
//  GKMatchManagerDelegate.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 24/05/24.
//

import Foundation
import GameKit

extension MatchManager: GKMatchmakerViewControllerDelegate {
    
    /// This is the function that handles the match found
    /// - Parameters:
    ///   - viewController: the gamekit view controller
    ///   - match: the match
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        viewController.dismiss(animated: true)
        startGame(newMatch: match)
    }
    
    /// This is the function that handles what happens if the matchmaking fails
    /// - Parameters:
    ///   - viewController: the gamekit view controller
    ///   - error: the error
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: any Error) {
        viewController.dismiss(animated: true)
        print("Matchmaking failed with error: \(error.localizedDescription)")
    }
    
    /// This describes what happens if the matchmaking was cancelled
    /// - Parameter viewController: the gamekit view controller
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true)
    }
}
