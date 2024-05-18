//
//  ContentView.swift
//  LottieOnBoarding
//
//  Created by Davide Castaldi on 27/04/24.
//

import SwiftUI
import Lottie

struct LottieAnimation: View {
    
    //understing which modifers are useful was very tedious and hard, but they should be everything that one would need. And now let's explain what is important.
    
    //DA NAME
    var name: String
    
    //the content mode is for how and where we want to display it
    var contentMode: UIView.ContentMode
    
    //there are A LOT of ways we can do playback of the animation...
    var playbackMode: LottiePlaybackMode
    
    //maybe after it finished something should happen?
    var didFinish: (() -> Void)? = nil
    
    //the modifiers (well technically everything is a modifer here..)
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    var scaleFactor: CGFloat? = nil
    var cornerRadiusFactor: Double? = nil
    
    var body: some View {
        LottieView(animation: .named(name))
            .configure({ configuration in
                configuration.contentMode = contentMode
            })
            .playbackMode(playbackMode)
            .animationDidFinish({ completed in
                didFinish?()
            })
            .frame(width: width, height: height)
            .scaleEffect(scaleFactor ?? 1)
            .cornerRadius(cornerRadiusFactor ?? 0)
    }
}

#Preview {
    LottieAnimation(name: "Map", contentMode: .center, playbackMode: .playing(.fromFrame(1, toFrame: 269, loopMode: .playOnce)), width: 300, height: 300, scaleFactor: 1, cornerRadiusFactor: 40)
}
