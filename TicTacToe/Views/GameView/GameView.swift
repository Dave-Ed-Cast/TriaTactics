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

        CompatibilityNavigation {
            ZStack {
                Color.buttonTheme.ignoresSafeArea()
                VStack(spacing: 15) {
                    ZStack {
                        Rectangle()
                            .foregroundStyle(.backgroundTheme.opacity(0.6))
                            .ignoresSafeArea()
                            .frame(maxHeight: 100)
                        HStack(alignment: .center) {

                            if changeViewTo.value == .offline {
                                Image("\(gameLogic.activePlayer == .X ? "X" : "O")")
                                    .resizable()
                                    .frame(maxWidth: 60, maxHeight: 60)
                                Spacer()
                                Text("It's your turn")
                            } else if changeViewTo.value == .online {
                                if let imageData = matchManager.localPlayerImage, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .frame(maxWidth: 50, maxHeight: 50)
                                    Text("\(matchManager.currentlyPlaying ? matchManager.localPlayer.displayName : matchManager.otherPlayer?.displayName ?? "Other")'s turn")
                                        .multilineTextAlignment(.center)
                                }
                            } else if changeViewTo.value == .bot {
                                Image("\(gameLogic.activePlayer == .X ? "X" : "O")")
                                    .resizable()
                                    .frame(maxWidth: 60, maxHeight: 60)
                                Spacer()
                                Text(gameLogic.activePlayer == .X ? "It's your turn" : "AI's turn")
                            }
                        }// end of HStack
                        .foregroundStyle(.textTheme)
                        .font(.title2)
                        .padding(.horizontal, 60)
                    }// end of inner ZStack, this is the top HUD

                    VStack(spacing: 0) {
                        Text("Score")
                            .fontWeight(.semibold)
                            .font(.title3)
                            .foregroundStyle(.textTheme)

                        ScoreView()
                            .frame(maxHeight: 0)
                    }
                    Spacer()
                    VStack {
                        if changeViewTo.value == .online {
                            Text("Time left: \(matchManager.remainingTime)")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .opacity((changeViewTo.value == .offline) ? 0 : 1)
                                .foregroundStyle(.textTheme)
                                .padding(.top, 80)
                        } else if changeViewTo.value == .bot {
                            // TODO: picker for difficulty
                        }
                    }

                    Spacer()
                    GameGrid(gameLogic: gameLogic)
                        .frame(maxWidth: 360)
                        .padding(.bottom, 60)

                }// end of outer VStack

                .onAppear {
                    gameLogic.resetGame()
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
                    // AI's turn (assuming AI plays as O)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        gameLogic.computerMove()
                    }
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
        }, color: .buttonTheme)
    }

    var backToMenuView: some View {

        PrimaryButton(label: "Menu") {
            showAlert = true
        }
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
