//
//  TutorialView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 21/05/24.
//

import SwiftUI

struct TutorialView: View {
    
    @Environment (\.dismiss) var dismiss
    var body: some View {
        VStack {
            Spacer(minLength: 20)
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 50, height: 5)
                .foregroundStyle(.gray.opacity(0.5))

            OnboardingPageViewModel(
                onboardingIsCompleted: .constant(false),
                onboardingTitle: "Tria Tactics rule",
                onboardingImage: "Rule",
                onboardingText: "Making a fourth move will cost the first one. The next one follows the same logic. \n\nTria Tactics is about choosing wisely!",
                animationSize: CGFloat(300)
            )
            .lineLimit(nil)
            
            Button {
                dismiss()
            } label: {
                Text("OK!")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.yellow)
                    )
                    .foregroundStyle(.black)
                    .font(.body)
            }
            .padding()
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

