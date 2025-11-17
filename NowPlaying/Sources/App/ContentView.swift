//
//  ContentView.swift
//  NowPlaying
//
//  Main Window - Liquid Glass Design
//
//  Created by Diego Castilho on 17/11/25
//  Copyright © 2025 Diego Castilho. All rights reserved.
//

import SwiftUI
import CoreData
import AppKit

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject var lastfm: LastFMClient
    @EnvironmentObject var artwork: ArtworkStore
    
    @State private var scrobbler: ScrobbleManager?
    @State private var pendingToken: String? = nil
    @State private var authError: String? = nil
    @State private var showingError = false
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            // Background dinâmico
            DynamicBackground(artwork: artwork)
                .ignoresSafeArea()
            
            // Content principal
            VStack(spacing: 0) {
                // Header com artwork
                headerSection
                    .padding(.top, DesignSpacing.xl)
                    .padding(.horizontal, DesignSpacing.xl)
                
                // Authentication section (se necessário)
                if pendingToken != nil && lastfm.username == nil {
                    authenticationSection
                        .padding(.horizontal, DesignSpacing.xl)
                        .padding(.top, DesignSpacing.md)
                        .transition(TransitionPreset.fadeScale.transition)
                }
                
                // Divider
                Divider()
                    .padding(.vertical, DesignSpacing.lg)
                    .padding(.horizontal, DesignSpacing.xl)
                
                // TabView
                tabViewSection
                    .padding(.horizontal, DesignSpacing.xl)
                
                // Footer
                footerSection
                    .padding(.horizontal, DesignSpacing.xl)
                    .padding(.bottom, DesignSpacing.lg)
            }
        }
        .frame(minWidth: 940, minHeight: 620)
        .onAppear {
            setupScrobbler()
        }
        .alert("Falha na autenticação", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(authError ?? "Erro desconhecido")
        }
    }
    
    // MARK: - Header Section
    
    @ViewBuilder
    private var headerSection: some View {
        GlassCard(
            padding: DesignSpacing.lg,
            cornerRadius: DesignSpacing.CornerRadius.xl,
            shadow: .prominent,
            backgroundColor: DesignColor.Glass.surface1.opacity(0.5)
        ) {
            HStack(alignment: .center, spacing: DesignSpacing.lg) {
                // Artwork grande
                artworkView
                    .frame(width: 120, height: 120)
                
                // Track info
                trackInfoGrid
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frostEffect(intensity: 0.8, tintColor: DesignColor.Accent.primary.opacity(0.05))
    }
    
    @ViewBuilder
    private var artworkView: some View {
        Image(nsImage: artwork.image ?? artwork.placeholder())
            .resizable()
            .interpolation(.high)
            .antialiased(true)
            .aspectRatio(1, contentMode: .fill)
            .clipShape(RoundedRectangle(cornerRadius: DesignSpacing.CornerRadius.lg))
            .shadow(DesignShadow.Semantic.artwork)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSpacing.CornerRadius.lg)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.4),
                                .white.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
            .transition(TransitionPreset.blur.transition)
            .animation(AnimationPreset.springBouncy.animation, value: artwork.image)
    }
    
    @ViewBuilder
    private var trackInfoGrid: some View {
        Grid(alignment: .leading, horizontalSpacing: DesignSpacing.md, verticalSpacing: DesignSpacing.sm) {
            // Música
            GridRow(alignment: .top) {
                Text("Música:")
                    .font(DesignTypography.headline)
                    .foregroundStyle(DesignColor.Text.secondary)
                    .gridColumnAlignment(.trailing)
                
                Text(artwork.title)
                    .font(DesignTypography.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                DesignColor.Text.primary,
                                DesignColor.Text.primary.opacity(0.9)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .lineLimit(2)
            }
            
            // Álbum
            GridRow(alignment: .top) {
                Text("Álbum:")
                    .font(DesignTypography.body)
                    .foregroundStyle(DesignColor.Text.secondary)
                    .gridColumnAlignment(.trailing)
                
                Text(artwork.album?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false ?
                     (artwork.album ?? "-") : "-")
                .font(DesignTypography.title3)
                .foregroundStyle(DesignColor.Text.primary)
                .lineLimit(2)
            }
            
            // Artista
            GridRow(alignment: .top) {
                Text("Artista:")
                    .font(DesignTypography.caption1)
                    .foregroundStyle(DesignColor.Text.tertiary)
                    .gridColumnAlignment(.trailing)
                
                Text(artwork.artist)
                    .font(DesignTypography.headline)
                    .foregroundStyle(DesignColor.Text.primary)
                    .lineLimit(2)
            }
        }
    }
    
    // MARK: - Authentication Section
    
    @ViewBuilder
    private var authenticationSection: some View {
        GlassCard(
            padding: DesignSpacing.md,
            cornerRadius: DesignSpacing.CornerRadius.lg,
            shadow: .prominent,
            backgroundColor: DesignColor.Glass.surface2.opacity(0.6)
        ) {
            HStack(spacing: DesignSpacing.md) {
                GlassButton(
                    "Já autorizei — Concluir login",
                    icon: "checkmark.circle",
                    style: .primary,
                    size: .medium
                ) {
                    Task { await completeAuth() }
                }
                .keyboardShortcut(.defaultAction)
                
                GlassButton(
                    "Cancelar",
                    style: .secondary,
                    size: .medium
                ) {
                    pendingToken = nil
                }
                
                Spacer()
            }
        }
        .frostEffect(intensity: 0.6)
    }
    
    // MARK: - TabView Section
    
    @ViewBuilder
    private var tabViewSection: some View {
        TabView(selection: $selectedTab) {
            LogListView()
                .tabItem {
                    Label("Scrobble Log", systemImage: "list.bullet.rectangle")
                }
                .tag(0)
            
            RecentTracksView(lastfm: lastfm)
                .tabItem {
                    Label("Recent Tracks", systemImage: "music.note.list")
                }
                .tag(1)
        }
        .animation(AnimationPreset.springGentle.animation, value: selectedTab)
    }
    
    // MARK: - Footer Section
    
    @ViewBuilder
    private var footerSection: some View {
        GlassCard(
            padding: DesignSpacing.md,
            cornerRadius: DesignSpacing.CornerRadius.lg,
            shadow: .prominent,
            backgroundColor: DesignColor.Glass.surface1.opacity(0.4)
        ) {
            HStack(spacing: DesignSpacing.md) {
                // Status
                statusBadge
                
                Spacer()
                
                // Actions
                actionButtons
            }
        }
        .frostEffect(intensity: 0.6)
    }
    
    @ViewBuilder
    private var statusBadge: some View {
        if let username = lastfm.username {
            HStack(spacing: DesignSpacing.xs) {
                Image(systemName: "checkmark.seal.fill")
                    .font(DesignTypography.caption1)
                    .foregroundStyle(DesignColor.Status.success)
                
                Text("Conectado ao Last.FM como \(username)")
                    .font(DesignTypography.body)
                    .foregroundStyle(DesignColor.Text.primary)
            }
            .transition(TransitionPreset.fadeScale.transition)
        } else {
            HStack(spacing: DesignSpacing.xs) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(DesignTypography.caption1)
                    .foregroundStyle(DesignColor.Status.warning)
                
                Text("Não conectado")
                    .font(DesignTypography.body)
                    .foregroundStyle(DesignColor.Text.secondary)
            }
            .transition(TransitionPreset.fadeScale.transition)
        }
    }
    
    @ViewBuilder
    private var actionButtons: some View {
        HStack(spacing: DesignSpacing.sm) {
            if lastfm.username != nil {
                GlassButton(
                    "Desconectar",
                    icon: "rectangle.portrait.and.arrow.right",
                    style: .destructive,
                    size: .medium
                ) {
                    lastfm.signOut()
                }
            } else {
                GlassButton(
                    "Conectar ao Last.fm",
                    icon: "link",
                    style: .primary,
                    size: .medium
                ) {
                    Task { await startAuth() }
                }
            }
        }
        .animation(AnimationPreset.springBouncy.animation, value: lastfm.username)
    }
    
    // MARK: - Authentication Actions
    
    private func startAuth() async {
        do {
            let token = try await lastfm.getToken()
            withAnimation(AnimationPreset.springBouncy.animation) {
                self.pendingToken = token
            }
            let url = lastfm.authURL(token: token)
            NSWorkspace.shared.open(url)
        } catch {
            authError = error.localizedDescription
            showingError = true
        }
    }
    
    private func completeAuth() async {
        guard let token = pendingToken else { return }
        do {
            try await lastfm.getSession(with: token)
            withAnimation(AnimationPreset.springBouncy.animation) {
                pendingToken = nil
            }
        } catch {
            authError = error.localizedDescription
            showingError = true
        }
    }
    
    // MARK: - Setup
    
    private func setupScrobbler() {
        let mgr = ScrobbleManager(lastfm: lastfm, context: context, artwork: artwork)
        self.scrobbler = mgr
        MusicEventListener.shared.start { [weak mgr] info in
            mgr?.handle(info)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let core = CoreDataStack.shared
        let lastfm = LastFMClient()
        let artwork = ArtworkStore()
        
        artwork.title = "Bohemian Rhapsody"
        artwork.artist = "Queen"
        artwork.album = "A Night at the Opera"
        artwork.image = artwork.placeholder()
        
        return ContentView()
            .environment(\.managedObjectContext, core.container.viewContext)
            .environmentObject(lastfm)
            .environmentObject(artwork)
            .frame(width: 940, height: 620)
    }
}
#endif
