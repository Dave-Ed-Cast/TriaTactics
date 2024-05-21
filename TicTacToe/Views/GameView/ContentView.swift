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
    @State private var showTutorialView: Bool = false
    @Binding var currentStep: Int
    
    var body: some View {
        if !onboardingIsOver {
            OnboardView(onbooardingIsOver: $onboardingIsOver, currentStep: $currentStep)
                .onDisappear {
                    UserDefaults.standard.set(true, forKey: onboardingStatusKey)
                }
        } else {
            VStack {
                    Text("Tria Tactics")
                        .font(.system(size: 50))
                        .fontWeight(.black)
                        .padding()
                
                VStack(spacing: 200) {
                    Text("Revisited")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    VStack (spacing: 20){
                        Button{
                            showGameView = true
                        } label: {
                            Text("Play")
                                .frame(width: 200, height: 70, alignment: .center)
                                .background(.yellow)
                                .foregroundStyle(.black)
                                .font(.title)
                                .fontWeight(.medium)
                                .cornerRadius(20)
                                .fullScreenCover(isPresented: $showGameView) {
                                    GameView()
                                }
                        }
                        Button{
                            showTutorialView = true
                        } label: {
                            Text("Tutorial")
                                .frame(width: 150, height: 50, alignment: .center)
                                .background(.yellow)
                                .foregroundStyle(.black)
                                .font(.title3)
                                .fontWeight(.medium)
                                .cornerRadius(20)
                        }
                        .sheet(isPresented: $showTutorialView) {
                            TutorialView()
                        }
                    }
                }
                
                
                
            }
        }
    }
}

#Preview {
    ContentView(currentStep: .constant(0))
}
