//
//  PlayView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 20/06/24.
//

import SwiftUI

struct PlayView: View {

    @EnvironmentObject var matchManager: MatchManager
    @EnvironmentObject var changeViewTo: Navigation

    @State private var isOffline: Bool = false
    @State private var showGameView: Bool = false
    @State private var showCreditsView: Bool = false
    @Namespace private var animationNamespace

    var body: some View {
        VStack {
            Spacer()
            // rectangle
            VStack {
                Image("appicon")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 120)
                    .cornerRadius(20)

                Text("Tria Tactics")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("The game for true tacticians!")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.textTheme)
            .padding()
            .background {
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.buttonTheme.opacity(0.8))
                    infoButton
                }
            }
            .matchedGeometryEffect(id: "heroRectangle", in: animationNamespace)
            .padding(.top, 100)

            Spacer()

            // buttons
            VStack(spacing: 20) {
                PrimaryButton(label: "Play Online", action: {
                    matchManager.startMatchmaking()
                    if matchManager.inGame && matchManager.autheticationState == .authenticated {
                        withAnimation {
                            changeViewTo.value = .online
                        }
                    }
                }, color: .buttonTheme.opacity(0.8))
                .opacity(matchManager.autheticationState != .authenticated ? 0.5 : 1)
                .disabled(matchManager.autheticationState != .authenticated)

                PrimaryButton(label: "Play Offline", action: {
                    withAnimation {
                        changeViewTo.value = .offline
                    }
                }, color: .buttonTheme.opacity(0.8))
                PrimaryButton(label: "Play vs AI", action: {
                    withAnimation {
                        changeViewTo.value = .bot
                    }
                }, color: .buttonTheme.opacity(0.8))
            }
            .padding(.top, 50)

            Spacer()

            // menu
            SecondaryButton(label: "Menu", action: {
                withAnimation {
                    changeViewTo.value = .main
                }
            }, color: .buttonTheme.opacity(0.8))
        }
        .background {
            BackgroundView()
        }
        .onAppear {
            matchManager.authenticateUser()
        }
    }

    var infoButton: some View {
        Button {
            changeViewTo.value = .collaborators
        } label: {
            Image(systemName: "info.circle")
                .foregroundStyle(.black)
                .font(.title3)
                .colorInvert()
        }
        .padding()
    }
}

#Preview {
    PlayView()
        .environmentObject(MatchManager())
        .environmentObject(Navigation.shared)
}
