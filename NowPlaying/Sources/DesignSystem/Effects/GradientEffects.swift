//
//  GradientEffects.swift
//  NowPlaying
//
//  Design System - Gradient Effects
//  Sistema de gradientes para backgrounds e overlays
//
//  Created by Diego Castilho on 01/11/25
//  Copyright © 2025 Diego Castilho. All rights reserved.//
//

import SwiftUI

// MARK: - Gradient Preset

/// Presets de gradientes predefinidos
enum GradientPreset {
    case music        // Laranja Last.fm
    case accent       // Azul/Roxo (accent colors)
    case status       // Verde/Vermelho
    case night        // Azul escuro/Roxo
    case sunrise      // Rosa/Laranja/Amarelo
    case ocean        // Azul/Verde água
    case forest       // Verde/Verde escuro
    case fire         // Vermelho/Laranja/Amarelo
    case custom([Color])
    
    /// Cores do gradiente
    var colors: [Color] {
        switch self {
        case .music:
            return [
                Color(red: 0.9, green: 0.3, blue: 0.2),  // Laranja Last.fm
                Color(red: 0.95, green: 0.5, blue: 0.2),
                Color(red: 1.0, green: 0.6, blue: 0.3)
            ]
            
        case .accent:
            return [
                DesignColor.Accent.primary,
                DesignColor.Accent.secondary,
                DesignColor.Accent.tertiary
            ]
            
        case .status:
            return [
                DesignColor.Status.success,
                Color(red: 0.3, green: 0.7, blue: 0.4),
                DesignColor.Status.error
            ]
            
        case .night:
            return [
                Color(red: 0.1, green: 0.1, blue: 0.3),
                Color(red: 0.2, green: 0.1, blue: 0.4),
                Color(red: 0.3, green: 0.2, blue: 0.5)
            ]
            
        case .sunrise:
            return [
                Color(red: 1.0, green: 0.4, blue: 0.6),  // Rosa
                Color(red: 1.0, green: 0.6, blue: 0.4),  // Laranja
                Color(red: 1.0, green: 0.9, blue: 0.5)   // Amarelo
            ]
            
        case .ocean:
            return [
                Color(red: 0.1, green: 0.5, blue: 0.7),
                Color(red: 0.2, green: 0.7, blue: 0.8),
                Color(red: 0.3, green: 0.8, blue: 0.7)
            ]
            
        case .forest:
            return [
                Color(red: 0.2, green: 0.5, blue: 0.3),
                Color(red: 0.3, green: 0.6, blue: 0.4),
                Color(red: 0.1, green: 0.4, blue: 0.2)
            ]
            
        case .fire:
            return [
                Color(red: 0.8, green: 0.1, blue: 0.1),  // Vermelho
                Color(red: 1.0, green: 0.4, blue: 0.1),  // Laranja
                Color(red: 1.0, green: 0.8, blue: 0.2)   // Amarelo
            ]
            
        case .custom(let colors):
            return colors
        }
    }
}

// MARK: - Static Gradient View

/// Gradiente estático simples
struct StaticGradient: View {
    let preset: GradientPreset
    let startPoint: UnitPoint
    let endPoint: UnitPoint
    
    init(
        _ preset: GradientPreset,
        startPoint: UnitPoint = .topLeading,
        endPoint: UnitPoint = .bottomTrailing
    ) {
        self.preset = preset
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    var body: some View {
        LinearGradient(
            colors: preset.colors,
            startPoint: startPoint,
            endPoint: endPoint
        )
    }
}

// MARK: - Animated Gradient

/// Gradiente com animação
struct AnimatedGradient: View {
    let colors: [Color]
    let duration: Double
    let startPoint: UnitPoint
    let endPoint: UnitPoint
    
    @State private var phase: CGFloat = 0
    
    init(
        preset: GradientPreset,
        duration: Double = 3.0,
        startPoint: UnitPoint = .topLeading,
        endPoint: UnitPoint = .bottomTrailing
    ) {
        self.colors = preset.colors
        self.duration = duration
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    init(
        colors: [Color],
        duration: Double = 3.0,
        startPoint: UnitPoint = .topLeading,
        endPoint: UnitPoint = .bottomTrailing
    ) {
        self.colors = colors
        self.duration = duration
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    var body: some View {
        // Cria cores rotacionadas baseado na fase
        let rotatedColors = rotateColors(colors, by: phase)
        
        LinearGradient(
            colors: rotatedColors,
            startPoint: startPoint,
            endPoint: endPoint
        )
        .onAppear {
            withAnimation(
                Animation.linear(duration: duration)
                    .repeatForever(autoreverses: false)
            ) {
                phase = 1.0
            }
        }
    }
    
    /// Rotaciona array de cores
    private func rotateColors(_ colors: [Color], by phase: CGFloat) -> [Color] {
        guard !colors.isEmpty else { return colors }
        
        // Interpola entre cores
        var result: [Color] = []
        for i in 0..<colors.count {
            let nextIndex = (i + 1) % colors.count
            let interpolated = interpolateColor(
                from: colors[i],
                to: colors[nextIndex],
                fraction: phase
            )
            result.append(interpolated)
        }
        return result
    }
    
    /// Interpola entre duas cores
    private func interpolateColor(from: Color, to: Color, fraction: CGFloat) -> Color {
        // Simplificado - na prática usaria CGColor para interpolação precisa
        return from.opacity(1.0 - Double(fraction))
    }
}

// MARK: - Radial Gradient

/// Gradiente radial
struct RadialGradientView: View {
    let preset: GradientPreset
    let center: UnitPoint
    let startRadius: CGFloat
    let endRadius: CGFloat
    
    init(
        _ preset: GradientPreset,
        center: UnitPoint = .center,
        startRadius: CGFloat = 0,
        endRadius: CGFloat = 500
    ) {
        self.preset = preset
        self.center = center
        self.startRadius = startRadius
        self.endRadius = endRadius
    }
    
    var body: some View {
        RadialGradient(
            colors: preset.colors,
            center: center,
            startRadius: startRadius,
            endRadius: endRadius
        )
    }
}

// MARK: - Angular Gradient

/// Gradiente angular (cone)
struct AngularGradientView: View {
    let preset: GradientPreset
    let center: UnitPoint
    let startAngle: Angle
    let endAngle: Angle
    
    init(
        _ preset: GradientPreset,
        center: UnitPoint = .center,
        startAngle: Angle = .zero,
        endAngle: Angle = .degrees(360)
    ) {
        self.preset = preset
        self.center = center
        self.startAngle = startAngle
        self.endAngle = endAngle
    }
    
    var body: some View {
        AngularGradient(
            colors: preset.colors,
            center: center,
            startAngle: startAngle,
            endAngle: endAngle
        )
    }
}

// MARK: - Mesh Gradient (macOS 15+)

/// Mesh gradient (disponível apenas macOS 15+)
@available(macOS 15.0, *)
struct MeshGradientView: View {
    let colors: [Color]
    let points: [SIMD2<Float>]
    
    init(preset: GradientPreset) {
        self.colors = preset.colors
        // Pontos de exemplo para mesh 2x2
        self.points = [
            SIMD2<Float>(0, 0),
            SIMD2<Float>(1, 0),
            SIMD2<Float>(0, 1),
            SIMD2<Float>(1, 1)
        ]
    }
    
    var body: some View {
        // Fallback para linear gradient se mesh não disponível
        LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Gradient Overlay Modifier

/// Modifier para adicionar gradiente como overlay
struct GradientOverlayModifier: ViewModifier {
    let preset: GradientPreset
    let opacity: Double
    let blendMode: BlendMode
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: preset.colors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .opacity(opacity)
                .blendMode(blendMode)
                .allowsHitTesting(false)
            )
    }
}

extension View {
    /// Adiciona gradiente como overlay
    ///
    /// Uso:
    /// ```swift
    /// Image("artwork")
    ///     .gradientOverlay(.music, opacity: 0.3)
    /// ```
    func gradientOverlay(
        _ preset: GradientPreset,
        opacity: Double = 0.5,
        blendMode: BlendMode = .normal
    ) -> some View {
        modifier(GradientOverlayModifier(
            preset: preset,
            opacity: opacity,
            blendMode: blendMode
        ))
    }
}

// MARK: - Artwork Gradient Extractor

/// Extrai cores dominantes de uma imagem
struct ArtworkGradientExtractor {
    
    /// Extrai cores principais de NSImage
    static func extractColors(from image: NSImage?, count: Int = 3) -> [Color] {
        guard let image = image else {
            return GradientPreset.accent.colors
        }
        
        // Simplificado - extrairia cores reais usando CIImage
        // Por ora, retorna cores baseadas no brilho médio
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return GradientPreset.accent.colors
        }
        
        // Análise simplificada
        let width = cgImage.width
        let height = cgImage.height
        
        // Amostra alguns pixels
        let samples = [
            (width / 4, height / 4),
            (width / 2, height / 2),
            (3 * width / 4, 3 * height / 4)
        ]
        
        // Retorna cores de exemplo
        // Em produção, usaria algoritmo K-means ou similar
        return [
            DesignColor.Accent.music,
            DesignColor.Accent.primary,
            DesignColor.Accent.secondary
        ]
    }
    
    /// Cria gradiente de artwork
    static func createGradient(from image: NSImage?) -> GradientPreset {
        let colors = extractColors(from: image)
        return .custom(colors)
    }
}

// MARK: - Preview

#if DEBUG
struct GradientEffects_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: DesignSpacing.xl) {
                Text("Gradient Effects")
                    .font(DesignTypography.title1)
                    .foregroundStyle(.white)
                    .padding(.top)
                
                // Static gradients
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Static Gradients")
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
                            ("Sunrise", GradientPreset.sunrise),
                            ("Ocean", GradientPreset.ocean),
                            ("Forest", GradientPreset.forest),
                            ("Fire", GradientPreset.fire),
                            ("Status", GradientPreset.status),
                        ], id: \.0) { name, preset in
                            VStack(spacing: DesignSpacing.xs) {
                                StaticGradient(preset)
                                    .frame(height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                
                                Text(name)
                                    .font(DesignTypography.caption1)
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                Divider().background(.white.opacity(0.3))
                
                // Animated gradient
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Animated Gradient")
                        .font(DesignTypography.headline)
                        .foregroundStyle(.white)
                    
                    AnimatedGradient(preset: .accent, duration: 3.0)
                        .frame(height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            Text("Watch me animate!")
                                .font(DesignTypography.title3)
                                .foregroundStyle(.white)
                        )
                }
                .padding(.horizontal)
                
                Divider().background(.white.opacity(0.3))
                
                // Radial gradient
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Radial Gradient")
                        .font(DesignTypography.headline)
                        .foregroundStyle(.white)
                    
                    RadialGradientView(.fire, center: .center)
                        .frame(height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal)
                
                Divider().background(.white.opacity(0.3))
                
                // Angular gradient
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Angular Gradient")
                        .font(DesignTypography.headline)
                        .foregroundStyle(.white)
                    
                    AngularGradientView(.ocean, center: .center)
                        .frame(height: 150)
                        .clipShape(Circle())
                }
                .padding(.horizontal)
                
                Divider().background(.white.opacity(0.3))
                
                // Gradient overlay
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Gradient Overlay")
                        .font(DesignTypography.headline)
                        .foregroundStyle(.white)
                    
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .frame(height: 150)
                        .gradientOverlay(.music, opacity: 0.5)
                        .overlay(
                            Text("Text over gradient overlay")
                                .font(DesignTypography.title3)
                                .foregroundStyle(.white)
                        )
                }
                .padding(.horizontal)
                
                Spacer(minLength: 40)
            }
        }
        .background(Color.black)
        .frame(width: 500, height: 1200)
    }
}
#endif
