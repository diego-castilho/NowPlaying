import Foundation
import CoreData
import Combine

@MainActor
final class ScrobbleManager: ObservableObject {
    private let lastfm: LastFMClientProtocol  // ← Protocol!
    private let context: NSManagedObjectContext
    private let artwork: ArtworkStore  // ← Manter concreta por enquanto
    
    private var currentTrackKey: String?
    private var currentStartDate: Date?
    private var currentTotalSec: Int?
    private var scrobbleTask: Task<Void, Never>?
    
    init(lastfm: LastFMClientProtocol, context: NSManagedObjectContext, artwork: ArtworkStore) {
        self.lastfm = lastfm
        self.context = context
        self.artwork = artwork
        
        print("🎯 ScrobbleManager: Inicializado com DI")
    }

    func handle(_ np: NowPlayingInfo) {
        guard let title = np.name, let artist = np.artist else { return }

        switch np.state {
        case "Playing":
            let album = np.album
            let totalSec = max(0, (np.totalMs ?? 0) / 1000)
            let key = "\(artist)|\(title)|\(album ?? "")"

            if key != currentTrackKey {
                cancelTimer()
                currentTrackKey = key
                currentStartDate = Date()
                currentTotalSec = totalSec

                artwork.title = title
                artwork.artist = artist
                artwork.album = album
                artwork.image = artwork.placeholder()

                Task {
                    if let url = await lastfm.fetchArtworkURL(artist: artist, track: title, album: album),
                       let img = await artwork.loadImage(from: url) {
                        artwork.image = img
                    }
                    do {
                        try await lastfm.updateNowPlaying(artist: artist, track: title, album: album, durationSec: totalSec > 0 ? totalSec : nil)
                        LogEntry.create(context: context, kind: "nowPlaying", status: "ok",
                                        track: title, artist: artist, album: album, extra: nil)
                    } catch {
                        LogEntry.create(context: context, kind: "nowPlaying", status: "failed",
                                        track: title, artist: artist, album: album, extra: error.localizedDescription)
                    }
                }

                scheduleScrobbleIfNeeded(totalSec: totalSec)
            }

        case "Paused":
            cancelTimer()

        case "Stopped":
            if let start = currentStartDate, let tot = currentTotalSec, tot > 0 {
                let played = Int(Date().timeIntervalSince(start))
                let threshold = min(max(30, tot / 2), 240)
                
                if played >= threshold {
                    print("⏹️ Música parada após \(played)s (threshold: \(threshold)s)")
                    
                    // Scrobble imediato quando música para
                    Task { [weak self] in
                        await self?.fireScrobble()
                    }
                } else {
                    print("⏭️ Música parada cedo (\(played)s < \(threshold)s), sem scrobble")
                }
            }
            
            cancelTimer()
            currentTrackKey = nil
            currentStartDate = nil
            currentTotalSec = nil

        default:
            break
        }
    }

    private func scheduleScrobbleIfNeeded(totalSec: Int) {
        guard totalSec > 30 else { return }
        let threshold = min(max(30, totalSec / 2), 240)
        
        // Cancelar task anterior se existir
        scrobbleTask?.cancel()
        
        // Criar nova task com delay
        scrobbleTask = Task { [weak self] in
            do {
                // Usar Task.sleep ao invés de Timer
                try await Task.sleep(for: .seconds(threshold))
                
                // Verificar se não foi cancelado
                guard !Task.isCancelled else {
                    print("⏭️ Scrobble cancelado (música mudou)")
                    return
                }
                
                // Executar scrobble
                await self?.fireScrobble()
            } catch {
                // Task.sleep pode lançar CancellationError
                print("⏭️ Scrobble cancelado: \(error.localizedDescription)")
            }
        }
        
        print("⏰ Scrobble agendado para \(threshold)s")
    }

    private func fireScrobble() async {
        guard let key = currentTrackKey,
              let start = currentStartDate,
              let tot = currentTotalSec else {
            print("⚠️ Scrobble ignorado: dados incompletos")
            return
        }
        
        let parts = key.split(separator: "|").map(String.init)
        let artist = parts[0], title = parts[1]
        let album = parts.count > 2 ? parts[2] : nil
        let ts = Int(start.timeIntervalSince1970)
        
        print("📤 Enviando scrobble: \(artist) - \(title)")
        
        do {
            try await lastfm.scrobble(
                artist: artist,
                track: title,
                album: album?.isEmpty == true ? nil : album,
                timestamp: ts,
                durationSec: tot
            )
            
            LogEntry.create(
                context: context,
                kind: "scrobble",
                status: "ok",
                track: title,
                artist: artist,
                album: album,
                extra: nil
            )
            
            print("✅ Scrobble enviado com sucesso")
        } catch {
            LogEntry.create(
                context: context,
                kind: "scrobble",
                status: "failed",
                track: title,
                artist: artist,
                album: album,
                extra: error.localizedDescription
            )
            
            print("❌ Erro ao enviar scrobble: \(error.localizedDescription)")
        }
    }

    private func cancelTimer() {
        scrobbleTask?.cancel()
        scrobbleTask = nil
    }
}
