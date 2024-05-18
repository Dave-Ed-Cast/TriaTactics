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
            VStack(spacing: 105) {
                Rectangle().frame(height: 5)
                Rectangle().frame(height: 5)
            }
            .frame(width: 350, height: 100)
            
            HStack(spacing: 125) {
                Rectangle().frame(width: 5)
                Rectangle().frame(width: 5)
            }
            .frame(width: 100, height: 340)
            
            LazyVGrid(columns: col, spacing: 10) {
                ForEach(0..<9) { value in
                    Button {
                        gameLogic.buttonTap(index: value)
                    } label: {
                        TimelineView(.animation) { tl in
                            let time = start.distance(to: tl.date)
                            Image(gameLogic.buttonLabel(index: value))
                                .interpolation(.none)
                                .resizable()
                                .frame(width: 100, height: 100, alignment: .center)
                                .colorEffect(ShaderLibrary.rainbow(.float(time)))
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
