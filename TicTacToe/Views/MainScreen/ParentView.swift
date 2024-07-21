//
//  ParentView.swift
//  TicTacToe
//
//  Created by Giuseppe Francione on 21/06/24.
//

import SwiftUI

struct ParentView: View {

    @AppStorage("animationStatus") private var animationEnabled = true

    @EnvironmentObject var view: Navigation
    @EnvironmentObject var matchManager: MatchManager
    @EnvironmentObject var gameLogic: GameLogic

    @Namespace private var namespace

    var body: some View {
        ZStack {
            BackgroundView(savedValueForAnimation: $animationEnabled)
            switch view.value {
            case .main:
                MainView(namespace: namespace)
            case .play:
                PlayView(namespace: namespace)
            case .online, .offline, .bot:
                GameView()
            case .tutorial:
                TutorialView()
            case .collaborators:
                CollaboratorsView()
            }
        }
    }
}

/// ParentView has the background.
/// with this we can control the background on the previews.
/// If needed, call `PreviewWrapper { SomeView() }`
/// to see what would happen with a background that you can either move or not
struct PreviewWrapper<Content: View>: View {
    @State private var isPreviewAnimationEnabled = true
    let content: () -> Content

    var body: some View {
        ZStack {
            content()
                .environmentObject(MatchManager.shared)
                .environmentObject(Navigation.shared)
                .environmentObject(GameLogic.shared)
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
        .environmentObject(MatchManager.shared)
        .environmentObject(GameLogic.shared)
}
