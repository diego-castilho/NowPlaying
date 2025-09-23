import SwiftUI
import CoreData
import AppKit

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject var lastfm: LastFMClient
    @EnvironmentObject var artwork: ArtworkStore
    @EnvironmentObject var progress: PlaybackProgress

    @State private var scrobbler: ScrobbleManager?
    @State private var pendingToken: String? = nil
    @State private var authError: String? = nil
    @State private var showingError = false

    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top, spacing: 16) {
                Image(nsImage: artwork.image ?? artwork.placeholder())
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .frame(width: 160, height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 8)

                VStack(alignment: .leading, spacing: 8) {
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

                    VStack(spacing: 6) {
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
.font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .padding(.top, 8)
                }
            }
            .padding([.horizontal, .top])

            HStack {
                if let u = lastfm.username {
                    Label("Conectado ao Last.FM como \(u)", systemImage: "checkmark.seal").foregroundStyle(.green)
                } else {
                    Label("Não conectado", systemImage: "exclamationmark.triangle").foregroundStyle(.secondary)
                }
                Spacer()
                if lastfm.username != nil {
                    Button(role: .destructive) { lastfm.signOut() } label: {
                        Label("Desconectar", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                } else {
                    Button { Task { await startAuth() } } label: {
                        Label("Conectar ao Last.fm", systemImage: "link")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding(.horizontal)

            if pendingToken != nil && lastfm.username == nil {
                HStack {
                    Button {
                        Task { await completeAuth() }
                    } label: {
                        Label("Já autorizei — Concluir login", systemImage: "checkmark.circle")
                    }
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut(.defaultAction)
                    Spacer()
                    Button("Cancelar") { pendingToken = nil }
                }
                .padding(.horizontal)
            }

            Divider()

            TabView {
                LogListView()
                    .tabItem { Label("Scrobble Log", systemImage: "list.bullet.rectangle") }
                RecentTracksView(lastfm: lastfm)
                    .tabItem { Label("Recent Tracks", systemImage: "music.note.list") }
            }
            .padding([.horizontal, .bottom])
        }
        .background(WindowAccessor())
        .onAppear {
            let mgr = ScrobbleManager(lastfm: lastfm, context: context, artwork: artwork)
            self.scrobbler = mgr
            MusicEventListener.shared.start { info in
                mgr.handle(info)
            }
        }
        .alert("Falha na autenticação", isPresented: $showingError, actions: {
            Button("OK", role: .cancel) { }
        }, message: {
            Text(authError ?? "Erro desconhecido")
        })
    }

    private func startAuth() async {
        do {
            let token = try await lastfm.getToken()
            self.pendingToken = token
            let url = lastfm.authURL(token: token)
            NSWorkspace.shared.open(url)
        } catch {
            authError = error.localizedDescription
            showingError = true
        }
    }

    private func completeAuth() async {
        guard let token = pendingToken else { return }
        do {
            try await lastfm.getSession(with: token)
            pendingToken = nil
        } catch {
            authError = error.localizedDescription
            showingError = true
        }
    }
}
