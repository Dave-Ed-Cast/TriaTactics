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
        
        RoundedRectangle(cornerRadius: 40)
            .foregroundStyle(.gray)
            .frame(width: 40, height: 5)
        VStack {
            LottieAnimation(name: "Rule", contentMode: .scaleAspectFit, playbackMode: .playing(.toProgress(1, loopMode: .loop)))
            Spacer()
            
            VStack(spacing: 50) {
                Text("The key rule")
                    .font(.title)
                    .fontWeight(.bold)
                Text("When each of you reach their 3rd move... the first move you made will disappear! So Tria Tactics begins...")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                Button {
                    dismiss()
                } label: {
                    Text("OK!")
                        .frame(width: 200, height: 70, alignment: .center)
                        .background(.yellow)
                        .foregroundStyle(.black)
                        .font(.title3)
                        .fontWeight(.medium)
                        .cornerRadius(20)
                }
            }
            .padding(.bottom, 30)
        }
        .padding()
    }
}

#Preview {
    TutorialView()
}
