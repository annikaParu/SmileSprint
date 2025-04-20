//
//  ThoughtBubblesView.swift
//  SmileSprint
//
//  Created by Gaurav Jena on 4/19/25.
//

import SwiftUI

struct ThoughtBubble: Identifiable {
    let id = UUID()
    let word: String
    let isPositive: Bool
}

struct ThoughtBubblesView: View {
    @EnvironmentObject private var model: EmotionalModel
    @AppStorage("moodValue") private var moodValue: Double = 3.0
    @State private var bubbles: [ThoughtBubble] = []
    @State private var kept: [ThoughtBubble] = []
    @State private var released: [ThoughtBubble] = []
    @State private var navigateToHome = false

    // MARK: - Emotion Lists

    private let positiveEmotions: [(String, Bool)] = [
        ("Hope", true), ("Gratitude", true), ("Joy", true), ("Calm", true),
        ("Confident", true), ("Self-Love", true), ("Resilience", true), ("Patience", true),
        ("Pride", true), ("Optimism", true), ("Kind", true), ("Motivated", true),
        ("Peace", true), ("Empathy", true), ("Excited", true), ("Cheerful", true),
        ("Courage", true), ("Serenity", true), ("Satisfied", true), ("Inspired", true)
    ]

    private let negativeEmotions: [(String, Bool)] = [
        ("Worry", false), ("Stress", false), ("Fear", false), ("Doubt", false),
        ("Guilt", false), ("Frustrated", false), ("Lonely", false), ("Anxious", false),
        ("Shame", false), ("Anger", false), ("Overthinking", false), ("Sad", false),
        ("Jealous", false), ("Embarrassed", false), ("Disappointed", false), ("Regret", false),
        ("Irritated", false), ("Hopeless", false), ("Envy", false), ("Tired", false)
    ]

    var body: some View {
        ZStack {
            LinearGradient(colors: [.cyan.opacity(0.4), .mint.opacity(0.5)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("Tap to keep or release thoughts")
                    .font(.headline)
                    .padding()

                GeometryReader { geo in
                    let cols = 4
                    let spacing: CGFloat = 10
                    let bubbleSize: CGFloat = (geo.size.width - CGFloat(cols + 1) * spacing) / CGFloat(cols)

                    LazyVGrid(columns: Array(repeating: GridItem(.fixed(bubbleSize), spacing: spacing), count: cols), spacing: spacing) {
                        ForEach(bubbles) { bubble in
                            Text(bubble.word)
                                .font(.headline)
                                .frame(width: bubbleSize, height: bubbleSize)
                                .background(bubble.isPositive ? Color.green.opacity(0.7) : Color.red.opacity(0.6))
                                .clipShape(Circle())
                                .foregroundColor(.white)
                                .onTapGesture {
                                    handleTap(bubble)
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxHeight: .infinity)

                if kept.count + released.count >= 20 {
                    NavigationLink(
                        destination: JournalingView(),
                        isActive: $navigateToHome
                    ) {
                        EmptyView()
                    }
                    .hidden()

                    Button("Reflect & Continue") {
                        navigateToHome = true
                    }
                    .buttonStyle(.borderedProminent)
                }

                Spacer()
            }
        }
        .onAppear {
            generateBubbles()
        }
    }

    // MARK: - Logic

    func generateBubbles() {
        let mood = Int(moodValue)
        let positiveCount: Int

        switch mood {
        case 1: positiveCount = 0
        case 2: positiveCount = 5
        case 3: positiveCount = 10
        case 4: positiveCount = 15
        case 5: positiveCount = 20
        default: positiveCount = 10
        }

        let negativeCount = 20 - positiveCount
        let selectedPositives = positiveEmotions.shuffled().prefix(positiveCount)
        let selectedNegatives = negativeEmotions.shuffled().prefix(negativeCount)

        let selected = (selectedPositives + selectedNegatives).shuffled()

        bubbles = selected.map { word, isPositive in
            ThoughtBubble(word: word, isPositive: isPositive)
        }
    }

    func handleTap(_ bubble: ThoughtBubble) {
        if bubble.isPositive {
            kept.append(bubble)
        } else {
            released.append(bubble)
            bubbles.removeAll { $0.id == bubble.id }
        }
    }
}
