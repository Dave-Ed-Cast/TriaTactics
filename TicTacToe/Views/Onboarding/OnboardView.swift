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
                onboardingText: "Making your fourth move of the game will make the first one disappear! And it keeps going after that! This is Tria Tactics..."
            )
            OnboardingViewModel(
                onboardingIsCompleted: $onboardingIsCompleted,
                onboardingTitle: "Multiplayer is finally here!",
                onboardingImage: "Cool",
                onboardingText: "Here comes the multiplayer! Challenge your friends in a strategic battle. Log into Game Center and enjoy!",
                showDoneButton: true
            )
        }
        
        .overlay(alignment: .topTrailing, content: {
            Button {
                withAnimation {
                    skipOnboarding = true
                }
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

