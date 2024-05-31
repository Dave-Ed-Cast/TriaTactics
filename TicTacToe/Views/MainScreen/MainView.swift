//
//  ContentView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 17/05/24.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var onboardingViewModel = OnboardingParameters()
    
    @State private var showTutorialView: Bool = false
    @State var isOffline: Bool = false
    @State private var showOnlineView: Bool = false
    
    @EnvironmentObject var matchManager: MatchManager
    @EnvironmentObject var gameLogic: GameLogic
    
    var body: some View {
        
        if !onboardingViewModel.onboardingIsCompleted && !onboardingViewModel.skipOnboarding {
            OnboardView(viewModel: onboardingViewModel)
                .onDisappear {
                    if onboardingViewModel.onboardingIsCompleted {
                        onboardingViewModel.completeOnboarding()
                    }
                }
        } else {
            NavigationView {
                VStack {
                    if showOnlineView {
                        withAnimation {
                            OnlineView(matchManager: matchManager, gameLogic: gameLogic, showLottieAnimation: .constant(false), isOffline: $isOffline)
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
            matchManager.startMatchmaking()
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
        .opacity(matchManager.autheticationState != .authenticated ? 0.5 : 1)
    }
    
    var offlineButtonView: some View {
        Button(action: {

        }) {
            NavigationLink(destination: GameView(matchManager: matchManager, isOffline: .constant(true))) {
                Text("Play Offline")
                    .fontWeight(.bold)
                    .frame(width: 200, height: 70, alignment: .center)
                    .background(.yellow)
                    .foregroundStyle(.black)
                    .font(.title)
                    .cornerRadius(20)
            }
        }
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
    MainView()
        .environmentObject(MatchManager())
        .environmentObject(GameLogic())
}
