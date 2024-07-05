////
////  SetupPlayersHUD.swift
////  TicTacToe
////
////  Created by Davide Castaldi on 05/07/24.
////
//
// import SwiftUI
//
// struct SetupPlayersHUD: View {
//
//    @EnvironmentObject var matchManager: MatchManager
//    @EnvironmentObject var gameLogic: GameLogic
//    @EnvironmentObject var changeViewTo: Navigation
//
//    let screenWidth: CGFloat
//
//    var body: some View {
//        HStack(alignment: .center) {
//
//            if changeViewTo.value == .online {
//                if let imageData = matchManager.localPlayerImage, let uiImage = UIImage(data: imageData) {
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .frame(width: screenWidth * 0.1, height: screenWidth * 0.1)
//                        .padding(.vertical, 20)
//                }
//                Text("\(matchManager.currentlyPlaying ? matchManager.localPlayer.displayName : matchManager.otherPlayer?.displayName ?? "Other")'s turn")
//                    .multilineTextAlignment(.center)
//                    .frame(width: screenWidth * 0.4, height: 0)
//            } else {
//                Image("\(gameLogic.activePlayer == .X ? "X" : "O")")
//                    .resizable()
//                    .frame(width: screenWidth * 0.1, height: screenWidth * 0.1)
//
//                Text(changeViewTo.value == .offline ? (gameLogic.activePlayer == .X ? "It's your turn" : "AI's turn") : "It's your turn")
//                    .frame(width: screenWidth * 0.4, height: 0)
//            }
//        } // end of HStack
//        .foregroundStyle(.textTheme)
//        .font(.title2)
//        .padding(.vertical, 10)
//    }
// }
//
// #Preview("Offline") {
//    SetupPlayersHUD(screenWidth: UIScreen.main.bounds.width)
//        .environmentObject(MatchManager())
//        .environmentObject(GameLogic())
//        .environmentObject({
//            let navigation = Navigation.shared
//            navigation.value = .offline
//            return navigation
//        }())
// }
// #Preview("Online") {
//    SetupPlayersHUD(screenWidth: UIScreen.main.bounds.width)
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
//    SetupPlayersHUD(screenWidth: UIScreen.main.bounds.width)
//        .environmentObject(MatchManager())
//        .environmentObject(GameLogic())
//        .environmentObject({
//            let navigation = Navigation.shared
//            navigation.value = .bot
//            return navigation
//        }())
// }
