import SwiftUI
import AppKit

struct ArtworkWidgetView: View {
    @ObservedObject var artwork: ArtworkStore
    @EnvironmentObject var progress: PlaybackProgress

    var body: some View {
        HStack(spacing: 12) {
            Image(nsImage: artwork.image ?? artwork.placeholder())
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .frame(width: 84, height: 84)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(artwork.title).font(.headline).lineLimit(2)
                Text(artwork.artist).font(.subheadline).foregroundStyle(.secondary).lineLimit(1)
                if let al = artwork.album, !al.isEmpty {
                    Text(al).font(.caption).foregroundStyle(.secondary).lineLimit(1)
                }
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(artwork.title).font(.headline).lineLimit(2)
                Text(artwork.artist).font(.subheadline).foregroundStyle(.secondary).lineLimit(1)
                if let al = artwork.album, !al.isEmpty {
                    Text(al).font(.caption).foregroundStyle(.secondary).lineLimit(1)
                }

                // Mini progress embutido no card
                VStack(spacing: 2) {
                    ProgressView(value: progress.fraction)
                        .progressViewStyle(.linear)
                    HStack {
                        Text(progress.elapsedString)
                        Spacer()
                        Text(progress.remainingString)
                    }
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
        .padding(10)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
