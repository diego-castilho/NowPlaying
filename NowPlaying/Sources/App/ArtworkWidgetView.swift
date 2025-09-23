import SwiftUI
import AppKit

struct ArtworkWidgetView: View {
    @ObservedObject var artwork: ArtworkStore
    @EnvironmentObject var progress: PlaybackProgress
    
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(nsImage: artwork.image ?? artwork.placeholder())
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 6)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("Música:").font(.title2).bold().foregroundStyle(.secondary)
                    Text(artwork.title).font(.title2).bold().lineLimit(2)
                }
                if let al = artwork.album, !al.isEmpty {
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text("Álbum:").font(.headline).foregroundStyle(.secondary)
                        Text(al).font(.headline).foregroundColor(.white).lineLimit(1)
                    }
                }
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("Artista:").font(.headline).foregroundStyle(.secondary)
                    Text(artwork.artist).font(.headline).foregroundColor(.white).lineLimit(1)
                }
                
                VStack(spacing: 4) {
                    ProgressView(value: progress.fraction)
                        .progressViewStyle(.linear)
                    HStack {
    Text(progress.elapsedString)
        .monospacedDigit()
        .foregroundColor(.white)
    Spacer()
    Text(progress.remainingString)
        .monospacedDigit()
        .foregroundColor(.white)
}
.font(.caption2)
                    .foregroundStyle(.secondary)
                }
                .padding(.top, 4)
            }
            Spacer()
        }
        .padding(10)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
}
