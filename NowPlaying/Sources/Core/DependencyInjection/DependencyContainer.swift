//
//  DependencyContainer.swift
//  NowPlaying
//
//  Container de Dependency Injection
//  Gerencia todas as dependências do aplicativo
//

import Foundation
import CoreData
import SwiftUI

/// Container central de dependências do aplicativo
///
/// Responsável por:
/// - Criar e gerenciar instâncias de serviços
/// - Fornecer dependências para toda a aplicação
/// - Facilitar testes com mock implementations
///
/// Uso:
/// ```swift
/// let container = DependencyContainer.shared
/// let lastfm = container.lastfm
/// ```
@MainActor
final class DependencyContainer {
    
    // MARK: - Singleton
    
    static let shared = DependencyContainer()
    
    // MARK: - Dependencies (Lazy Initialization)
    
    /// Last.fm API client
    /// Lazy: criado apenas quando usado pela primeira vez
    lazy var lastfm: LastFMClientProtocol = {
        let client = LastFMClient()
        print("📦 DI: LastFMClient criado")
        return client
    }()
    
    /// Keychain service (já é Actor, mas mantemos protocol)
    /// Não é lazy porque é Actor e já tem shared instance
    var keychain: KeychainServiceProtocol {
        KeychainService.shared
    }
    
    /// Configuration manager (temporário: classe concreta até criar protocol)
    lazy var configuration: ConfigurationManager = {
        let manager = ConfigurationManager.shared
        print("📦 DI: ConfigurationManager criado (concrete)")
        return manager
    }()
    
    /// Core Data stack (temporário: classe concreta até criar protocol)
    lazy var coreDataStack: CoreDataStack = {
        let stack = CoreDataStack.shared
        print("📦 DI: CoreDataStack criado (concrete)")
        return stack
    }()
    
    /// Managed object context (convenience)
    var viewContext: NSManagedObjectContext {
        coreDataStack.container.viewContext
    }
    
    /// Artwork store (temporário: classe concreta até criar protocol)
    lazy var artworkStore: ArtworkStore = {
        let store = ArtworkStore()
        print("📦 DI: ArtworkStore criado (concrete)")
        return store
    }()
    
    // MARK: - Initialization
    
    private init() {
        print("📦 DI: DependencyContainer inicializado")
    }
    
    // MARK: - Factory Methods
    
    /// Cria um novo ScrobbleManager com dependências injetadas
    /// - Note: Usa casting temporário até refatorarmos ScrobbleManager
    func makeScrobbleManager() -> ScrobbleManager {
        let manager = ScrobbleManager(
            lastfm: lastfm,  // ✅ Protocol - sem casting!
            context: viewContext,
            artwork: artworkStore
        )
        print("📦 DI: ScrobbleManager criado")
        return manager
    }
    
    // MARK: - Testing Support
    
#if DEBUG
    /// Reseta todas as dependências lazy (apenas para testes)
    func resetForTesting() {
        // Força recriação de dependências lazy
        // Nota: Este método será expandido conforme necessário
        print("🔄 DI: Reset para testes")
    }
#endif
    
    // MARK: - Debug
    
    /// Retorna informações sobre dependências criadas
    func diagnostics() -> String {
        var info = "📦 DependencyContainer Diagnostics:\n"
        info += "- LastFM: \(type(of: lastfm))\n"
        info += "- Keychain: \(type(of: keychain))\n"
        info += "- Configuration: \(type(of: configuration))\n"
        info += "- CoreData: \(type(of: coreDataStack))\n"
        info += "- Artwork: \(type(of: artworkStore))\n"
        return info
    }
}

// MARK: - Environment Key (para SwiftUI)

/// Environment key para DependencyContainer em SwiftUI
struct DependencyContainerKey: EnvironmentKey {
    static let defaultValue: DependencyContainer = .shared
}

extension EnvironmentValues {
    var dependencies: DependencyContainer {
        get { self[DependencyContainerKey.self] }
        set { self[DependencyContainerKey.self] = newValue }
    }
}

// MARK: - SwiftUI View Extension

extension View {
    /// Injeta o DependencyContainer no environment
    func withDependencies(_ container: DependencyContainer = .shared) -> some View {
        self.environment(\.dependencies, container)
    }
}
