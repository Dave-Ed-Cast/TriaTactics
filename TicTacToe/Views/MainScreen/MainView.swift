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
    @EnvironmentObject var animation: AnimationTap

    @AppStorage("animationStatus") private var animationEnabled = true

    @State private var isSettingsPresented = false
    @State private var isAnimationEnabled = UserDefaults.standard.bool(forKey: "animationStatus")

    var namespace: Namespace.ID

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size

            VStack(spacing: 10) {
                VStack {
                    Image("appicon")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                        .frame(height: size.height / 7.5)

                    Text(verbatim: "Tria Tactics")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("The game for true tacticians!")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundStyle(.textTheme)
                .padding()
                .background {
                    ZStack(alignment: .topTrailing) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.buttonTheme.opacity(0.8))
                        infoButton
                    }
                }
                .matchedGeometryEffect(id: "icon", in: namespace)
                .padding(.vertical, size.height * 0.05)

                VStack(spacing: size.height * 0.03) {
                    if view.value == .main {
                        PrimaryButton(label: "Play", action: {
                            animation.shouldAnimate = true
                            withAnimation {
                                view.value = .play
                            }
                        }, color: .buttonTheme.opacity(0.8))

                        VStack(spacing: size.height * 0.01) {
                            SecondaryButton(label: "Tutorial", action: {
                                animation.shouldAnimate = true
                                withAnimation {
                                    view.value = .tutorial
                                }
                            }, color: .buttonTheme.opacity(0.8))

                            SecondaryButton(label: "Settings", action: {
                                animation.shouldAnimate = true
                                withAnimation {
                                    isSettingsPresented.toggle()
                                }
                            }, color: .buttonTheme.opacity(0.8))
                        }
                    } else if view.value == .play {

                        VStack(spacing: size.height * 0.03) {
                            PrimaryButton(label: "Play Online", action: {
                                animation.shouldAnimate = true
                                matchManager.startMatchmaking()
                            }, color: .buttonTheme.opacity(0.8))
                            .opacity(matchManager.authenticationState != .authenticated ? 0.5 : 1)
                            .disabled(matchManager.authenticationState != .authenticated)

                            PrimaryButton(label: "Play Offline", subtitle: "2P same device", action: {
                                animation.shouldAnimate = true
                                withAnimation {
                                    view.value = .offline
                                }
                            }, color: .buttonTheme.opacity(0.8))

                            PrimaryButton(label: "Play vs AI", action: {
                                animation.shouldAnimate = true
                                withAnimation {
                                    view.value = .bot
                                }
                            }, color: .buttonTheme.opacity(0.8))
                        }
                        .padding(.top, size.height * 0.05)
                        .onAppear {
                            matchManager.authenticateUser()
                        }

                        // menu
                        SecondaryButton(label: "Menu", action: {
                            animation.shouldAnimate = true
                            withAnimation {
                                view.value = .main
                            }
                        }, color: .buttonTheme.opacity(0.8))
                    }
                }
            }
            .frame(maxWidth: size.width, maxHeight: size.height)
            .position(x: size.width / 2, y: size.height / 2)
            .lineLimit(1)
            .halfModal(isPresented: $isSettingsPresented) {
                SettingsView(toggleAnimation: $isAnimationEnabled)
                    .onDisappear {
                        isSettingsPresented = false
                    }
            }
        }
    }

    var infoButton: some View {
        Button {
            animation.shouldAnimate = true
            view.value = .collaborators

        } label: {
            Image(systemName: "info.circle")
                .foregroundStyle(.buttonTheme)
                .font(.title3)
                .colorInvert()
        }
        .padding()
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
