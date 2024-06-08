//
//  MatchManager+GKMatchDelegate.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 25/05/24.
//

import Foundation
import GameKit

///This is the match delegate
extension MatchManager: GKMatchDelegate {
    
    /// This is the core function that defines a match
    /// - Parameters:
    ///   - match: the match we are in
    ///   - data: the data as the string content
    ///   - recipient: this is unused but could be useful in future
    ///   - player: this is unused but could be useful in future
    func match(_ match: GKMatch, didReceive data: Data, forRecipient recipient: GKPlayer, fromRemotePlayer player: GKPlayer) {
        let content = String(decoding: data, as: UTF8.self)
        if content.starts(with: "strData:") {
            let message = content.replacingOccurrences(of: "strData:", with: "")
            receivedString(message)
        } else if content == "requestRematch" {
            showRematchRequest()
        } else if content == "rematchAccepted" {
            handleRematchAccepted()
        } else if content == "rematchDeclined" {
            handleRematchDeclined()
        }
    }
    
    /// This sends the string encoded with data in utf8
    /// - Parameter message: the message we need to send after modifying it
    func sendString(_ message: String) {
        guard let encoded = "strData:\(message)".data(using: .utf8) else { return }
        sendData(encoded, mode: .reliable)
        print("sent")
    }
    
    /// This is the sending of that data
    /// - Parameters:
    ///   - data: the data we are passing it to
    ///   - mode: mode is just reagrding the type of data
    func sendData(_ data: Data, mode: GKMatch.SendDataMode) {
        
        do {
            try match?.sendData(toAllPlayers: data, with: mode)
        } catch {
            print(error)
        }
    }
    
    /// This is the function that dictates what happens if someone disconnects
    /// - Parameters:
    ///   - match: the match we are talking about
    ///   - player: the player that can disconnect
    ///   - state: its connection state
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        guard state == .disconnected else { return }
        let alert = UIAlertController(title: "Player disconnected!", message: "The other player disconnected from the game", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.match?.disconnect()
        })
        DispatchQueue.main.async {
            self.gameOver()
            self.rootViewController?.present(alert, animated: true)
        }
    }
    
    /// Handles the request to the other user 
    func showRematchRequest() {
        let alert = UIAlertController(title: "Rematch?", message: "The other player requested a rematch. Do you want to play again?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { [self] _ in
            sendRematchResponse(accepted: true)
            resetGame()
        })
        alert.addAction(UIAlertAction(title: "No", style: .cancel) { [self] _ in
            sendRematchResponse(accepted: false)
            self.match?.disconnect()
            gameOver()
        })
        DispatchQueue.main.async { [self] in
            rootViewController?.present(alert, animated: true)
        }
    }
    
    /// Send rematch response
    func sendRematchResponse(accepted: Bool) {
        let response = accepted ? "rematchAccepted" : "rematchDeclined"
        guard let data = response.data(using: .utf8) else { return }
        sendData(data, mode: .reliable)
    }
    
    /// Handle rematch accepted response
    func handleRematchAccepted() {
        // Logic to handle rematch accepted
        DispatchQueue.main.async {
            self.gameLogic?.resetGame()
            let alert = UIAlertController(title: "Rematch Accepted", message: "The other player accepted the rematch", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.rootViewController?.present(alert, animated: true)
        }
    }
    
    /// Handle rematch declined response
    func handleRematchDeclined() {
        // Logic to handle rematch declined
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Rematch Declined", message: "The other player declined the rematch", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.rootViewController?.present(alert, animated: true)
        }
    }
    
    /// Show rematch alert when game ends
    func showEndGameRematchAlert() {
        let alert = UIAlertController(title: "Game Over", message: "Do you want a rematch?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
            self.sendRematchRequest()
        })
        alert.addAction(UIAlertAction(title: "No", style: .cancel) { _ in
            self.match?.disconnect()
        })
        DispatchQueue.main.async {
            self.rootViewController?.present(alert, animated: true)
        }
    }
    
    /// Send rematch request to the other player
    func sendRematchRequest() {
        guard let data = "requestRematch".data(using: .utf8) else { return }
        sendData(data, mode: .reliable)
    }
}
