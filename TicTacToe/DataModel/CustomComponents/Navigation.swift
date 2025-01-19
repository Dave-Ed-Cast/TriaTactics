//
//  NavigationValue.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/01/25.
//

import SwiftUI

enum NavigationValue {
    case main
    case play
    case online
    case offline
    case bot
    case tutorial
    case collaborators
}

class Navigation: ObservableObject {
    static var shared = Navigation()
    @Published public var value: NavigationValue = .main
    private init() {}
}
