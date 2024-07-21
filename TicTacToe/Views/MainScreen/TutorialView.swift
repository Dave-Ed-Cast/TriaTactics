//
//  TutorialView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 21/05/24.
//

import SwiftUI

struct TutorialView: View {

    @EnvironmentObject var view: Navigation
    @AppStorage("animationStatus") private var animationEnabled = true

    var body: some View {

        VStack(spacing: 30) {
            Spacer()
            LottieAnimation(
                name: "Rule",
                contentMode: .scaleAspectFit,
                playbackMode: .playing(.toFrame(1, loopMode: .loop)),
                scaleFactor: 1.0
            )

            Text("Tria Tactics rule")
                .font(.title)
                .fontWeight(.bold)

            Text("Making a fourth move will cost the first one. The next one follows the same logic. Choose wisely!")
                .font(.title3)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .shadow(color: .black.opacity(0.7), radius: 10)

            Spacer()
            SecondaryButton(label: "OK!", action: {
                withAnimation {
                    view.value = .main
                }
            }, color: .buttonTheme.opacity(0.8))

            .padding(.bottom, 70)
        }
        .padding()
    }
}

#Preview("English") {
    PreviewWrapper {
        TutorialView()
            .environment(\.locale, Locale(identifier: "EN"))
    }

}

#Preview("Italian"){
    PreviewWrapper {
        TutorialView()
            .environment(\.locale, Locale(identifier: "IT"))
    }
}
