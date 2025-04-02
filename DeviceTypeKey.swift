//
//  DeviceTypeKey.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/01/25.
//

import SwiftUI

struct DeviceTypeKey: EnvironmentKey {
    static let defaultValue: UiDe = .unspecified
}
UIDevice.current.localizedModel

extension EnvironmentValues {
    var device: UIUserInterfaceIdiom {
        get { self[DeviceTypeKey.self] }
        set { self[DeviceTypeKey.self] = newValue }
    }
}
