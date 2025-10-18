import Foundation
import ServiceManagement
import Combine
import AppKit

/// Gerencia a funcionalidade de iniciar o aplicativo no login do macOS
/// Versão simplificada que evita problemas com Core Foundation
final class LaunchAtLoginManager: ObservableObject {
    static let shared = LaunchAtLoginManager()
    
    private init() {}
    
    /// Indica se o aplicativo está configurado para iniciar no login
    @Published var isEnabled: Bool = false {
        didSet {
            if isEnabled != oldValue {
                updateLaunchAtLogin()
            }
        }
    }
    
    /// Inicializa o estado atual da configuração
    func initialize() {
        // Verifica o estado atual sem causar mudanças
        let currentState = checkCurrentStatus()
        // Atualiza sem trigger do didSet para evitar loops
        if currentState != isEnabled {
            DispatchQueue.main.async { [weak self] in
                self?.isEnabled = currentState
            }
        }
    }
    
    /// Verifica o status atual do launch at login
    private func checkCurrentStatus() -> Bool {
        if #available(macOS 13.0, *) {
            let service = SMAppService.mainApp
            return service.status == .enabled
        } else {
            // Para versões antigas, usa UserDefaults como fallback
            // (não é ideal, mas evita problemas com LSSharedFileList)
            return UserDefaults.standard.bool(forKey: "LaunchAtLoginEnabled")
        }
    }
    
    /// Atualiza a configuração de launch at login
    private func updateLaunchAtLogin() {
        if #available(macOS 13.0, *) {
            updateModernLaunchAtLogin()
        } else {
            updateLegacyLaunchAtLogin()
        }
    }
    
    /// Implementação para macOS 13+
    @available(macOS 13.0, *)
    private func updateModernLaunchAtLogin() {
        let service = SMAppService.mainApp
        
        do {
            if isEnabled {
                try service.register()
                print("✅ Launch at login habilitado com sucesso")
            } else {
                try service.unregister()
                print("✅ Launch at login desabilitado com sucesso")
            }
        } catch {
            print("❌ Erro ao configurar launch at login: \(error.localizedDescription)")
            // Reverte o estado em caso de erro
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.isEnabled = !self.isEnabled
            }
        }
    }
    
    /// Implementação simplificada para macOS 12 e anteriores
    private func updateLegacyLaunchAtLogin() {
        // Para versões antigas, salva a preferência localmente
        // Nota: O usuário precisará configurar manualmente nas Preferências do Sistema
        UserDefaults.standard.set(isEnabled, forKey: "LaunchAtLoginEnabled")
        
        if isEnabled {
            print("ℹ️ Para macOS 12 e anteriores: Configure manualmente em Preferências do Sistema > Usuários e Grupos > Itens de Login")
            
            // Opcional: Tenta abrir as Preferências do Sistema
            DispatchQueue.main.async {
                let alert = NSAlert()
                alert.messageText = "Configuração Manual Necessária"
                alert.informativeText = "Para macOS 12 e anteriores, você precisa adicionar manualmente o aplicativo em:\nPreferências do Sistema > Usuários e Grupos > Itens de Login"
                alert.addButton(withTitle: "Abrir Preferências")
                alert.addButton(withTitle: "OK")
                
                if alert.runModal() == .alertFirstButtonReturn {
                    if let url = URL(string: "x-apple.systempreferences:com.apple.LoginItems-Settings.extension") {
                        NSWorkspace.shared.open(url)
                    }
                }
            }
        } else {
            print("✅ Preferência de Launch at login desabilitada localmente")
        }
    }
    
    /// Toggle do estado atual
    func toggle() {
        isEnabled.toggle()
    }
}
