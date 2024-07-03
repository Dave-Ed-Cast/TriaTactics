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

    @State private var showAlert = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {

        CompatibilityNavigation {
            ZStack {
                colorScheme == .dark ? (Color.gray.ignoresSafeArea()) : (Color.white.ignoresSafeArea())
                VStack(spacing: 15) {
                    ZStack {
                        Rectangle()
                            .foregroundStyle(.backgroundTheme.opacity(0.5))
                            .ignoresSafeArea()
                            .frame(maxHeight: 100)
                        HStack(alignment: .center) {
                            Image("\(gameLogic.activePlayer == .X ? "X" : "O")")
                                .resizable()
                                .frame(maxWidth: 60, maxHeight: 60)
                            Spacer()

                            if changeViewTo.value == .offline {
                                Text("It's your turn")
                            } else {
                                Text("\(matchManager.currentlyPlaying ? matchManager.localPlayer.displayName : matchManager.otherPlayer?.displayName ?? "Other")'s turn")
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .foregroundStyle(.textTheme)
                        .font(.title2)
                        .padding(.horizontal, 60)
                    }// end of inner ZStack
                    Spacer()
                    VStack {

                        Text("Time left: \(matchManager.remainingTime)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .opacity((changeViewTo.value == .offline) ? 0 : 1)
                    }
                    .foregroundStyle(.textTheme)

                    VStack {
                        GameGrid(gameLogic: gameLogic)
                            .frame(maxWidth: 360)
                            .padding(.top, 30)
                        Spacer()
                        Text("Score")
                            .fontWeight(.semibold)
                            .padding(.vertical, -10)
                            .font(.title3)
                            .foregroundStyle(.textTheme)
                        ScoreView()
                            .frame(maxHeight: 0)
                        buttonView
                    }
                    .padding()

                }// end of outer VStack

                .onAppear {
                    gameLogic.resetGame()
                }
                .onDisappear {
                    matchManager.gameOver()
                }
            }// end of outer ZStack
        }
    }

    var winnerView: some View {
        Group {
            if let winner = gameLogic.winner {
                if changeViewTo.value == .offline {
                    Text("\(winner.rawValue) wins!")
                        .fontWeight(.bold)
                } else {
                    Text(matchManager.localPlayerWin ? "You win!" : "You Lose!")
                        .fontWeight(.bold)
                }
            }
        }
        .opacity(gameLogic.checkWinner() ? 1 : 0)
        .font(.title)

    }

//    var scoreView: some View {
//
//        HStack(spacing: 80) {
//            RoundedRectangle(cornerRadius: 20)
//            Spacer()
//            RoundedRectangle(cornerRadius: 20)
//        }
//        .frame(width: 200, height: 50)
//        HStack(spacing: 80) {
//            if !(changeViewTo.value == .offline) {
//                Text("Your wins: \(matchManager.localPlayerScore)")
//                Text("Opponent wins: \(matchManager.otherPlayerScore)")
//            } else {
//                Text("")
//            }
//        }
//        .font(.callout)
//    }

    var buttonView: some View {
        Button {
            guard gameLogic.checkWinner() else { return }
            if changeViewTo.value == .offline {
                gameLogic.resetGame()
            } else {
                matchManager.sendRematchRequest()
            }
        } label: {
            Text("Rematch")
                .fontWeight(.medium)
                .foregroundStyle(.black)
                .font(.title3)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(.yellow)
                )
        }
        .opacity(gameLogic.checkWinner() ? 1 : 0)
        .disabled(!gameLogic.checkWinner())
        .padding(.vertical, 20)
    }

    var backToMenuView: some View {
        Button {
            showAlert = true
        } label: {
            Image(systemName: "xmark.circle.fill")
                .scaleEffect(1.5)
                .foregroundStyle(.black, .yellow)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Quit game?"),
                message: Text("Are you sure you want to leave?"),
                primaryButton: .destructive(Text("Yes")) {

                    changeViewTo.value == .online ? (matchManager.gameOver()) : (changeViewTo.value = .offline)

                    showAlert = false
                },
                secondaryButton: .cancel()
            )
        }
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
