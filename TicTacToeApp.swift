//
//  TicTacToeApp.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 17/05/24.
//

import SwiftUI

enum NavigationValue {
    case main
    case play
    case online
    case offline
    case bot
    case tutorial
}
class Navigation: ObservableObject {
    static var shared = Navigation()
    @Published public var value: NavigationValue = .main
    private init() {}
}

@main
struct TicTacToeApp: App {

    @StateObject private var matchManager = MatchManager()
    @StateObject private var gameLogic = GameLogic()
    @StateObject private var navigation = Navigation.shared
    @Environment(\.colorScheme) var colorScheme

    var body: some Scene {
        WindowGroup {
            ParentView()
            .environmentObject(matchManager)
            .environmentObject(gameLogic)
            .environmentObject(navigation)
            .onAppear {
                matchManager.gameLogic = gameLogic
                gameLogic.matchManager = matchManager
            }
        }
    }
}

extension Image {
    init?(base64String: String) {
        guard let data = Data(base64Encoded: base64String) else { return nil }
        guard let uiImage = UIImage(data: data) else { return nil }
        self = Image(uiImage: uiImage)
    }
}
