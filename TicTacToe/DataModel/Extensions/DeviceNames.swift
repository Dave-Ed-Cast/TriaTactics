//
//  DeviceSetKey.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/01/25.
//

import SwiftUI

extension UIDevice {
    enum Target {
        case pad
        case phone
        case mac
        case tv
        case vision
    }

    static var device: Target {
        switch UIDevice.current.localizedModel {
        case "iPhone": return .phone
        case "iPad": return .pad
        case "Mac": return .mac
        case "Tv": return .tv
        case "vision": return .vision
        default: return .phone
        }
    }
}

struct DeviceKey: EnvironmentKey {
    static let defaultValue: UIDevice.Target = UIDevice.device
}

extension EnvironmentValues {
    var device: UIDevice.Target {
        get { self[DeviceKey.self] }
        set { self[DeviceKey.self] = newValue }
    }
}
