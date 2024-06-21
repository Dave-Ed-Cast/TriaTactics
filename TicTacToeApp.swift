//
//  TicTacToeApp.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 17/05/24.
//

import SwiftUI

@main
struct TicTacToeApp: App {

    @StateObject private var matchManager = MatchManager()
    @StateObject private var gameLogic = GameLogic()

    var body: some Scene {
        WindowGroup {
            MainView()
            .preferredColorScheme(.light)
            .environmentObject(matchManager)
            .environmentObject(gameLogic)
            .onAppear {
                matchManager.gameLogic = gameLogic
                gameLogic.matchManager = matchManager
            }
        }
    }
}
