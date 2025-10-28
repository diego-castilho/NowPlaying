//
//  MockLastFMClient.swift
//  NowPlaying
//
//  Mock implementation do LastFMClient para testes
//
//  Created by Diego Castilho on 28/10/25
//  Copyright © 2025 Diego Castilho. All rights reserved.
//

import Foundation
import Combine

/// Mock do LastFMClient para testes unitários
///
/// Permite testar código que depende de LastFMClient sem:
/// - Fazer chamadas de rede reais
/// - Precisar de credenciais Last.fm
/// - Depender de conexão com internet
///
/// Uso em testes:
/// ```swift
/// let mock = MockLastFMClient()
/// mock.sessionKey = "fake-session-key"
/// mock.username = "testuser"
///
/// let manager = ScrobbleManager(lastfm: mock, ...)
/// // Testar sem rede!
/// ```
@MainActor
final class MockLastFMClient: LastFMClientProtocol {
    
    // MARK: - Published Properties (ObservableObject)
    
    /// Session key mockada
    @Published var sessionKey: String?
    
    /// Username mockado
    @Published var username: String?
    
    // MARK: - Test Configuration
    
    /// Se true, métodos de autenticação falham
    var shouldFailAuth = false
    
    /// Se true, métodos de scrobbling falham
    var shouldFailScrobble = false
    
    /// Se true, métodos de fetching falham
    var shouldFailFetch = false
    
    /// Delay artificial para simular latência de rede (em segundos)
    var networkDelay: TimeInterval = 0
    
    /// Erro customizado para retornar quando operações falham
    var mockError: Error = LastFMError(code: 999, message: "Mock error")
    
    // MARK: - Call Tracking (para asserts em testes)
    
    /// Número de vezes que getToken() foi chamado
    var getTokenCallCount = 0
    
    /// Número de vezes que getSession() foi chamado
    var getSessionCallCount = 0
    
    /// Número de vezes que updateNowPlaying() foi chamado
    var updateNowPlayingCallCount = 0
    
    /// Número de vezes que scrobble() foi chamado
    var scrobbleCallCount = 0
    
    /// Número de vezes que fetchRecentTracks() foi chamado
    var fetchRecentTracksCallCount = 0
    
    /// Número de vezes que fetchArtworkURL() foi chamado
    var fetchArtworkURLCallCount = 0
    
    /// Número de vezes que signOut() foi chamado
    var signOutCallCount = 0
    
    /// Última música enviada via updateNowPlaying
    var lastNowPlayingTrack: (artist: String, track: String, album: String?)?
    
    /// Última música scrobbled
    var lastScrobbledTrack: (artist: String, track: String, album: String?, timestamp: Int)?
    
    /// Histórico completo de scrobbles
    var scrobbleHistory: [(artist: String, track: String, album: String?, timestamp: Int)] = []
    
    // MARK: - Mock Data
    
    /// Token mockado retornado por getToken()
    var mockToken = "mock-token-12345"
    
    /// URL de autenticação mockada
    var mockAuthURL = URL(string: "https://www.last.fm/api/auth?api_key=mock&token=mock")!
    
    /// Músicas recentes mockadas para fetchRecentTracks()
    var mockRecentTracks: [[String: Any]] = []
    
    /// URL de artwork mockada para fetchArtworkURL()
    var mockArtworkURL: URL?
    
    // MARK: - Initialization
    
    init() {
        print("🎭 MockLastFMClient: Inicializado")
    }
    
    // MARK: - Authentication
    
    func getToken() async throws -> String {
        getTokenCallCount += 1
        print("🎭 MockLastFMClient.getToken() chamado (count: \(getTokenCallCount))")
        
        if networkDelay > 0 {
            try await Task.sleep(for: .seconds(networkDelay))
        }
        
        if shouldFailAuth {
            print("🎭 MockLastFMClient.getToken() → ERRO (configurado para falhar)")
            throw mockError
        }
        
        print("🎭 MockLastFMClient.getToken() → SUCCESS: \(mockToken)")
        return mockToken
    }
    
    func authURL(token: String) -> URL {
        print("🎭 MockLastFMClient.authURL(token: \(token)) → \(mockAuthURL)")
        return mockAuthURL
    }
    
    func getSession(with token: String) async throws {
        getSessionCallCount += 1
        print("🎭 MockLastFMClient.getSession(token: \(token)) chamado (count: \(getSessionCallCount))")
        
        if networkDelay > 0 {
            try await Task.sleep(for: .seconds(networkDelay))
        }
        
        if shouldFailAuth {
            print("🎭 MockLastFMClient.getSession() → ERRO (configurado para falhar)")
            throw mockError
        }
        
        // Simular sucesso: definir session key e username
        sessionKey = "mock-session-key-\(UUID().uuidString.prefix(8))"
        username = "mockuser"
        
        print("🎭 MockLastFMClient.getSession() → SUCCESS")
        print("   - sessionKey: \(sessionKey ?? "nil")")
        print("   - username: \(username ?? "nil")")
    }
    
    func signOut() {
        signOutCallCount += 1
        print("🎭 MockLastFMClient.signOut() chamado (count: \(signOutCallCount))")
        
        sessionKey = nil
        username = nil
        
        print("🎭 MockLastFMClient.signOut() → Credenciais limpas")
    }
    
    // MARK: - Scrobbling
    
    func updateNowPlaying(
        artist: String,
        track: String,
        album: String?,
        durationSec: Int?
    ) async throws {
        updateNowPlayingCallCount += 1
        print("🎭 MockLastFMClient.updateNowPlaying() chamado (count: \(updateNowPlayingCallCount))")
        print("   - Artist: \(artist)")
        print("   - Track: \(track)")
        print("   - Album: \(album ?? "nil")")
        print("   - Duration: \(durationSec?.description ?? "nil")s")
        
        if networkDelay > 0 {
            try await Task.sleep(for: .seconds(networkDelay))
        }
        
        if shouldFailScrobble {
            print("🎭 MockLastFMClient.updateNowPlaying() → ERRO (configurado para falhar)")
            throw mockError
        }
        
        // Armazenar para verificação em testes
        lastNowPlayingTrack = (artist, track, album)
        
        print("🎭 MockLastFMClient.updateNowPlaying() → SUCCESS")
    }
    
    func scrobble(
        artist: String,
        track: String,
        album: String?,
        timestamp: Int,
        durationSec: Int?
    ) async throws {
        scrobbleCallCount += 1
        print("🎭 MockLastFMClient.scrobble() chamado (count: \(scrobbleCallCount))")
        print("   - Artist: \(artist)")
        print("   - Track: \(track)")
        print("   - Album: \(album ?? "nil")")
        print("   - Timestamp: \(timestamp)")
        print("   - Duration: \(durationSec?.description ?? "nil")s")
        
        if networkDelay > 0 {
            try await Task.sleep(for: .seconds(networkDelay))
        }
        
        if shouldFailScrobble {
            print("🎭 MockLastFMClient.scrobble() → ERRO (configurado para falhar)")
            throw mockError
        }
        
        // Armazenar para verificação em testes
        lastScrobbledTrack = (artist, track, album, timestamp)
        scrobbleHistory.append((artist, track, album, timestamp))
        
        print("🎭 MockLastFMClient.scrobble() → SUCCESS")
        print("   - Total scrobbles: \(scrobbleHistory.count)")
    }
    
    // MARK: - Data Fetching
    
    func fetchRecentTracks(limit: Int = 30) async throws -> [[String: Any]] {
        fetchRecentTracksCallCount += 1
        print("🎭 MockLastFMClient.fetchRecentTracks(limit: \(limit)) chamado (count: \(fetchRecentTracksCallCount))")
        
        if networkDelay > 0 {
            try await Task.sleep(for: .seconds(networkDelay))
        }
        
        if shouldFailFetch {
            print("🎭 MockLastFMClient.fetchRecentTracks() → ERRO (configurado para falhar)")
            throw mockError
        }
        
        print("🎭 MockLastFMClient.fetchRecentTracks() → SUCCESS (\(mockRecentTracks.count) tracks)")
        return mockRecentTracks
    }
    
    func fetchArtworkURL(
        artist: String,
        track: String,
        album: String?
    ) async -> URL? {
        fetchArtworkURLCallCount += 1
        print("🎭 MockLastFMClient.fetchArtworkURL() chamado (count: \(fetchArtworkURLCallCount))")
        print("   - Artist: \(artist)")
        print("   - Track: \(track)")
        print("   - Album: \(album ?? "nil")")
        
        if networkDelay > 0 {
            try? await Task.sleep(for: .seconds(networkDelay))
        }
        
        print("🎭 MockLastFMClient.fetchArtworkURL() → \(mockArtworkURL?.absoluteString ?? "nil")")
        return mockArtworkURL
    }
    
    // MARK: - Test Helpers
    
    /// Reseta todos os contadores de chamadas
    func resetCallCounts() {
        getTokenCallCount = 0
        getSessionCallCount = 0
        updateNowPlayingCallCount = 0
        scrobbleCallCount = 0
        fetchRecentTracksCallCount = 0
        fetchArtworkURLCallCount = 0
        signOutCallCount = 0
        
        print("🎭 MockLastFMClient: Contadores resetados")
    }
    
    /// Reseta todo o estado do mock
    func reset() {
        resetCallCounts()
        
        sessionKey = nil
        username = nil
        shouldFailAuth = false
        shouldFailScrobble = false
        shouldFailFetch = false
        networkDelay = 0
        
        lastNowPlayingTrack = nil
        lastScrobbledTrack = nil
        scrobbleHistory.removeAll()
        mockRecentTracks.removeAll()
        mockArtworkURL = nil
        
        print("🎭 MockLastFMClient: Estado completo resetado")
    }
    
    /// Configura mock data de exemplo para testes
    func setupMockData() {
        mockRecentTracks = [
            [
                "name": "Bohemian Rhapsody",
                "artist": ["#text": "Queen"],
                "album": ["#text": "A Night at the Opera"],
                "date": ["uts": "1234567890"]
            ],
            [
                "name": "Stairway to Heaven",
                "artist": ["#text": "Led Zeppelin"],
                "album": ["#text": "Led Zeppelin IV"],
                "date": ["uts": "1234567800"]
            ]
        ]
        
        mockArtworkURL = URL(string: "https://example.com/artwork.jpg")
        
        print("🎭 MockLastFMClient: Mock data configurado")
    }
}

// MARK: - Convenience Initializers para Testes

extension MockLastFMClient {
    
    /// Mock já autenticado (com session key e username)
    static func authenticated(username: String = "testuser") -> MockLastFMClient {
        let mock = MockLastFMClient()
        mock.sessionKey = "mock-session-\(UUID().uuidString.prefix(8))"
        mock.username = username
        print("🎭 MockLastFMClient.authenticated(username: \(username)) criado")
        return mock
    }
    
    /// Mock configurado para falhar em autenticação
    static func failingAuth() -> MockLastFMClient {
        let mock = MockLastFMClient()
        mock.shouldFailAuth = true
        print("🎭 MockLastFMClient.failingAuth() criado")
        return mock
    }
    
    /// Mock configurado para falhar em scrobbles
    static func failingScrobble() -> MockLastFMClient {
        let mock = MockLastFMClient()
        mock.shouldFailScrobble = true
        print("🎭 MockLastFMClient.failingScrobble() criado")
        return mock
    }
    
    /// Mock com latência de rede simulada
    static func withNetworkDelay(_ delay: TimeInterval) -> MockLastFMClient {
        let mock = MockLastFMClient()
        mock.networkDelay = delay
        print("🎭 MockLastFMClient.withNetworkDelay(\(delay)s) criado")
        return mock
    }
}
