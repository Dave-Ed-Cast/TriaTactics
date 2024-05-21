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
        Onboarding(
            onboardingIsOver: .constant(false),
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
    //
    //        RoundedRectangle(cornerRadius: 40)
    //            .foregroundStyle(.gray)
    //            .frame(width: 40, height: 5)
    //        VStack {
    //            LottieAnimation(name: "Rule", contentMode: .scaleAspectFit, playbackMode: .playing(.toProgress(1, loopMode: .loop)))
    //            Spacer()
    //
    //            VStack(spacing: 50) {
    //                Text("Tria Tactics rule")
    //                    .font(.title2)
    //                    .fontWeight(.bold)
    //                Text("When each of you reach their 3rd move... the first move you made will disappear! So Tria Tactics begins...")
    //                    .font(.body)
    //                    .fontWeight(.semibold)
    //                    .multilineTextAlignment(.center)
    //                Button {
    //                    dismiss()
    //                } label: {
    //                    Text("OK!")
    //                        .frame(width: 200, height: 60)
    //                        .background(.yellow)
    //                        .foregroundStyle(.black)
    //                        .font(.body)
    //                        .fontWeight(.semibold)
    //                        .cornerRadius(20)
    //                }
    //            }
    //            .padding()
    //            .padding(.bottom, 30)
    //        }
    //        .padding()
    
}

#Preview {
    TutorialView()
}
