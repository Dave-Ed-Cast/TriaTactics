//
//  GameOver.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 25/05/24.
//

import SwiftUI

struct GameOver: View {

    @ObservedObject var gameLogic: GameLogic
    @Binding var showLottieAnimation: Bool

    var body: some View {
        ZStack {
            LottieAnimation(
                name: "Line",
                contentMode: .scaleAspectFit,
                playbackMode: .playing(.fromFrame(1, toFrame: 12, loopMode: .playOnce)),
                height: 380,
                scaleFactor: 8,
                degrees: gameLogic.degrees,
                offset: gameLogic.offsetPosition
            )

//            if showLottieAnimation {
//                LottieAnimation(
//                    name: "GameOver",
//                    contentMode: .center,
//                    playbackMode: .playing(.toProgress(1, loopMode: .playOnce)),
//                    scaleFactor: 1
//                )
//                    .background(Color.black.opacity(0.65))
//                    .cornerRadius(20)
//                    .padding()
//            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { _ in
                withAnimation {
                    showLottieAnimation = true
                }
            }
            showLottieAnimation = false
        }
    }
}

#Preview {
    GameOver(gameLogic: GameLogic.shared, showLottieAnimation: .constant(true))
}
