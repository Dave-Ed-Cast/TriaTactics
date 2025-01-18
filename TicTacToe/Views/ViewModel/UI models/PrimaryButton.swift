//
//  PrimaryButton.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 20/06/24.
//

import SwiftUI

struct PrimaryButton: View {
    let label: LocalizedStringKey
    let subtitle: LocalizedStringKey?
    let action: (() -> Void)?
    let color: Color
    let invertColor: Bool
    let animation: Bool

    let device = UIDevice.current.userInterfaceIdiom
    let size = UIScreen.main.bounds.size

    init(_ label: LocalizedStringKey, subtitle: LocalizedStringKey? = nil, color: Color = .buttonTheme.opacity(0.8), invertColor: Bool = false, animation: Bool = true, action: (() -> Void)? = nil) {
        self.label = label
        self.subtitle = subtitle
        self.action = action
        self.color = color
        self.invertColor = invertColor
        self.animation = animation
    }

    var body: some View {
        VStack(alignment: .center) {
            let buttonWidth = size.width * 0.5
            let buttonHeight = size.height * 0.1
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
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(color)
                        .if(invertColor) { $0.colorInvert() }
                    VStack {
                        Text(label)
                            .fontWeight(.bold)
                            .font(device == .pad ? .largeTitle : .title)
                        if let subtitle = subtitle {
                            Text("(\(subtitle))")
                                .fontWeight(.light)
                                .font(device == .pad ? .title2 : .callout)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .foregroundStyle(.textTheme)
                    .padding()

                }
            }
            .frame(width: buttonWidth, height: buttonHeight)
        }
    }
}

#Preview {

    //    VStack(spacing: 30) {
    //        PrimaryButton(label: "orland shbienen", subtitle: "ciao", action: {})
    //        //            PrimaryButton(label: "TEST BBBB", action: {}, color: .red)
    //        //            PrimaryButton(label: "TEST CCCC", action: {}, color: .red, invertColor: true)
    //
    //    }

    PreviewWrapper {
        MainView(namespace: Namespace().wrappedValue)
            .environmentObject(AnimationTap())
    }
}
