import SwiftUI

struct QuoteStoriesView: View {
    let quotes = [
        "You are stronger than you think.",
        "Breathe in calm, breathe out stress.",
        "Your feelings are valid.",
        "Small steps matter too."
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(quotes, id: \.self) { quote in
                    VStack {
                        Text(quote)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 20).fill(Color.purple.opacity(0.7)))
                            .foregroundColor(.white)
                            .frame(width: 250)
                    }
                }
            }
            .padding()
        }
    }
}
