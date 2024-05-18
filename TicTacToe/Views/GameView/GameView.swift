//
//  GameView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/05/24.
//

import SwiftUI

struct GameView: View {
    
    @ObservedObject var gameLogic: GameLogic = GameLogic()
    
    var body: some View {
        VStack {
            
            Text("Tria Tactics")
                .font(.largeTitle)
                .fontWeight(.black)
                .padding(.bottom, 100)

            GameGrid()
                .padding()
                Button {
                    gameLogic.resetGame()
                } label: {
                    Text("Restart")
                        .frame(width: 200, height: 70, alignment: .center)
                        .background(.red)
                        .foregroundStyle(.white)
                        .font(.title3)
                        .fontWeight(.medium)
                        .cornerRadius(20)
                        .opacity(1)
                }
                .padding()
                .padding(.top, 50)
            
            //            Spacer()
            //            Group {
            //                Text("Tic Tac Toe")
            //                    .font(.largeTitle)
            //                    .fontWeight(.black)
            //                Text("Revisited")
            //                    .font(.callout)
            //            }
            //            .rotationEffect(.degrees(180))
            
        }
    }
}


#Preview {
    GameView()
}
