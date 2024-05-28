//
//  GameView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/05/24.
//

import SwiftUI

var countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

struct GameView: View {
    
    @ObservedObject var matchManager: MatchManager
    @ObservedObject var gameLogic: GameLogic = GameLogic()
    
    @Binding var isOffline: Bool
    
    var body: some View {
        
        Group {
            VStack {
                
                Text("Tria Tactics")
                    .font(.largeTitle)
                    .fontWeight(.black)
                Text("Time left: \(isOffline ? 0 : matchManager.remainingTime)")
                    .font(.title)
                    .fontWeight(.semibold)
                    .opacity(isOffline ? 0 : 1)
                HStack {
                    if isOffline {
                        Text("Your turn: \(gameLogic.activePlayer == .X ? "X" : "O")")
                            .font(.title2)
                            .fontWeight(.bold)
                    } else {
                        Text("\(matchManager.currentlyPlaying ? "Your Turn" : "Opponent's Turn")")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(matchManager.currentlyPlaying ? .blue : .red)
                    }
                }
                .padding()
                .padding(.bottom, 60)
                .overlay(
                    winnerView
                        .offset(y: 30)
                )
            }
            .foregroundStyle(.black)
            
            GameGrid(matchManager: matchManager, gameLogic: gameLogic)
                .padding()
            
            buttonView
            
        }
        .onAppear {
            gameLogic.resetGame()
            gameLogic.isOffline = isOffline
        }
        .onReceive(countdownTimer) { _ in
            guard matchManager.isTimeKeeper else { return }
            matchManager.remainingTime -= 1
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
                        Text("You Lose!")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 20)
                    } else {
                        Text("You Win!")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 20)
                    }
                }
            }
        }
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
                        matchManager.gameOver()
                        matchManager.resetGame()
                    }
                }
            }
        } label: {
            Text(isOffline ? "Restart" : "Finish")
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
}


#Preview {
    GameView(matchManager: MatchManager(), isOffline: .constant(true))
}
