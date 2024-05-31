//
//  GameView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/05/24.
//

import SwiftUI

struct GameView: View {
    
    @ObservedObject var matchManager: MatchManager = MatchManager()
    @ObservedObject var gameLogic: GameLogic = GameLogic()
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var isOffline: Bool
    
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            
        }
        .overlay(alignment: .topTrailing) {
            if !isOffline {
                backToMenuView
                    .padding()
                    .padding(.top, 20)
            }
        }
        Group {
            VStack {
                Text("Tria Tactics")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .padding()
                Text("Time left: \(isOffline ? 0 : matchManager.remainingTime)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .opacity(isOffline ? 0 : 1)
                    .padding()
                Spacer()
                HStack {
                    if isOffline {
                        Text("Your turn: \(gameLogic.activePlayer == .X ? "X" : "O")")
                            .font(.title3)
                            .fontWeight(.bold)
                    } else {
                        Text("\(matchManager.currentlyPlaying ? matchManager.localPlayer.displayName : matchManager.otherPlayer!.displayName) turn")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(matchManager.currentlyPlaying ? .blue : .red)
                    }
                        
                }
                .padding(.bottom, 60)
                .overlay(
                    winnerView
                        .offset(y: 20)
                )
            }
            .foregroundStyle(.black)
            
            scoreView
            
            GameGrid(matchManager: matchManager, gameLogic: gameLogic)
                .padding()
            
            buttonView
            
        }
        .onAppear {
            gameLogic.resetGame()
            gameLogic.isOffline = isOffline
        }
        .onDisappear {
            matchManager.gameOver()
        }
    }
    
    var winnerView: some View {
        Group {
            if let winner = gameLogic.winner {
                if isOffline {
                    Text("\(winner.rawValue) wins!")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                } else {
                    if matchManager.localPlayerWin {
                        Text("You Win!")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 20)
                    } else {
                        Text("You Lose!")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 20)
                    }
                }
            }
        }
    }
    var scoreView: some View {
        HStack(spacing: 80) {
            if !isOffline {
                Text("Your wins: \(matchManager.otherPlayerScore)")
                Text("Opponent wins: \(matchManager.localPlayerScore)")
            }
        }
        .font(.callout)
    }
    var buttonView: some View {
        Button {
            if isOffline {
                if gameLogic.checkWinner() {
                    gameLogic.resetGame()
                }
            } else {
                if gameLogic.checkWinner() {
                    withAnimation {
                        gameLogic.resetGame()
                        matchManager.resetGame()
                    }
                }
            }
        } label: {
            Text("Restart?")
                .fontWeight(.medium)
                .frame(width: 200, height: 70, alignment: .center)
                .background(.yellow)
                .foregroundStyle(.black)
                .font(.title3)
                .cornerRadius(20)
        }
        .opacity(gameLogic.checkWinner() ? 1 : 0.5)
        .disabled(!gameLogic.checkWinner())
        .padding()
    }
    var backToMenuView: some View {
            Button(action: {
                showAlert = true
            }) {
                ZStack {
                    Circle()
                        .scaledToFit()
                        .foregroundColor(.yellow)
                    Text("X")
                        .font(.callout)
                        .foregroundColor(.black)
                        .background(
                            Circle()
                                .fill(Color.yellow)
                                .scaleEffect(CGSize(width: 3.0, height: 3.0))
                        )
                }
                .padding(.horizontal, 10)
                
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Quit game?"),
                    message: Text("Are you sure you want to leave?"),
                    primaryButton: .destructive(Text("Yes")) {
                        matchManager.gameOver()
                        showAlert = false
                    },
                    secondaryButton: .cancel()
                )
            }
        }
}


#Preview {
    //setting offline = false crashes the preview due to Text(match manager)
    GameView(matchManager: MatchManager(), isOffline: .constant(true))
}
