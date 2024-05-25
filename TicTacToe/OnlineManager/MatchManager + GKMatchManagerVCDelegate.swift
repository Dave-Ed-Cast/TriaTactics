//
//  GKMatchManagerDelegate.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 24/05/24.
//

import Foundation
import GameKit

extension MatchManager: GKMatchmakerViewControllerDelegate {
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        viewController.dismiss(animated: true)
        startGame(newMatch: match)
        print("fail1")        
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: any Error) {
        viewController.dismiss(animated: true)
        print("Matchmaking failed with error: \(error.localizedDescription)")
    }
    
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true)
        print("fail3")
    }
}
