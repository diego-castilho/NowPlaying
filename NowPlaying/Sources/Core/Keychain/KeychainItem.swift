//
//  KeychainItem.swift
//  NowPlaying
//
//  Representação type-safe de itens no Keychain
//
//  Created by Diego Castilho on 25/10/25
//  Copyright © 2025 Diego Castilho. All rights reserved.
//

import Foundation
import Security

/// Representa um item armazenado no Keychain de forma type-safe
struct KeychainItem {
    
    // MARK: - Properties
    
    /// Identificador único do item
    let account: String
    
    /// Serviço associado ao item (geralmente o bundle ID ou nome do app)
    let service: String
    
    /// Dados a serem armazenados
    let data: Data
    
    /// Grupo de acesso do Keychain (para compartilhar entre apps/extensions)
    let accessGroup: String?
    
    /// Nível de acessibilidade do item
    let accessibility: Accessibility
    
    // MARK: - Initialization
    
    /// Inicializador completo
    /// - Parameters:
    ///   - account: Identificador único (ex: "lastfm_session_key")
    ///   - service: Serviço (geralmente bundle ID)
    ///   - data: Dados a armazenar
    ///   - accessGroup: Grupo de acesso (opcional, para compartilhamento)
    ///   - accessibility: Nível de acessibilidade
    init(
        account: String,
        service: String,
        data: Data,
        accessGroup: String? = nil,
        accessibility: Accessibility = .whenUnlocked
    ) {
        self.account = account
        self.service = service
        self.data = data
        self.accessGroup = accessGroup
        self.accessibility = accessibility
    }
    
    /// Inicializador conveniente com String
    /// - Parameters:
    ///   - account: Identificador único
    ///   - service: Serviço
    ///   - value: String a armazenar
    ///   - accessGroup: Grupo de acesso (opcional)
    ///   - accessibility: Nível de acessibilidade
    init(
        account: String,
        service: String,
        value: String,
        accessGroup: String? = nil,
        accessibility: Accessibility = .whenUnlocked
    ) {
        self.account = account
        self.service = service
        self.data = Data(value.utf8)
        self.accessGroup = accessGroup
        self.accessibility = accessibility
    }
}

// MARK: - Accessibility Levels

extension KeychainItem {
    
    /// Níveis de acessibilidade do Keychain
    enum Accessibility {
        /// Acessível apenas quando desbloqueado (recomendado)
        case whenUnlocked
        
        /// Acessível após primeiro desbloqueio
        case afterFirstUnlock
        
        /// Sempre acessível (menos seguro)
        case always
        
        /// Acessível quando desbloqueado, não migra para novos dispositivos
        case whenUnlockedThisDeviceOnly
        
        /// Acessível após primeiro desbloqueio, não migra
        case afterFirstUnlockThisDeviceOnly
        
        /// Sempre acessível, não migra
        case alwaysThisDeviceOnly
        
        /// Converte para valor do Security framework
        var secAttrAccessible: CFString {
            switch self {
            case .whenUnlocked:
                return kSecAttrAccessibleWhenUnlocked
            case .afterFirstUnlock:
                return kSecAttrAccessibleAfterFirstUnlock
            case .always:
                return kSecAttrAccessibleAlways
            case .whenUnlockedThisDeviceOnly:
                return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
            case .afterFirstUnlockThisDeviceOnly:
                return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
            case .alwaysThisDeviceOnly:
                return kSecAttrAccessibleAlwaysThisDeviceOnly
            }
        }
    }
}

// MARK: - Query Building

extension KeychainItem {
    
    /// Constrói query para operações no Keychain
    /// - Parameter includeData: Se deve incluir os dados na query
    /// - Returns: Dicionário de query
    func buildQuery(includeData: Bool = true) -> [String: Any] {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service,
            kSecAttrAccessible as String: accessibility.secAttrAccessible
        ]
        
        if includeData {
            query[kSecValueData as String] = data
        }
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        
        return query
    }
    
    /// Constrói query de busca
    /// - Returns: Dicionário de query para buscar o item
    static func searchQuery(account: String, service: String, accessGroup: String? = nil) -> [String: Any] {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        
        return query
    }
}

// MARK: - Predefined Items

extension KeychainItem {
    
    /// Service padrão (bundle ID do app)
    private static var defaultService: String {
        Bundle.main.bundleIdentifier ?? "com.diegocastilho.NowPlaying"
    }
    
    /// Session key do Last.fm
    /// - Parameter sessionKey: Chave de sessão
    /// - Returns: KeychainItem configurado
    static func lastFMSession(sessionKey: String) -> KeychainItem {
        KeychainItem(
            account: "lastfm_session_key",
            service: defaultService,
            value: sessionKey,
            accessibility: .whenUnlocked
        )
    }
    
    /// Username do Last.fm
    /// - Parameter username: Nome de usuário
    /// - Returns: KeychainItem configurado
    static func lastFMUsername(username: String) -> KeychainItem {
        KeychainItem(
            account: "lastfm_username",
            service: defaultService,
            value: username,
            accessibility: .whenUnlocked
        )
    }
    
    /// API Key do Last.fm (temporário - será migrado para configuração)
    /// - Parameter apiKey: API Key
    /// - Returns: KeychainItem configurado
    static func lastFMAPIKey(apiKey: String) -> KeychainItem {
        KeychainItem(
            account: "lastfm_api_key",
            service: defaultService,
            value: apiKey,
            accessibility: .whenUnlocked
        )
    }
    
    /// Shared Secret do Last.fm (temporário - será migrado para configuração)
    /// - Parameter sharedSecret: Shared Secret
    /// - Returns: KeychainItem configurado
    static func lastFMSharedSecret(sharedSecret: String) -> KeychainItem {
        KeychainItem(
            account: "lastfm_shared_secret",
            service: defaultService,
            value: sharedSecret,
            accessibility: .whenUnlocked
        )
    }
}

// MARK: - Data Conversion

extension KeychainItem {
    
    /// Converte os dados para String
    /// - Returns: String ou nil se conversão falhar
    var stringValue: String? {
        String(data: data, encoding: .utf8)
    }
    
    /// Cria um item a partir de Data existente
    /// - Parameters:
    ///   - account: Identificador
    ///   - service: Serviço
    ///   - data: Dados recuperados
    ///   - accessGroup: Grupo de acesso
    /// - Returns: KeychainItem reconstruído
    static func from(
        account: String,
        service: String,
        data: Data,
        accessGroup: String? = nil
    ) -> KeychainItem {
        KeychainItem(
            account: account,
            service: service,
            data: data,
            accessGroup: accessGroup
        )
    }
}

// MARK: - Equatable

extension KeychainItem: Equatable {
    
    static func == (lhs: KeychainItem, rhs: KeychainItem) -> Bool {
        lhs.account == rhs.account &&
        lhs.service == rhs.service &&
        lhs.data == rhs.data &&
        lhs.accessGroup == rhs.accessGroup
    }
}

// MARK: - CustomStringConvertible

extension KeychainItem: CustomStringConvertible {
    
    var description: String {
        """
        KeychainItem(
            account: "\(account)",
            service: "\(service)",
            dataSize: \(data.count) bytes,
            accessGroup: \(accessGroup ?? "nil"),
            accessibility: \(accessibility)
        )
        """
    }
}

// MARK: - Debug Helpers

extension KeychainItem {
    
    /// Retorna descrição segura para logs (não expõe dados sensíveis)
    var safeDescription: String {
        """
        KeychainItem(
            account: "\(account)",
            service: "\(service)",
            hasData: \(data.count > 0),
            dataSize: \(data.count) bytes
        )
        """
    }
}
