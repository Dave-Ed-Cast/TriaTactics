//
//  TertiaryButton.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 06/07/24.
//

import SwiftUI

struct TertiaryButton: View {

    @Environment(\.device) private var device

    let action: (() -> Void)?
    let color: Color
    let invertColor: Bool

    let size = UIScreen.main.bounds.size

    init(color: Color = .buttonTheme, invertColor: Bool = false, action: (() -> Void)? = nil) {
        self.action = action
        self.color = color
        self.invertColor = invertColor
    }

    var body: some View {
        let buttonSize = size.width / 12
        Button {
            action?()
        } label: {
            ZStack {
                Circle()
                    .foregroundStyle(color)
                    .if(invertColor) { view in
                        view.colorInvert()
                    }
                Image(systemName: "xmark")
                    .padding()
                    .foregroundStyle(.textTheme)
                    .font(device == .pad ? .title :.headline)
            }
        }
        .frame(width: buttonSize, height: buttonSize)
    }
}

#Preview {
    ZStack {
        Color.black

        VStack(spacing: 20) {
            TertiaryButton()
            TertiaryButton(color: .yellow)
        }
    }

}
