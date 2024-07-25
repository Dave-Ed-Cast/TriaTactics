//
//  ContentView.swift
//  LottieOnBoarding
//
//  Created by Davide Castaldi on 27/04/24.
//

import SwiftUI
import Lottie

struct LottieAnimation: View {

    // the name of the animation
    var name: String

    // the content mode is for how and where we want to display it
    var contentMode: UIView.ContentMode

    // there are different ways we can do playback of the animation
    var playbackMode: LottiePlaybackMode

    // maybe after it finished something should happen?
    var didFinish: (() -> Void)?

    // the optional parameters
    var width: CGFloat?
    var height: CGFloat?
    var scaleFactor: CGFloat?
    var cornerRadiusFactor: Double?
    var degrees: Double?
    var offset: CGSize?

    var body: some View {
        Group {
            LottieView(animation: .named(name))
                .configure({ configuration in
                    configuration.contentMode = contentMode
                })
                .playbackMode(playbackMode)
                .animationDidFinish({ _ in
                    didFinish?()
                })
        }
        .frame(width: width, height: height)
        .scaleEffect(scaleFactor ?? 1)
        .cornerRadius(cornerRadiusFactor ?? 0)
        .rotationEffect(.degrees(degrees ?? 0))
        .offset(offset ?? CGSize.zero)

    }
}

#Preview {
    LottieAnimation(name: "Sparkle", contentMode: .scaleAspectFit, playbackMode: .playing(.toProgress(1, loopMode: .loop)), scaleFactor: 2)
        .background {
            BackgroundView(savedValueForAnimation: .constant(true))
        }
}
