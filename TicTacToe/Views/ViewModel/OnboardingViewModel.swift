//
//  Onboarding.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/05/24.
//

import SwiftUI

struct OnboardingViewModel: View {

    @Binding var onboardingIsCompleted: Bool
    
    @State var onboardingTitle: LocalizedStringKey
    @State var onboardingImage: String
    @State var onboardingText: LocalizedStringKey
    @State var showDoneButton: Bool = false
    
    var body: some View {
        
        //this is the model i call for the onboarding
        VStack(spacing: 25) {

            LottieAnimation(name: onboardingImage, contentMode: .scaleAspectFit, playbackMode: .playing(.toProgress(1, loopMode: .loop)))
            
            Spacer()
            
            Text(onboardingTitle)
                .font(.title2)
                .fontWeight(.bold)
            Text(onboardingText)
                .font(.body)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            Button {
                withAnimation {
                    onboardingIsCompleted = true
                }
            } label: {

                Text("Let's start!")
                    .font(.body)
                    .foregroundStyle(.black)
                    .fontWeight(.semibold)
                    .frame(width: 200, height: 60)
                    
            }
            .background(.yellow)
            .cornerRadius(20)
            .opacity(showDoneButton ? 1 : 0)
            
        }
        
        .padding()
        .padding(.bottom, 50)
    }
}


#Preview("English") {
    OnboardingViewModel(
        onboardingIsCompleted: .constant(false),
        onboardingTitle: "Local multiplayer (for now)",
        onboardingImage: "Cool",
        onboardingText: "For now enjoy the local version because multiplayer is coming soon as possible!",
        showDoneButton: true
    )
        .environment(\.locale, Locale(identifier: "EN"))
}

#Preview("Italian"){
    OnboardingViewModel(
        onboardingIsCompleted: .constant(false),
        onboardingTitle: "Local multiplayer (for now)",
        onboardingImage: "Cool",
        onboardingText: "For now enjoy the local version because multiplayer is coming soon as possible!",
        showDoneButton: true
    )
        .environment(\.locale, Locale(identifier: "IT"))
}
