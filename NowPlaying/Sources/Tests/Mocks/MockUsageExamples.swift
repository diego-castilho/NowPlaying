//
//  MockUsageExamples.swift
//  NowPlaying
//
//  Exemplos de como usar MockLastFMClient em testes
//  Este arquivo é apenas documentação e não será executado
//
//  Created by Diego Castilho on 28/10/25
//  Copyright © 2025 Diego Castilho. All rights reserved.
//

#if DEBUG
import Foundation
import CoreData
import SwiftUI

/// Exemplos de uso do MockLastFMClient
///
/// Nota: Este código é apenas para documentação.
/// Em testes reais, você usaria XCTest.
enum MockUsageExamples {
    
    // MARK: - Exemplo 1: Testar ScrobbleManager sem rede
    
    static func example1_TestScrobbleManagerIsolated() async {
        print("\n📚 EXEMPLO 1: Testar ScrobbleManager sem rede")
        print("════════════════════════════════════════════════\n")
        
        // Setup: Criar mock
        let mockLastFM = MockLastFMClient.authenticated(username: "testuser")
        
        // Setup: Criar ScrobbleManager com mock
        let context = CoreDataStack.shared.container.viewContext
        let artwork = ArtworkStore()
        let manager = ScrobbleManager(
            lastfm: mockLastFM,
            context: context,
            artwork: artwork
        )
        
        // Test: Simular música tocando
        let info = NowPlayingInfo(
            state: "Playing",
            name: "Bohemian Rhapsody",
            artist: "Queen",
            album: "A Night at the Opera",
            totalMs: 355000
        )
        
        manager.handle(info)
        
        // Aguardar processamento assíncrono
        try? await Task.sleep(for: .seconds(1))
        
        // Assert: Verificar que updateNowPlaying foi chamado
        print("✅ updateNowPlaying chamado: \(mockLastFM.updateNowPlayingCallCount) vez(es)")
        print("✅ Última música: \(mockLastFM.lastNowPlayingTrack?.track ?? "nenhuma")")
        
        // Assert: Verificar dados corretos
        assert(mockLastFM.updateNowPlayingCallCount == 1, "Deveria chamar updateNowPlaying 1 vez")
        assert(mockLastFM.lastNowPlayingTrack?.track == "Bohemian Rhapsody", "Track incorreto")
        assert(mockLastFM.lastNowPlayingTrack?.artist == "Queen", "Artist incorreto")
        
        print("\n✅ EXEMPLO 1: PASSOU!\n")
    }
    
    // MARK: - Exemplo 2: Testar tratamento de erros
    
    static func example2_TestErrorHandling() async {
        print("\n📚 EXEMPLO 2: Testar tratamento de erros")
        print("════════════════════════════════════════════════\n")
        
        // Setup: Mock configurado para falhar
        let mockLastFM = MockLastFMClient.failingScrobble()
        mockLastFM.sessionKey = "fake-key"
        mockLastFM.username = "testuser"
        
        // Test: Tentar scrobble (vai falhar)
        do {
            try await mockLastFM.scrobble(
                artist: "U2",
                track: "Beautiful Day",
                album: "All That You Can't Leave Behind",
                timestamp: Int(Date().timeIntervalSince1970),
                durationSec: 258
            )
            
            print("❌ Não deveria chegar aqui!")
            assert(false, "Scrobble deveria ter falhado")
            
        } catch {
            print("✅ Erro capturado corretamente: \(error.localizedDescription)")
            assert(mockLastFM.scrobbleCallCount == 1, "Deveria tentar scrobble 1 vez")
        }
        
        print("\n✅ EXEMPLO 2: PASSOU!\n")
    }
    
    // MARK: - Exemplo 3: Testar autenticação
    
    static func example3_TestAuthentication() async {
        print("\n📚 EXEMPLO 3: Testar autenticação")
        print("════════════════════════════════════════════════\n")
        
        // Setup: Mock sem autenticação
        let mockLastFM = MockLastFMClient()
        
        // Assert: Inicialmente não está autenticado
        assert(mockLastFM.sessionKey == nil, "Não deveria estar autenticado")
        assert(mockLastFM.username == nil, "Não deveria ter username")
        
        // Test: Obter token
        do {
            let token = try await mockLastFM.getToken()
            print("✅ Token obtido: \(token)")
            assert(mockLastFM.getTokenCallCount == 1, "getToken deveria ser chamado 1 vez")
            
            // Test: Obter session
            try await mockLastFM.getSession(with: token)
            print("✅ Session obtida")
            assert(mockLastFM.getSessionCallCount == 1, "getSession deveria ser chamado 1 vez")
            
            // Assert: Agora está autenticado
            assert(mockLastFM.sessionKey != nil, "Deveria estar autenticado")
            assert(mockLastFM.username != nil, "Deveria ter username")
            print("✅ Autenticado: sessionKey=\(mockLastFM.sessionKey ?? "nil"), username=\(mockLastFM.username ?? "nil")")
            
        } catch {
            print("❌ Não deveria falhar: \(error)")
            assert(false, "Autenticação não deveria falhar")
        }
        
        print("\n✅ EXEMPLO 3: PASSOU!\n")
    }
    
    // MARK: - Exemplo 4: Testar com latência de rede
    
    static func example4_TestWithNetworkDelay() async {
        print("\n📚 EXEMPLO 4: Testar com latência de rede")
        print("════════════════════════════════════════════════\n")
        
        // Setup: Mock com delay de 2 segundos
        let mockLastFM = MockLastFMClient.withNetworkDelay(2.0)
        mockLastFM.sessionKey = "fake-key"
        
        // Test: Medir tempo de scrobble
        let start = Date()
        
        do {
            try await mockLastFM.scrobble(
                artist: "Coldplay",
                track: "Fix You",
                album: "X&Y",
                timestamp: Int(Date().timeIntervalSince1970),
                durationSec: 295
            )
            
            let elapsed = Date().timeIntervalSince(start)
            print("✅ Scrobble completado em \(String(format: "%.1f", elapsed))s")
            
            // Assert: Deve ter levado ~2 segundos
            assert(elapsed >= 2.0 && elapsed < 3.0, "Deveria levar ~2 segundos")
            
        } catch {
            print("❌ Não deveria falhar: \(error)")
            assert(false, "Scrobble não deveria falhar")
        }
        
        print("\n✅ EXEMPLO 4: PASSOU!\n")
    }
    
    // MARK: - Exemplo 5: Testar histórico de scrobbles
    
    static func example5_TestScrobbleHistory() async {
        print("\n📚 EXEMPLO 5: Testar histórico de scrobbles")
        print("════════════════════════════════════════════════\n")
        
        // Setup: Mock autenticado
        let mockLastFM = MockLastFMClient.authenticated()
        
        // Test: Fazer múltiplos scrobbles
        let tracks = [
            ("Queen", "Bohemian Rhapsody", "A Night at the Opera"),
            ("U2", "Beautiful Day", "All That You Can't Leave Behind"),
            ("Coldplay", "Fix You", "X&Y")
        ]
        
        for (artist, track, album) in tracks {
            try? await mockLastFM.scrobble(
                artist: artist,
                track: track,
                album: album,
                timestamp: Int(Date().timeIntervalSince1970),
                durationSec: 300
            )
        }
        
        // Assert: Verificar histórico
        print("✅ Total de scrobbles: \(mockLastFM.scrobbleHistory.count)")
        assert(mockLastFM.scrobbleHistory.count == 3, "Deveria ter 3 scrobbles")
        assert(mockLastFM.scrobbleCallCount == 3, "scrobble() deveria ser chamado 3 vezes")
        
        // Assert: Verificar último scrobble
        if let last = mockLastFM.lastScrobbledTrack {
            print("✅ Último scrobble: \(last.artist) - \(last.track)")
            assert(last.track == "Fix You", "Último track incorreto")
        }
        
        print("\n✅ EXEMPLO 5: PASSOU!\n")
    }
    
    // MARK: - Rodar Todos os Exemplos
    
    static func runAllExamples() async {
        print("\n" + String(repeating: "═", count: 60))
        print("🎭 EXECUTANDO TODOS OS EXEMPLOS DE MOCK")
        print(String(repeating: "═", count: 60) + "\n")
        
        await example1_TestScrobbleManagerIsolated()
        await example2_TestErrorHandling()
        await example3_TestAuthentication()
        await example4_TestWithNetworkDelay()
        await example5_TestScrobbleHistory()
        
        print(String(repeating: "═", count: 60))
        print("🎉 TODOS OS EXEMPLOS PASSARAM!")
        print(String(repeating: "═", count: 60) + "\n")
    }
}

#endif
