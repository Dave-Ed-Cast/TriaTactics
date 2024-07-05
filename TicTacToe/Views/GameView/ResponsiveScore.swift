////
////  ResponsiveScore.swift
////  TicTacToe
////
////  Created by Davide Castaldi on 05/07/24.
////
//
// import SwiftUI
//
// struct ResponsiveScore: View {
//
//    @EnvironmentObject var changeViewTo: Navigation
//
//    let gameLogic: GameLogic
//    let matchManager: MatchManager
//    let xSize: CGFloat = UIScreen.main.bounds.width
//    let ySize: CGFloat = UIScreen.main.bounds.height
//
//    var body: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 10)
//
//                .offset(x: moveWinner(for: xSize))
//                .animation(.snappy(duration: 1), value: gameLogic.xScore)
//                .animation(.snappy(duration: 1), value: gameLogic.oScore)
//            HStack(spacing: 10) {
//                Spacer()
//                if changeViewTo.value == .offline {
//                    Image("X")
//                        .resizable()
//                        .frame(width: xSize * 0.1, height: xSize * 0.1)
//                } else {
//                    if let imageData = matchManager.localPlayerImage, let uiImage = UIImage(data: imageData) {
//                        Image(uiImage: uiImage)
//                            .resizable()
//                        frame(width: xSize * 0.1, height: xSize * 0.1)
//                    } else {
//                        Image(systemName: "person.circle")
//                            .resizable()
//                        frame(width: xSize * 0.1, height: xSize * 0.1)
//                    }
//                }
//                Text("\(gameLogic.xScore)")
//                    .fontWeight(.bold)
//                    .multilineTextAlignment(.leading)
//                Spacer()
//            }
//            .frame(width: xSize / 2)
//            .foregroundStyle(.textTheme)
//            .font(.title)
//
//        }
//        .frame(height: ySize * 0.07)
//    }
//
//    func moveWinner(for value: CGFloat) -> CGFloat {
//        let multiplyingFactor = 0.0468
//        let difference = abs(gameLogic.xScore - gameLogic.oScore)
//        if difference >= 0 && difference <= 5 {
//            return CGFloat(gameLogic.xScore - gameLogic.oScore) * value * multiplyingFactor
//        } else {
//            return CGFloat(5) * value * multiplyingFactor
//        }
//    }
// }
//
// #Preview("Offline") {
//    ResponsiveScore(gameLogic: GameLogic(), matchManager: MatchManager())
//        .environmentObject(MatchManager())
//        .environmentObject(GameLogic())
//        .environmentObject({
//            let navigation = Navigation.shared
//            navigation.value = .offline
//            return navigation
//        }())
// }
// #Preview("Online") {
//    ResponsiveScore(gameLogic: GameLogic(), matchManager: MatchManager())
//        .environmentObject(MatchManager())
//        .environmentObject(GameLogic())
//        .environmentObject({
//            let navigation = Navigation.shared
//            navigation.value = .online
//            return navigation
//        }())
// }
//
// #Preview("AI") {
//    ResponsiveScore(gameLogic: GameLogic(), matchManager: MatchManager())
//        .environmentObject(MatchManager())
//        .environmentObject(GameLogic())
//        .environmentObject({
//            let navigation = Navigation.shared
//            navigation.value = .bot
//            return navigation
//        }())
// }
