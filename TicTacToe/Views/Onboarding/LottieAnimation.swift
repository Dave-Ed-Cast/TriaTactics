//
//  ContentView.swift
//  LottieOnBoarding
//
//  Created by Davide Castaldi on 27/04/24.
//

import SwiftUI
import Lottie

struct LottieAnimation: View {
        
    //the name of the animation
    var name: String
    
    //the content mode is for how and where we want to display it
    var contentMode: UIView.ContentMode
    
    //there are different ways we can do playback of the animation
    var playbackMode: LottiePlaybackMode
    
    //maybe after it finished something should happen?
    var didFinish: (() -> Void)? = nil
    
    //the optional parameters
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    var scaleFactor: CGFloat? = nil
    var cornerRadiusFactor: Double? = nil
    var degrees: Double? = nil
    
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
            .rotationEffect(.degrees(degrees ?? 0))
    }
}

#Preview {
    LottieAnimation(name: "Line", contentMode: .scaleAspectFit, playbackMode: .playing(.toProgress(1, loopMode: .loop)), scaleFactor: 5)
}
