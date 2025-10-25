//
//  ConfigurationManager.swift
//  NowPlaying
//
//  Gerenciador central de configurações do aplicativo
//

import Foundation

/// Erros relacionados à configuração
enum ConfigurationError: LocalizedError {
    case missingAPIKey
    case missingSharedSecret
    case invalidConfiguration(String)
    
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "Last.fm API Key não encontrada"
        case .missingSharedSecret:
            return "Last.fm Shared Secret não encontrado"
        case .invalidConfiguration(let detail):
            return "Configuração inválida: \(detail)"
        }
    }
}

/// Gerenciador central de configurações
@MainActor
final class ConfigurationManager {
    
    // MARK: - Singleton
    
    static let shared = ConfigurationManager()
    
    private init() {}
    
    // MARK: - Configuration Properties
    
    /// Last.fm API Key
    private(set) lazy var lastFMAPIKey: String = {
        loadConfiguration(key: "LASTFM_API_KEY")
    }()
    
    /// Last.fm Shared Secret
    private(set) lazy var lastFMSharedSecret: String = {
        loadConfiguration(key: "LASTFM_SHARED_SECRET")
    }()
    
    /// Last.fm API Endpoint
    private(set) lazy var lastFMAPIEndpoint: String = {
        loadConfiguration(
            key: "LASTFM_API_ENDPOINT",
            defaultValue: "https://ws.audioscrobbler.com/2.0/"
        )
    }()
    
    /// Nível de log
    private(set) lazy var logLevel: String = {
        loadConfiguration(key: "LOG_LEVEL", defaultValue: "info")
    }()
    
    /// Flag para analytics
    private(set) lazy var analyticsEnabled: Bool = {
        let value = loadConfiguration(key: "ENABLE_ANALYTICS", defaultValue: "false")
        return value.lowercased() == "true"
    }()
    
    // MARK: - Public Methods
    
    /// Valida se todas as configurações obrigatórias estão presentes
    func validate() throws {
        // Forçar carregamento
        _ = lastFMAPIKey
        _ = lastFMSharedSecret
        _ = lastFMAPIEndpoint
        
        // Validar API Key
        guard !lastFMAPIKey.isEmpty,
              lastFMAPIKey != "YOUR_API_KEY_HERE",
              lastFMAPIKey.count >= 20 else {
            throw ConfigurationError.missingAPIKey
        }
        
        // Validar Shared Secret
        guard !lastFMSharedSecret.isEmpty,
              lastFMSharedSecret != "YOUR_SHARED_SECRET_HERE",
              lastFMSharedSecret.count >= 20 else {
            throw ConfigurationError.missingSharedSecret
        }
        
        // Validar endpoint
        guard let url = URL(string: lastFMAPIEndpoint),
              url.scheme == "https" else {
            throw ConfigurationError.invalidConfiguration("Endpoint inválido")
        }
        
        print("✅ Configuração validada com sucesso")
    }
    
    /// Resumo das configurações
    func configurationSummary() -> String {
        """
        📋 Configuração do NowPlaying:
        • API Endpoint: \(lastFMAPIEndpoint)
        • API Key: \(lastFMAPIKey.prefix(8))...
        • Log Level: \(logLevel)
        • Analytics: \(analyticsEnabled ? "Sim" : "Não")
        """
    }
    
    // MARK: - Private Methods
    
    /// Carrega uma configuração
    private func loadConfiguration(key: String, defaultValue: String = "") -> String {
        // 1. Tentar variável de ambiente
        if let envValue = ProcessInfo.processInfo.environment[key], !envValue.isEmpty {
            print("🔧 \(key) de variável de ambiente")
            return envValue
        }
        
        // 2. Tentar Info.plist
        if let plistValue = Bundle.main.infoDictionary?[key] as? String,
           !plistValue.isEmpty,
           !plistValue.contains("$(") {
            print("🔧 \(key) do Info.plist")
            return plistValue
        }
        
        // 3. FALLBACK TEMPORÁRIO - Permite o app funcionar
        if key == "LASTFM_API_KEY" {
            print("⚠️ \(key) usando fallback")
            return "3201db2d552a4bb712be9b07e4a9a37f"
        }
        
        if key == "LASTFM_SHARED_SECRET" {
            print("⚠️ \(key) usando fallback")
            return "565db7293104183cc854980450ddc603"
        }
        
        // 4. Valor padrão
        if !defaultValue.isEmpty {
            print("⚠️ \(key) valor padrão")
            return defaultValue
        }
        
        print("❌ \(key) não encontrado")
        return ""
    }
    
    /// Recarrega configurações
    func reload() {
        lastFMAPIKey = loadConfiguration(key: "LASTFM_API_KEY")
        lastFMSharedSecret = loadConfiguration(key: "LASTFM_SHARED_SECRET")
        lastFMAPIEndpoint = loadConfiguration(
            key: "LASTFM_API_ENDPOINT",
            defaultValue: "https://ws.audioscrobbler.com/2.0/"
        )
        logLevel = loadConfiguration(key: "LOG_LEVEL", defaultValue: "info")
        analyticsEnabled = loadConfiguration(key: "ENABLE_ANALYTICS", defaultValue: "false").lowercased() == "true"
    }
}

// MARK: - Extensions

extension ConfigurationManager {
    
    struct LastFMCredentials {
        let apiKey: String
        let sharedSecret: String
        let endpoint: String
    }
    
    var lastFMCredentials: LastFMCredentials {
        LastFMCredentials(
            apiKey: lastFMAPIKey,
            sharedSecret: lastFMSharedSecret,
            endpoint: lastFMAPIEndpoint
        )
    }
}
