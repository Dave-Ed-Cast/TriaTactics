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
    @Namespace private var namespace

    var body: some View {
        VStack {
            Spacer()
            // rectangle
            VStack {
                Image("appicon")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                    .matchedGeometryEffect(id: "icon", in: namespace)
                    .frame(maxHeight: 120)

                Text("Tria Tactics")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .matchedGeometryEffect(id: "title", in: namespace)
                Text("The game for true tacticians!")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .matchedGeometryEffect(id: "subtitle", in: namespace)
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
            .matchedGeometryEffect(id: "heroRectangle", in: namespace)
            .padding(.top, 100)

            Spacer()

            // buttons
            VStack(spacing: 20) {
                PrimaryButton(label: "Play Online", action: {
                    matchManager.startMatchmaking()
                    if matchManager.inGame && matchManager.authenticationState == .authenticated {
                        withAnimation {
                            changeViewTo.value = .online
                        }
                    }
                }, color: .buttonTheme.opacity(0.8))
                .opacity(matchManager.authenticationState != .authenticated ? 0.5 : 1)
                .disabled(matchManager.authenticationState != .authenticated)

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
            withAnimation {
                changeViewTo.value = .collaborators
            }
        } label: {
            Image(systemName: "info.circle")
                .foregroundStyle(.buttonTheme)
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
