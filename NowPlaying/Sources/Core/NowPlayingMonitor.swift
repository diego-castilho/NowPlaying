import Foundation

final class NowPlayingMonitor {
    enum Player: String {
        case appleMusic = "com.apple.iTunes.playerInfo"
    }

    private weak var progress: PlaybackProgress?

    init(progress: PlaybackProgress) { self.progress = progress }

    func start() {
        let dnc = DistributedNotificationCenter.default()
        dnc.addObserver(self,
                        selector: #selector(handleAppleMusic(_:)),
                        name: NSNotification.Name(Player.appleMusic.rawValue),
                        object: nil)
    }

    deinit { DistributedNotificationCenter.default().removeObserver(self) }

    @objc private func handleAppleMusic(_ note: Notification) {
        guard
            let info = note.userInfo as? [String: Any],
            let progress = progress
        else { return }

        let state  = (info["Player State"] as? String) ?? ""

        // Apple Music: "Total Time" may be in ms -> normalize to seconds if necessary
        var duration = (info["Total Time"] as? NSNumber)?.doubleValue ?? 0
        if duration > 1000 { duration /= 1000.0 }

        let elapsed = (info["Player Position"] as? NSNumber)?.doubleValue

        switch state {
        case "Playing":
            DispatchQueue.main.async {
                if duration > 0 {
                    progress.setTrack(duration: duration, startAt: elapsed ?? progress.elapsed, playing: true)
                } else if let e = elapsed {
                    progress.update(elapsed: e)
                    progress.play()
                } else {
                    progress.play()
                }
            }
        case "Paused":
            DispatchQueue.main.async {
                if let e = elapsed { progress.update(elapsed: e) }
                progress.pause()
            }
        case "Stopped":
            DispatchQueue.main.async {
                progress.pause()
                progress.update(elapsed: 0)
            }
        default:
            break
        }

        #if DEBUG
        let name = (info["Name"] as? String) ?? ""
        print("[AMusic] state=\(state) name=\(name) duration=\(duration) elapsed=\(elapsed ?? -1)")
        #endif
    }
}