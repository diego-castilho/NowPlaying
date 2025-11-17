//
//  ArtworkWidgetView.swift
//  NowPlaying
//
//  Menu Bar Artwork Widget - Liquid Glass Design
//
//  Created by Diego Castilho on 17/11/25
//  Copyright © 2025 Diego Castilho. All rights reserved.
//

import SwiftUI

/// Widget de artwork para o menu bar popover
/// Versão Liquid Glass com animações
struct ArtworkWidgetView: View {
    @ObservedObject var artwork: ArtworkStore
    
    @State private var isImageLoaded = false
    @State private var showPlaceholder = true
    
    var body: some View {
        GlassCard(
            padding: DesignSpacing.md,
            cornerRadius: DesignSpacing.CornerRadius.lg,  // ✅ CORRETO
            shadow: .prominent,
            backgroundColor: DesignColor.Glass.surface1.opacity(0.4)  // ✅ surface1 existe
        ) {
            HStack(alignment: .center, spacing: DesignSpacing.md) {
                // Artwork Image
                artworkImage
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: DesignSpacing.CornerRadius.md))  // ✅ CORRETO
                    .shadow(DesignShadow.Semantic.artwork)  // ✅ Semantic.artwork existe
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSpacing.CornerRadius.md)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.3),
                                        .white.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .transition(TransitionPreset.blur.transition.combined(with: .scale(scale: 0.8)))
                    .animation(AnimationPreset.springBouncy.animation, value: isImageLoaded)
                
                // Track Info
                trackInfo
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer(minLength: 0)
            }
        }
        .frostEffect(intensity: 0.7, tintColor: DesignColor.Accent.primary.opacity(0.1))
        .onChange(of: artwork.image) { _, newValue in
            withAnimation(AnimationPreset.fadeInOut.animation) {
                isImageLoaded = newValue != nil
                showPlaceholder = newValue == nil
            }
        }
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var artworkImage: some View {
        ZStack {
            if showPlaceholder {
                // Placeholder com shimmer
                RoundedRectangle(cornerRadius: DesignSpacing.CornerRadius.md)
                    .fill(DesignColor.Glass.surface2.opacity(0.3))  // ✅ surface2 existe
                    .overlay(
                        Image(systemName: "music.note")
                            .font(.system(size: 32, weight: .light))
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
                    )
                    .skeletonShimmer(isLoading: true)
            } else if let image = artwork.image {
                Image(nsImage: image)
                    .resizable()
                    .interpolation(.high)
                    .aspectRatio(contentMode: .fill)
            }
        }
    }
    
    @ViewBuilder
    private var trackInfo: some View {
        VStack(alignment: .leading, spacing: DesignSpacing.xs) {
            // Track Name
            Text(artwork.title)
                .font(DesignTypography.title3)
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
                .lineLimit(1)
                .truncationMode(.tail)
            
            // Album Name
            if let album = artwork.album, !album.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                HStack(spacing: DesignSpacing.xxs) {
                    Image(systemName: "opticaldisc")
                        .font(DesignTypography.caption1)
                        .foregroundStyle(DesignColor.Text.secondary)
                    
                    Text(album)
                        .font(DesignTypography.body)
                        .foregroundStyle(DesignColor.Text.secondary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
            
            // Artist Name
            HStack(spacing: DesignSpacing.xxs) {
                Image(systemName: "person.fill")
                    .font(DesignTypography.caption1)
                    .foregroundStyle(DesignColor.Text.tertiary)
                
                Text(artwork.artist)
                    .font(DesignTypography.caption1)
                    .foregroundStyle(DesignColor.Text.tertiary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct ArtworkWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        let artwork = ArtworkStore()
        artwork.title = "Bohemian Rhapsody"
        artwork.artist = "Queen"
        artwork.album = "A Night at the Opera"
        artwork.image = artwork.placeholder()
        
        return Group {
            // Com artwork
            ArtworkWidgetView(artwork: artwork)
                .frame(width: 480)
                .padding()
                .background(Color.black)
            
            // Sem artwork (loading)
            ArtworkWidgetView(artwork: ArtworkStore())
                .frame(width: 480)
                .padding()
                .background(Color.black)
        }
    }
}
#endif
