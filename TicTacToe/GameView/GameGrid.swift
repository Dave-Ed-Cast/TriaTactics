//
//  Grid.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/05/24.
//

import SwiftUI

struct GameGrid: View {
    
    @ObservedObject var gameLogic: GameLogic = GameLogic()

    let col = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        LazyVGrid(columns: col, content: {
            ForEach(0..<9) { value in
                Button {
                    gameLogic.buttonTap(index: value)
                } label: {
                    Text("\(gameLogic.buttonLabel(index: value))")
                        .frame(width: 100, height: 100, alignment: .center)
                        .background(.black)
                        .foregroundStyle(.white)
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
        })
    }
}

#Preview {
    GameGrid()
}
