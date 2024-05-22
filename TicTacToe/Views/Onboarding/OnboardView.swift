//
//  OnboardView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 21/05/24.
//

import SwiftUI

struct OnboardView: View {
    
    @Binding var onboardingIsCompleted: Bool
    @Binding var skipOnboarding: Bool
    @Binding var currentStep: Int
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        TabView {
            
            OnboardingViewModel(
                onboardingIsCompleted: $onboardingIsCompleted,
                onboardingTitle: "Welcome to Tria Tactics!",
                onboardingImage: "TicTacToe",
                onboardingText: "Tria Tactics is a revisited version of Tic Tac Toe. Play the classic game until something new will happen!"
            )
            OnboardingViewModel(
                onboardingIsCompleted: $onboardingIsCompleted,
                onboardingTitle: "Tria Tactics rule",
                onboardingImage: "Rule",
                onboardingText: "After your third move, when you will make your fourth, the first one made will disappear! This is Tria Tactics..."
            )
            OnboardingViewModel(
                onboardingIsCompleted: $onboardingIsCompleted,
                onboardingTitle: "Local multiplayer (for now)",
                onboardingImage: "Cool",
                onboardingText: "For the moment, enjoy the local version because multiplayer and, later, new challenges will be on their way!",
                showDoneButton: true
            )
        }
        
        .overlay(alignment: .topTrailing, content: {
            Button {
                skipOnboarding = true
            } label: {
                Text("Skip")
            }
            .buttonBorderShape(.automatic)
            .padding()
        })
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}

#Preview("English") {
    OnboardView(onboardingIsCompleted: .constant(false), skipOnboarding: .constant(false), currentStep: .constant(0))
        .environment(\.locale, Locale(identifier: "EN"))
}

#Preview("Italian"){
    OnboardView(onboardingIsCompleted: .constant(false), skipOnboarding: .constant(false), currentStep: .constant(0))
        .environment(\.locale, Locale(identifier: "IT"))
}

