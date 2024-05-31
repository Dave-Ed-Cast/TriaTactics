//
//  MatchManager.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 22/05/24.
//

import Foundation
import GameKit
import SwiftUI

/// This is the class that manages the online part of the matches
class MatchManager: NSObject, ObservableObject {
    
    //these variables are all needed for the management of the matches
    @Published var inGame: Bool = false
    @Published var isGameOver: Bool = false
    @Published var autheticationState: PlayerAuthState = .authenticating
    @Published var currentlyPlaying: Bool = false
    @Published var localPlayerScore: Int = 0
    @Published var otherPlayerScore: Int = 0
    @Published var lastIndexReceived: Int = 0
    @Published var isTimeKeeper: Bool = false
    @Published var remainingTime = 10
    @Published var localPlayerWin: Bool = false
    
    //there needs to be a reference of the GameLogic
    var gameLogic: GameLogic?
    
    var localPlayerSymbol: Player = .X
    var match: GKMatch?
    var localPlayer: GKLocalPlayer = GKLocalPlayer.local
    var otherPlayer: GKPlayer?
    var playerUUIDKey = UUID().uuidString
    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
    
    /// This is the function that handles the log in of the user into game center
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
            } else {
                self?.autheticationState = .unauthenticated
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
    
    /// The moment the users wants to play online, we find the players
    func startMatchmaking() {
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        
        let matchMakerVC = GKMatchmakerViewController(matchRequest: request)
        matchMakerVC?.matchmakerDelegate = self
        rootViewController?.present(matchMakerVC!, animated: true)
    }
    
    /// And when the player is found, we play
    /// - Parameter newMatch: this new match is to assign the id of the match so that we know which is it
    func startGame(newMatch: GKMatch) {
        match = newMatch
        match?.delegate = self
        otherPlayer = match?.players.first
        currentlyPlaying = true
        sendString("began:\(playerUUIDKey)")
    }
    
    /// When we send moves we just have to tell that something should change
    /// - Parameters:
    ///   - index: So we just give the move command, along with the index
    ///   - player: and the player that made the move
    func sendMove(index: Int, player: Player) {
        let moveMessage = "move:\(index):\(player)"
        sendString(moveMessage)
    }
    
    

    /// Ends the game
    func gameOver() {
        isGameOver = true
        inGame = false
        currentlyPlaying = false
        lastIndexReceived = 0
        localPlayerScore = 0
        match?.disconnect()
        match?.delegate = nil
        match = nil
        gameLogic?.resetGame()
    }
    
    /// Resets the game
    func resetGame() {
        
        gameLogic?.resetGame()
        localPlayerWin = false
        isTimeKeeper = false
        playerUUIDKey = UUID().uuidString
    }
    
    /// When we send a string, we also need to receive it
    /// - Parameter message: so we receive the message string with all the components (command, index and player)
    func receivedString(_ message: String) {
        
        //we split the message and know the first element is the command
        let messageSplit = message.split(separator: ":")
        guard let messagePrefix = messageSplit.first else { return }
        let parameter = String(messageSplit.last ?? "")
        
        switch messagePrefix {
            
            //this means the game started, so we assign UUID keys
        case "began":
            if playerUUIDKey == parameter {
                playerUUIDKey = UUID().uuidString
                sendString("began:\(playerUUIDKey)")
                break
            }
            
            /*
             we set the player who is lexicographically smaller, UUIDkey < param, currentlyPlaying = true
             also we set the inGame status and isTimeKeeper for the views
             */
            currentlyPlaying = playerUUIDKey < parameter
            inGame = true
            print("Beginning the game, inGame: \(inGame)")
            isTimeKeeper = true
            
            if isTimeKeeper {
                countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            }
            
            //then we make the move made of three elements regarding the message and if it's sent successfully
        case "move":
            if messageSplit.count == 3, let index = Int(messageSplit[1]), let playerSymbol = messageSplit[2].first, let player = Player(rawValue: String(playerSymbol)) {
                
                //we make the game logic receive this move
                gameLogic?.receiveMove(index: index, player: player)
                
                //tell that the other player can't move
                currentlyPlaying = playerUUIDKey != player.rawValue
                
                //and if with the received move they won, then we know the winner
                if gameLogic!.checkWinner() {
                    localPlayerWin = gameLogic?.winner == localPlayerSymbol
                    localPlayerScore += 1
                    otherPlayerScore = localPlayerScore
                    currentlyPlaying = playerUUIDKey == player.rawValue
                }
            }
        case "requestRematch":
            showRematchRequest()
        case "rematchAccepted":
            handleRematchAccepted()
        case "rematchDeclined":
            handleRematchDeclined()
        default:
            break
        }
    }
}
