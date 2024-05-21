//
//  Onboarding.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/05/24.
//

import SwiftUI

struct Onboarding: View {
    
    //we need 2 variables
    //one knows where we are in the onboarding
    @State private var currentStep: Int = 0
    @State private var progress: Double = 0.0
    //the other keeps track of the onboarding status
    @Binding var onboardingIsOver: Bool
    
    //this is the array of wall text to make the user read
    
    var onboardingTitle: [String] = [
        String(localized: "Welcome to Tria Tactics!"),
        String(localized: "Tria Tactics rule"),
        String(localized: "Local multiplayer (for now)")
    ]
    
    var onboardingImages: [String] = ["TicTacToe", "Rule", "Cool"]
    
    var onboardingText: [String] = [
        String(localized: "Tria Tactics is a revisited version of Tic Tac Toe. Play the classic game until something new will happen!"),
        String(localized: "When each of you reach their 3rd move... the first move you made will disappear! So Tria Tactics begins..."),
        String(localized: "For now enjoy the local version because multiplayer is coming soon as possible!")
    ]
    var body: some View {
        
        //ok so bear with me now, this is boring part
        VStack(spacing: 25) {
            //i created this view which can handle different modifiers, and 3 required fields (the first three). Lottie is extremely powerful and given any kind of animation, you can totally modify it and play it however you want. The hard part however is to make it in a way that suits your needs, so using these modifiers everyone can simply adjust accordingly
            LottieAnimation(name: onboardingImages[currentStep], contentMode: .scaleAspectFit, playbackMode: .playing(.toProgress(1, loopMode: .loop)))
            
            //god bless the spacers so that they do everything on their own
            Spacer()
            
            //user, read it please
            Text(onboardingTitle[currentStep])
                .font(.title2)
                .fontWeight(.bold)
            Text(onboardingText[currentStep])
                .font(.body)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            ProgressView(value: progress + 1, total: 3)
                .padding()

            //this is the backend in the frontend
            Button {
                //so the way onboarding is completed is after pressind done all the time
                if currentStep < 2 {
                    currentStep += 1
                } else {
                    withAnimation {
                        //and this is the important value that is getting stored outside the onboarding
                        onboardingIsOver = true
                    }
                }
                withAnimation {
                    progress = Double(currentStep)
                }
                
            } label: {
                //pretty way to display the text according to where we are
                Text(currentStep == 2 ? "Done" : "Continue")
                    .font(.body)
                    .foregroundStyle(.black)
                    .fontWeight(.semibold)
                    .frame(width: 200, height: 60)
            }
            .background(.yellow)
            .cornerRadius(20)
            
        }
        .padding()
        .padding(.bottom, 50)
    }
}


#Preview("English") {
    Onboarding(onboardingIsOver: .constant(false))
        .environment(\.locale, Locale(identifier: "EN"))
}

#Preview("Italian"){
    Onboarding(onboardingIsOver: .constant(false))
        .environment(\.locale, Locale(identifier: "IT"))
}
