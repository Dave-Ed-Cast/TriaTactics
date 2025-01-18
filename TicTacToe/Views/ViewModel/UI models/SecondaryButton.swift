//
//  SecondaryButton.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 20/06/24.
//

import SwiftUI

struct SecondaryButton: View {

    let label: LocalizedStringKey
    let action: (() -> Void)?
    let color: Color
    let invertColor: Bool
    let animation: Bool

    let device = UIDevice.current.userInterfaceIdiom
    let size = UIScreen.main.bounds.size

    init(_ label: LocalizedStringKey, color: Color = .buttonTheme.opacity(0.8), invertColor: Bool = false, animation: Bool = true, action: (() -> Void)? = nil) {
        self.label = label
        self.action = action
        self.color = color
        self.invertColor = invertColor
        self.animation = animation
    }

    var body: some View {

        let buttonWidth = size.width * 0.3
        let buttonHeight = size.height * 0.05

        Button {
            if animation {
                withAnimation {
                    action?()
                }
            } else {
                action?()
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(color)
                    .if(invertColor) { view in
                        view.colorInvert()
                    }
                Text(label)
                    .fontWeight(.light)
                    .padding()
                    .foregroundStyle(.textTheme)
                    .font(device == .pad ? .title : .title3)
            }
        }
        .frame(width: buttonWidth, height: buttonHeight)
    }
}

#Preview {
    //    ZStack {
    //        VStack {
    ////                        PrimaryButton(label: "TEST AAAA")
    //            //            PrimaryButton(label: "TEST BBBB")
    //                        SecondaryButton(label: "TEST AAAA")
    //                        SecondaryButton(label: "TEST BBBB", color: .red)
    //        }
    //    }
    PreviewWrapper {
        MainView(namespace: Namespace().wrappedValue)
            .environmentObject(AnimationTap())
    }
}
