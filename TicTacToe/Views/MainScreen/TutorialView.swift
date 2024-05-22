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
        OnboardingViewModel(
            onboardingIsCompleted: .constant(false),
            onboardingTitle: "Tria Tactics rule",
            onboardingImage: "Rule",
            onboardingText: "After your third move, when you will make your fourth, the first one made will disappear! This is Tria Tactics..."
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
        .padding(.bottom, 30)

    }
}

#Preview {
    TutorialView()
}
