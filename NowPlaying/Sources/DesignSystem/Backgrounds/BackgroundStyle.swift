//
//  GlassBackground.swift
//  NowPlaying
//
//  Design System - Background Components
//  Componentes de background para telas completas
//
//  Created by Diego Castilho on 01/11/25
//  Copyright © 2025 Diego Castilho. All rights reserved.//
//

import SwiftUI
import AppKit

// MARK: - Background Style

/// Estilos de background disponíveis
enum BackgroundStyle {
    case solid(Color)
    case gradient(GradientPreset)
    case artwork(NSImage?, blur: CGFloat)
    case dynamic(GradientPreset, animated: Bool)
    case custom(AnyView)
}

// MARK: - Glass Background

/// Background full-screen com glass effect
struct GlassBackground: View {
    let style: BackgroundStyle
    
    init(_ style: BackgroundStyle) {
        self.style = style
    }
    
    var body: some View {
        Group {
            switch style {
            case .solid(let color):
                color
                
            case .gradient(let preset):
                StaticGradient(preset)
                
            case .artwork(let image, let blur):
                if let image = image {
                    ArtworkBackgroundView(image: image, blurRadius: blur)
                } else {
                    StaticGradient(.accent)
                }
                
            case .dynamic(let preset, let animated):
                if animated {
                    AnimatedGradient(preset: preset, duration: 5.0)
                } else {
                    StaticGradient(preset)
                }
                
            case .custom(let view):
                view
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Artwork Background View

/// Background usando artwork (capa do álbum)
struct ArtworkBackgroundView: View {
    let image: NSImage
    let blurRadius: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            Image(nsImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height
                )
                .blur(radius: blurRadius)
                .clipped()
                .overlay(
                    // Overlay escuro para legibilidade
                    Color.black.opacity(0.4)
                )
        }
    }
}

// MARK: - Gradient Background

/// Background com gradiente (wrapper convenience)
struct GradientBackground: View {
    let preset: GradientPreset
    let animated: Bool
    let startPoint: UnitPoint
    let endPoint: UnitPoint
    
    init(
        _ preset: GradientPreset,
        animated: Bool = false,
        startPoint: UnitPoint = .topLeading,
        endPoint: UnitPoint = .bottomTrailing
    ) {
        self.preset = preset
        self.animated = animated
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    var body: some View {
        if animated {
            AnimatedGradient(
                preset: preset,
                duration: 5.0,
                startPoint: startPoint,
                endPoint: endPoint
            )
            .ignoresSafeArea()
        } else {
            StaticGradient(
                preset,
                startPoint: startPoint,
                endPoint: endPoint
            )
            .ignoresSafeArea()
        }
    }
}

// MARK: - Dynamic Background

/// Background que muda baseado no contexto
struct DynamicBackground: View {
    @ObservedObject var artwork: ArtworkStore
    let fallbackPreset: GradientPreset
    let blurRadius: CGFloat
    let useArtwork: Bool
    
    init(
        artwork: ArtworkStore,
        fallbackPreset: GradientPreset = .accent,
        blurRadius: CGFloat = 50,
        useArtwork: Bool = true
    ) {
        self.artwork = artwork
        self.fallbackPreset = fallbackPreset
        self.blurRadius = blurRadius
        self.useArtwork = useArtwork
    }
    
    var body: some View {
        Group {
            if useArtwork, let image = artwork.image {
                ArtworkBackgroundView(
                    image: image,
                    blurRadius: blurRadius
                )
            } else {
                AnimatedGradient(
                    preset: fallbackPreset,
                    duration: 8.0
                )
            }
        }
        .ignoresSafeArea()
        .animation(DesignAnimation.smooth, value: artwork.image != nil)
    }
}

// MARK: - Layered Background

/// Background com múltiplas camadas (depth)
struct LayeredBackground: View {
    let baseGradient: GradientPreset
    let overlayGradient: GradientPreset?
    let overlayOpacity: Double
    
    init(
        base: GradientPreset,
        overlay: GradientPreset? = nil,
        overlayOpacity: Double = 0.3
    ) {
        self.baseGradient = base
        self.overlayGradient = overlay
        self.overlayOpacity = overlayOpacity
    }
    
    var body: some View {
        ZStack {
            // Base layer
            StaticGradient(baseGradient)
            
            // Overlay layer (opcional)
            if let overlay = overlayGradient {
                StaticGradient(
                    overlay,
                    startPoint: .bottomTrailing,
                    endPoint: .topLeading
                )
                .opacity(overlayOpacity)
                .blendMode(.screen)
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Mesh Background (macOS 15+)

/// Background com mesh gradient
@available(macOS 15.0, *)
struct MeshBackground: View {
    let preset: GradientPreset
    
    var body: some View {
        // Fallback para linear gradient
        // Mesh gradient real seria implementado com MeshGradient API
        StaticGradient(preset)
            .ignoresSafeArea()
    }
}

// MARK: - Convenience Initializers

extension GlassBackground {
    /// Background sólido
    static func solid(_ color: Color) -> GlassBackground {
        GlassBackground(.solid(color))
    }
    
    /// Background com gradiente
    static func gradient(_ preset: GradientPreset) -> GlassBackground {
        GlassBackground(.gradient(preset))
    }
    
    /// Background com artwork
    static func artwork(_ image: NSImage?, blur: CGFloat = 50) -> GlassBackground {
        GlassBackground(.artwork(image, blur: blur))
    }
    
    /// Background dinâmico animado
    static func animated(_ preset: GradientPreset) -> GlassBackground {
        GlassBackground(.dynamic(preset, animated: true))
    }
}

// MARK: - Background Container

/// Container que combina background com conteúdo
struct BackgroundContainer<Content: View>: View {
    let background: BackgroundStyle
    let content: Content
    
    init(
        background: BackgroundStyle,
        @ViewBuilder content: () -> Content
    ) {
        self.background = background
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            GlassBackground(background)
            content
        }
    }
}

// MARK: - Preview

#if DEBUG
struct GlassBackground_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: DesignSpacing.xl) {
                Text("Background Components")
                    .font(DesignTypography.title1)
                    .foregroundStyle(.white)
                    .padding(.top)
                
                // Solid backgrounds
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Solid Backgrounds")
                        .font(DesignTypography.headline)
                        .foregroundStyle(.white)
                    
                    HStack(spacing: DesignSpacing.md) {
                        ForEach([
                            ("Black", Color.black),
                            ("Blue", Color.blue),
                            ("Purple", Color.purple)
                        ], id: \.0) { name, color in
                            VStack(spacing: DesignSpacing.xs) {
                                GlassBackground.solid(color)
                                    .frame(height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(
                                        Text(name)
                                            .font(DesignTypography.caption1)
                                            .foregroundStyle(.white)
                                    )
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                Divider().background(.white.opacity(0.3))
                
                // Gradient backgrounds
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Gradient Backgrounds")
                        .font(DesignTypography.headline)
                        .foregroundStyle(.white)
                    
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: DesignSpacing.md
                    ) {
                        ForEach([
                            ("Music", GradientPreset.music),
                            ("Accent", GradientPreset.accent),
                            ("Night", GradientPreset.night),
                            ("Ocean", GradientPreset.ocean)
                        ], id: \.0) { name, preset in
                            VStack(spacing: DesignSpacing.xs) {
                                GlassBackground.gradient(preset)
                                    .frame(height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(
                                        Text(name)
                                            .font(DesignTypography.body)
                                            .foregroundStyle(.white)
                                    )
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                Divider().background(.white.opacity(0.3))
                
                // Animated background
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Animated Background")
                        .font(DesignTypography.headline)
                        .foregroundStyle(.white)
                    
                    GlassBackground.animated(.accent)
                        .frame(height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            VStack(spacing: DesignSpacing.xs) {
                                Text("Animated Gradient")
                                    .font(DesignTypography.title3)
                                    .foregroundStyle(.white)
                                Text("Watch the colors shift")
                                    .font(DesignTypography.caption1)
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                        )
                }
                .padding(.horizontal)
                
                Divider().background(.white.opacity(0.3))
                
                // Layered background
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Layered Background")
                        .font(DesignTypography.headline)
                        .foregroundStyle(.white)
                    
                    LayeredBackground(
                        base: .night,
                        overlay: .fire,
                        overlayOpacity: 0.4
                    )
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        Text("Multiple Layers")
                            .font(DesignTypography.title3)
                            .foregroundStyle(.white)
                    )
                }
                .padding(.horizontal)
                
                Divider().background(.white.opacity(0.3))
                
                // Background container
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Background Container")
                        .font(DesignTypography.headline)
                        .foregroundStyle(.white)
                    
                    BackgroundContainer(background: .gradient(.sunrise)) {
                        VStack(spacing: DesignSpacing.md) {
                            Text("Content Over Background")
                                .font(DesignTypography.title2)
                                .foregroundStyle(.white)
                            
                            GlassCard {
                                Text("Glass card on gradient")
                                    .font(DesignTypography.body)
                            }
                            .frame(maxWidth: 300)
                        }
                        .padding()
                    }
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal)
                
                Divider().background(.white.opacity(0.3))
                
                // Comparison
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("With Content")
                        .font(DesignTypography.headline)
                        .foregroundStyle(.white)
                    
                    GlassBackground.gradient(.ocean)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            VStack(spacing: DesignSpacing.md) {
                                Image(systemName: "music.note")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.white)
                                
                                Text("Now Playing")
                                    .font(DesignTypography.title2)
                                    .foregroundStyle(.white)
                                
                                Text("Background looks great with UI")
                                    .font(DesignTypography.caption1)
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                            .padding()
                        )
                }
                .padding(.horizontal)
                
                Spacer(minLength: 40)
            }
        }
        .background(Color.black)
        .frame(width: 500, height: 1400)
    }
}
#endif
