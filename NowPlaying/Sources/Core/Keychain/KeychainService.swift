//
//  ModernKeychainService.swift
//  NowPlaying
//
//  Implementação moderna do serviço de Keychain
//

import Foundation
import Security

/// Implementação concreta do KeychainServiceProtocol
///
/// **Thread-Safety**: Todas as operações são thread-safe
/// **Singleton**: Acesse via `KeychainService.shared`
///
/// **Exemplo de uso**:
/// ```swift
/// let service = KeychainService.shared
/// let item = KeychainItem.lastFMSession(sessionKey: "abc123")
/// try service.save(item)
/// ```

actor KeychainService: KeychainServiceProtocol {
    
    // MARK: - Singleton
    
    /// Instância compartilhada
    static let shared = KeychainService()
    
    private init() {
        print("🔐 KeychainService inicializado")
    }
    
    // MARK: - CRUD Operations
    
    func save(_ item: KeychainItem) throws {
        let query = item.buildQuery(includeData: true)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            if status == errSecDuplicateItem {
                print("⚠️ Item já existe no Keychain: \(item.account)")
            } else {
                print("❌ Erro ao salvar no Keychain: \(status)")
            }
            throw KeychainError.from(status: status)
        }
        
        print("✅ Item salvo no Keychain: \(item.account)")
    }
    
    func load(account: String, service: String, accessGroup: String? = nil) throws -> KeychainItem {
        let query = KeychainItem.searchQuery(
            account: account,
            service: service,
            accessGroup: accessGroup
        )
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                print("⚠️ Item não encontrado no Keychain: \(account)")
            } else {
                print("❌ Erro ao carregar do Keychain: \(status)")
            }
            throw KeychainError.from(status: status)
        }
        
        guard let data = result as? Data else {
            print("❌ Dados inválidos no Keychain para: \(account)")
            throw KeychainError.invalidData
        }
        
        print("✅ Item carregado do Keychain: \(account)")
        
        return KeychainItem.from(
            account: account,
            service: service,
            data: data,
            accessGroup: accessGroup
        )
    }
    
    func update(_ item: KeychainItem) throws {
        // Query para encontrar o item
        let searchQuery = KeychainItem.searchQuery(
            account: item.account,
            service: item.service,
            accessGroup: item.accessGroup
        )
        
        // Atributos a atualizar
        let updateAttributes: [String: Any] = [
            kSecValueData as String: item.data,
            kSecAttrAccessible as String: item.accessibility.secAttrAccessible
        ]
        
        let status = SecItemUpdate(
            searchQuery as CFDictionary,
            updateAttributes as CFDictionary
        )
        
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                print("⚠️ Item não encontrado para atualizar: \(item.account)")
            } else {
                print("❌ Erro ao atualizar no Keychain: \(status)")
            }
            throw KeychainError.from(status: status)
        }
        
        print("✅ Item atualizado no Keychain: \(item.account)")
    }
    
    func delete(account: String, service: String, accessGroup: String? = nil) throws {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service
        ]
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        
        let status = SecItemDelete(query as CFDictionary)
        
        // Não consideramos itemNotFound como erro (operação idempotente)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            print("❌ Erro ao deletar do Keychain: \(status)")
            throw KeychainError.from(status: status)
        }
        
        if status == errSecItemNotFound {
            print("ℹ️ Item não existia no Keychain: \(account)")
        } else {
            print("✅ Item deletado do Keychain: \(account)")
        }
    }
    
    func exists(account: String, service: String, accessGroup: String? = nil) -> Bool {
        do {
            _ = try load(account: account, service: service, accessGroup: accessGroup)
            return true
        } catch {
            return false
        }
    }
}

// MARK: - Save or Update

extension KeychainService {
    
    /// Salva ou atualiza um item (upsert)
    /// - Parameter item: Item a salvar/atualizar
    /// - Throws: `KeychainError` se a operação falhar
    ///
    /// **Comportamento**:
    /// - Tenta salvar primeiro
    /// - Se já existe, atualiza
    func saveOrUpdate(_ item: KeychainItem) throws {
        do {
            try save(item)
        } catch KeychainError.duplicateItem {
            // Item já existe, atualizar
            try update(item)
        }
    }
}

// MARK: - Migration Support

extension KeychainService {
    
    /// Migra dados do KeychainHelper antigo para o novo sistema
    /// - Throws: `KeychainError` se a migração falhar
    ///
    /// **O que faz**:
    /// 1. Tenta carregar session key antiga
    /// 2. Se encontrar, salva no novo formato
    /// 3. Remove formato antigo
    /// 4. Repete para username
    func migrateFromLegacyKeychain() throws {
        let service = Bundle.main.bundleIdentifier ?? "com.diegocastilho.NowPlaying"
        
        print("🔄 Iniciando migração do Keychain legacy...")
        
        // Migrar session key
        if let sessionKey = KeychainHelper.shared.get("lastfm_sessionKey") {
            print("📦 Encontrado session key antigo, migrando...")
            
            let item = KeychainItem.lastFMSession(sessionKey: sessionKey)
            try? saveOrUpdate(item)
            
            // Remover formato antigo
            KeychainHelper.shared.remove("lastfm_sessionKey")
            print("✅ Session key migrado com sucesso")
        }
        
        // Migrar username
        if let username = KeychainHelper.shared.get("lastfm_username") {
            print("📦 Encontrado username antigo, migrando...")
            
            let item = KeychainItem.lastFMUsername(username: username)
            try? saveOrUpdate(item)
            
            // Remover formato antigo
            KeychainHelper.shared.remove("lastfm_username")
            print("✅ Username migrado com sucesso")
        }
        
        print("✅ Migração do Keychain concluída")
    }
}

// MARK: - Debug Helpers

extension KeychainService {
    
    /// Lista todos os itens do app no Keychain (apenas para debug)
    /// - Returns: Array de accounts encontrados
    func listAllItems() -> [String] {
        let service = Bundle.main.bundleIdentifier ?? "com.diegocastilho.NowPlaying"
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecReturnAttributes as String: true,
            kSecMatchLimit as String: kSecMatchLimitAll
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let items = result as? [[String: Any]] else {
            return []
        }
        
        return items.compactMap { $0[kSecAttrAccount as String] as? String }
    }
    
    /// Remove TODOS os itens do app (apenas para debug/testes)
    /// ⚠️ CUIDADO: Esta operação é irreversível!
    func deleteAllItems() throws {
        let service = Bundle.main.bundleIdentifier ?? "com.diegocastilho.NowPlaying"
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.from(status: status)
        }
        
        print("🗑️ Todos os itens do Keychain foram removidos")
    }
}

// MARK: - Validation

extension KeychainService {
    
    /// Valida se o Keychain está acessível
    /// - Returns: `true` se o Keychain está funcionando
    ///
    /// **Uso**:
    /// Útil para verificar se o app tem permissões corretas
    func validateKeychainAccess() -> Bool {
        let testItem = KeychainItem(
            account: "test_validation_\(UUID().uuidString)",
            service: Bundle.main.bundleIdentifier ?? "com.diegocastilho.NowPlaying",
            value: "test"
        )
        
        do {
            // Tentar salvar
            try save(testItem)
            
            // Tentar carregar
            _ = try load(
                account: testItem.account,
                service: testItem.service
            )
            
            // Tentar deletar
            try delete(
                account: testItem.account,
                service: testItem.service
            )
            
            print("✅ Keychain está acessível e funcionando")
            return true
            
        } catch {
            print("❌ Erro ao validar acesso ao Keychain: \(error)")
            return false
        }
    }
}

// MARK: - Type Alias for Convenience

/// Alias para facilitar uso (opcional)
typealias Keychain = KeychainService
