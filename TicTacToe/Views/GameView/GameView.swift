//
//  GameView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/05/24.
//

import SwiftUI

struct GameView: View {

    @EnvironmentObject var matchManager: MatchManager
    @EnvironmentObject var gameLogic: GameLogic
    @EnvironmentObject var changeViewTo: Navigation

    @Environment(\.colorScheme) var colorScheme

    @State private var showAlert = false
    @State private var showWinnerOverlay = false

    var body: some View {

        ZStack {
            Color.buttonTheme.ignoresSafeArea()

            VStack(spacing: 0) {

                TopHUD()

                ScoreView()
                    .padding(.vertical, 0)
                Spacer()
                VStack {
                    if changeViewTo.value == .online {
                        Text("Time left: \(matchManager.remainingTime)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .opacity((changeViewTo.value == .offline) ? 0 : 1)
                            .foregroundStyle(.textTheme)
                            .padding(.bottom, 10)
                            .onAppear {
                                print("matchManager: \(matchManager)")
                            }
                    } else if changeViewTo.value == .offline || changeViewTo.value == .bot {
                        // TODO: picker for difficulty
                        Text("placeholder")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.textTheme)
                            .padding(.bottom, 10)
                            .opacity(0)
                    }
                }

                GameGrid(gameLogic: gameLogic)
                Spacer()
            }// end of outer VStack

            .onAppear {
                gameLogic.resetGame()
                gameLogic.xScore = 0
                gameLogic.oScore = 0
            }
            .onDisappear {
                matchManager.gameOver()
            }
            .onChange(of: gameLogic.winner) { newValue in
                if newValue != nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        withAnimation(.easeIn(duration: 0.7)) {
                            showWinnerOverlay = true
                        }
                    }
                }
            }

            if showWinnerOverlay {
                winnerOverlay
            }
        }// end of outer ZStack

    }

    var winnerOverlay: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()

            VStack(spacing: 20) {

                VStack {
                    Text("The winner is:")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundStyle(.textTheme)

                    if changeViewTo.value == .offline || changeViewTo.value == .bot {
                        Image(gameLogic.winner?.rawValue ?? "")
                            .resizable()
                            .frame(maxWidth: 130, maxHeight: 130)
                    } else {
                        Text(matchManager.localPlayerWin ? matchManager.localPlayer.displayName : matchManager.otherPlayer?.displayName ?? "Other")
                            .fontWeight(.bold)
                            .font(.largeTitle)
                            .foregroundStyle(.textTheme)
                    }
                }
                .padding(.horizontal, 50)
                .padding(.vertical, 30)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color.buttonTheme.opacity(0.8))
                        .shadow(radius: 10)
                }
                .padding(.top, 150)

                buttonView
                backToMenuView

            }
            .onChange(of: gameLogic.activePlayer) { activePlayer in
                if activePlayer == .O && changeViewTo.value == .bot {
                    gameLogic.computerMove()
                }
            }
        }
    }

    var buttonView: some View {

        PrimaryButton(label: "Rematch", action: {

            if changeViewTo.value == .offline || changeViewTo.value == .bot {
                gameLogic.resetGame()
            } else {
                matchManager.sendRematchRequest()
            }
            withAnimation(.easeIn(duration: 0.5)) {
                showWinnerOverlay = false
            }
        }, color: .buttonTheme.opacity(0.8))
    }

    var backToMenuView: some View {

        PrimaryButton(label: "Menu", action: {
            showAlert = true
        }, color: .buttonTheme.opacity(0.8))
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Quit game?"),
                message: Text("Are you sure you want to leave?"),
                primaryButton: .destructive(Text("Yes")) {

                    withAnimation(.easeOut(duration: 0.5)) {
                        changeViewTo.value == .online ? (matchManager.gameOver()) : (changeViewTo.value = .play)
                    }

                    showAlert = false

                },
                secondaryButton: .cancel()
            )
        }
        .preferredColorScheme(colorScheme)
    }
}

#Preview("Offline") {
    GameView()
        .environmentObject(MatchManager())
        .environmentObject(GameLogic())
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .offline
            return navigation
        }())
}
#Preview("Online") {
    GameView()
        .environmentObject(MatchManager())
        .environmentObject(GameLogic())
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .online
            return navigation
        }())
}

#Preview("AI") {
    GameView()
        .environmentObject(MatchManager())
        .environmentObject(GameLogic())
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .bot
            return navigation
        }())
}
