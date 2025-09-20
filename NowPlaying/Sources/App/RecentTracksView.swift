import SwiftUI

struct RecentTracksView: View {
    @ObservedObject var lastfm: LastFMClient
    @State private var tracks: [[String:Any]] = []
    @State private var isLoading = false
    @State private var errorText: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Button { Task { await load() } } label: {
                    Label("Atualizar", systemImage: "arrow.clockwise")
                }
                .disabled(isLoading || lastfm.username == nil)

                if let u = lastfm.username {
                    Text("Usuário: \(u)").foregroundStyle(.secondary)
                } else {
                    Text("Conecte ao Last.fm para ver as faixas recentes.")
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            if isLoading {
                ProgressView().padding(.top, 8)
            } else if let err = errorText {
                Text(err).foregroundStyle(.red)
            } else {
                List(tracks.indices, id: \.self) { i in
                    let t = tracks[i]
                    let name = (t["name"] as? String) ?? "—"
                    let artist = ((t["artist"] as? [String:Any])?["#text"] as? String) ?? "—"
                    let album = ((t["album"] as? [String:Any])?["#text"] as? String) ?? ""
                    let dateDict = (t["date"] as? [String:Any])
                    let uts = Int((dateDict?["uts"] as? String) ?? "")
                    let dateStr = uts.map { Date(timeIntervalSince1970: TimeInterval($0)).shortHuman() } ?? "agora"

                    HStack(spacing: 12) {
                        VStack(alignment: .leading) {
                            Text("\(artist) — \(name)").font(.headline)
                            HStack(spacing: 8) {
                                if !album.isEmpty {
                                    Label(album, systemImage: "opticaldisc").font(.subheadline).foregroundStyle(.secondary)
                                }
                                Label(dateStr, systemImage: "clock").font(.subheadline).foregroundStyle(.secondary)
                            }
                        }
                        Spacer()
                        if let attr = t["@attr"] as? [String:Any], attr["nowplaying"] as? String == "true" {
                            Text("NOW").font(.caption2.bold())
                                .padding(.horizontal, 6).padding(.vertical, 3)
                                .background(Color.blue.opacity(0.15)).foregroundStyle(.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .task { await load() }
    }

    private func load() async {
        guard lastfm.username != nil else { return }
        isLoading = true
        errorText = nil
        defer { isLoading = false }
        do {
            let r = try await lastfm.fetchRecentTracks(limit: 30)
            tracks = r
        } catch {
            errorText = error.localizedDescription
        }
    }
}
