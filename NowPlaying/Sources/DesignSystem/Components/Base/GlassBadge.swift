//
//  GlassBadge.swift
//  NowPlaying
//
//  Design System - Glass Badge Component
//  Badge de status com glassmorphism
//
//  Created by Diego Castilho on 01/11/25
//  Copyright © 2025 Diego Castilho. All rights reserved.//
//

import SwiftUI

/// Badge de status com efeito glass
///
/// Uso básico:
/// ```swift
/// GlassBadge("NOW")
/// GlassBadge("OK", style: .success)
/// ```
///
/// Com ícone:
/// ```swift
/// GlassBadge("Playing", icon: "play.fill", style: .info)
/// ```
struct GlassBadge: View {
    
    // MARK: - Properties
    
    /// Texto do badge
    let text: String
    
    /// Ícone SF Symbol (opcional)
    let icon: String?
    
    /// Estilo do badge
    let style: BadgeStyle
    
    /// Tamanho do badge
    let size: BadgeSize
    
    /// Se deve pulsar (animação)
    let shouldPulse: Bool
    
    // MARK: - State
    
    @State private var isPulsing = false
    
    // MARK: - Enums
    
    enum BadgeStyle {
        case primary      // Azul (accent)
        case secondary    // Roxo
        case success      // Verde (scrobble ok)
        case error        // Vermelho (scrobble failed)
        case warning      // Laranja/Amarelo
        case info         // Azul claro
        case nowPlaying   // Especial para "Now Playing"
        case neutral      // Cinza
        
        var backgroundColor: Color {
            switch self {
            case .primary:
                return DesignColor.Accent.primary.opacity(0.15)
            case .secondary:
                return DesignColor.Accent.secondary.opacity(0.15)
            case .success:
                return DesignColor.Status.success.opacity(0.15)
            case .error:
                return DesignColor.Status.error.opacity(0.15)
            case .warning:
                return DesignColor.Status.warning.opacity(0.15)
            case .info:
                return DesignColor.Status.info.opacity(0.15)
            case .nowPlaying:
                return DesignColor.Semantic.nowPlaying.opacity(0.15)
            case .neutral:
                return DesignColor.Glass.surface2.opacity(0.5)
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .primary:
                return DesignColor.Accent.primary
            case .secondary:
                return DesignColor.Accent.secondary
            case .success:
                return DesignColor.Status.success
            case .error:
                return DesignColor.Status.error
            case .warning:
                return DesignColor.Status.warning
            case .info:
                return DesignColor.Status.info
            case .nowPlaying:
                return DesignColor.Semantic.nowPlaying
            case .neutral:
                return DesignColor.Text.secondary
            }
        }
        
        var borderColor: Color {
            foregroundColor.opacity(0.3)
        }
    }
    
    enum BadgeSize {
        case small
        case medium
        case large
        
        var font: Font {
            switch self {
            case .small:
                return DesignTypography.caption2.bold()
            case .medium:
                return DesignTypography.NowPlaying.badge
            case .large:
                return DesignTypography.caption1.bold()
            }
        }
        
        var horizontalPadding: CGFloat {
            switch self {
            case .small: return DesignSpacing.xs
            case .medium: return DesignSpacing.sm
            case .large: return DesignSpacing.md
            }
        }
        
        var verticalPadding: CGFloat {
            switch self {
            case .small: return DesignSpacing.xxs
            case .medium: return DesignSpacing.xs
            case .large: return DesignSpacing.sm
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .small: return 8
            case .medium: return 10
            case .large: return 12
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .small: return DesignSpacing.CornerRadius.xs
            case .medium: return DesignSpacing.CornerRadius.badge
            case .large: return DesignSpacing.CornerRadius.sm
            }
        }
    }
    
    // MARK: - Initialization
    
    init(
        _ text: String,
        icon: String? = nil,
        style: BadgeStyle = .primary,
        size: BadgeSize = .medium,
        shouldPulse: Bool = false
    ) {
        self.text = text
        self.icon = icon
        self.style = style
        self.size = size
        self.shouldPulse = shouldPulse
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: DesignSpacing.xxs) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: size.iconSize, weight: .bold))
            }
            
            Text(text)
                .font(size.font)
        }
        .foregroundStyle(style.foregroundColor)
        .padding(.horizontal, size.horizontalPadding)
        .padding(.vertical, size.verticalPadding)
        .background(
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .fill(style.backgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .strokeBorder(style.borderColor, lineWidth: DesignSpacing.BorderWidth.thin)
        )
        .opacity(shouldPulse && isPulsing ? 0.7 : 1.0)
        .scaleEffect(shouldPulse && isPulsing ? 1.05 : 1.0)
        .animation(
            shouldPulse
                ? Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)
                : nil,
            value: isPulsing
        )
        .onAppear {
            if shouldPulse {
                isPulsing = true
            }
        }
    }
}

// MARK: - Convenience Initializers

extension GlassBadge {
    /// Badge "NOW" para now playing
    static func nowPlaying() -> GlassBadge {
        GlassBadge("NOW", style: .nowPlaying, shouldPulse: true)
    }
    
    /// Badge de sucesso (scrobble OK)
    static func success(_ text: String = "OK") -> GlassBadge {
        GlassBadge(text, icon: "checkmark.circle.fill", style: .success)
    }
    
    /// Badge de erro (scrobble failed)
    static func error(_ text: String = "FAILED") -> GlassBadge {
        GlassBadge(text, icon: "xmark.circle.fill", style: .error)
    }
    
    /// Badge de scrobble (verde)
    static func scrobbled() -> GlassBadge {
        GlassBadge("SC", style: .success, size: .small)
    }
    
    /// Badge de nowPlaying (azul)
    static func np() -> GlassBadge {
        GlassBadge("NP", style: .nowPlaying, size: .small)
    }
    
    /// Badge informativo
    static func info(_ text: String, icon: String? = nil) -> GlassBadge {
        GlassBadge(text, icon: icon, style: .info)
    }
    
    /// Badge de warning
    static func warning(_ text: String, icon: String? = nil) -> GlassBadge {
        GlassBadge(text, icon: icon, style: .warning)
    }
}

// MARK: - Preview

#if DEBUG
struct GlassBadge_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color(red: 0.4, green: 0.2, blue: 0.8),
                    Color(red: 0.2, green: 0.4, blue: 0.9),
                    Color(red: 0.1, green: 0.5, blue: 0.95)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: DesignSpacing.xl) {
                    Text("Glass Badge Components")
                        .font(DesignTypography.title1)
                        .foregroundStyle(.white)
                        .padding(.top)
                    
                    // Estilos
                    VStack(alignment: .leading, spacing: DesignSpacing.md) {
                        Text("Badge Styles")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        HStack(spacing: DesignSpacing.md) {
                            GlassBadge("Primary", style: .primary)
                            GlassBadge("Secondary", style: .secondary)
                            GlassBadge("Success", style: .success)
                        }
                        
                        HStack(spacing: DesignSpacing.md) {
                            GlassBadge("Error", style: .error)
                            GlassBadge("Warning", style: .warning)
                            GlassBadge("Info", style: .info)
                        }
                        
                        HStack(spacing: DesignSpacing.md) {
                            GlassBadge("Now Playing", style: .nowPlaying)
                            GlassBadge("Neutral", style: .neutral)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider().background(.white.opacity(0.3))
                    
                    // Com ícones
                    VStack(alignment: .leading, spacing: DesignSpacing.md) {
                        Text("With Icons")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        HStack(spacing: DesignSpacing.md) {
                            GlassBadge("Playing", icon: "play.fill", style: .nowPlaying)
                            GlassBadge("Success", icon: "checkmark.circle.fill", style: .success)
                            GlassBadge("Error", icon: "xmark.circle.fill", style: .error)
                        }
                        
                        HStack(spacing: DesignSpacing.md) {
                            GlassBadge("New", icon: "sparkles", style: .warning)
                            GlassBadge("Info", icon: "info.circle.fill", style: .info)
                            GlassBadge("Star", icon: "star.fill", style: .primary)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider().background(.white.opacity(0.3))
                    
                    // Tamanhos
                    VStack(alignment: .leading, spacing: DesignSpacing.md) {
                        Text("Badge Sizes")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        HStack(alignment: .center, spacing: DesignSpacing.md) {
                            GlassBadge("Small", size: .small)
                            GlassBadge("Medium", size: .medium)
                            GlassBadge("Large", size: .large)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider().background(.white.opacity(0.3))
                    
                    // Convenience
                    VStack(alignment: .leading, spacing: DesignSpacing.md) {
                        Text("Convenience Badges")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        HStack(spacing: DesignSpacing.md) {
                            GlassBadge.nowPlaying()
                            GlassBadge.success()
                            GlassBadge.error()
                        }
                        
                        HStack(spacing: DesignSpacing.md) {
                            GlassBadge.scrobbled()
                            GlassBadge.np()
                            GlassBadge.info("Beta")
                            GlassBadge.warning("New")
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider().background(.white.opacity(0.3))
                    
                    // Animação
                    VStack(alignment: .leading, spacing: DesignSpacing.md) {
                        Text("Animated (Pulse)")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        HStack(spacing: DesignSpacing.md) {
                            GlassBadge("NOW", style: .nowPlaying, shouldPulse: true)
                            GlassBadge("LIVE", icon: "circle.fill", style: .error, shouldPulse: true)
                            GlassBadge("NEW", icon: "sparkles", style: .warning, shouldPulse: true)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider().background(.white.opacity(0.3))
                    
                    // Uso real
                    VStack(alignment: .leading, spacing: DesignSpacing.md) {
                        Text("Real Use Cases")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        // Lista de logs simulada
                        VStack(spacing: DesignSpacing.sm) {
                            GlassCard {
                                HStack(spacing: DesignSpacing.md) {
                                    GlassBadge.np()
                                    
                                    VStack(alignment: .leading, spacing: DesignSpacing.xxs) {
                                        Text("Bohemian Rhapsody")
                                            .font(DesignTypography.headline)
                                        Text("Queen")
                                            .font(DesignTypography.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    GlassBadge.success()
                                }
                            }
                            
                            GlassCard {
                                HStack(spacing: DesignSpacing.md) {
                                    GlassBadge.scrobbled()
                                    
                                    VStack(alignment: .leading, spacing: DesignSpacing.xxs) {
                                        Text("Stairway to Heaven")
                                            .font(DesignTypography.headline)
                                        Text("Led Zeppelin")
                                            .font(DesignTypography.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    GlassBadge.error()
                                }
                            }
                            
                            GlassCard {
                                HStack(spacing: DesignSpacing.md) {
                                    GlassBadge.nowPlaying()
                                    
                                    VStack(alignment: .leading, spacing: DesignSpacing.xxs) {
                                        Text("Hotel California")
                                            .font(DesignTypography.headline)
                                        Text("Eagles")
                                            .font(DesignTypography.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Circle()
                                        .fill(DesignColor.Status.success)
                                        .frame(width: 10, height: 10)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .frame(width: 500, height: 1200)
    }
}
#endif
