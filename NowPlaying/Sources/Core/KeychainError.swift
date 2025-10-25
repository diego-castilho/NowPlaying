//
//  KeychainError.swift
//  NowPlaying
//
//  Sistema de erros para operações de Keychain

//  Created by Diego Castilho on 25/10/25
//  Copyright © 2025 Diego Castilho. All rights reserved.
//

import Foundation
import Security

/// Erros específicos de operações no Keychain
enum KeychainError: LocalizedError {
    
    // MARK: - Error Cases
    
    /// Item não encontrado no Keychain
    case itemNotFound
    
    /// Acesso ao item foi negado (permissões)
    case accessDenied
    
    /// Operação não foi autorizada (autenticação necessária)
    case authenticationRequired
    
    /// Item já existe no Keychain (ao tentar adicionar duplicado)
    case duplicateItem
    
    /// Dados inválidos ou corrompidos
    case invalidData
    
    /// Erro de codificação/decodificação
    case encodingError(String)
    
    /// Erro não mapeado do Keychain
    case unhandledError(OSStatus)
    
    /// Operação cancelada pelo usuário
    case userCanceled
    
    // MARK: - Error Descriptions
    
    var errorDescription: String? {
        switch self {
        case .itemNotFound:
            return "Item não encontrado no Keychain"
            
        case .accessDenied:
            return "Acesso negado ao Keychain. Verifique as permissões do app"
            
        case .authenticationRequired:
            return "Autenticação necessária para acessar este item"
            
        case .duplicateItem:
            return "Item já existe no Keychain"
            
        case .invalidData:
            return "Dados inválidos ou corrompidos no Keychain"
            
        case .encodingError(let detail):
            return "Erro ao codificar dados: \(detail)"
            
        case .unhandledError(let status):
            return "Erro do Keychain não tratado: \(status)"
            
        case .userCanceled:
            return "Operação cancelada pelo usuário"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .itemNotFound:
            return "O item solicitado não está armazenado no Keychain"
            
        case .accessDenied:
            return "O sistema negou acesso ao Keychain. Pode ser um problema de sandbox ou entitlements"
            
        case .authenticationRequired:
            return "Este item requer autenticação do usuário (Touch ID, senha, etc)"
            
        case .duplicateItem:
            return "Um item com as mesmas características já está salvo"
            
        case .invalidData:
            return "Os dados armazenados estão em formato inválido ou foram corrompidos"
            
        case .encodingError:
            return "Falha ao converter dados para formato do Keychain"
            
        case .unhandledError(let status):
            return "Código de erro OSStatus: \(status)"
            
        case .userCanceled:
            return "O usuário cancelou a operação de autenticação"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .itemNotFound:
            return "Verifique se o item foi salvo anteriormente ou se as credenciais de busca estão corretas"
            
        case .accessDenied:
            return "Verifique os entitlements do app e se o Keychain Access está habilitado"
            
        case .authenticationRequired:
            return "Autentique-se usando Touch ID, Face ID ou senha do sistema"
            
        case .duplicateItem:
            return "Use o método update() ao invés de save() para atualizar um item existente"
            
        case .invalidData:
            return "Tente remover e recriar o item no Keychain"
            
        case .encodingError:
            return "Verifique se os dados estão em formato válido e serializável"
            
        case .unhandledError:
            return "Consulte a documentação do Security framework da Apple para mais detalhes"
            
        case .userCanceled:
            return "Tente a operação novamente e complete a autenticação"
        }
    }
    
    // MARK: - Error Mapping
    
    /// Mapeia um OSStatus do Keychain para KeychainError
    /// - Parameter status: Código de status retornado pelo Keychain
    /// - Returns: KeychainError correspondente
    static func from(status: OSStatus) -> KeychainError {
        switch status {
        case errSecItemNotFound:
            return .itemNotFound
            
        case errSecAuthFailed, errSecNotAvailable:
            return .accessDenied
            
        case errSecUserCanceled:
            return .userCanceled
            
        case errSecDuplicateItem:
            return .duplicateItem
            
        case errSecDecode, errSecInvalidData:
            return .invalidData
            
        case errSecInteractionNotAllowed:
            return .authenticationRequired
            
        default:
            return .unhandledError(status)
        }
    }
}

// MARK: - Debug Helpers

extension KeychainError {
    
    /// Retorna uma descrição detalhada para debug
    var debugDescription: String {
        """
        🔐 KeychainError:
        • Erro: \(errorDescription ?? "Desconhecido")
        • Razão: \(failureReason ?? "Não especificada")
        • Solução: \(recoverySuggestion ?? "Não disponível")
        """
    }
}
