//
//  File.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 04/01/25.
//

PrimaryButton(label: "Play", action: {
                        withAnimation {
                            view.value = .play
                        }
                    }, color: .buttonTheme.opacity(0.8))
                    .frame(width: size.width * 0.5, height: size.height * 0.1)

                        SecondaryButton(label: "Tutorial", action: {
                            withAnimation {
                                view.value = .tutorial
                            }
                        }, color: .buttonTheme.opacity(0.8))
                        .frame(width: size.width * 0.3, height: size.height * 0.05)
                        SecondaryButton(label: "Settings", action: {
                            withAnimation {
                                isSettingsPresented.toggle()
                            }
                        }, color: .buttonTheme.opacity(0.8))
                        .frame(width: size.width * 0.3, height: size.height * 0.05)
