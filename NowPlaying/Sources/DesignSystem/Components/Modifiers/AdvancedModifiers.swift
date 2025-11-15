//
//  AdvancedModifiers.swift
//  NowPlaying
//
//  Design System - Advanced Modifiers
//  Modifiers avançados para efeitos visuais profissionais
//
//  Created by Diego Castilho on 01/11/25
//  Copyright © 2025 Diego Castilho. All rights reserved.
//

import SwiftUI
import AppKit

// MARK: - Frost Effect Modifier

/// Modifier que adiciona efeito frost (glass mais pronunciado)
struct FrostEffectModifier: ViewModifier {
    let intensity: Double
    let tintColor: Color
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // Base blur
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThickMaterial)
                    
                    // Tint overlay
                    RoundedRectangle(cornerRadius: 16)
                        .fill(tintColor.opacity(intensity * 0.15))
                    
                    // Highlight (simula reflexo)
                    LinearGradient(
                        colors: [
                            Color.white.opacity(intensity * 0.3),
                            Color.clear,
                            Color.white.opacity(intensity * 0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        Color.white.opacity(intensity * 0.3),
                        lineWidth: 1.5
                    )
            )
    }
}

extension View {
    /// Aplica efeito frost (glass pronunciado)
    ///
    /// Uso:
    /// ```swift
    /// VStack {
    ///     Text("Content")
    /// }
    /// .padding()
    /// .frostEffect(intensity: 0.8)
    /// ```
    func frostEffect(
        intensity: Double = 0.8,
        tintColor: Color = .blue
    ) -> some View {
        modifier(FrostEffectModifier(
            intensity: intensity,
            tintColor: tintColor
        ))
    }
}

// MARK: - Depth Effect Modifier

/// Modifier que adiciona efeito de profundidade (parallax)
struct DepthEffectModifier: ViewModifier {
    let layers: Int
    let offset: CGFloat
    let shadowIntensity: Double
    
    @State private var hoverOffset: CGSize = .zero
    
    func body(content: Content) -> some View {
        ZStack {
            // Shadow layers
            ForEach(0..<layers, id: \.self) { index in
                content
                    .opacity(0.3 - (Double(index) * 0.1))
                    .blur(radius: CGFloat(index + 1) * 2)
                    .offset(
                        x: hoverOffset.width * CGFloat(index + 1) * 0.1,
                        y: hoverOffset.height * CGFloat(index + 1) * 0.1 + CGFloat(index + 1) * offset
                    )
            }
            
            // Main content
            content
                .offset(hoverOffset)
        }
        .onContinuousHover { phase in
            switch phase {
            case .active(let location):
                withAnimation(DesignAnimation.bouncy) {
                    // Calcula offset baseado na posição do mouse
                    // Simplificado - em produção usaria geometry reader
                    hoverOffset = CGSize(
                        width: (location.x - 150) / 30,
                        height: (location.y - 150) / 30
                    )
                }
            case .ended:
                withAnimation(DesignAnimation.bouncy) {
                    hoverOffset = .zero
                }
            }
        }
    }
}

extension View {
    /// Aplica efeito de profundidade (parallax)
    ///
    /// Uso:
    /// ```swift
    /// Card()
    ///     .depthEffect(layers: 3, offset: 5)
    /// ```
    func depthEffect(
        layers: Int = 3,
        offset: CGFloat = 5,
        shadowIntensity: Double = 0.5
    ) -> some View {
        modifier(DepthEffectModifier(
            layers: layers,
            offset: offset,
            shadowIntensity: shadowIntensity
        ))
    }
}

// MARK: - Reflection Effect Modifier

/// Modifier que adiciona reflexo de luz
struct ReflectionEffectModifier: ViewModifier {
    let angle: Angle
    let intensity: Double
    let animated: Bool
    
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0),
                        Color.white.opacity(intensity * 0.4),
                        Color.white.opacity(0)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .rotationEffect(angle)
                .offset(x: animated ? phase * 100 : 0)
                .mask(content)
                .allowsHitTesting(false)
            )
            .onAppear {
                guard animated else { return }
                withAnimation(
                    Animation.linear(duration: 3.0)
                        .repeatForever(autoreverses: false)
                ) {
                    phase = 3.0
                }
            }
    }
}

extension View {
    /// Aplica reflexo de luz
    ///
    /// Uso:
    /// ```swift
    /// Card()
    ///     .reflectionEffect(angle: .degrees(45), animated: true)
    /// ```
    func reflectionEffect(
        angle: Angle = .degrees(45),
        intensity: Double = 0.5,
        animated: Bool = false
    ) -> some View {
        modifier(ReflectionEffectModifier(
            angle: angle,
            intensity: intensity,
            animated: animated
        ))
    }
}

// MARK: - Artwork Tint Modifier

/// Modifier que aplica tint baseado em artwork
struct ArtworkTintModifier: ViewModifier {
    let artwork: NSImage?
    let intensity: Double
    let blendMode: BlendMode
    
    @State private var dominantColor: Color?
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if let color = dominantColor {
                        color
                            .opacity(intensity)
                            .blendMode(blendMode)
                            .allowsHitTesting(false)
                    }
                }
            )
            .onAppear {
                extractDominantColor()
            }
            .onChange(of: artwork) { _, _ in
                extractDominantColor()
            }
    }
    
    private func extractDominantColor() {
        guard let image = artwork else {
            dominantColor = nil
            return
        }
        
        // Extração simplificada - em produção usaria algoritmo K-means
        // Por ora, pega cor do centro da imagem
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            dominantColor = DesignColor.Accent.primary
            return
        }
        
        let width = cgImage.width
        let height = cgImage.height
        
        // Amostra o pixel do centro
        let centerX = width / 2
        let centerY = height / 2
        
        // Simplificado - retorna cor do design system
        dominantColor = DesignColor.Accent.music
    }
}

extension View {
    /// Aplica tint baseado no artwork
    ///
    /// Uso:
    /// ```swift
    /// VStack {
    ///     Content()
    /// }
    /// .artworkTint(artwork: currentArtwork, intensity: 0.3)
    /// ```
    func artworkTint(
        artwork: NSImage?,
        intensity: Double = 0.3,
        blendMode: BlendMode = .overlay
    ) -> some View {
        modifier(ArtworkTintModifier(
            artwork: artwork,
            intensity: intensity,
            blendMode: blendMode
        ))
    }
}

// MARK: - Glass Border Modifier

/// Modifier que adiciona borda glass estilizada
struct GlassBorderModifier: ViewModifier {
    let width: CGFloat
    let cornerRadius: CGFloat
    let gradient: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if gradient {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.5),
                                        Color.white.opacity(0.2),
                                        Color.white.opacity(0.5)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: width
                            )
                    } else {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .strokeBorder(
                                Color.white.opacity(0.3),
                                lineWidth: width
                            )
                    }
                }
            )
    }
}

extension View {
    /// Adiciona borda glass estilizada
    ///
    /// Uso:
    /// ```swift
    /// Card()
    ///     .glassBorder(width: 2, gradient: true)
    /// ```
    func glassBorder(
        width: CGFloat = 1.5,
        cornerRadius: CGFloat = 16,
        gradient: Bool = true
    ) -> some View {
        modifier(GlassBorderModifier(
            width: width,
            cornerRadius: cornerRadius,
            gradient: gradient
        ))
    }
}

// MARK: - Inner Shadow Modifier

/// Modifier que adiciona sombra interna
struct InnerShadowModifier: ViewModifier {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color, lineWidth: radius)
                    .blur(radius: radius)
                    .offset(x: x, y: y)
                    .mask(RoundedRectangle(cornerRadius: 16).fill(
                        LinearGradient(
                            colors: [Color.black, Color.clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    ))
                    .allowsHitTesting(false)
            )
    }
}

extension View {
    /// Adiciona sombra interna
    ///
    /// Uso:
    /// ```swift
    /// Card()
    ///     .innerShadow(color: .black.opacity(0.3))
    /// ```
    func innerShadow(
        color: Color = .black.opacity(0.5),
        radius: CGFloat = 5,
        x: CGFloat = 0,
        y: CGFloat = 2
    ) -> some View {
        modifier(InnerShadowModifier(
            color: color,
            radius: radius,
            x: x,
            y: y
        ))
    }
}

// MARK: - Material Tint Modifier

/// Modifier que adiciona tint ao material
struct MaterialTintModifier: ViewModifier {
    let color: Color
    let intensity: Double
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.regularMaterial)
                    
                    RoundedRectangle(cornerRadius: 16)
                        .fill(color.opacity(intensity))
                }
            )
    }
}

extension View {
    /// Adiciona tint ao material
    ///
    /// Uso:
    /// ```swift
    /// Text("Hello")
    ///     .padding()
    ///     .materialTint(.blue, intensity: 0.2)
    /// ```
    func materialTint(
        _ color: Color,
        intensity: Double = 0.2
    ) -> some View {
        modifier(MaterialTintModifier(
            color: color,
            intensity: intensity
        ))
    }
}

// MARK: - Preview

#if DEBUG
struct AdvancedModifiers_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            // Background
            GradientBackground(.night)
            
            ScrollView {
                VStack(spacing: DesignSpacing.xl) {
                    Text("Advanced Modifiers")
                        .font(DesignTypography.title1)
                        .foregroundStyle(.white)
                        .padding(.top)
                    
                    // Frost Effect
                    VStack(alignment: .leading, spacing: DesignSpacing.md) {
                        Text(".frostEffect()")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        HStack(spacing: DesignSpacing.md) {
                            VStack {
                                Text("Low")
                                    .font(DesignTypography.caption1)
                            }
                            .padding()
                            .frostEffect(intensity: 0.4)
                            
                            VStack {
                                Text("Medium")
                                    .font(DesignTypography.caption1)
                            }
                            .padding()
                            .frostEffect(intensity: 0.7)
                            
                            VStack {
                                Text("High")
                                    .font(DesignTypography.caption1)
                            }
                            .padding()
                            .frostEffect(intensity: 1.0)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider().background(.white.opacity(0.3))
                    
                    // Depth Effect
                    VStack(alignment: .leading, spacing: DesignSpacing.md) {
                        Text(".depthEffect() - Hover me!")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        Text("Parallax Depth")
                            .font(DesignTypography.title3)
                            .padding(DesignSpacing.lg)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(DesignColor.Glass.surface1)
                            )
                            .depthEffect(layers: 3, offset: 4)
                    }
                    .padding(.horizontal)
                    
                    Divider().background(.white.opacity(0.3))
                    
                    // Reflection Effect
                    VStack(alignment: .leading, spacing: DesignSpacing.md) {
                        Text(".reflectionEffect()")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        HStack(spacing: DesignSpacing.md) {
                            Text("Static")
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(DesignColor.Glass.surface2)
                                )
                                .reflectionEffect(intensity: 0.5)
                            
                            Text("Animated")
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(DesignColor.Glass.surface2)
                                )
                                .reflectionEffect(intensity: 0.7, animated: true)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider().background(.white.opacity(0.3))
                    
                    // Glass Border
                    VStack(alignment: .leading, spacing: DesignSpacing.md) {
                        Text(".glassBorder()")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        HStack(spacing: DesignSpacing.md) {
                            Text("Solid")
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(DesignColor.Glass.surface1)
                                )
                                .glassBorder(gradient: false)
                            
                            Text("Gradient")
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(DesignColor.Glass.surface1)
                                )
                                .glassBorder(gradient: true)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider().background(.white.opacity(0.3))
                    
                    // Inner Shadow
                    VStack(alignment: .leading, spacing: DesignSpacing.md) {
                        Text(".innerShadow()")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        Text("Inner Shadow Effect")
                            .padding(DesignSpacing.lg)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.9))
                            )
                            .innerShadow(color: .black.opacity(0.3), radius: 8)
                    }
                    .padding(.horizontal)
                    
                    Divider().background(.white.opacity(0.3))
                    
                    // Material Tint
                    VStack(alignment: .leading, spacing: DesignSpacing.md) {
                        Text(".materialTint()")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        HStack(spacing: DesignSpacing.md) {
                            Text("Blue Tint")
                                .padding()
                                .materialTint(.blue, intensity: 0.3)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            Text("Purple Tint")
                                .padding()
                                .materialTint(.purple, intensity: 0.3)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider().background(.white.opacity(0.3))
                    
                    // Composição
                    VStack(alignment: .leading, spacing: DesignSpacing.md) {
                        Text("Composição de Modifiers")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        VStack(spacing: DesignSpacing.sm) {
                            Text("Professional Card")
                                .font(DesignTypography.title3)
                            Text("Frost + Reflection + Glass Border")
                                .font(DesignTypography.caption1)
                                .foregroundStyle(.secondary)
                        }
                        .padding(DesignSpacing.xl)
                        .frostEffect(intensity: 0.8, tintColor: .blue)
                        .reflectionEffect(intensity: 0.3, animated: true)
                        .glassBorder(width: 2, gradient: true)
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .frame(width: 500, height: 1400)
    }
}
#endif
