//
//  Grid.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/05/24.
//

import SwiftUI
import MetalKit

struct GameGrid: View {
    
    @ObservedObject var gameLogic: GameLogic = GameLogic()
    
    let col = Array(repeating: GridItem(.flexible()), count: 3)
    
    @State private var start: Date = Date.now
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 350, height: 350)
                .foregroundStyle(.yellow)
            VStack(spacing: 105) {
                Rectangle()
                    .frame(height: 5)
                Rectangle()
                    .frame(height: 5)
            }
            .frame(width: 350, height: 100)
            
            HStack(spacing: 125) {
                Rectangle()
                    .frame(width: 5)
                Rectangle()
                    .frame(width: 5)
            }
            .frame(width: 100, height: 340)
            
            VStack(spacing: 30) { 
                            ForEach(0..<3) { row in
                                HStack(spacing: 40) { // Horizontal spacing between images in a row
                                    ForEach(0..<3) { col in
                                        let index = row * 3 + col
                                        Button {
                                            gameLogic.buttonTap(index: index)
                                        } label: {
                                            TimelineView(.animation) { tl in
                                                let time = start.distance(to: tl.date)
                                                Image(gameLogic.buttonLabel(index: index))
                                                    .interpolation(.none)
                                                    .resizable()
                                                    .frame(width: 80, height: 80) // Adjust size as needed
                                                    .colorEffect(ShaderLibrary.rainbow(.float(time)))
                                            }
                                        }
                                    }
                                }
                            }
                        }
            
            if gameLogic.isGameOver ?? false {
                LottieAnimation(name: "GameOver", contentMode: .center, playbackMode: .playing(.toProgress(1, loopMode: .playOnce)))
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(20)
                    .padding()
            }
        }
        
    }
}

#Preview {
    GameGrid()
}
