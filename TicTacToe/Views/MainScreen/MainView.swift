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

    @Environment(\.device) private var device

    var namespace: Namespace.ID

    var body: some View {

        VStack(spacing: device == .pad ? 35 : 35) {
            Spacer()
            TriaLogo(namespace: namespace)
            if view.value == .main {
                PrimaryButton("Play") {
                    view.value = .play
                }
                .padding()
                VStack(spacing: device == .pad ? 15 : 20) {
                    SecondaryButton("Tutorial") {
                        view.value = .tutorial
                    }
                    SecondaryButton("Settings") {
                        isSettingsPresented.toggle()
                    }
                }
                Spacer()

            } else if view.value == .play {
                Spacer()
                VStack(spacing: device == .pad ? 35 : 20) {
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
                .padding(.bottom, 25)

            }
        }
        .onAppear {
            matchManager.authenticateUser()
        }
        .lineLimit(1)
        .padding()

        .if(device == .phone) { view in
            view.halfModal(isPresented: $isSettingsPresented) {
                SettingsView(toggleAnimation: $isAnimationEnabled)
                    .onDisappear {
                        isSettingsPresented = false
                    }
            }
        }
        .if(device == .pad) { view in
            view.sheet(isPresented: $isSettingsPresented) {
                SettingsView(toggleAnimation: $isAnimationEnabled)
                    .onDisappear {
                        isSettingsPresented = false
                    }

            }
        }

    }
}

#Preview {
    PreviewWrapper {
        MainView(namespace: Namespace().wrappedValue)
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
        .background {
            BackgroundView(savedValueForAnimation: .constant(true))
        }
}
