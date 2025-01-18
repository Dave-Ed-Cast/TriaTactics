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
        GeometryReader { geometry in
            let size = geometry.size

            VStack(spacing: 30) {
                Spacer()

                LottieAnimation(
                    name: "Rule",
                    contentMode: .scaleAspectFit,
                    playbackMode: .playing(.toProgress(1, loopMode: .loop)),
                    scaleFactor: 1.0
                )
                .frame(height: size.height * 0.4)

                Text("Tria Tactics rule")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Making a fourth move will cost the first one. The next one follows the same logic. Choose wisely!")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .shadow(color: .black.opacity(0.7), radius: 10)
                    .padding(.horizontal)

                Spacer()

                SecondaryButton("OK!") {
                    view.value = .main
                }
                .padding(.bottom, size.height * 0.05)
            }
            .padding()
            .frame(maxWidth: size.width, maxHeight: size.height, alignment: .center)
        }
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
