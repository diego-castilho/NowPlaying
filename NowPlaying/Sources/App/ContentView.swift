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
            ArtworkWidgetView(artwork: artwork)
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
