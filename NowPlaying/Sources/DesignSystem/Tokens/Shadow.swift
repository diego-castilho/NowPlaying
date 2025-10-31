//
//  Shadows.swift
//  NowPlaying
//
//  Design System - Shadow Tokens
//  Sistema de sombras para profundidade e elevação
//
//  Created by Diego Castilho on 31/10/25
//  Copyright © 2025 Diego Castilho. All rights reserved.
//

import SwiftUI

/// Namespace para todas as sombras do Design System
///
/// Uso:
/// ```swift
/// RoundedRectangle(cornerRadius: 12)
///     .fill(Color.white)
///     .shadow(DesignShadow.medium)
/// ```
enum DesignShadow {
    
    // MARK: - Shadow Definitions
    
    /// Sombra nenhuma (flat)
    static let none = ShadowStyle(
        color: .clear,
        radius: 0,
        x: 0,
        y: 0
    )
    
    /// Sombra XS - muito sutil
    static let xs = ShadowStyle(
        color: Color.black.opacity(0.05),
        radius: 2,
        x: 0,
        y: 1
    )
    
    /// Sombra SM - sutil
    static let sm = ShadowStyle(
        color: Color.black.opacity(0.08),
        radius: 4,
        x: 0,
        y: 2
    )
    
    /// Sombra MD - média (padrão)
    static let md = ShadowStyle(
        color: Color.black.opacity(0.10),
        radius: 8,
        x: 0,
        y: 4
    )
    
    /// Sombra LG - pronunciada
    static let lg = ShadowStyle(
        color: Color.black.opacity(0.12),
        radius: 12,
        x: 0,
        y: 6
    )
    
    /// Sombra XL - muito pronunciada
    static let xl = ShadowStyle(
        color: Color.black.opacity(0.15),
        radius: 16,
        x: 0,
        y: 8
    )
    
    /// Sombra XXL - dramática
    static let xxl = ShadowStyle(
        color: Color.black.opacity(0.20),
        radius: 24,
        x: 0,
        y: 12
    )
    
    // MARK: - Semantic Shadows
    
    /// Sombras com significado semântico
    enum Semantic {
        /// Card elevation - para cards
        static let card = DesignShadow.md
        
        /// Button elevation - para botões
        static let button = DesignShadow.sm
        
        /// Button hover - botão em hover
        static let buttonHover = DesignShadow.md
        
        /// Button pressed - botão pressionado
        static let buttonPressed = DesignShadow.xs
        
        /// Popover - para popovers e modals
        static let popover = DesignShadow.xl
        
        /// Menu - para menus dropdown
        static let menu = DesignShadow.lg
        
        /// Glass - para glass elements
        static let glass = DesignShadow.lg
        
        /// Artwork - para capas de álbum
        static let artwork = DesignShadow.xl
        
        /// Floating - para elementos que flutuam
        static let floating = DesignShadow.xxl
    }
    
    // MARK: - Colored Shadows
    
    /// Sombras coloridas (para efeitos especiais)
    enum Colored {
        /// Sombra azul (accent)
        static func accent(opacity: Double = 0.3) -> ShadowStyle {
            ShadowStyle(
                color: Color.blue.opacity(opacity),
                radius: 12,
                x: 0,
                y: 4
            )
        }
        
        /// Sombra roxa (secondary)
        static func secondary(opacity: Double = 0.3) -> ShadowStyle {
            ShadowStyle(
                color: Color.purple.opacity(opacity),
                radius: 12,
                x: 0,
                y: 4
            )
        }
        
        /// Sombra de sucesso (verde)
        static func success(opacity: Double = 0.3) -> ShadowStyle {
            ShadowStyle(
                color: Color.green.opacity(opacity),
                radius: 8,
                x: 0,
                y: 3
            )
        }
        
        /// Sombra de erro (vermelho)
        static func error(opacity: Double = 0.3) -> ShadowStyle {
            ShadowStyle(
                color: Color.red.opacity(opacity),
                radius: 8,
                x: 0,
                y: 3
            )
        }
        
        /// Sombra personalizada
        static func custom(color: Color, opacity: Double = 0.3, radius: CGFloat = 12) -> ShadowStyle {
            ShadowStyle(
                color: color.opacity(opacity),
                radius: radius,
                x: 0,
                y: radius / 3
            )
        }
    }
    
    // MARK: - Inner Shadows (simuladas)
    
    /// Inner shadows (efeito de profundidade interna)
    /// Nota: SwiftUI não tem inner shadow nativo, então simulamos com overlay
    enum Inner {
        /// Inner shadow subtle
        static let subtle = Color.black.opacity(0.05)
        
        /// Inner shadow medium
        static let medium = Color.black.opacity(0.10)
        
        /// Inner shadow strong
        static let strong = Color.black.opacity(0.15)
    }
}

// MARK: - Shadow Style Struct

/// Struct que encapsula propriedades de sombra
struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
    
    init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
}

// MARK: - View Extensions

extension View {
    /// Aplica sombra do Design System
    ///
    /// Exemplo:
    /// ```swift
    /// RoundedRectangle(cornerRadius: 12)
    ///     .shadow(DesignShadow.md)
    /// ```
    func shadow(_ style: ShadowStyle) -> some View {
        self.shadow(
            color: style.color,
            radius: style.radius,
            x: style.x,
            y: style.y
        )
    }
    
    /// Aplica múltiplas sombras (layered shadows para efeito mais realista)
    ///
    /// Exemplo:
    /// ```swift
    /// RoundedRectangle(cornerRadius: 12)
    ///     .layeredShadow(primary: DesignShadow.lg, secondary: DesignShadow.xs)
    /// ```
    func layeredShadow(primary: ShadowStyle, secondary: ShadowStyle) -> some View {
        self
            .shadow(primary)
            .shadow(secondary)
    }
    
    /// Sombra de card (pré-configurada)
    func cardShadow() -> some View {
        self.shadow(DesignShadow.Semantic.card)
    }
    
    /// Sombra de glass (pré-configurada)
    func glassShadow() -> some View {
        self.shadow(DesignShadow.Semantic.glass)
    }
    
    /// Inner shadow simulado
    func innerShadow(color: Color = DesignShadow.Inner.subtle, cornerRadius: CGFloat = 0) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(color, lineWidth: 1)
                .blur(radius: 2)
                .offset(x: 0, y: 1)
                .mask(RoundedRectangle(cornerRadius: cornerRadius))
        )
    }
}

// MARK: - Preview

#if DEBUG
struct DesignShadow_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text("Design System - Shadows")
                    .font(.title.bold())
                    .padding(.bottom)
                
                // Standard shadows
                VStack(alignment: .leading, spacing: 24) {
                    Text("Standard Shadows")
                        .font(.headline)
                    
                    HStack(spacing: 24) {
                        ForEach([
                            ("None", DesignShadow.none),
                            ("XS", DesignShadow.xs),
                            ("SM", DesignShadow.sm),
                            ("MD", DesignShadow.md),
                        ], id: \.0) { name, shadow in
                            VStack(spacing: 12) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                    .frame(width: 80, height: 80)
                                    .shadow(shadow)
                                
                                Text(name)
                                    .font(.caption)
                            }
                        }
                    }
                    
                    HStack(spacing: 24) {
                        ForEach([
                            ("LG", DesignShadow.lg),
                            ("XL", DesignShadow.xl),
                            ("XXL", DesignShadow.xxl),
                        ], id: \.0) { name, shadow in
                            VStack(spacing: 12) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                    .frame(width: 80, height: 80)
                                    .shadow(shadow)
                                
                                Text(name)
                                    .font(.caption)
                            }
                        }
                    }
                }
                
                Divider()
                
                // Semantic shadows
                VStack(alignment: .leading, spacing: 24) {
                    Text("Semantic Shadows")
                        .font(.headline)
                    
                    HStack(spacing: 24) {
                        VStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .frame(width: 100, height: 80)
                                .shadow(DesignShadow.Semantic.card)
                            
                            Text("Card")
                                .font(.caption)
                        }
                        
                        VStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue)
                                .frame(width: 100, height: 40)
                                .shadow(DesignShadow.Semantic.button)
                            
                            Text("Button")
                                .font(.caption)
                        }
                        
                        VStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.8))
                                .frame(width: 100, height: 80)
                                .shadow(DesignShadow.Semantic.glass)
                            
                            Text("Glass")
                                .font(.caption)
                        }
                    }
                }
                
                Divider()
                
                // Colored shadows
                VStack(alignment: .leading, spacing: 24) {
                    Text("Colored Shadows")
                        .font(.headline)
                    
                    HStack(spacing: 24) {
                        VStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue)
                                .frame(width: 80, height: 80)
                                .shadow(DesignShadow.Colored.accent())
                            
                            Text("Accent")
                                .font(.caption)
                        }
                        
                        VStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.green)
                                .frame(width: 80, height: 80)
                                .shadow(DesignShadow.Colored.success())
                            
                            Text("Success")
                                .font(.caption)
                        }
                        
                        VStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.red)
                                .frame(width: 80, height: 80)
                                .shadow(DesignShadow.Colored.error())
                            
                            Text("Error")
                                .font(.caption)
                        }
                    }
                }
                
                Divider()
                
                // Layered shadows
                VStack(alignment: .leading, spacing: 24) {
                    Text("Layered Shadow (Realistic)")
                        .font(.headline)
                    
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .frame(width: 200, height: 120)
                        .layeredShadow(
                            primary: DesignShadow.lg,
                            secondary: DesignShadow.xs
                        )
                    
                    Text("Multiple shadow layers create more realistic depth")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(40)
            .frame(maxWidth: .infinity)
            .background(Color(.sRGB, white: 0.95, opacity: 1))
        }
        .frame(width: 700, height: 1000)
    }
}
#endif
