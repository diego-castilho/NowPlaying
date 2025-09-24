import SwiftUI
import AppKit

struct ArtworkWidgetView: View {
    @ObservedObject var artwork: ArtworkStore

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(nsImage: artwork.image ?? artwork.placeholder())
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 6)
            
            Grid(alignment: .leading, horizontalSpacing: 8, verticalSpacing: 6) {
                GridRow(alignment: .top) {
                    Text("Música:")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.secondary)
                        .gridColumnAlignment(.trailing)
                    Text(artwork.title)
                        .font(.title3)
                        .bold()
                        .gridColumnAlignment(.leading)
                        .truncationMode(.tail)
                }
                GridRow(alignment: .top) {
                    Text("Álbum:")
                        .font(.headline)
                        .bold()
                        .foregroundStyle(.secondary)
                        .gridColumnAlignment(.trailing)
                    Text((artwork.album?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false ? artwork.album : "-") ?? "-")
                        .font(.headline)
                        .bold()
                        .gridColumnAlignment(.leading)
                        .truncationMode(.tail)
                }
                GridRow(alignment: .top) {
                    Text("Artista:")
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(.secondary)
                        .gridColumnAlignment(.trailing)
                    Text(artwork.artist)
                        .font(.subheadline)
                        .bold()
                        .gridColumnAlignment(.leading)
                        .truncationMode(.tail)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
        .padding(10)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
}

