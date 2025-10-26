import Foundation
import AppKit
import SwiftUI
import Combine

@MainActor
final class ArtworkStore: ObservableObject {
    @Published var image: NSImage? = nil
    @Published var title: String = "-"
    @Published var artist: String = "-"
    @Published var album: String? = nil
    
    func placeholder() -> NSImage {
        let size = NSSize(width: 300, height: 300)
        let img = NSImage(size: size)
        img.lockFocus()
        NSColor(calibratedRed: 0.2, green: 0.25, blue: 0.5, alpha: 1).setFill()
        NSRect(origin: .zero, size: size).fill()
        let attrs: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 48, weight: .bold),
            .foregroundColor: NSColor.white.withAlphaComponent(0.8)
        ]
        let str = NSAttributedString(string: "♪", attributes: attrs)
        str.draw(at: NSPoint(x: 130, y: 110))
        img.unlockFocus()
        return img
    }
    
    // MARK: - Image Loading
    
    /// Carrega uma imagem de forma assíncrona de uma URL
    /// - Parameter url: URL da imagem
    /// - Returns: NSImage carregada ou nil se falhar
    func loadImage(from url: URL) async -> NSImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return NSImage(data: data)
        } catch {
            print("❌ Erro ao carregar imagem: \(error.localizedDescription)")
            return nil
        }
    }
}
