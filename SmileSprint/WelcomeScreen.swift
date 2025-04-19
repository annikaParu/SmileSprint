//
//  WelcomeScreen.swift
//  SmileSprint
//
//  Created by Gaurav Jena on 4/19/25.
//

import SwiftUI

struct WelcomeScreen: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.mint, .yellow, .orange],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 64))
                        .foregroundColor(.white)

                    Text("SmileSprint")
                        .font(.system(size: 48, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(radius: 4)

                    Text("Play, reflect, and level up your mind.")
                        .font(.title3.weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding()

                    NavigationLink("Start My Journey") {
                        MoodCheckView()
                    }
                    .font(.title2.bold())
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 20)
                }
                .padding()
            }
        }
    }
}
