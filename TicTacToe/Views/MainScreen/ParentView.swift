//
//  ParentView.swift
//  TicTacToe
//
//  Created by Giuseppe Francione on 21/06/24.
//

import SwiftUI

struct ParentView: View {

    @EnvironmentObject var navigation: Navigation
    @EnvironmentObject var matchManager: MatchManager
    @EnvironmentObject var gameLogic: GameLogic

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
            }
        }

    }
}

#Preview {
    ParentView()
        .environmentObject(Navigation.shared)
        .environmentObject(MatchManager())
        .environmentObject(GameLogic())
}
