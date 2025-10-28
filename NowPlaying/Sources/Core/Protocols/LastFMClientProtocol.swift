//
//  LastFMClientProtocol.swift
//  NowPlaying
//
//  Protocol para Last.fm API client
//
//  Created by Diego Castilho on 26/10/25
//  Copyright © 2025 Diego Castilho. All rights reserved.
//

import Foundation

/// Protocol que define operações do Last.fm API Client
///
/// Permite:
/// - Dependency Injection
/// - Mock implementations para testes
/// - Substituição de implementação sem mudança de código
@MainActor
protocol LastFMClientProtocol: AnyObject, ObservableObject {
    
    // MARK: - Published Properties
    
    /// Session key do usuário autenticado
    var sessionKey: String? { get set }
    
    /// Username do usuário autenticado
    var username: String? { get set }
    
    // MARK: - Authentication
    
    /// Obtém um token de autenticação do Last.fm
    /// - Returns: Token para usar no fluxo de OAuth
    /// - Throws: LastFMError se falhar
    func getToken() async throws -> String
    
    /// URL de autenticação para o usuário autorizar o app
    /// - Parameter token: Token obtido via getToken()
    /// - Returns: URL para abrir no navegador
    func authURL(token: String) -> URL
    
    /// Obtém session key após usuário autorizar
    /// - Parameter token: Token autorizado pelo usuário
    /// - Throws: LastFMError se falhar ou token inválido
    func getSession(with token: String) async throws
    
    /// Faz logout e limpa credenciais
    func signOut()
    
    // MARK: - Scrobbling
    
    /// Atualiza "Now Playing" no Last.fm
    /// - Parameters:
    ///   - artist: Nome do artista
    ///   - track: Nome da música
    ///   - album: Nome do álbum (opcional)
    ///   - durationSec: Duração em segundos (opcional)
    /// - Throws: LastFMError se falhar
    func updateNowPlaying(
        artist: String,
        track: String,
        album: String?,
        durationSec: Int?
    ) async throws
    
    /// Envia um scrobble para o Last.fm
    /// - Parameters:
    ///   - artist: Nome do artista
    ///   - track: Nome da música
    ///   - album: Nome do álbum (opcional)
    ///   - timestamp: Unix timestamp de quando a música começou
    ///   - durationSec: Duração em segundos (opcional)
    /// - Throws: LastFMError se falhar
    func scrobble(
        artist: String,
        track: String,
        album: String?,
        timestamp: Int,
        durationSec: Int?
    ) async throws
    
    // MARK: - Data Fetching
    
    /// Busca músicas recentes do usuário
    /// - Parameter limit: Número de músicas (default: 30)
    /// - Returns: Array de dicionários com dados das músicas
    /// - Throws: LastFMError se falhar
    func fetchRecentTracks(limit: Int) async throws -> [[String: Any]]
    
    /// Busca URL do artwork da música
    /// - Parameters:
    ///   - artist: Nome do artista
    ///   - track: Nome da música
    ///   - album: Nome do álbum (opcional)
    /// - Returns: URL do artwork ou nil se não encontrado
    func fetchArtworkURL(
        artist: String,
        track: String,
        album: String?
    ) async -> URL?
}

// MARK: - Default Implementations

extension LastFMClientProtocol {
    
    /// fetchRecentTracks com limit padrão
    func fetchRecentTracks() async throws -> [[String: Any]] {
        try await fetchRecentTracks(limit: 30)
    }
}
