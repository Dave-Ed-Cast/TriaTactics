//
//  ContentView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 17/05/24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var ticTacToe: TicTacToe = TicTacToe()
    var body: some View {
        
        VStack {
            
            Text("Title")
                .font(.largeTitle)
                .fontWeight(.black)
            
            let col = Array(repeating: GridItem(.flexible()), count: 3)
            
            LazyVGrid(columns: col, content: {
                ForEach(0..<9) { value in
                    Button {
                        ticTacToe.buttonTap(index: value)
                    } label: {
                        Text("\(ticTacToe.buttonLabel(index: value))")
                            .frame(width: 100, height: 100, alignment: .center)
                            .background(.black)
                            .foregroundStyle(.white)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                }
            })
            .padding()
            
            Button {
                ticTacToe.resetGame()
            } label: {
                Text("Restart")
                    .frame(width: 200, height: 50, alignment: .center)
                    .background(.black)
                    .foregroundStyle(.white)
                    .font(.title3)
                    .fontWeight(.medium)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
