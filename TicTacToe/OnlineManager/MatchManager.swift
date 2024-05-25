//
//  MatchManager.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 22/05/24.
//

import Foundation
import GameKit
import SwiftUI

class MatchManager: NSObject, ObservableObject, GKTurnBasedMatchmakerViewControllerDelegate, GKTurnBasedEventListener, GKLocalPlayerListener {
    
    @Published var inGame: Bool = false
    @Published var isGameOver: Bool = false
    @Published var autheticationState: PlayerAuthState = .authenticating
    @Published var currentlyPlaying: Bool = false
    @Published var score: Int = 0
    @Published var activePlayer: Player = .X
    
    var match: GKTurnBasedMatch?
    var localPlayer: GKLocalPlayer = GKLocalPlayer.local
    var playerUUIDString = UUID().uuidString
    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
    
    override init() {
        super.init()
        GKLocalPlayer.local.register(self)
    }
    
    func authenticateUser() {
        GKLocalPlayer.local.authenticateHandler = { [weak self] viewController, error in
            if let viewController = viewController {
                self?.rootViewController?.present(viewController, animated: true)
                return
            }
            
            if let error = error {
                self?.autheticationState = .error
                print(error)
                return
            }
            
            if let localPlayer = self?.localPlayer, localPlayer.isAuthenticated {
                if localPlayer.isMultiplayerGamingRestricted {
                    self?.autheticationState = .restricted
                } else {
                    self?.autheticationState = .authenticated
                }
            } else {
                self?.autheticationState = .unauthenticated
            }
        }
    }
    
    func startMatchmaking() {
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        
        let matchMakerViewController = GKTurnBasedMatchmakerViewController(matchRequest: request)
        matchMakerViewController.turnBasedMatchmakerDelegate = self
        rootViewController?.present(matchMakerViewController, animated: true, completion: nil)
    }
    
    func startGame(match: GKTurnBasedMatch) {
        self.match = match
        // Initialize your game state with the match data
        self.inGame = true
    }
    
    // MARK: - GKTurnBasedMatchmakerViewControllerDelegate
    func turnBasedMatchmakerViewController(_ viewController: GKTurnBasedMatchmakerViewController, didFind match: GKTurnBasedMatch) {
        viewController.dismiss(animated: true, completion: nil)
        startGame(match: match)
    }
    
    func turnBasedMatchmakerViewControllerWasCancelled(_ viewController: GKTurnBasedMatchmakerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func turnBasedMatchmakerViewController(_ viewController: GKTurnBasedMatchmakerViewController, didFailWithError error: Error) {
        print("Matchmaking failed with error: \(error.localizedDescription)")
        viewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - GKTurnBasedEventListener
    func player(_ player: GKPlayer, receivedTurnEventFor match: GKTurnBasedMatch, didBecomeActive: Bool) {
        self.match = match
        // Handle turn events and update the game state
    }
    
    func player(_ player: GKPlayer, matchEnded match: GKTurnBasedMatch) {
        // Handle end of match and update the game state
        self.isGameOver = true
    }
    
    // MARK: - GKLocalPlayerListener
    func player(_ player: GKPlayer, didAccept inviteTo: GKInvite) {
        // Handle invitation acceptance
    }
    
    // Implement other GKLocalPlayerListener methods as needed
}
