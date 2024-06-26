//
//  ParentView.swift
//  TicTacToe
//
//  Created by Giuseppe Francione on 21/06/24.
//

import SwiftUI

struct ParentView: View {
    @EnvironmentObject var navigation: Navigation
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
                EmptyView()
            case .tutorial:
                TutorialView()
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
