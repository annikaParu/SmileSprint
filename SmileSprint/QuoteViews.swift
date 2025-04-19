//
//  QuoteViews.swift
//  SmileSprint
//
//  Created by Gaurav Jena on 4/19/25.
//

import SwiftUI
import PhotosUI

// individual card -----------------------------------------------------------
struct QuoteCard: View {
    let quote: Quote
    let liked: Bool

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("“\(quote.text)”")
                .font(.title2)
                .italic()
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text("— \(quote.author)")
                .font(.headline)
                .foregroundColor(.secondary)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(.systemMint))
                .shadow(radius: 6)
        )
        .overlay(
            Image(systemName: liked ? "heart.fill" : "heart")
                .foregroundColor(.white)
                .padding(),
            alignment: .topTrailing
        )
        .padding(32)
    }
}

// swiper / saving -----------------------------------------------------------
struct QuoteSwipeView: View {
    @EnvironmentObject private var model: EmotionalModel
    @State private var index = 0
    @State private var currentScreenshot: UIImage?

    private let quotes = QuoteManager.samples

    var body: some View {
        TabView(selection: $index) {
            ForEach(quotes.indices, id: \.self) { i in
                let q = quotes[i]
                QuoteCard(quote: q, liked: model.likedQuoteIDs.contains(q.id))
                    .tag(i)
                    .onTapGesture { model.toggleLike(q) }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .navigationTitle("Pick Quotes You ❤️")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save Poster") {
                    let img = renderPoster(for: quotes[index])
                    save(img)
                }
            }
        }
    }

    // make a simple poster --------------------------------------------------
    private func renderPoster(for quote: Quote) -> UIImage {
        let size = CGSize(width: 1080, height: 1920)
        return UIGraphicsImageRenderer(size: size).image { ctx in
            UIColor.systemMint.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))

            let p = NSMutableParagraphStyle()
            p.alignment = .center

            ("“\(quote.text)”" as NSString).draw(
                in: CGRect(x: 60, y: 500, width: 960, height: 800),
                withAttributes: [
                    .font : UIFont.italicSystemFont(ofSize: 64),
                    .foregroundColor : UIColor.white,
                    .paragraphStyle : p
                ])

            ("— \(quote.author)" as NSString).draw(
                in: CGRect(x: 60, y: 1350, width: 960, height: 100),
                withAttributes: [
                    .font : UIFont.boldSystemFont(ofSize: 48),
                    .foregroundColor : UIColor.white
                ])
        }
    }

    private func save(_ image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
}
