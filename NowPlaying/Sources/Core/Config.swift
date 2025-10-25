//
//  Config.swift
//  NowPlaying
//
//  Configurações estáticas do Last.fm
//  DEPRECATED: Use ConfigurationManager.shared ao invés deste arquivo
//

import Foundation

/// Configurações do Last.fm
///
/// ⚠️ DEPRECATED: Este enum está mantido apenas para compatibilidade.
/// Use `ConfigurationManager.shared` para acessar as configurações.
///
/// - Note: As credenciais agora são carregadas de forma segura via ConfigurationManager
enum LastFMConfig {
    
    /// API Key do Last.fm
    /// - Warning: DEPRECATED - Use `ConfigurationManager.shared.lastFMAPIKey`
    static var apiKey: String {
        ConfigurationManager.shared.lastFMAPIKey
    }
    
    /// Shared Secret do Last.fm
    /// - Warning: DEPRECATED - Use `ConfigurationManager.shared.lastFMSharedSecret`
    static var sharedSecret: String {
        ConfigurationManager.shared.lastFMSharedSecret
    }
}

// MARK: - Migration Helper

extension LastFMConfig {
    
    /// Valida se as configurações estão corretas
    /// Usado durante a migração para garantir que tudo funciona
    static func validate() throws {
        try ConfigurationManager.shared.validate()
    }
    
    /// Retorna um resumo das configurações (para debug)
    static func summary() -> String {
        ConfigurationManager.shared.configurationSummary()
    }
}
