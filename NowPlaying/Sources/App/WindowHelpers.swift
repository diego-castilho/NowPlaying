import SwiftUI
import AppKit

final class WindowDelegateProxy: NSObject, NSWindowDelegate {
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        sender.orderOut(nil)
        return false
    }
}

struct WindowAccessor: NSViewRepresentable {
    static let sharedDelegate = WindowDelegateProxy()
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let win = view.window {
                win.delegate = Self.sharedDelegate
                win.isReleasedWhenClosed = false
            }
        }
        return view
    }
    func updateNSView(_ nsView: NSView, context: Context) {}
}

enum WindowControl {
    static func showMainWindow() {
        NSApp.activate(ignoringOtherApps: true)
        if let win = NSApp.windows.first {
            win.makeKeyAndOrderFront(nil)
        }
    }
}
