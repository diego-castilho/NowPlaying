//
//  KeychainServiceProtocol.swift
//  NowPlaying
//
//  Protocol para serviços de Keychain com suporte a Swift Concurrency
//

import Foundation

/// Protocol que define operações do Keychain com async/await
protocol KeychainServiceProtocol: Actor {
    
    // MARK: - CRUD Operations
    
    /// Salva um item no Keychain
    /// - Parameter item: Item a ser salvo
    /// - Throws: KeychainError se a operação falhar
    func save(_ item: KeychainItem) async throws
    
    /// Carrega um item do Keychain
    /// - Parameters:
    ///   - account: Account do item
    ///   - service: Service do item
    ///   - accessGroup: Access group (opcional)
    /// - Returns: KeychainItem encontrado
    /// - Throws: KeychainError se não encontrar ou falhar
    func load(account: String, service: String, accessGroup: String?) async throws -> KeychainItem
    
    /// Atualiza um item existente no Keychain
    /// - Parameter item: Item com novos valores
    /// - Throws: KeychainError se não encontrar ou falhar
    func update(_ item: KeychainItem) async throws
    
    /// Remove um item do Keychain
    /// - Parameters:
    ///   - account: Account do item
    ///   - service: Service do item
    ///   - accessGroup: Access group (opcional)
    /// - Throws: KeychainError se não encontrar ou falhar
    func delete(account: String, service: String, accessGroup: String?) async throws
    
    /// Verifica se um item existe no Keychain
    /// - Parameters:
    ///   - account: Account do item
    ///   - service: Service do item
    ///   - accessGroup: Access group (opcional)
    /// - Returns: true se existe, false caso contrário
    func exists(account: String, service: String, accessGroup: String?) async -> Bool
}

// MARK: - Convenience Extensions

extension KeychainServiceProtocol {
    
    // MARK: - CRUD sem Access Group
    
    /// Carrega um item sem especificar access group
    func load(account: String, service: String) async throws -> KeychainItem {
        try await load(account: account, service: service, accessGroup: nil)
    }
    
    /// Remove um item sem especificar access group
    func delete(account: String, service: String) async throws {
        try await delete(account: account, service: service, accessGroup: nil)
    }
    
    /// Verifica existência sem especificar access group
    func exists(account: String, service: String) async -> Bool {
        await exists(account: account, service: service, accessGroup: nil)
    }
    
    // MARK: - String Helpers
    
    /// Salva uma string no Keychain
    func saveString(_ value: String, account: String, service: String, accessibility: KeychainItem.Accessibility = .whenUnlocked) async throws {
        let item = KeychainItem(
            account: account,
            service: service,
            value: value,
            accessGroup: nil,
            accessibility: accessibility
        )
        try await save(item)
    }
    
    /// Carrega uma string do Keychain
    func loadString(account: String, service: String) async throws -> String {
        let item = try await load(account: account, service: service)
        guard let string = item.stringValue else {
            throw KeychainError.invalidData
        }
        return string
    }
    
    /// Atualiza uma string no Keychain
    func updateString(_ value: String, account: String, service: String) async throws {
        let item = KeychainItem(
            account: account,
            service: service,
            value: value,
            accessGroup: nil,
            accessibility: .whenUnlocked
        )
        try await update(item)
    }
    
    // MARK: - Last.fm Specific
    
    /// Salva session key do Last.fm
    func saveLastFMSession(_ sessionKey: String) async throws {
        let item = KeychainItem.lastFMSession(sessionKey: sessionKey)
        try await save(item)
    }
    
    /// Carrega session key do Last.fm
    func loadLastFMSession() async throws -> String {
        let service = Bundle.main.bundleIdentifier ?? "com.diegocastilho.NowPlaying"
        return try await loadString(account: "lastfm_session_key", service: service)
    }
    
    /// Salva username do Last.fm
    func saveLastFMUsername(_ username: String) async throws {
        let item = KeychainItem.lastFMUsername(username: username)
        try await save(item)
    }
    
    /// Carrega username do Last.fm
    func loadLastFMUsername() async throws -> String {
        let service = Bundle.main.bundleIdentifier ?? "com.diegocastilho.NowPlaying"
        return try await loadString(account: "lastfm_username", service: service)
    }
    
    /// Remove todas as credenciais do Last.fm
    func deleteAllLastFMCredentials() async throws {
        let service = Bundle.main.bundleIdentifier ?? "com.diegocastilho.NowPlaying"
        
        do {
            try await delete(account: "lastfm_session_key", service: service)
        } catch KeychainError.itemNotFound {
            // OK, item já não existe
        }
        
        do {
            try await delete(account: "lastfm_username", service: service)
        } catch KeychainError.itemNotFound {
            // OK, item já não existe
        }
    }
    
    // MARK: - Batch Operations
    
    /// Salva múltiplos items de uma vez
    func saveBatch(_ items: [KeychainItem]) async throws {
        for item in items {
            try await save(item)
        }
    }
    
    /// Remove múltiplos items de uma vez
    func deleteBatch(_ items: [(account: String, service: String)]) async throws {
        for (account, service) in items {
            try await delete(account: account, service: service)
        }
    }
    
    // MARK: - Migration Helper
    
    /// Migra um item de um account para outro
    func migrate(from oldAccount: String, to newAccount: String, service: String) async throws {
        do {
            let oldItem = try await load(account: oldAccount, service: service)
            
            // Criar novo item com novo account
            let newItem = KeychainItem(
                account: newAccount,
                service: oldItem.service,
                data: oldItem.data,
                accessGroup: oldItem.accessGroup,
                accessibility: oldItem.accessibility
            )
            
            try await save(newItem)
            try await delete(account: oldAccount, service: service)
            print("✅ Migração: \(oldAccount) → \(newAccount)")
        } catch {
            print("⚠️ Erro na migração de \(oldAccount): \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Upsert (Save or Update)
    
    /// Salva ou atualiza um item (upsert)
    func saveOrUpdate(_ item: KeychainItem) async throws {
        let itemExists = await exists(
            account: item.account,
            service: item.service,
            accessGroup: item.accessGroup
        )
        
        if itemExists {
            try await update(item)
        } else {
            try await save(item)
        }
    }
}
