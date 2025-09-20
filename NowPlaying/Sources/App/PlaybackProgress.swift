import Foundation
import Combine

final class PlaybackProgress: ObservableObject {
    @Published var elapsed: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var isPlaying: Bool = false

    private var timerCancellable: AnyCancellable?

    var fraction: Double {
        guard duration > 0 else { return 0 }
        return min(max(elapsed / duration, 0), 1)
    }

    var elapsedString: String { Self.format(elapsed) }
    var remainingString: String {
        guard duration > 0 else { return "--:--" }
        let remain = max(duration - elapsed, 0)
        return "-\(Self.format(remain))"
    }

    func setTrack(duration: TimeInterval, startAt elapsed: TimeInterval = 0, playing: Bool = true) {
        self.duration = max(duration, 0)
        self.elapsed = min(max(elapsed, 0), duration)
        self.isPlaying = playing
        restartTimerIfNeeded()
    }

    func update(elapsed: TimeInterval) {
        self.elapsed = min(max(elapsed, 0), duration)
    }

    func pause() {
        isPlaying = false
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    func play() {
        isPlaying = true
        restartTimerIfNeeded()
    }

    private func restartTimerIfNeeded() {
        timerCancellable?.cancel()
        timerCancellable = nil
        guard isPlaying, duration > 0 else { return }
        timerCancellable = Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                self.elapsed = min(self.elapsed + 0.5, self.duration)
                if self.elapsed >= self.duration { self.pause() }
            }
    }

    private static func format(_ t: TimeInterval) -> String {
        let ts = Int(t.rounded())
        let m = ts / 60
        let s = ts % 60
        return String(format: "%02d:%02d", m, s)
    }
}
