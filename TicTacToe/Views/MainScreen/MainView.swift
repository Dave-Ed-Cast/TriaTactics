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
                VStack(spacing: -150) {
                    Spacer()
                    if showOnlineView {
                        onlineView
                    } else {
                        mainMenuView
                        Spacer()
                        Text("Status: \(matchManager.autheticationState.rawValue)")
                            .font(.body)
                            .padding()
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
                .font(.largeTitle)
                .fontWeight(.black)
            
            VStack(spacing: 170) {
                Text("The game for true tacticians!")
                    .font(.headline)
                
                VStack (spacing: 20) {
                    onlineButtonView
                    offlineButtonView
                    tutorialButtonView
                    
                }
            }
        }
    }
    
    var onlineView: some View {
        Group {
            if matchManager.autheticationState == .authenticated {
                if matchManager.inGame {
                    GameView(matchManager: matchManager, gameLogic: gameLogic, isOffline: .constant(false))
                } else {
                    mainMenuView
                        .onChange(of: matchManager.inGame) { _ in
                            showOnlineView = false
                        }
                }
            }
        }
    }
    
    var onlineButtonView: some View {
        Button(action: {
            if !matchManager.inGame {
                matchManager.startMatchmaking()
            }
            showOnlineView = true
        }) {
            Text("Play Online")
                .fontWeight(.bold)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(.yellow)
                )
                .foregroundStyle(.black)
                .font(.title)
        }
        .opacity(matchManager.autheticationState != .authenticated ? 0.5 : 1)
        .disabled(matchManager.autheticationState != .authenticated)
    }
    
    var offlineButtonView: some View {
        Button(action: {
            
        }) {
            NavigationLink(destination: GameView(matchManager: matchManager, isOffline: .constant(true))) {
                Text("Play Offline")
                    .fontWeight(.bold)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(.yellow)
                    )
                    .foregroundStyle(.black)
                    .font(.title)
            }
        }
    }
    
    var tutorialButtonView: some View {
        Button {
            showTutorialView = true
        } label: {
            Text("Tutorial")
                .fontWeight(.medium)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(.yellow)
                )
                .foregroundStyle(.black)
                .font(.title3)
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
