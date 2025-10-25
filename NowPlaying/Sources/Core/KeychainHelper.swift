//
//  KeychainHelper.swift
//  NowPlaying
//
//  ⚠️ DEPRECATED: Use KeychainService ao invés desta classe
//  Mantido apenas para compatibilidade durante migração
//

import Foundation
import Security

/// Helper para acesso ao Keychain
///
/// ⚠️ **DEPRECATED**: Esta classe está obsoleta.
/// Use `KeychainService` para novo código.
///
/// **Migração**:
/// ```swift
/// // Antigo (deprecated)
/// KeychainHelper.shared.set("value", for: "key")
/// let value = KeychainHelper.shared.get("key")
///
/// // Novo (recomendado)
/// let item = KeychainItem(account: "key", service: "...", value: "value")
/// try KeychainService.shared.save(item)
/// let loaded = try KeychainService.shared.loadString(account: "key", service: "...")
/// ```
@available(*, deprecated, message: "Use KeychainService ao invés desta classe")
final class KeychainHelper {
    
    // MARK: - Singleton
    
    static let shared = KeychainHelper()
    
    private init() {
        print("⚠️ KeychainHelper (deprecated) está sendo usado - migre para KeychainService")
    }
    
    // MARK: - Public Methods (Deprecated)
    
    /// Salva um valor no Keychain
    /// - Parameters:
    ///   - value: String a ser salva
    ///   - key: Chave de identificação
    ///
    /// ⚠️ **DEPRECATED**: Use `KeychainService.shared.saveString(_:account:service:)`
    @available(*, deprecated, message: "Use KeychainService.shared.saveString(_:account:service:)")
    func set(_ value: String, for key: String) {
        let data = Data(value.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "NowPlaying",
            kSecAttrAccount as String: key
        ]
        
        // Deletar item existente
        SecItemDelete(query as CFDictionary)
        
        // Adicionar novo item
        let attrs = query.merging([kSecValueData as String: data]) { $1 }
        let status = SecItemAdd(attrs as CFDictionary, nil)
        
        if status != errSecSuccess {
            print("⚠️ [KeychainHelper] Erro ao salvar: \(status)")
        }
    }
    
    /// Recupera um valor do Keychain
    /// - Parameter key: Chave de identificação
    /// - Returns: String armazenada ou nil
    ///
    /// ⚠️ **DEPRECATED**: Use `KeychainService.shared.loadString(account:service:)`
    @available(*, deprecated, message: "Use KeychainService.shared.loadString(account:service:)")
    func get(_ key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "NowPlaying",
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess,
              let data = item as? Data,
              let str = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return str
    }
    
    /// Remove um valor do Keychain
    /// - Parameter key: Chave de identificação
    ///
    /// ⚠️ **DEPRECATED**: Use `KeychainService.shared.delete(account:service:)`
    @available(*, deprecated, message: "Use KeychainService.shared.delete(account:service:)")
    func remove(_ key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "NowPlaying",
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess && status != errSecItemNotFound {
            print("⚠️ [KeychainHelper] Erro ao remover: \(status)")
        }
    }
}

// MARK: - Migration Bridge

extension KeychainHelper {
    
    /// Verifica se há dados no formato antigo que precisam ser migrados
    /// - Returns: `true` se há dados para migrar
    func hasLegacyData() -> Bool {
        let legacyKeys = ["lastfm_sessionKey", "lastfm_username"]
        
        for key in legacyKeys {
            if get(key) != nil {
                return true
            }
        }
        
        return false
    }
    
    /// Retorna todos os dados legacy para migração
    /// - Returns: Dicionário com dados encontrados
    func getAllLegacyData() -> [String: String] {
        var data: [String: String] = [:]
        
        let legacyKeys = ["lastfm_sessionKey", "lastfm_username"]
        
        for key in legacyKeys {
            if let value = get(key) {
                data[key] = value
            }
        }
        
        return data
    }
}
