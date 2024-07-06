//
//  ParentView.swift
//  TicTacToe
//
//  Created by Giuseppe Francione on 21/06/24.
//

import SwiftUI

struct ParentView: View {

    @EnvironmentObject var navigation: Navigation
    @State private var isSettingsPresented = false
    @State private var isAnimationEnabled = UserDefaults.standard.bool(forKey: "animationStatus")

    var body: some View {
        Group {
            switch navigation.value {
            case .main:
                MainView()
            case .play:
                PlayView()
            case .online:
                GameView()
            case .offline:
                GameView()
            case .bot:
                GameView()
            case .tutorial:
                TutorialView()
            case .collaborators:
                CollaboratorsView()
            case .settings:
                MainView()
            }

        }
        .halfModal(isPresented: $isSettingsPresented) {
            SettingsView(isAnimationEnabled: $isAnimationEnabled)
        }
        .onChange(of: navigation.value) { newValue in
            if newValue == .settings {
                withAnimation {
                    isSettingsPresented = true
                }
            }
        }
        .environmentObject(AnimationSettings(isAnimationEnabled: $isAnimationEnabled))
    }
}

#Preview {
    ParentView()
        .environmentObject(Navigation.shared)
        .environmentObject(MatchManager())
        .environmentObject(GameLogic())
}
