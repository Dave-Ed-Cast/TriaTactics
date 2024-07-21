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

    var namespace: Namespace.ID

    let size = UIScreen.main.bounds

    var body: some View {

        Group {
            VStack(spacing: 10) {
                VStack {
                    Image("appicon")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                        .frame(height: size.height / 7.5)

                    Text("Tria Tactics")
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
                .padding(.vertical, 50)
                VStack(spacing: 30) {
                    if view.value == .main {
                        PrimaryButton(label: "Play", action: {
                            withAnimation {
                                view.value = .play
                            }
                        }, color: .buttonTheme.opacity(0.8))

                        VStack(spacing: 10) {
                            SecondaryButton(label: "Tutorial", action: {
                                withAnimation {
                                    view.value = .tutorial
                                }
                            }, color: .buttonTheme.opacity(0.8))

                            SecondaryButton(label: "Settings", action: {
                                withAnimation {
                                    isSettingsPresented.toggle()
                                }
                            }, color: .buttonTheme.opacity(0.8))
                        }
                    } else if view.value == .play {

                        VStack(spacing: 30) {
                            PrimaryButton(label: "Play Online", action: {
                                matchManager.startMatchmaking()
                            }, color: .buttonTheme.opacity(0.8))
                            .opacity(matchManager.authenticationState != .authenticated ? 0.5 : 1)
                            .disabled(matchManager.authenticationState != .authenticated)

                            PrimaryButton(label: "Play Offline", action: {
                                withAnimation {
                                    view.value = .offline
                                }
                            }, color: .buttonTheme.opacity(0.8))
                            PrimaryButton(label: "Play vs AI", action: {
                                withAnimation {
                                    view.value = .bot
                                }
                            }, color: .buttonTheme.opacity(0.8))
                        }
                        .padding(.top, 50)
                        .onAppear {
                            matchManager.authenticateUser()
                        }

                        // menu
                        SecondaryButton(label: "Menu", action: {
                            withAnimation {
                                view.value = .main
                            }
                        }, color: .buttonTheme.opacity(0.8))
                    }
                }
            }
        }// end of outer vstack

        .lineLimit(1)

        .halfModal(isPresented: $isSettingsPresented) {
            SettingsView(toggleAnimation: $isAnimationEnabled)
                .onDisappear {
                    isSettingsPresented = false
                }
        }
    }

    var infoButton: some View {
        Button {

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
