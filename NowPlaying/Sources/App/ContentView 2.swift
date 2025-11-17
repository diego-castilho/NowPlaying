//import SwiftUI
//import CoreData
//import AppKit
//
//struct ContentView: View {
//    @Environment(\.managedObjectContext) private var context
//    @EnvironmentObject var lastfm: LastFMClient
//    @EnvironmentObject var artwork: ArtworkStore
//    @State private var scrobbler: ScrobbleManager?
//    @State private var pendingToken: String? = nil
//    @State private var authError: String? = nil
//    @State private var showingError = false
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            HStack(alignment: .center, spacing: 16) {
//                Image(nsImage: artwork.image ?? artwork.placeholder())
//                    .resizable()
//                    .interpolation(.high)
//                    .antialiased(true)
//                    .aspectRatio(1, contentMode: .fill)
//                    .frame(width: 120, height: 120)
//                    .clipShape(RoundedRectangle(cornerRadius: 16))
//                    .shadow(radius: 8)
//
//                Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 8) {
//                    GridRow(alignment: .top) {
//                        Text("Música:")
//                            .font(.title2)
//                            .bold()
//                            .foregroundStyle(.secondary)
//                            .gridColumnAlignment(.trailing)
//                        Text(artwork.title)
//                            .font(.title2)
//                            .bold()
//                            .lineLimit(2)
//                    }
//                    GridRow(alignment: .top) {
//                        Text("Álbum:")
//                            .font(.title3)
//                            .bold()
//                            .foregroundStyle(.secondary)
//                            .gridColumnAlignment(.trailing)
//                        Text((artwork.album?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false ? artwork.album : "-") ?? "-")
//                            .font(.title3)
//                            .foregroundColor(.white)
//                            .lineLimit(2)
//                    }
//                    GridRow(alignment: .top) {
//                        Text("Artista:")
//                            .font(.headline)
//                            .bold()
//                            .foregroundStyle(.secondary)
//                            .gridColumnAlignment(.trailing)
//                        Text(artwork.artist)
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .lineLimit(2)
//                    }
//                }
//            }
//            .padding([.horizontal, .top])
//
//            if pendingToken != nil && lastfm.username == nil {
//                HStack {
//                    Button {
//                        Task { await completeAuth() }
//                    } label: {
//                        Label("Já autorizei — Concluir login", systemImage: "checkmark.circle")
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .keyboardShortcut(.defaultAction)
//                    Spacer()
//                    Button("Cancelar") { pendingToken = nil }
//                }
//                .padding(.horizontal)
//            }
//
//            Divider()
//
//            TabView {
//                LogListView()
//                    .tabItem { Label("Scrobble Log", systemImage: "list.bullet.rectangle") }
//                RecentTracksView(lastfm: lastfm)
//                    .tabItem { Label("Recent Tracks", systemImage: "music.note.list") }
//            }
//            .padding([.horizontal, .bottom])
//
//            HStack {
//                if let u = lastfm.username {
//                    Label("Conectado ao Last.FM como \(u)", systemImage: "checkmark.seal").foregroundStyle(.green)
//                } else {
//                    Label("Não conectado", systemImage: "exclamationmark.triangle").foregroundStyle(.secondary)
//                }
//                Spacer()
//                if lastfm.username != nil {
//                    Button(role: .destructive) { lastfm.signOut() } label: {
//                        Label("Desconectar", systemImage: "rectangle.portrait.and.arrow.right")
//                    }
//                } else {
//                    Button { Task { await startAuth() } } label: {
//                        Label("Conectar ao Last.fm", systemImage: "link")
//                    }
//                    .buttonStyle(.borderedProminent)
//                }
//            }
//            .padding([.horizontal, .bottom])
//        }
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .onAppear {
//            // IMPORTANTE: Usar a mesma instância de artwork que está no Environment
//            let container = DependencyContainer.shared
//            
//            // ScrobbleManager deve usar a MESMA instância de artwork
//            let mgr = ScrobbleManager(
//                lastfm: container.lastfm,
//                context: context,
//                artwork: artwork  // ← Usar a instância do @EnvironmentObject!
//            )
//            self.scrobbler = mgr
//            
//            MusicEventListener.shared.start { [weak mgr] in
//                mgr?.handle($0)
//            }
//            
//            print("✅ ContentView: ScrobbleManager configurado")
//            print("✅ ContentView: Artwork instance: \(ObjectIdentifier(artwork))")
//        }
//        .alert("Falha na autenticação", isPresented: $showingError, actions: {
//            Button("OK", role: .cancel) { }
//        }, message: {
//            Text(authError ?? "Erro desconhecido")
//        })
//    }
//
//    private func startAuth() async {
//        do {
//            let token = try await lastfm.getToken()
//            self.pendingToken = token
//            let url = lastfm.authURL(token: token)
//            NSWorkspace.shared.open(url)
//        } catch {
//            authError = error.localizedDescription
//            showingError = true
//        }
//    }
//
//    private func completeAuth() async {
//        guard let token = pendingToken else { return }
//        do {
//            try await lastfm.getSession(with: token)
//            pendingToken = nil
//        } catch {
//            authError = error.localizedDescription
//            showingError = true
//        }
//    }
//}
