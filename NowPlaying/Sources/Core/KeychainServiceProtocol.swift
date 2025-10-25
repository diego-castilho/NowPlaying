//
//  KeychainServiceProtocol.swift
//  NowPlaying
//
//  Protocol para abstração de operações no Keychain
//  Permite dependency injection e testes com mocks
//
//  Created by Diego Castilho on 25/10/25
//  Copyright © 2025 Diego Castilho. All rights reserved.
//

import Foundation

/// Protocol que define operações no Keychain
/// 
/// Este protocol permite:
/// - Dependency injection
/// - Testes unitários com mocks
/// - Múltiplas implementações (Keychain real, in-memory para testes, etc)
///
/// **Exemplo de uso**:
/// ```swift
/// let service: KeychainServiceProtocol = KeychainService.shared
/// let item = KeychainItem.lastFMSession(sessionKey: "abc123")
/// try service.save(item)
/// ```
protocol KeychainServiceProtocol {
    
    // MARK: - CRUD Operations
    
    /// Salva um item no Keychain
    /// - Parameter item: Item a ser salvo
    /// - Throws: `KeychainError` se a operação falhar
    ///
    /// **Comportamento**:
    /// - Se o item já existe, lança `KeychainError.duplicateItem`
    /// - Use `update()` para atualizar itens existentes
    func save(_ item: KeychainItem) throws
    
    /// Carrega um item do Keychain
    /// - Parameters:
    ///   - account: Identificador do item
    ///   - service: Serviço associado
    ///   - accessGroup: Grupo de acesso (opcional)
    /// - Returns: KeychainItem com os dados
    /// - Throws: `KeychainError.itemNotFound` se não encontrado
    func load(account: String, service: String, accessGroup: String?) throws -> KeychainItem
    
    /// Atualiza um item existente no Keychain
    /// - Parameter item: Item com novos dados
    /// - Throws: `KeychainError` se a operação falhar
    ///
    /// **Comportamento**:
    /// - Se o item não existe, lança `KeychainError.itemNotFound`
    /// - Use `save()` para criar novos itens
    func update(_ item: KeychainItem) throws
    
    /// Remove um item do Keychain
    /// - Parameters:
    ///   - account: Identificador do item
    ///   - service: Serviço associado
    ///   - accessGroup: Grupo de acesso (opcional)
    /// - Throws: `KeychainError` se a operação falhar
    ///
    /// **Comportamento**:
    /// - Se o item não existe, não lança erro (operação é idempotente)
    func delete(account: String, service: String, accessGroup: String?) throws
    
    /// Verifica se um item existe no Keychain
    /// - Parameters:
    ///   - account: Identificador do item
    ///   - service: Serviço associado
    ///   - accessGroup: Grupo de acesso (opcional)
    /// - Returns: `true` se o item existe, `false` caso contrário
    func exists(account: String, service: String, accessGroup: String?) -> Bool
}

// MARK: - Convenience Methods

extension KeychainServiceProtocol {
    
    /// Carrega um item sem access group (usa defaults)
    /// - Parameters:
    ///   - account: Identificador do item
    ///   - service: Serviço associado
    /// - Returns: KeychainItem com os dados
    /// - Throws: `KeychainError` se a operação falhar
    func load(account: String, service: String) throws -> KeychainItem {
        try load(account: account, service: service, accessGroup: nil)
    }
    
    /// Remove um item sem access group (usa defaults)
    /// - Parameters:
    ///   - account: Identificador do item
    ///   - service: Serviço associado
    /// - Throws: `KeychainError` se a operação falhar
    func delete(account: String, service: String) throws {
        try delete(account: account, service: service, accessGroup: nil)
    }
    
    /// Verifica se um item existe sem access group (usa defaults)
    /// - Parameters:
    ///   - account: Identificador do item
    ///   - service: Serviço associado
    /// - Returns: `true` se o item existe
    func exists(account: String, service: String) -> Bool {
        exists(account: account, service: service, accessGroup: nil)
    }
}

// MARK: - String Convenience Methods

extension KeychainServiceProtocol {
    
    /// Salva uma string no Keychain
    /// - Parameters:
    ///   - value: String a ser salva
    ///   - account: Identificador do item
    ///   - service: Serviço associado
    ///   - accessibility: Nível de acessibilidade
    /// - Throws: `KeychainError` se a operação falhar
    func saveString(
        _ value: String,
        account: String,
        service: String,
        accessibility: KeychainItem.Accessibility = .whenUnlocked
    ) throws {
        let item = KeychainItem(
            account: account,
            service: service,
            value: value,
            accessibility: accessibility
        )
        try save(item)
    }
    
    /// Carrega uma string do Keychain
    /// - Parameters:
    ///   - account: Identificador do item
    ///   - service: Serviço associado
    /// - Returns: String armazenada
    /// - Throws: `KeychainError` se não encontrado ou conversão falhar
    func loadString(account: String, service: String) throws -> String {
        let item = try load(account: account, service: service)
        
        guard let string = item.stringValue else {
            throw KeychainError.invalidData
        }
        
        return string
    }
    
    /// Atualiza uma string no Keychain
    /// - Parameters:
    ///   - value: Nova string
    ///   - account: Identificador do item
    ///   - service: Serviço associado
    ///   - accessibility: Nível de acessibilidade
    /// - Throws: `KeychainError` se a operação falhar
    func updateString(
        _ value: String,
        account: String,
        service: String,
        accessibility: KeychainItem.Accessibility = .whenUnlocked
    ) throws {
        let item = KeychainItem(
            account: account,
            service: service,
            value: value,
            accessibility: accessibility
        )
        try update(item)
    }
}

// MARK: - Last.fm Convenience Methods

extension KeychainServiceProtocol {
    
    /// Salva session key do Last.fm
    /// - Parameter sessionKey: Chave de sessão
    /// - Throws: `KeychainError` se a operação falhar
    func saveLastFMSession(_ sessionKey: String) throws {
        let item = KeychainItem.lastFMSession(sessionKey: sessionKey)
        try save(item)
    }
    
    /// Carrega session key do Last.fm
    /// - Returns: Chave de sessão
    /// - Throws: `KeychainError` se não encontrado
    func loadLastFMSession() throws -> String {
        let service = Bundle.main.bundleIdentifier ?? "com.diegocastilho.NowPlaying"
        return try loadString(account: "lastfm_session_key", service: service)
    }
    
    /// Salva username do Last.fm
    /// - Parameter username: Nome de usuário
    /// - Throws: `KeychainError` se a operação falhar
    func saveLastFMUsername(_ username: String) throws {
        let item = KeychainItem.lastFMUsername(username: username)
        try save(item)
    }
    
    /// Carrega username do Last.fm
    /// - Returns: Nome de usuário
    /// - Throws: `KeychainError` se não encontrado
    func loadLastFMUsername() throws -> String {
        let service = Bundle.main.bundleIdentifier ?? "com.diegocastilho.NowPlaying"
        return try loadString(account: "lastfm_username", service: service)
    }
    
    /// Remove todas as credenciais do Last.fm
    /// - Throws: `KeychainError` se a operação falhar
    func deleteAllLastFMCredentials() throws {
        let service = Bundle.main.bundleIdentifier ?? "com.diegocastilho.NowPlaying"
        
        // Session key
        try? delete(account: "lastfm_session_key", service: service)
        
        // Username
        try? delete(account: "lastfm_username", service: service)
        
        // Credenciais antiga
    }
}
