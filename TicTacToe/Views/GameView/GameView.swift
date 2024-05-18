//
//  GameView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/05/24.
//

import SwiftUI

struct GameView: View {
    
    @ObservedObject var gameLogic: GameLogic = GameLogic()
    @State private var start: Date = Date.now
    
    var body: some View {
        VStack {
            
            Text("Tic Tac Toe")
                .font(.largeTitle)
                .fontWeight(.black)
            Text("Revisited")
                .font(.callout)
            
            GameGrid()
                .padding()
            
            
            Button {
                gameLogic.resetGame()
            } label: {
                Text("Restart")
                    .frame(width: 200, height: 70, alignment: .center)
                    .background(.black)
                    .foregroundStyle(.white)
                    .font(.title3)
                    .fontWeight(.medium)
                    .cornerRadius(20)
                
            }
            .padding()
            
            
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
