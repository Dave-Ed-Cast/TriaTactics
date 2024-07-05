//
//  TopHUD.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 05/07/24.
//
//
// import SwiftUI
//
// struct TopHUD: View {
//
//    @EnvironmentObject var matchManager: MatchManager
//    @EnvironmentObject var gameLogic: GameLogic
//    @EnvironmentObject var changeViewTo: Navigation
//
//    @Environment(\.colorScheme) var colorScheme
//
//    @State private var showAlert = false
//    @State private var showWinnerOverlay = false
//    var body: some View {
//        ZStack {
//            GeometryReader { geometry in
//                let xSize = geometry.size.width
//                let ySize = geometry.size.height
//
//                Rectangle()
//                    .foregroundStyle(.backgroundTheme.opacity(0.6))
//                    .ignoresSafeArea()
//
//                HStack(alignment: .center) {
//
//                    if changeViewTo.value == .offline {
//                        Image("\(gameLogic.activePlayer == .X ? "X" : "O")")
//                            .resizable()
//                            .frame(width: xSize * 0.1, height: xSize * 0.1)
//                            .padding(.vertical, 20)
//                        Text("It's your turn")
//                            .frame(width: xSize * 0.4, height: 0)
//                    } else if changeViewTo.value == .online {
//                        if let imageData = matchManager.localPlayerImage, let uiImage = UIImage(data: imageData) {
//                            Image(uiImage: uiImage)
//                                .resizable()
//                                .frame(width: xSize * 0.1, height: xSize * 0.1)
//                                .padding(.vertical, 20)
//                            Text("\(matchManager.currentlyPlaying ? matchManager.localPlayer.displayName : matchManager.otherPlayer?.displayName ?? "Other")'s turn")
//                                .multilineTextAlignment(.center)
//                                .frame(width: xSize * 0.4, height: 0)
//                        }
//                    } else if changeViewTo.value == .bot {
//                        Image("\(gameLogic.activePlayer == .X ? "X" : "O")")
//                            .resizable()
//                            .frame(width: xSize * 0.1, height: xSize * 0.1)
//                            .padding(.vertical, 10)
//                        Text(gameLogic.activePlayer == .X ? "It's your turn" : "AI's turn")
//                            .frame(width: xSize * 0.4, height: 0)
//                    }
//                } // end of HStack
//                .foregroundStyle(.textTheme)
//                .font(.title2)
//                .frame(maxWidth: xSize * 2)
//                .ignoresSafeArea()
//            }
////            .frame(height: ySize * 0.05)
//
//        }
//
//    }
// }
//
// #Preview("Offline") {
//    TopHUD()
//        .environmentObject(MatchManager())
//        .environmentObject(GameLogic())
//        .environmentObject({
//            let navigation = Navigation.shared
//            navigation.value = .offline
//            return navigation
//        }())
// }
// #Preview("Online") {
//    TopHUD()
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
//    TopHUD()
//        .environmentObject(MatchManager())
//        .environmentObject(GameLogic())
//        .environmentObject({
//            let navigation = Navigation.shared
//            navigation.value = .bot
//            return navigation
//        }())
// }

import SwiftUI

struct TopHUD: View {

    @EnvironmentObject var matchManager: MatchManager
    @EnvironmentObject var gameLogic: GameLogic
    @EnvironmentObject var changeViewTo: Navigation

    @Environment(\.colorScheme) var colorScheme

    @State private var showAlert = false
    @State private var showWinnerOverlay = false

    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width

            VStack {
                ZStack {
                    Rectangle()
                        .foregroundStyle(.backgroundTheme.opacity(0.6))
                        .ignoresSafeArea()

                    SetupPlayersHUD(screenWidth: screenWidth)
                }
                .frame(height: geometry.size.height * 0.2)
                .padding(.vertical, 70)
            }
            .ignoresSafeArea()

        }
        .frame(height: 0)
    }
}

#Preview("Offline") {
    TopHUD()
        .environmentObject(MatchManager())
        .environmentObject(GameLogic())
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .offline
            return navigation
        }())
}
#Preview("Online") {
    TopHUD()
        .environmentObject(MatchManager())
        .environmentObject(GameLogic())
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .online
            return navigation
        }())
}

#Preview("AI") {
    TopHUD()
        .environmentObject(MatchManager())
        .environmentObject(GameLogic())
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .bot
            return navigation
        }())
}

// if changeViewTo.value == .offline {
//    Image("\(gameLogic.activePlayer == .X ? "X" : "O")")
//        .resizable()
//        .frame(width: screenWidth * 0.1, height: screenWidth * 0.1)
//    Text("It's your turn")
//        .frame(width: screenWidth * 0.4, height: 0)
// } else if changeViewTo.value == .online {
//    if let imageData = matchManager.localPlayerImage, let uiImage = UIImage(data: imageData) {
//        Image(uiImage: uiImage)
//            .resizable()
//            .frame(width: screenWidth * 0.1, height: screenWidth * 0.1)
//            .padding(.vertical, 20)
//        Text("\(matchManager.currentlyPlaying ? matchManager.localPlayer.displayName : matchManager.otherPlayer?.displayName ?? "Other")'s turn")
//            .multilineTextAlignment(.center)
//            .frame(width: screenWidth * 0.4, height: 0)
//    }
// } else if changeViewTo.value == .bot {
//    Image("\(gameLogic.activePlayer == .X ? "X" : "O")")
//        .resizable()
//        .frame(width: screenWidth * 0.1, height: screenWidth * 0.1)
//        .padding(.vertical, 10)
//    Text(gameLogic.activePlayer == .X ? "It's your turn" : "AI's turn")
//        .frame(width: screenWidth * 0.4, height: 0)
//    }
