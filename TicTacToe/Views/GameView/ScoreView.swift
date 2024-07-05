//
//  ScoreView.swift
//  TicTacToe
//    
//  Created by Davide Castaldi on 03/07/24.
//

import SwiftUI

struct ScoreView: View {
    @EnvironmentObject var changeViewTo: Navigation
    @EnvironmentObject var matchManager: MatchManager
    @EnvironmentObject var gameLogic: GameLogic

    let xSize = UIScreen.main.bounds.width
    let ySize = UIScreen.main.bounds.height

    var body: some View {
        VStack(spacing: 20) {
            Text("Score")
                .fontWeight(.semibold)
                .font(.title3)
                .foregroundStyle(.textTheme)
        HStack {
            ZStack {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .offset(x: moveWinner(for: xSize))
                            .animation(.snappy(duration: 1), value: gameLogic.xScore)
                            .animation(.snappy(duration: 1), value: gameLogic.oScore)
                        HStack(spacing: 10) {
                            Spacer()

                            if changeViewTo.value == .offline || changeViewTo.value == .bot {
                                Image("X")
                                    .resizable()
                                    .frame(width: xSize * 0.1, height: xSize * 0.1)
                            } else {
                                if let imageData = matchManager.localPlayerImage, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .frame(width: xSize * 0.1, height: xSize * 0.1)
                                } else {

                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .frame(width: xSize * 0.1, height: xSize * 0.1)
                                }
                            }
                            Text("\(gameLogic.xScore)")
                                .fontWeight(.bold)
                                .multilineTextAlignment(.trailing)
                            Spacer()
                        }
                        .frame(width: xSize / 3.3)
                        .foregroundStyle(.textTheme)
                        .font(.title)
                    }
                    .frame(height: ySize * 0.09)

                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .offset(x: moveWinner(for: xSize))
                            .animation(.snappy(duration: 1), value: gameLogic.xScore)
                            .animation(.snappy(duration: 1), value: gameLogic.oScore)
                        HStack(spacing: 10) {
                            Spacer()
                            Text("\(gameLogic.oScore)")
                                .fontWeight(.bold)
                                .multilineTextAlignment(.trailing)

                            if changeViewTo.value == .offline || changeViewTo.value == .bot {
                                Image("O")
                                    .resizable()
                                    .frame(width: xSize * 0.1, height: xSize * 0.1)
                            } else {
                                if let imageData = matchManager.otherPlayerImage, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .frame(width: xSize * 0.1, height: xSize * 0.1)
                                } else {

                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .frame(width: xSize * 0.1, height: xSize * 0.1)
                                }
                            }
                            Spacer()
                        }
                        .frame(width: xSize / 3.3)
                        .foregroundStyle(.textTheme)
                        .font(.title)
                    }
                    .frame(height: ySize * 0.09)
                }
                .frame(width: xSize * 1.5)
            }
            .foregroundStyle(.backgroundTheme)
            .frame(width: xSize / 1.5)
        }

        .edgesIgnoringSafeArea(.all)
    }
}

    func moveWinner(for value: CGFloat) -> CGFloat {
        let multiplyingFactor = 0.0468
        let difference = abs(gameLogic.xScore - gameLogic.oScore)
        if difference >= 0 && difference <= 5 {
            return CGFloat(gameLogic.xScore - gameLogic.oScore) * value * multiplyingFactor
        } else {
            return CGFloat(5) * value * multiplyingFactor
        }
    }
}

#Preview("Offline") {
    ScoreView()
        .environmentObject(MatchManager())
        .environmentObject(GameLogic())
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .offline
            return navigation
        }())
}
#Preview("Online") {
    ScoreView()
        .environmentObject(MatchManager())
        .environmentObject(GameLogic())
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .online
            return navigation
        }())
}

#Preview("Game") {
    GameView()
        .environmentObject(MatchManager())
        .environmentObject(GameLogic())
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .offline
            return navigation
        }())
}
