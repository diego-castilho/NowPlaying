//
//  RecentTracksView.swift
//  NowPlaying
//
//  Recent Tracks View - Liquid Glass Design
//
//  Created by Diego Castilho on 17/11/25
//  Copyright © 2025 Diego Castilho. All rights reserved.
//

import SwiftUI

struct RecentTracksView: View {
    @ObservedObject var lastfm: LastFMClient
    @State private var tracks: [[String:Any]] = []
    @State private var isLoading = false
    @State private var errorText: String? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with refresh
            headerSection
                .padding(.horizontal, DesignSpacing.lg)
                .padding(.top, DesignSpacing.md)
            
            // Content
            if isLoading {
                loadingState
            } else if let error = errorText {
                errorState(error)
            } else if tracks.isEmpty {
                emptyState
            } else {
                tracksList
            }
        }
        .background(
            Color.clear
                .background(.ultraThinMaterial)
        )
        .task {
            await load()
        }
    }
    
    // MARK: - Header
    
    @ViewBuilder
    private var headerSection: some View {
        GlassCard(
            padding: DesignSpacing.md,
            cornerRadius: DesignSpacing.CornerRadius.lg,
            shadow: .prominent,
            backgroundColor: DesignColor.Glass.surface1.opacity(0.4)
        ) {
            HStack(spacing: DesignSpacing.md) {
                // Info
                VStack(alignment: .leading, spacing: DesignSpacing.xxs) {
                    if let username = lastfm.username {
                        HStack(spacing: DesignSpacing.xs) {
                            Image(systemName: "person.circle.fill")
                                .font(DesignTypography.caption1)
                                .foregroundStyle(DesignColor.Accent.primary)
                            
                            Text("Músicas recentes de \(username)")
                                .font(DesignTypography.body)
                                .foregroundStyle(DesignColor.Text.primary)
                        }
                    } else {
                        Text("Conecte ao Last.fm para ver suas músicas recentes")
                            .font(DesignTypography.body)
                            .foregroundStyle(DesignColor.Text.secondary)
                    }
                    
                    if !tracks.isEmpty {
                        Text("\(tracks.count) músicas")
                            .font(DesignTypography.caption1)
                            .foregroundStyle(DesignColor.Text.tertiary)
                    }
                }
                
                Spacer()
                
                // Refresh button
                GlassButton(
                    "Atualizar",
                    icon: "arrow.clockwise",
                    style: .primary,
                    size: .small
                ) {
                    Task { await load() }
                }
                .disabled(isLoading || lastfm.username == nil)
            }
        }
        .frostEffect(intensity: 0.6)
    }
    
    // MARK: - Tracks List
    
    @ViewBuilder
    private var tracksList: some View {
        ScrollView {
            LazyVStack(spacing: DesignSpacing.sm) {
                ForEach(Array(tracks.enumerated()), id: \.offset) { index, track in
                    trackItemView(track, index: index)
                        .transition(TransitionPreset.fadeScale.transition)
                        .animation(
                            AnimationPreset.springGentle.animation.delay(Double(index) * 0.02),
                            value: tracks.count
                        )
                }
            }
            .padding(.horizontal, DesignSpacing.lg)
            .padding(.vertical, DesignSpacing.md)
        }
    }
    
    @ViewBuilder
    private func trackItemView(_ track: [String:Any], index: Int) -> some View {
        let name = (track["name"] as? String) ?? "—"
        let artist = ((track["artist"] as? [String:Any])?["#text"] as? String) ?? "—"
        let album = ((track["album"] as? [String:Any])?["#text"] as? String) ?? ""
        let dateDict = (track["date"] as? [String:Any])
        let uts = Int((dateDict?["uts"] as? String) ?? "")
        let dateStr = uts.map { Date(timeIntervalSince1970: TimeInterval($0)).shortHuman() } ?? "agora"
        let isNowPlaying = (track["@attr"] as? [String:Any])?["nowplaying"] as? String == "true"
        
        GlassCard(
            padding: DesignSpacing.md,
            cornerRadius: DesignSpacing.CornerRadius.md,
            shadow: .prominent,
            backgroundColor: DesignColor.Glass.surface1.opacity(0.3)
        ) {
            HStack(alignment: .top, spacing: DesignSpacing.md) {
                // Track number or NOW badge
                if isNowPlaying {
                    GlassBadge(
                        "NOW",
                        style: .info,
                        size: .small
                    )
                } else {
                    Text("#\(index + 1)")
                        .font(DesignTypography.caption1)
                        .foregroundStyle(DesignColor.Text.tertiary)
                        .frame(width: 32)
                }
                
                // Track info
                VStack(alignment: .leading, spacing: DesignSpacing.xs) {
                    // Artist — Track
                    Text("\(artist) — \(name)")
                        .font(DesignTypography.headline)
                        .foregroundStyle(DesignColor.Text.primary)
                        .lineLimit(2)
                    
                    // Album + Date
                    HStack(spacing: DesignSpacing.sm) {
                        if !album.isEmpty {
                            HStack(spacing: DesignSpacing.xxs) {
                                Image(systemName: "opticaldisc")
                                    .font(DesignTypography.caption1)
                                Text(album)
                                    .font(DesignTypography.subheadline)
                            }
                            .foregroundStyle(DesignColor.Text.secondary)
                        }
                        
                        HStack(spacing: DesignSpacing.xxs) {
                            Image(systemName: "clock")
                                .font(DesignTypography.caption1)
                            Text(dateStr)
                                .font(DesignTypography.subheadline)
                        }
                        .foregroundStyle(DesignColor.Text.tertiary)
                    }
                }
                
                Spacer()
            }
        }
        .frostEffect(intensity: 0.4)
    }
    
    // MARK: - Loading State
    
    @ViewBuilder
    private var loadingState: some View {
        VStack(spacing: DesignSpacing.lg) {
            Spacer()
            
            ProgressView()
                .scaleEffect(1.5)
                .tint(DesignColor.Accent.primary)
            
            VStack(spacing: DesignSpacing.xs) {
                Text("Carregando músicas…")
                    .font(DesignTypography.title3)
                    .foregroundStyle(DesignColor.Text.primary)
                
                Text("Buscando do Last.fm")
                    .font(DesignTypography.body)
                    .foregroundStyle(DesignColor.Text.secondary)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .transition(TransitionPreset.fadeScale.transition)
    }
    
    // MARK: - Error State
    
    @ViewBuilder
    private func errorState(_ error: String) -> some View {
        VStack(spacing: DesignSpacing.lg) {
            Spacer()
            
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 64))
                .foregroundStyle(DesignColor.Status.error)
            
            VStack(spacing: DesignSpacing.xs) {
                Text("Erro ao carregar")
                    .font(DesignTypography.title3)
                    .foregroundStyle(DesignColor.Text.primary)
                
                Text(error)
                    .font(DesignTypography.body)
                    .foregroundStyle(DesignColor.Text.secondary)
                    .multilineTextAlignment(.center)
            }
            
            GlassButton(
                "Tentar Novamente",
                icon: "arrow.clockwise",
                style: .primary,
                size: .medium
            ) {
                Task { await load() }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(DesignSpacing.xl)
        .transition(TransitionPreset.fadeScale.transition)
    }
    
    // MARK: - Empty State
    
    @ViewBuilder
    private var emptyState: some View {
        VStack(spacing: DesignSpacing.lg) {
            Spacer()
            
            Image(systemName: "music.note.list")
                .font(.system(size: 64))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            DesignColor.Accent.primary.opacity(0.6),
                            DesignColor.Accent.secondary.opacity(0.6)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: DesignSpacing.xs) {
                Text(lastfm.username == nil ? "Não conectado" : "Nenhuma música encontrada")
                    .font(DesignTypography.title3)
                    .foregroundStyle(DesignColor.Text.primary)
                
                Text(lastfm.username == nil
                     ? "Conecte-se ao Last.fm para ver suas músicas recentes"
                     : "Comece a ouvir música no Apple Music")
                .font(DesignTypography.body)
                .foregroundStyle(DesignColor.Text.secondary)
                .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(DesignSpacing.xl)
        .transition(TransitionPreset.fadeScale.transition)
    }
    
    // MARK: - Load Logic
    
    private func load() async {
        guard lastfm.username != nil else { return }
        
        withAnimation(AnimationPreset.springGentle.animation) {
            isLoading = true
            errorText = nil
        }
        
        defer {
            withAnimation(AnimationPreset.springGentle.animation) {
                isLoading = false
            }
        }
        
        do {
            let result = try await lastfm.fetchRecentTracks(limit: 30)
            withAnimation(AnimationPreset.springBouncy.animation) {
                tracks = result
            }
        } catch {
            withAnimation(AnimationPreset.springGentle.animation) {
                errorText = error.localizedDescription
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct RecentTracksView_Previews: PreviewProvider {
    static var previews: some View {
        let lastfm = LastFMClient()
        
        return Group {
            // With username
            RecentTracksView(lastfm: lastfm)
                .frame(width: 800, height: 600)
                .onAppear {
                    lastfm.username = "test_user"
                }
            
            // Without username
            RecentTracksView(lastfm: LastFMClient())
                .frame(width: 800, height: 600)
        }
    }
}
#endif
