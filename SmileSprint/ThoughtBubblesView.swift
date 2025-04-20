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
    var offset: CGSize = .zero
}

struct ThoughtBubblesView: View {
    @EnvironmentObject private var model: EmotionalModel
    @State private var bubbles: [ThoughtBubble] = []
    @State private var kept: [ThoughtBubble] = []
    @State private var released: [ThoughtBubble] = []
    @State private var navigateToJournal = false

    private let allThoughts = [
        ("Hope", true), ("Gratitude", true), ("Joy", true),
        ("Calm", true), ("Confidence", true), ("Worry", false),
        ("Stress", false), ("Fear", false), ("Doubt", false),
        ("Guilt", false), ("Frustration", false)
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

                ZStack {
                    ForEach(bubbles) { bubble in
                        Text(bubble.word)
                            .font(.headline)
                            .padding(12)
                            .background(bubble.isPositive ? Color.green.opacity(0.7) : Color.red.opacity(0.6))
                            .clipShape(Circle())
                            .foregroundColor(.white)
                            .offset(bubble.offset)
                            .onTapGesture {
                                handleTap(bubble)
                            }
                    }
                }
                .frame(height: 400)

                if kept.count + released.count >= 8 {
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
        var selected = allThoughts.shuffled().prefix(8)
        bubbles = selected.map { word, isPositive in
            ThoughtBubble(word: word, isPositive: isPositive,
                          offset: CGSize(width: Double.random(in: -120...120), height: Double.random(in: -150...150)))
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
