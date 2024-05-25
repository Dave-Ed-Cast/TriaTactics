//
//  MatchManager+GKMatchDelegate.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 25/05/24.
//

import Foundation
import GameKit

extension MatchManager: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, forRecipient recipient: GKPlayer, fromRemotePlayer player: GKPlayer) {
        let content = String(decoding: data, as: UTF8.self)
        if content.starts(with: "strData:") {
            let message = content.replacing("strData", with: "")
            receivedString(message)
            print("okok")
        } else {
            do {
                print("oh no")
            } catch {
                print(error)
            }
        }
    }
    
    func sendString(_ message: String) {
        guard let encoded = "strData:\(message)".data(using: .utf8) else { return }
        sendData(encoded, mode: .reliable)
        print("sent")
    }
    
    func sendData(_ data: Data, mode: GKMatch.SendDataMode) {
        
        do {
            try match?.sendData(toAllPlayers: data, with: mode)
        } catch {
            print(error)
        }
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        
    }
}
