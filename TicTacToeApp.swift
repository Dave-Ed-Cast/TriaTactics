//
//  TicTacToeApp.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 17/05/24.
//

import SwiftUI

@main
struct TicTacToeApp: App {

    @StateObject private var onboarding: OnboardingParameters = .init()
    @StateObject private var matchManager = MatchManager.shared
    @StateObject private var gameLogic = GameLogic.shared
    @StateObject private var navigation = Navigation.shared

    @AppStorage("animationStatus") private var animationEnabled = true

    let setConfig = UserDefaults.standard

    init() {
        if setConfig.object(forKey: "hasLaunchedBefore") == nil {
            setConfig.set(true, forKey: "hasLaunchedBefore")
            setConfig.set(true, forKey: "animationStatus")
        }
        GameLogic.shared.matchManager = MatchManager.shared
        MatchManager.shared.gameLogic = GameLogic.shared
    }

    var body: some Scene {

        WindowGroup {
            if onboarding.completed || onboarding.skipped {
                ParentView()
                    .environmentObject(matchManager)
                    .environmentObject(gameLogic)
                    .environmentObject(navigation)
            } else {
                OnboardView(onboarding: onboarding)
            }
        }
    }
}
