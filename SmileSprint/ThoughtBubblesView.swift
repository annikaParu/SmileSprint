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
    var position: CGPoint = .zero
}

struct ThoughtBubblesView: View {
    @EnvironmentObject private var model: EmotionalModel
    @State private var bubbles: [ThoughtBubble] = []
    @State private var kept: [ThoughtBubble] = []
    @State private var released: [ThoughtBubble] = []
    @State private var navigateToJournal = false

    private let allThoughts = [
        ("Hope", true), ("Gratitude", true), ("Joy", true),
        ("Calm", true), ("Confident", true), ("Self-Love", true),
        ("Resilience", true), ("Patience", true), ("Pride", true),
        ("Optimism", true),
        ("Worry", false), ("Stress", false), ("Fear", false),
        ("Doubt", false), ("Guilt", false), ("Frustration", false),
        ("Lonely", false), ("Anxious", false), ("Shame", false),
        ("Anger", false)
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
                    let rows = 5
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
                        isActive: $navigateToJournal
                    ) {
                        EmptyView()
                    }
                    .hidden()

                    Button("Reflect & Continue") {
                        navigateToJournal = true
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

    func generateBubbles() {
        bubbles = allThoughts.shuffled().map { word, isPositive in
            ThoughtBubble(word: word, isPositive: isPositive)
        }
    }

    func handleTap(_ bubble: ThoughtBubble) {
        if bubble.isPositive {
            kept.append(bubble)
        } else {
            released.append(bubble)
        }
        bubbles.removeAll { $0.id == bubble.id }
    }
}
