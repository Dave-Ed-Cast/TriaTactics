//
//  ContentView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 17/05/24.
//

import SwiftUI

struct MainView: View {
    
    private let onboardingStatusKey = "OnboardingStatus"
    
    @State var onboardingIsCompleted: Bool = UserDefaults.standard.bool(forKey: "OnboardingStatus")
    @State private var showTutorialView: Bool = false
    @State var isOffline: Bool = false
    @State private var showOnlineView: Bool = false
    
    @Binding var currentStep: Int
    @Binding var skipOnboarding: Bool
    @Binding var showLottieAnimation: Bool
    
    @EnvironmentObject var matchManager: MatchManager
    @EnvironmentObject var gameLogic: GameLogic
    
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
            NavigationView {
                VStack {
                    if showOnlineView {
                        withAnimation {
                            OnlineView(matchManager: matchManager, gameLogic: gameLogic, showLottieAnimation: $showLottieAnimation, isOffline: $isOffline, currentStep: $currentStep, skipOnboarding: $skipOnboarding)
                        }
                    } else {
                        mainMenuView
                    }
                }
                .overlay(alignment: .bottom) {
                    if !showOnlineView {
                        Text("Status: \(matchManager.autheticationState.rawValue)")
                            .offset(CGSize(width: 0.0, height: 80.0))
                            .frame(width: 350)
                    }
                }
                
            }
            .onAppear {
                matchManager.authenticateUser()
            }
            .tint(.black)
            
        }
    }
    
    var mainMenuView: some View {
        VStack {
            Text("Tria Tactics")
                .font(.system(size: 50))
                .fontWeight(.black)
                .padding()
            
            VStack(spacing: 200) {
                Text("The game for true tacticians!")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                VStack (spacing: 20) {
                    
                    onlineButtonView
                    offlineButtonView
                    tutorialButtonView
                    
                }
            }
        }
    }
    var onlineButtonView: some View {
        Button(action: {
            showOnlineView = true
        }) {
            Text("Play Online")
                .fontWeight(.bold)
                .frame(width: 200, height: 70, alignment: .center)
                .background(.yellow)
                .foregroundStyle(.black)
                .font(.title)
                .cornerRadius(20)
        }
//        .disabled(matchManager.autheticationState != .authenticated || matchManager.isGameOver)
        .opacity(matchManager.autheticationState != .authenticated ? 0.5 : 1)
    }
    var offlineButtonView: some View {
        Button(action: {
            isOffline = true
        }) {
            NavigationLink(destination: GameView(matchManager: matchManager, isOffline: $isOffline)) {
                Text("Play Offline")
                    .fontWeight(.bold)
                    .frame(width: 200, height: 70, alignment: .center)
                    .background(.yellow)
                    .foregroundStyle(.black)
                    .font(.title)
                    .cornerRadius(20)
            }
        }
        .simultaneousGesture(TapGesture().onEnded {
            isOffline = true
        })
    }
    var tutorialButtonView: some View {
        Button {
            showTutorialView = true
        } label: {
            Text("Tutorial")
                .fontWeight(.medium)
                .frame(width: 150, height: 50, alignment: .center)
                .background(.yellow)
                .foregroundStyle(.black)
                .font(.title3)
                .cornerRadius(20)
        }
        .sheet(isPresented: $showTutorialView) {
            TutorialView()
        }
    }
}

#Preview {
    MainView(currentStep: .constant(0), skipOnboarding: .constant(false), showLottieAnimation: .constant(true))
        .environmentObject(MatchManager())
        .environmentObject(GameLogic())
}
