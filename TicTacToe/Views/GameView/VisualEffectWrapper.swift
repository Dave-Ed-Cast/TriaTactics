//
//  VisualEffectWrapper.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/07/24.
//

import SwiftUI

struct VisualEffectWrapper: ViewModifier {
    var time: TimeInterval

    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .visualEffect { content, geometryProxy in
                    content.colorEffect(
                        ShaderLibrary.finalRainbow(
                            .float2(geometryProxy.size),
                            .float(time)
                        )
                    )
                }
        } else {
            content
        }
    }
}

extension View {
    @ViewBuilder
    func rainbowEffect(time: TimeInterval) -> some View {
        if #available(iOS 17.0, *) {
            self.modifier(VisualEffectWrapper(time: time))
        } else {
            self
        }
    }
}

struct SampleView: View {
    var time: TimeInterval = 0.0

    var body: some View {
        Text("Rainbow Effect!")
            .font(.largeTitle)
            .padding()
            .rainbowEffect(time: time)
    }
}

struct VisualEffectWrapper_Previews: PreviewProvider {
    static var previews: some View {
        SampleView(time: 0.0)
            .previewLayout(.sizeThatFits)
            .background(Color.clear)
    }
}

#Preview("Offline") {
    GameView()
        .environmentObject(MatchManager.shared)
        .environmentObject(GameLogic.shared)
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .offline
            return navigation
        }())
}
