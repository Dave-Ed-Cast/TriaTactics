//
//  Grid.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/05/24.
//

import SwiftUI

struct GameGrid: View {
    
    @ObservedObject var matchManager: MatchManager
    @ObservedObject var gameLogic: GameLogic
    
    let col = Array(repeating: GridItem(.flexible()), count: 3)
    
    @State private var showLottieAnimation = false
    
    var body: some View {
        ZStack {
            BackgroundGridViewModel()
            
            VStack(spacing: 35) {
                ForEach(0..<3) { row in
                    HStack(spacing: 40) {
                        ForEach(0..<3) { col in
                            let index = row * 3 + col
                            Button {
                                gameLogic.buttonTap(index: index)
                            } label: {
                                Image(gameLogic.buttonLabel(index: index))
                                    .interpolation(.none)
                                    .resizable()
                                    .frame(width: 80, height: 80)
                            }
                        }
                    }
                }
            }
            
            if gameLogic.isGameOver ?? false {
                GameOver(gameLogic: gameLogic, showLottieAnimation: $showLottieAnimation)
            }
        }
    }
}

#Preview {
    GameGrid(matchManager: MatchManager(), gameLogic: GameLogic())
}
