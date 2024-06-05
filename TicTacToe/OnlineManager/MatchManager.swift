//
//  MatchManager.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 22/05/24.
//

import Foundation
import GameKit
import SwiftUI

/** 
 This is the class that manages the online part of the matches
 It is indipendent from the game logic  for mantainability, scalability, and testing purposes.
 */
class MatchManager: NSObject, ObservableObject {
    
    //these variables are all needed for the management of the matches
    @Published var inGame: Bool = false
    @Published var isGameOver: Bool = false
    @Published var autheticationState: PlayerAuthState = .authenticating
    @Published var currentlyPlaying: Bool = false
    @Published var localPlayerScore: Int = 0
    @Published var otherPlayerScore: Int = 0
    @Published var isTimeKeeper: Bool = false
    @Published var remainingTime = 10
    @Published var localPlayerWin: Bool = false
    @Published var waitingForRematchResponse: Bool = false
    
    //there needs to be a reference of the GameLogic
    var gameLogic: GameLogic?
    
    var timer: Timer?
    
    //matchmaking and online variables
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
    
    func startTimer() {
        isTimeKeeper = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.handleTimerTick()
        }
    }
    
    func handleTimerTick() {
        remainingTime -= 1
        if remainingTime <= 0 {
            remainingTime = 10
            gameLogic?.makeRandomMove()
        }
    }
    
    func stopTimer() {
        isTimeKeeper = false
        timer?.invalidate()
        timer = nil
    }
    
    /// Pair two players to play online
    func startMatchmaking() {
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        
        let matchMakerVC = GKMatchmakerViewController(matchRequest: request)
        matchMakerVC?.matchmakerDelegate = self
        rootViewController?.present(matchMakerVC!, animated: true)
    }
    
    /// Start the game when players are found
    /// - Parameter newMatch: this new match is to assign the id of the match so that we know which is it
    func startGame(newMatch: GKMatch) {
        match = newMatch
        match?.delegate = self
        otherPlayer = match?.players.first
        sendString("began:\(playerUUIDKey)")
    }
    
    /// Send the current move
    /// - Parameters:
    ///   - index: the index at which the player tapped
    ///   - player: the player that made the move
    func sendMove(index: Int, player: Player) {
        let moveMessage = "move:\(index):\(player)"
        sendString(moveMessage)
    }
    
    /// Ends the game
    func gameOver() {
        isGameOver = true
        inGame = false
        currentlyPlaying = false
        localPlayerScore = 0
        match?.disconnect()
        match?.delegate = nil
        match = nil
        gameLogic?.resetGame()
        stopTimer()
    }
    
    /// Resets the game
    func resetGame() {
        gameLogic?.resetGame()
        stopTimer()
        sendString("began:\(playerUUIDKey)")
    }
    
    /// When we send a string, we also need to receive it
    /// - Parameter message: so we receive the message string with all the components (command, index and player)
    func receivedString(_ message: String) {
        
        //we split the message and know the first element is the command
        let messageSplit = message.split(separator: ":")
        guard let messagePrefix = messageSplit.first else { return }
        let parameter = String(messageSplit.last ?? "")
        
        switch messagePrefix {
            
            //when the encoded message is "began" do some stuff
        case "began":
            if playerUUIDKey == parameter {
                //determine which playerID to give this player
                playerUUIDKey = UUID().uuidString
                sendString("began:\(playerUUIDKey)")
                break
            }
            
            //the player lexicographically smaller goes first
            currentlyPlaying = (playerUUIDKey < parameter)
            inGame = true
            startTimer()
            
            //when the encoded message is "move" do some stuff
        case "move":
            if messageSplit.count == 3, let index = Int(messageSplit[1]), let playerSymbol = messageSplit[2].first, let player = Player(rawValue: String(playerSymbol)) {
                
                //if you were to receive this move, who would win?
                gameLogic?.receiveMove(index: index, player: player)
                
                //if my opponent were intelligent i would be in a bit of trouble
                
                //but would you lose?
                if gameLogic!.checkWinner() {
                    localPlayerWin = (gameLogic?.winner == gameLogic?.activePlayer)
                    localPlayerWin ? (localPlayerScore += 1) : (otherPlayerScore += 1)
                } else {
                    //nah, i'd win
                    currentlyPlaying = (playerUUIDKey != player.rawValue)
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
