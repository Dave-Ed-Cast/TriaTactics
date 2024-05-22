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
        Spacer(minLength: 20)
        RoundedRectangle(cornerRadius: 20)
            .frame(width: 50, height: 5)
            .foregroundStyle(.gray.opacity(0.5))
        OnboardingViewModel(
            onboardingIsCompleted: .constant(false),
            onboardingTitle: "Tria Tactics rule",
            onboardingImage: "Rule",
            onboardingText: "Making a fourth move will cost the first one. The next one follows the same logic. \n\nTria Tactics is about choosing wisely!"
        )
        
        Button {
            dismiss()
        } label: {
            Text("OK!")
                .frame(width: 200, height: 60)
                .background(.yellow)
                .foregroundStyle(.black)
                .font(.body)
                .fontWeight(.semibold)
                .cornerRadius(20)
        }
        
        .padding()

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

