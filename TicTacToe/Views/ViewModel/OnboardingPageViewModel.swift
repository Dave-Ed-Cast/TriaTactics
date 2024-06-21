//
//  Onboarding.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/05/24.
//

import SwiftUI

struct OnboardingPageViewModel: View {
    
    @Binding var onboardingIsCompleted: Bool
    
    var onboardingTitle: LocalizedStringKey
    var onboardingImage: String
    var onboardingText: LocalizedStringKey
    var showDoneButton: Bool = false
    var animationSize: CGFloat = 350
    var scaleFactor: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            LottieAnimation(name: onboardingImage, contentMode: .scaleAspectFit, playbackMode: onboardingImage != "Done" ? (.playing(.toProgress(1, loopMode: .loop))) : (.playing(.fromFrame(87, toFrame: 140, loopMode: .autoReverse))), width: animationSize, height: animationSize, scaleFactor: scaleFactor)
            
            Text(onboardingTitle)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(onboardingText)
                .font(.body)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            Spacer()
            
        }
        .padding()
        .overlay(alignment: .bottom, content: {
            
            if showDoneButton {
                Button {
                    withAnimation {
                        onboardingIsCompleted = true
                    }
                } label: {
                    Text("Let's start!")
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                        .font(.body)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.yellow)
                        )
                }
            }
        })
        .padding(.bottom, 50)
    }
}

#Preview("English") {
    OnboardingPageViewModel(
        onboardingIsCompleted: .constant(false),
        onboardingTitle: "Multiplayer is finally here!",
        onboardingImage: "Done",
        onboardingText: "Here comes the multiplayer! Challenge your friends in a strategic battle. Log into Game Center and enjoy!",
        showDoneButton: false
    )
    .environment(\.locale, Locale(identifier: "EN"))
}

#Preview("Italian") {
    OnboardingPageViewModel(
        onboardingIsCompleted: .constant(false),
        onboardingTitle: "Multiplayer is finally here!",
        onboardingImage: "Done",
        onboardingText: "Here comes the multiplayer! Challenge your friends in a strategic battle. Log into Game Center and enjoy!",
        showDoneButton: true
    )
    .environment(\.locale, Locale(identifier: "IT"))
}
