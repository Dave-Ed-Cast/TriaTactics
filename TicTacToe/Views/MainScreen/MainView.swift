//
//  ContentView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 17/05/24.
//

import SwiftUI

struct MainView: View {
    
    private let onboardingStatusKey = "OnboardingStatus"
    @Environment (\.dismiss) var dismiss
    
    @State var onboardingIsCompleted: Bool = UserDefaults.standard.bool(forKey: "OnboardingStatus")
    @State private var showTutorialView: Bool = false
    
    @Binding var currentStep: Int
    @Binding var skipOnboarding: Bool
    
    
    var body: some View {
        
        if !onboardingIsCompleted && !skipOnboarding {
            OnboardView(
                onboardingIsCompleted: $onboardingIsCompleted,
                skipOnboarding: $skipOnboarding,
                currentStep: $currentStep)
            .onDisappear {
                if onboardingIsCompleted {
                    UserDefaults.standard.set(true, forKey: onboardingStatusKey)
                }
            }
            
        } else {
            NavigationStack {
                VStack {
                    Text("Tria Tactics")
                        .font(.system(size: 50))
                        .fontWeight(.black)
                        .padding()
                    
                    VStack(spacing: 200) {
                        Text("Tic Tac Toe - Revisited!")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        VStack (spacing: 20) {
                            Button(action: {
                                //empty
                            }) {
                                NavigationLink(destination: GameView()) {
                                    Text("Play")
                                        .frame(width: 200, height: 70, alignment: .center)
                                        .background(.yellow)
                                        .foregroundStyle(.black)
                                        .font(.title)
                                        .fontWeight(.medium)
                                        .cornerRadius(20)
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
            .tint(.black)
        }
    }
}

#Preview {
    MainView(currentStep: .constant(0), skipOnboarding: .constant(false))
}
