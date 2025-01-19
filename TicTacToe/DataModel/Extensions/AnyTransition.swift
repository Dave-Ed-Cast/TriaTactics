//
//  Transition.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 19/01/25.
//

import SwiftUI

extension AnyTransition {
    static func customPush(cfrom edge: Edge) -> AnyTransition {
        if #available(iOS 16.0, *) {
            return .push(from: edge)
        } else {
            return .modifier(
                active: PushTransition(isActive: true, direction: edge),
                identity: PushTransition(isActive: false, direction: edge)
            )
        }
    }
}
