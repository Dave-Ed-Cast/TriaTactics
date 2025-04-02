//
//  ParentView.swift
//  TicTacToe
//
//  Created by Giuseppe Francione on 21/06/24.
//

import SwiftUI

struct ParentView: View {

    @AppStorage("animationStatus") private var animationEnabled = true

    @EnvironmentObject private var view: Navigation
    @EnvironmentObject private var matchManager: MatchManager
    @EnvironmentObject private var gameLogic: GameLogic

    @Namespace private var namespace

    @State private var animateSparkle: Bool = false
    @State var touchLocation: CGPoint?

    let size = UIScreen.main.bounds

    var body: some View {
        ZStack(alignment: .center) {
            BackgroundView(savedValueForAnimation: $animationEnabled)

            switch view.value {
            case .main, .play:
                VStack(alignment: .center) {
                    MainView(namespace: namespace)
                }
                .transition(.customPush(cfrom: .top))

            case .online, .offline, .bot:
                VStack {
                    Spacer()
                    GameView()
                    Spacer()
                }

            case .tutorial:
                VStack {
                    Spacer()
                    TutorialView()
                    Spacer()
                }
                .transition(.customPush(cfrom: .bottom))

            case .collaborators:

                Group {
                    CollaboratorsView()
                }
                .padding(.top, 40)
                .transition(.customPush(cfrom: .bottom))
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
