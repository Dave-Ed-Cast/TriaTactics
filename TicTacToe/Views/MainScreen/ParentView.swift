//
//  ParentView.swift
//  TicTacToe
//
//  Created by Giuseppe Francione on 21/06/24.
//

import SwiftUI

struct ParentView: View {

    @AppStorage("animationStatus") private var animationEnabled = true

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
        .background {
            BackgroundView(savedValueForAnimation: $animationEnabled)
        }
    }
}

// ParentView has the background.
// with this we can control the background on the previews.
// If needed, call PreviewWrapper { SomeView() }
// to see what would happen with a background that you can either move or not

struct PreviewWrapper<Content: View>: View {
    @State private var isPreviewAnimationEnabled = true
    let content: () -> Content

    var body: some View {
        ZStack {
            content()
                .environmentObject(MatchManager())
                .environmentObject(Navigation.shared)
                .environmentObject(GameLogic())
                .background {
                    BackgroundView(savedValueForAnimation: $isPreviewAnimationEnabled)
                }
            VStack {
                Spacer()
                Toggle("Toggle Animation", isOn: $isPreviewAnimationEnabled)
                    .padding()
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
