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
                    .padding()
                Text("Time left: \(isOffline ? 0 : matchManager.remainingTime)")
                    .font(.title)
                    .fontWeight(.semibold)
                    .opacity(isOffline ? 0 : 1)
                HStack {
                    
                    Text("Your turn: ")
                        .font(.title)
                        .fontWeight(.semibold)
                    Text("\(isOffline ? (gameLogic.activePlayer == .X ? "X" : "O") : matchManager.playerUUIDKey) ")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .padding()
                .padding(.bottom, 50)
            }
            .foregroundStyle(.black)
            
            GameGrid(matchManager: matchManager, gameLogic: gameLogic)
                .padding()
            
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
                    .frame(width: 200, height: 70, alignment: .center)
                    .background(.yellow)
                    .foregroundStyle(.black)
                    .font(.title3)
                    .fontWeight(.medium)
                    .cornerRadius(20)
            }
            .opacity(gameLogic.checkWinner() ? 1 : 0.5)
            .disabled(!gameLogic.checkWinner())
            .padding()
            
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
}


#Preview {
    GameView(matchManager: MatchManager(), isOffline: .constant(true))
}
