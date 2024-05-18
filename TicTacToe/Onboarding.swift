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
    @State var currentStep: Int = 0
    //the other keeps track of the onboarding status
    @Binding var onboardingIsOver: Bool
    
    //this is the array of wall text to make the user read
    
    var onboardingTitle: [String] = [
        "Welcome!",
        "Title"
    ]
    var onboardingText: [String] = [
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt",
        "Lorem ipsum tunz tunz tempor incididunt tempor incididunt tempor incididunt",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt"
    ]
    var body: some View {
        
        //ok so bear with me now, this is boring part
        VStack(spacing: 50) {
            //i created this view which can handle different modifiers, and 3 required fields (the first three). Lottie is extremely powerful and given any kind of animation, you can totally modify it and play it however you want. The hard part however is to make it in a way that suits your needs, so using these modifiers everyone can simply adjust accordingly
            LottieAnimation(name: "Map", contentMode: .scaleAspectFit, playbackMode: .playing(.fromFrame(1, toFrame: 269, loopMode: .playOnce)), width: 300, height: 230, scaleFactor: 1.5, cornerRadiusFactor: 20)
            
            //god bless the spacers so that they do everything on their own
            Spacer()
            
            //user, read it please
            Text("\(onboardingTitle[currentStep])")
                .font(.title)
                .fontWeight(.bold)
            Text(onboardingText[currentStep])
                .font(.title3)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            Spacer()
            
            //this is the backend in the frontend
            Button {
                //so the way onboarding is completed is after pressind done all the time
                if currentStep < 1 {
                    currentStep += 1
                } else {
                    withAnimation {
                        //and this is the important value that is getting stored outside the onboarding
                        onboardingIsOver = true
                    }
                }
            } label: {
                //pretty way to display the text according to where we are
                Text(currentStep == 1 ? "Done" : "Continue")
                    .foregroundColor(.white)
                    .frame(width: 150, height: 50)
            }
            .background(.red)
            .cornerRadius(10)
            
        }
        .padding()
        .padding(.bottom, 50)
    }
}


#Preview {
    Onboarding(onboardingIsOver: .constant(false))
}
