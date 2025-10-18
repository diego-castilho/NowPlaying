import SwiftUI
import AppKit
import CoreData

@main
struct NowPlayingApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene { Settings { EmptyView() } }
}

final class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    static weak var shared: AppDelegate?

    private var statusItem: NSStatusItem?
    private let popover = NSPopover()
    private var globalHoverMonitor: Any?
    private var localHoverMonitor: Any?
    private var hoverCloseWorkItem: DispatchWorkItem?
    
    // Windows para gerenciar referências
    private var mainWindow: NSWindow?
    private var preferencesWindow: NSWindow?

    private let core = CoreDataStack.shared
    private let lastfm = LastFMClient()
    private let artwork = ArtworkStore()
    private let launchManager = LaunchAtLoginManager.shared

    func applicationDidFinishLaunching(_ notification: Notification) {
        AppDelegate.shared = self
        NSApp.setActivationPolicy(.accessory) // Começa como accessory
        
        // Inicializa o gerenciador de launch at login
        launchManager.initialize()

        let content = MenuBarPanelView(core: core, lastfm: lastfm, artwork: artwork)

        popover.behavior = .transient
        popover.contentSize = NSSize(width: 480, height: 260)
        popover.contentViewController = NSHostingController(rootView: content)

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "music.note", accessibilityDescription: "Now Playing")
            button.target = self
            button.action = #selector(statusItemAction(_:))
            button.sendAction(on: [.leftMouseUp, .mouseEntered, .rightMouseUp])

            globalHoverMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { [weak self] event in
                self?.handleHover(event)
            }
            localHoverMonitor = NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { [weak self] event in
                self?.handleHover(event); return event
            }
        }
        
        // Abre a janela principal automaticamente na inicialização
        // (isso mudará automaticamente para .regular)
        openMainWindow()
    }

    @objc private func statusItemAction(_ sender: Any?) {
        guard let button = statusItem?.button else { return }
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
        case .some(.rightMouseUp):
            showContextMenu()
        default: break
        }
    }
    
    private func showContextMenu() {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Abrir janela principal", action: #selector(openMainWindowFromMenu), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Preferências...", action: #selector(openPreferences), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Sair do Now Playing", action: #selector(quitApp), keyEquivalent: "q"))
        
        // Configura o target para os itens do menu
        menu.items.forEach { $0.target = self }
        
        statusItem?.menu = menu
        statusItem?.button?.performClick(nil)
        statusItem?.menu = nil
    }
    
    @objc private func openMainWindowFromMenu() {
        openMainWindow()
    }
    
    @objc func openPreferences() {
        if preferencesWindow == nil {
            let hosting = NSHostingController(rootView: PreferencesView())
            let window = NSWindow(contentViewController: hosting)
            window.title = "Preferências - Now Playing"
            window.styleMask = [.titled, .closable]
            window.isReleasedWhenClosed = false
            window.center()
            preferencesWindow = window
        }
        
        preferencesWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc private func quitApp() {
        let alert = NSAlert()
        alert.messageText = "Sair do Now Playing?"
        alert.informativeText = "Tem certeza que deseja encerrar o aplicativo?"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Sair")
        alert.addButton(withTitle: "Cancelar")
        
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            NSApp.terminate(nil)
        }
    }

    private func handleHover(_ event: NSEvent) {
        guard let button = statusItem?.button, let window = button.window else { return }
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
    
    // MARK: - NSWindowDelegate
    
    func windowWillClose(_ notification: Notification) {
        // Quando a janela principal for fechada, volta para modo accessory (sem dock)
        if notification.object as? NSWindow == mainWindow {
            NSApp.setActivationPolicy(.accessory)
        }
    }

    func closePopover() { popover.performClose(nil) }

    // Abre a janela principal
    func openMainWindow() {
        // Muda para .regular quando a janela principal for aberta
        NSApp.setActivationPolicy(.regular)
        
        if mainWindow == nil {
            let hosting = NSHostingController(
                rootView: ContentView()
                    .environment(\.managedObjectContext, core.container.viewContext)
                    .environmentObject(lastfm)
                    .environmentObject(artwork)
            )
            let window = NSWindow(contentViewController: hosting)
            window.title = "Now Playing"
            window.styleMask = [.titled, .closable, .miniaturizable, .resizable]
            window.isReleasedWhenClosed = false
            window.setContentSize(NSSize(width: 940, height: 620))
            window.center()
            
            // Adiciona delegate para detectar quando a janela for fechada
            window.delegate = self
            
            mainWindow = window
        }
        
        mainWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}

// Popover content
struct MenuBarPanelView: View {
    let core: CoreDataStack
    @ObservedObject var lastfm: LastFMClient
    @ObservedObject var artwork: ArtworkStore

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
                
                Button {
                    AppDelegate.shared?.openPreferences()
                } label: {
                    Label("Preferências", systemImage: "gear")
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
        .frame(width: 520)
    }
}
