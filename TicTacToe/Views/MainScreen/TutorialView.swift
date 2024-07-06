//
//  TutorialView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 21/05/24.
//

import SwiftUI

struct TutorialView: View {

    @EnvironmentObject var changeViewTo: Navigation
    var body: some View {
        VStack {

            OnboardingPageViewModel(
                onboardingIsCompleted: .constant(false),
                onboardingTitle: "Tria Tactics rule",
                onboardingImage: "Rule",
                onboardingText: "Making a fourth move will cost the first one. The next one follows the same logic. Tria Tactics is about choosing wisely!",
                animationSize: CGFloat(300)
            )
            .lineLimit(nil)

            SecondaryButton(label: "OK!", action: {
                withAnimation {
                    changeViewTo.value = .main
                }
            }, color: .buttonTheme.opacity(0.8))
            .padding()
        }
        .background {
            BackgroundView()
        }
    }
}

#Preview("English") {
    TutorialView()
        .environment(\.locale, Locale(identifier: "EN"))
}

#Preview("Italian"){
    TutorialView()
        .environment(\.locale, Locale(identifier: "IT"))
}
