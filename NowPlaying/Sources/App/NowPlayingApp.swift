import SwiftUI
import AppKit
import CoreData

@main
struct NowPlayingApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene { Settings { EmptyView() } }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    static weak var shared: AppDelegate?

    private var statusItem: NSStatusItem!
    private let popover = NSPopover()
    private var globalHoverMonitor: Any?
    private var localHoverMonitor: Any?
    private var hoverCloseWorkItem: DispatchWorkItem?

    private let core = CoreDataStack.shared
    private let lastfm = LastFMClient()
    private let artwork = ArtworkStore()
    private let progress = PlaybackProgress()   // progresso compartilhado
    private var monitor: NowPlayingMonitor?

    func applicationDidFinishLaunching(_ notification: Notification) {
        AppDelegate.shared = self
        NSApp.setActivationPolicy(.accessory)

        let content = MenuBarPanelView(core: core, lastfm: lastfm, artwork: artwork)
            .environmentObject(progress) // injeta no popover

        popover.behavior = .transient
        popover.contentSize = NSSize(width: 480, height: 260)
        popover.contentViewController = NSHostingController(rootView: content)

        // Start Apple Music monitor and retain it
        let monitor = NowPlayingMonitor(progress: progress)
        monitor.start()
        self.monitor = monitor

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "music.note", accessibilityDescription: "Now Playing")
            button.target = self
            button.action = #selector(statusItemAction(_:))
            button.sendAction(on: [.leftMouseUp, .mouseEntered])

            globalHoverMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { [weak self] event in
                self?.handleHover(event)
            }
            localHoverMonitor = NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { [weak self] event in
                self?.handleHover(event); return event
            }
        }
    }

    @objc private func statusItemAction(_ sender: Any?) {
        guard let button = statusItem.button else { return }
        switch NSApp.currentEvent?.type {
        case .some(.mouseEntered):
            if !popover.isShown {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .maxY)
            }
        case .some(.leftMouseUp):
            if popover.isShown { popover.performClose(sender) }
            else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .maxY)
                NSApp.activate(ignoringOtherApps: true)
            }
        default: break
        }
    }

    private func handleHover(_ event: NSEvent) {
        guard let button = statusItem.button, let window = button.window else { return }
        let mouse = NSEvent.mouseLocation
        let rInWin = button.convert(button.bounds, to: nil)
        let rOnScreen = NSRect(x: window.frame.origin.x + rInWin.origin.x,
                               y: window.frame.origin.y + rInWin.origin.y,
                               width: rInWin.width, height: rInWin.height)
        if rOnScreen.contains(mouse) {
            hoverCloseWorkItem?.cancel()
            if !popover.isShown {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .maxY)
            }
        } else {
            hoverCloseWorkItem?.cancel()
            let work = DispatchWorkItem { [weak self] in self?.popover.performClose(nil) }
            hoverCloseWorkItem = work
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: work)
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        if let gm = globalHoverMonitor { NSEvent.removeMonitor(gm) }
        if let lm = localHoverMonitor { NSEvent.removeMonitor(lm) }
        globalHoverMonitor = nil; localHoverMonitor = nil
    }

    func closePopover() { popover.performClose(nil) }

    // Abre a janela principal com o mesmo PlaybackProgress injetado
    func openMainWindow() {
        let hosting = NSHostingController(
            rootView: ContentView()
                .environment(\.managedObjectContext, core.container.viewContext)
                .environmentObject(lastfm)
                .environmentObject(artwork)
                .environmentObject(progress) // injeta na janela
        )
        let win = NSWindow(contentViewController: hosting)
        win.title = "Now Playing"
        win.styleMask = [.titled, .closable, .miniaturizable, .resizable]
        win.isReleasedWhenClosed = false
        win.setContentSize(NSSize(width: 720, height: 520))
        win.center()
        win.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}

// Popover content
struct MenuBarPanelView: View {
    let core: CoreDataStack
    @ObservedObject var lastfm: LastFMClient
    @ObservedObject var artwork: ArtworkStore
    @EnvironmentObject var progress: PlaybackProgress

    init(core: CoreDataStack, lastfm: LastFMClient, artwork: ArtworkStore) {
        self.core = core; self.lastfm = lastfm; self.artwork = artwork
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ArtworkWidgetView(artwork: artwork)

            HStack {
                Button {
                    AppDelegate.shared?.openMainWindow()
                } label: {
                    Label("Abrir janela", systemImage: "rectangle.and.arrow.up.right")
                }
                Spacer()
                Button {
                    let alert = NSAlert()
                    alert.messageText = "Sair do Now Playing?"
                    alert.informativeText = "Tem certeza que deseja encerrar o aplicativo?"
                    alert.alertStyle = .warning
                    alert.addButton(withTitle: "Sair")
                    alert.addButton(withTitle: "Cancelar")
                    let response = alert.runModal()
                    if response == .alertFirstButtonReturn { NSApp.terminate(nil) }
                    else { AppDelegate.shared?.closePopover() }
                } label: {
                    Label("Sair", systemImage: "power")
                }
            }
        }
        .padding(8)
        .frame(width: 480)
    }
}
