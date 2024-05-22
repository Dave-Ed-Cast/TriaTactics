//
//  Misc.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 22/05/24.
//

import Foundation

/// This defines the state of the authetication
enum PlayerAuthState: String {
    case authenticating = "Logging in to Game Center..."
    case unauthenticated = "Please sign in to Game Center to play."
    case authenticated = "Logged in!"
    case error = "There was an error logging into Game Center."
    case restricted = "You're not allowed to play multiplayer games!"
}
