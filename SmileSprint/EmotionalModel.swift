import SwiftUI

struct Quote: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let author: String
}

@MainActor
final class EmotionalModel: ObservableObject {
    // lightweight persistence for prototyping
    @AppStorage("totalSessions") private var totalSessions = 0
    @AppStorage("totalPoints")   private var totalPoints   = 0
    @AppStorage("likedIDs")      private var likedData     = Data()

    @Published private(set) var likedQuoteIDs: Set<UUID> = []

    init() { likedQuoteIDs = decodeIDs() }

    // MARK: – Public API
    func recordSession(points: Int) {
        totalSessions += 1
        totalPoints   += points
    }

    func toggleLike(_ quote: Quote) {
        if likedQuoteIDs.contains(quote.id) {
            likedQuoteIDs.remove(quote.id)
        } else {
            likedQuoteIDs.insert(quote.id)
        }
        encodeIDs()
    }

    var averagePoints: Double {
        totalSessions == 0 ? 0 : Double(totalPoints) / Double(totalSessions)
    }

    // MARK: – persistence helpers
    private func encodeIDs() {
        likedData = try! JSONEncoder().encode(Array(likedQuoteIDs))
    }

    private func decodeIDs() -> Set<UUID> {
        (try? JSONDecoder().decode([UUID].self, from: likedData)).map(Set.init) ?? []
    }
}
