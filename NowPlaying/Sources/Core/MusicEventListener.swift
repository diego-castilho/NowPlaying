import Foundation
import Combine

struct NowPlayingInfo {
    let state: String
    let name: String?
    let artist: String?
    let album: String?
    let totalMs: Int?
}

final class MusicEventListener: ObservableObject {
    static let shared = MusicEventListener()
    private init() {}

    private var observer: NSObjectProtocol?

    func start(handler: @escaping (NowPlayingInfo) -> Void) {
        stop()
        observer = DistributedNotificationCenter.default.addObserver(
            forName: NSNotification.Name("com.apple.Music.playerInfo"),
            object: nil,
            queue: .main
        ) { note in
            let info = note.userInfo ?? [:]
            let state = info["Player State"] as? String ?? ""
            let name  = info["Name"] as? String
            let artist = info["Artist"] as? String
            let album = info["Album"] as? String
            let totalMs = info["Total Time"] as? Int
            handler(.init(state: state, name: name, artist: artist, album: album, totalMs: totalMs))
        }
    }

    func stop() {
        if let obs = observer {
            DistributedNotificationCenter.default.removeObserver(obs)
            observer = nil
        }
    }
}
