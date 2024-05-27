//
//  Misc.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 22/05/24.
//

import Foundation

/// This defines the state of the authetication of the user
enum PlayerAuthState: String {
    case authenticating = "Logging in to Game Center..."
    case unauthenticated = "Sign in to Game Center to play."
    case authenticated = "Logged in!"
    case error = "Error logging into Game Center."
    case restricted = "You're can't play multiplayer games!"
}
