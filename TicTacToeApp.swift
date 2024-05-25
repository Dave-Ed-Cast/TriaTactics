//
//  TicTacToeApp.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 17/05/24.
//

import SwiftUI

@main
struct TicTacToeApp: App {
    
    @State var skipOnboarding: Bool = false
    @State var showLottieAnimation: Bool = false
    @StateObject private var matchManager = MatchManager()
    @StateObject private var gameLogic = GameLogic()

    var body: some Scene {
        WindowGroup {
            MainView(
                onboardingIsCompleted: UserDefaults.standard.bool(forKey: "OnboardingStatus"),
                currentStep: .constant(0),
                skipOnboarding: $skipOnboarding,
                showLottieAnimation: $showLottieAnimation
            )
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
