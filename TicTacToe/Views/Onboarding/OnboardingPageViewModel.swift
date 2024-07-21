//
//  Onboarding.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/05/24.
//

import SwiftUI

struct OnboardingPageViewModel: View {

    @Binding var onboardingIsCompleted: Bool

    @Environment(\.colorScheme) var colorScheme

    var onboardingTitle: LocalizedStringKey
    var onboardingImage: String
    var onboardingText: LocalizedStringKey
    var showDoneButton: Bool = false
    var animationSize: CGFloat = 350
    var scaleFactor: CGFloat = 1.0

    var body: some View {
        VStack(spacing: 50) {
            //            Spacer()
            Group {
                LottieAnimation(
                    name: onboardingImage,
                    contentMode: .scaleAspectFit,
                    playbackMode: onboardingImage != "Done" ? (.playing(.toProgress(1, loopMode: .loop))) : (.playing(.fromFrame(87, toFrame: 140, loopMode: .autoReverse))),
                    width: animationSize,
                    height: animationSize,
                    scaleFactor: scaleFactor
                )

                Text(onboardingTitle)
                    .font(.title)
                    .fontWeight(.bold)

                Text(onboardingText)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .shadow(color: .black.opacity(0.7), radius: 10)

            }
            .lineLimit(nil)
            SecondaryButton(label: "Lets' start!", action: {
                onboardingIsCompleted = true
            }, color: .buttonTheme.opacity(0.8))
            .padding(.bottom, 40)
            .opacity(showDoneButton ? 1 : 0)
        }
        .padding()
        .foregroundStyle(.textTheme)
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
