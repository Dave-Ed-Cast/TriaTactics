//
//  ContentView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 17/05/24.
//

import SwiftUI

struct MainView: View {

    @EnvironmentObject var matchManager: MatchManager
    @EnvironmentObject var gameLogic: GameLogic
    @EnvironmentObject var view: Navigation

    @AppStorage("animationStatus") private var animationEnabled = true

    @State private var isSettingsPresented = false
    @State private var isAnimationEnabled = UserDefaults.standard.bool(forKey: "animationStatus")

    let sizeOfBounds = UIScreen.main.bounds
    var namespace: Namespace.ID

    var body: some View {

        VStack(spacing: 30) {
            Spacer()
            TriaLogo(namespace: namespace)
            if view.value == .main {
                PrimaryButton("Play") {
                    view.value = .play
                }
                .padding()
                VStack(spacing: 15) {
                    SecondaryButton("Tutorial") {
                        view.value = .tutorial
                    }
                    SecondaryButton("Settings") {
                        withAnimation {
                            isSettingsPresented.toggle()
                        }
                    }
                }
                Spacer()

            } else if view.value == .play {
                Spacer()
                PrimaryButton("Play Online") {
                    matchManager.startMatchmaking()
                }
                .opacity(matchManager.authenticationState != .authenticated ? 0.5 : 1)
                .disabled(matchManager.authenticationState != .authenticated)

                PrimaryButton("Play Offline", subtitle: "2P same device") {
                    view.value = .offline
                }
                PrimaryButton("Play vs AI") {
                    view.value = .bot
                }
                SecondaryButton("Menu") {
                    view.value = .main
                }

            }

        }
        .halfModal(isPresented: $isSettingsPresented) {
            SettingsView(toggleAnimation: $isAnimationEnabled)
                .onDisappear {
                    isSettingsPresented = false
                }
        }
        .onAppear {
            matchManager.authenticateUser()
        }
        .lineLimit(1)
    }
}

#Preview {
    PreviewWrapper {
        MainView(namespace: Namespace().wrappedValue)
            .environmentObject(AnimationTap())
    }
}

#Preview("Play part") {
    MainView(namespace: Namespace().wrappedValue)
        .environmentObject(MatchManager.shared)
        .environmentObject(GameLogic.shared)
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .play
            return navigation
        }())
        .environmentObject(AnimationTap())
        .background {
            BackgroundView(savedValueForAnimation: .constant(true))
        }
}
