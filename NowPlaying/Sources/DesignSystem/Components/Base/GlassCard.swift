//
//  GlassCard.swift
//  NowPlaying
//
//  Design System - Glass Card Component
//  Card com efeito glassmorphism
//
//  Created by Diego Castilho on 01/11/25
//  Copyright © 2025 Diego Castilho. All rights reserved.//
//

import SwiftUI

/// Card com efeito glassmorphism
///
/// Uso básico:
/// ```swift
/// GlassCard {
///     Text("Hello")
/// }
/// ```
///
/// Com customização:
/// ```swift
/// GlassCard(
///     padding: DesignSpacing.lg,
///     cornerRadius: DesignSpacing.CornerRadius.glass,
///     shadow: .prominent
/// ) {
///     VStack {
///         Text("Title")
///         Text("Content")
///     }
/// }
/// ```
struct GlassCard<Content: View>: View {
    
    // MARK: - Properties
    
    /// Conteúdo do card
    let content: Content
    
    /// Padding interno
    let padding: CGFloat
    
    /// Corner radius
    let cornerRadius: CGFloat
    
    /// Tipo de sombra
    let shadow: ShadowType
    
    /// Cor de fundo (glass surface)
    let backgroundColor: Color
    
    /// Cor da borda
    let borderColor: Color
    
    /// Largura da borda
    let borderWidth: CGFloat
    
    /// Se deve usar blur background
    let useBlur: Bool
    
    // MARK: - Shadow Type
    
    enum ShadowType {
        case none
        case subtle
        case medium
        case prominent
        case custom(ShadowStyle)
        
        var style: ShadowStyle {
            switch self {
            case .none:
                return DesignShadow.none
            case .subtle:
                return DesignShadow.sm
            case .medium:
                return DesignShadow.md
            case .prominent:
                return DesignShadow.lg
            case .custom(let style):
                return style
            }
        }
    }
    
    // MARK: - Initialization
    
    /// Inicializador completo
    init(
        padding: CGFloat = DesignSpacing.Semantic.cardPadding,
        cornerRadius: CGFloat = DesignSpacing.CornerRadius.glass,
        shadow: ShadowType = .medium,
        backgroundColor: Color = DesignColor.Glass.surface1,
        borderColor: Color = DesignColor.Glass.border,
        borderWidth: CGFloat = DesignSpacing.BorderWidth.thin,
        useBlur: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.useBlur = useBlur
        self.content = content()
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Background com blur (se habilitado)
            if useBlur {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
            }
            
            // Glass surface
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(backgroundColor)
            
            // Content
            content
                .padding(padding)
        }
        .overlay(
            // Border
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(borderColor, lineWidth: borderWidth)
        )
        .shadow(shadow.style)
    }
}

// MARK: - Convenience Initializers

extension GlassCard {
    /// Card padrão com apenas conteúdo
    init(@ViewBuilder content: () -> Content) {
        self.init(
            padding: DesignSpacing.Semantic.cardPadding,
            cornerRadius: DesignSpacing.CornerRadius.glass,
            shadow: .medium,
            backgroundColor: DesignColor.Glass.surface1,
            borderColor: DesignColor.Glass.border,
            borderWidth: DesignSpacing.BorderWidth.thin,
            useBlur: true,
            content: content
        )
    }
    
    /// Card sem blur (performance)
    static func noBlur(@ViewBuilder content: () -> Content) -> GlassCard {
        GlassCard(
            useBlur: false,
            content: content
        )
    }
    
    /// Card com sombra pronunciada
    static func prominent(@ViewBuilder content: () -> Content) -> GlassCard {
        GlassCard(
            shadow: .prominent,
            content: content
        )
    }
    
    /// Card sutil (menos destaque)
    static func subtle(@ViewBuilder content: () -> Content) -> GlassCard {
        GlassCard(
            shadow: .subtle,
            backgroundColor: DesignColor.Glass.surface1.opacity(0.5),
            content: content
        )
    }
}

// MARK: - Preview

#if DEBUG
struct GlassCard_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            // Background gradient para visualizar glass effect
            LinearGradient(
                colors: [
                    Color(red: 0.4, green: 0.2, blue: 0.8),  // Roxo
                    Color(red: 0.2, green: 0.4, blue: 0.9),  // Azul
                    Color(red: 0.1, green: 0.5, blue: 0.95)  // Azul claro
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: DesignSpacing.xl) {
                    Text("Glass Card Components")
                        .font(DesignTypography.title1)
                        .foregroundStyle(.white)
                        .padding(.top)
                    
                    // Card padrão
                    VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                        Text("Default Card")
                            .font(DesignTypography.caption1)
                            .foregroundStyle(.white.opacity(0.7))
                        
                        GlassCard {
                            VStack(alignment: .leading, spacing: DesignSpacing.md) {
                                Text("Glass Card")
                                    .font(DesignTypography.headline)
                                
                                Text("This is a glass card with default settings. It has blur, border, and medium shadow.")
                                    .font(DesignTypography.body)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Card sem blur
                    VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                        Text("No Blur (Performance)")
                            .font(DesignTypography.caption1)
                            .foregroundStyle(.white.opacity(0.7))
                        
                        GlassCard.noBlur {
                            VStack(alignment: .leading, spacing: DesignSpacing.md) {
                                Text("No Blur Card")
                                    .font(DesignTypography.headline)
                                
                                Text("Better performance without blur effect.")
                                    .font(DesignTypography.body)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Card prominent
                    VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                        Text("Prominent Shadow")
                            .font(DesignTypography.caption1)
                            .foregroundStyle(.white.opacity(0.7))
                        
                        GlassCard.prominent {
                            VStack(alignment: .leading, spacing: DesignSpacing.md) {
                                Text("Prominent Card")
                                    .font(DesignTypography.headline)
                                
                                Text("More elevation with prominent shadow.")
                                    .font(DesignTypography.body)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Card subtle
                    VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                        Text("Subtle (Less Emphasis)")
                            .font(DesignTypography.caption1)
                            .foregroundStyle(.white.opacity(0.7))
                        
                        GlassCard.subtle {
                            VStack(alignment: .leading, spacing: DesignSpacing.md) {
                                Text("Subtle Card")
                                    .font(DesignTypography.headline)
                                
                                Text("Less emphasis, more transparent.")
                                    .font(DesignTypography.body)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Card com conteúdo real
                    VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                        Text("Real Content Example")
                            .font(DesignTypography.caption1)
                            .foregroundStyle(.white.opacity(0.7))
                        
                        GlassCard {
                            HStack(spacing: DesignSpacing.lg) {
                                // Mock artwork
                                RoundedRectangle(cornerRadius: DesignSpacing.CornerRadius.md)
                                    .fill(DesignColor.Accent.music)
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Image(systemName: "music.note")
                                            .font(.system(size: 24))
                                            .foregroundStyle(.white)
                                    )
                                
                                VStack(alignment: .leading, spacing: DesignSpacing.xs) {
                                    Text("Bohemian Rhapsody")
                                        .font(DesignTypography.NowPlaying.trackName)
                                        .lineLimit(1)
                                    
                                    Text("Queen")
                                        .font(DesignTypography.NowPlaying.artistName)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(1)
                                    
                                    Text("A Night at the Opera")
                                        .font(DesignTypography.NowPlaying.albumName)
                                        .foregroundStyle(.tertiary)
                                        .lineLimit(1)
                                }
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .frame(width: 500, height: 900)
    }
}
#endif
