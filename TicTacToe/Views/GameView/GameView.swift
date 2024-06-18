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
    
    @Binding var isOffline: Bool
    
    @State private var showAlert = false
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 25) {
                Spacer()
                VStack(spacing: 5) {
                    Text("Tria Tactics")
                        .font(.largeTitle)
                        .fontWeight(.black)
                    Text("Time left: \(matchManager.remainingTime)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .opacity(isOffline ? 0 : 1)
                }
                
                HStack {
                    if isOffline {
                        Text("Your turn: \(gameLogic.activePlayer == .X ? "X" : "O")")
                            .font(.headline)
                            .fontWeight(.bold)
                    } else {
                        Text("\(matchManager.currentlyPlaying ? matchManager.localPlayer.displayName : matchManager.otherPlayer!.displayName) turn")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(matchManager.currentlyPlaying ? .blue : .red)
                    }
                }
                
                
                VStack(spacing: 10) {
                    winnerView
                    Spacer()
                    scoreView
                    GameGrid(gameLogic: gameLogic)
                        .frame(maxWidth: 360)
                    buttonView
                }
                
                
            }
            .foregroundStyle(.black)
            .onAppear {
                gameLogic.resetGame()
                gameLogic.isOffline = isOffline
            }
            .onDisappear {
                matchManager.gameOver()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !isOffline {
                    backToMenuView
                }
            }
        }
    }
    
    var winnerView: some View {
        Group {
            if let winner = gameLogic.winner {
                if isOffline {
                    Text("\(winner.rawValue) wins!")
                        .fontWeight(.bold)
                } else if matchManager.localPlayerWin {
                    Text("You win!")
                        .fontWeight(.bold)
                } else {
                    Text("You lose!")
                        .fontWeight(.bold)
                }
            } else {
                Text("")
            }
        }
        .opacity(gameLogic.checkWinner() ? 1 : 0)
        .font(.title)
        
    }
    
    var scoreView: some View {
        HStack(spacing: 80) {
            if !isOffline {
                Text("Your wins: \(matchManager.localPlayerScore)")
                Text("Opponent wins: \(matchManager.otherPlayerScore)")
            } else {
                Text("")
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
                        matchManager.sendRematchRequest()
                    }
                }
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
        Button(action: {
            showAlert = true
        }) {
            Text("X")
                .foregroundStyle(.black)
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
                .background(
                    Circle()
                        .foregroundStyle(.yellow)
                )
            
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
