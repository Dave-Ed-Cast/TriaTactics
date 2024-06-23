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

    // these variables are all needed for the management of the matches
    @Published var inGame: Bool = false
    @Published var isGameOver: Bool = false
    @Published var autheticationState: PlayerAuthState = .authenticating
    @Published var currentlyPlaying: Bool = false
    @Published var localPlayerScore: Int = 0
    @Published var otherPlayerScore: Int = 0
    @Published var remainingTime = 10
    @Published var localPlayerWin: Bool = false
    @Published var waitingForRematchResponse: Bool = false
    @Published var localPlayerSymbol: Player = .X

    // there needs to be a reference of the GameLogic
    var gameLogic: GameLogic?

    var timer: Timer?
    var match: GKMatch?
    var localPlayer: GKLocalPlayer = GKLocalPlayer.local
    var otherPlayer: GKPlayer?
    var playerUUIDKey = UUID().uuidString
    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }

    /// Handles the log in of the user into game center
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
    /// Start the timer of the match
    func startTimer() {
        remainingTime = 10
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.handleTimerTick()
        }
    }

    /// Timer logic
    func handleTimerTick() {
        remainingTime -= 1
        if remainingTime < 0 {
            remainingTime = 10
            gameLogic?.makeRandomMove()
        }
    }

    /// Stop the timer of the match
    func stopTimer() {
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
        localPlayerSymbol = currentlyPlaying ? .X : .O
        print("prima")
        inGame = true
        print("dopo")
        sendString("began:\(playerUUIDKey)")
    }

    /// This is an exclusive function for online matches.
    /// The local player sends the move
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
        startTimer()
        currentlyPlaying = !currentlyPlaying
    }

    /// When we send a string, we also need to receive it
    /// - Parameter message: so we receive the message string with all the components (command, index and player)
    func receivedString(_ message: String) {

        // MARK: message example - move:2:X

        let messageSplit = message.split(separator: ":")
        guard let messagePrefix = messageSplit.first else { return }
        let parameter = String(messageSplit.last ?? "")

        // MARK: split message example - ["move", "2", "X"]

        switch messagePrefix {

            // when the encoded message is "began"
        case "began":
            if playerUUIDKey == parameter {
                // determine which playerID to give this player
                playerUUIDKey = UUID().uuidString
                print("my playerUUIDKey is: \(playerUUIDKey)")
                sendString("began:\(playerUUIDKey)")
                break
            }

            // the player lexicographically smaller goes first
            currentlyPlaying = (playerUUIDKey < parameter)
            print("\(playerUUIDKey) currently playing: \(currentlyPlaying)")
            startTimer()
            Navigation.shared.value = .online

            // when the encoded message is "move" do some stuff
            // if you were to receive this move, who would win?
        case "move":
            print(messageSplit)
            if messageSplit.count == 3, let index = Int(messageSplit[1]), let playerSymbol = messageSplit[2].first, let player = Player(rawValue: String(playerSymbol)) {

                // if my opponent were a tactician i would be in a bit of trouble

                gameLogic?.receiveMove(index: index, player: player)
            }
        case "winner":
            localPlayerWin = (gameLogic?.winner == localPlayerSymbol)
            localPlayerWin ? (localPlayerScore += 1) : (otherPlayerScore += 1)
            stopTimer()
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
