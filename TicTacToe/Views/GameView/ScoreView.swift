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

    var body: some View {
        GeometryReader { geometry in
            HStack {
                ZStack {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .offset(x: moveWinner())
                                .animation(.easeOut(duration: 1), value: gameLogic.xScore)
                                .animation(.easeOut(duration: 1), value: gameLogic.oScore)
                            HStack(spacing: 10) {

                                if changeViewTo.value == .offline {
                                    Image("X")
                                        .resizable()
                                        .frame(maxWidth: 50, maxHeight: 50)
                                } else {
                                    if let imageData = matchManager.localPlayerImage, let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .frame(maxWidth: 50, maxHeight: 50)
                                    } else {
                                        Image(systemName: "person.circle")
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                    }
                                }
                                Text("\(gameLogic.xScore)")
                                    .fontWeight(.bold)
                            }
                            .frame(width: geometry.size.width / 2)
                            .foregroundStyle(.textTheme)
                            .font(.title)
                        }

                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .offset(x: moveWinner())
                                .animation(.easeOut(duration: 1), value: gameLogic.xScore)
                                .animation(.easeOut(duration: 1), value: gameLogic.oScore)
                            HStack(spacing: 10) {

                                Text("\(gameLogic.oScore)")
                                    .fontWeight(.bold)

                                if changeViewTo.value == .offline {
                                    Image("O")
                                        .resizable()
                                        .frame(maxWidth: 50, maxHeight: 50)
                                } else {
                                    if let imageData = matchManager.otherPlayerImage, let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .frame(maxWidth: 50, maxHeight: 50)
                                    } else {

                                        Image(systemName: "person.circle")
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                    }
                                }
                            }
                            .frame(width: geometry.size.width / 2)
                            .foregroundStyle(.textTheme)
                            .font(.title)
                        }
                    }
                    .frame(width: geometry.size.width * 1.5, height: 70)
                }
                .foregroundStyle(.backgroundTheme)
                .frame(width: geometry.size.width / 1.5, height: 70)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .edgesIgnoringSafeArea(.all)
    }

    func moveWinner() -> CGFloat {
        return CGFloat(gameLogic.xScore - gameLogic.oScore) * 20
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
