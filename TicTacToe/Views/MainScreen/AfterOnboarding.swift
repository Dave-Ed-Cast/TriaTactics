//
//  AfterOnboarding.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 30/05/24.
//

import SwiftUI

struct AfterOnboarding: View {
    
    @Binding var currentStep: Int
    @Binding var skipOnboarding: Bool
    @Binding var showLottieAnimation: Bool
    @Binding var onboardingIsCompleted: Bool
    private let onboardingStatusKey = "OnboardingStatus"
    var body: some View {
        OnboardView(
            onboardingIsCompleted: $onboardingIsCompleted,
            skipOnboarding: $skipOnboarding,
            currentStep: $currentStep)
        .onDisappear {
            if onboardingIsCompleted {
                UserDefaults.standard.set(true, forKey: onboardingStatusKey)
            }
        }
    }
}

#Preview {
    AfterOnboarding(currentStep: .constant(0), skipOnboarding: .constant(false), showLottieAnimation: .constant(true), onboardingIsCompleted: .constant(true))
}
