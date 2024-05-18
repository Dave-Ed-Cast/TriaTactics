//
//  ContentView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 17/05/24.
//

import SwiftUI

struct ContentView: View {
    
    let onboardingStatusKey = "OnboardingStatus"
    @State var onboardingIsOver: Bool = UserDefaults.standard.bool(forKey: "OnboardingStatus")
    @State private var showGameView: Bool = false
    
    var body: some View {
        if !onboardingIsOver {
            Onboarding(onboardingIsOver: $onboardingIsOver)
                .preferredColorScheme(.light)
            //and after the user completed it
                .onDisappear {
                    //we save its value
                    UserDefaults.standard.set(true, forKey: onboardingStatusKey)
                }
        } else {
            VStack {
                Text("Tic Tac Toe")
                    .font(.largeTitle)
                    .fontWeight(.black)
                Text("Revisited")
                    .font(.callout)
                
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 200, height: 100, alignment: .center)
                    .foregroundStyle(.red)
                    .padding()
                    .overlay(
                        Button{
                            showGameView = true
                        } label: {
                            Text("Play")
                                .foregroundStyle(.white)
                                .font(.title)
                                .fontWeight(.bold)
                                .frame(width: 200, height: 100, alignment: .center)
                        }
                    )
                    .fullScreenCover(isPresented: $showGameView) {
                        GameView()
                            .preferredColorScheme(.light)
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
