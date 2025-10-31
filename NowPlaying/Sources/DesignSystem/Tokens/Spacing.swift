//
//  Spacing.swift
//  NowPlaying
//
//  Design System - Spacing Tokens
//  Sistema de espaçamento consistente
//
//  Created by Diego Castilho on 30/10/25
//  Copyright © 2025 Diego Castilho. All rights reserved.
//

import SwiftUI

/// Namespace para todos os espaçamentos do Design System
///
/// Uso:
/// ```swift
/// VStack(spacing: DesignSpacing.md) {
///     Text("Hello")
///         .padding(DesignSpacing.sm)
/// }
/// ```
enum DesignSpacing {
    
    // MARK: - Base Spacing Scale
    
    /// XXS - extra extra small (2pt)
    static let xxs: CGFloat = 2
    
    /// XS - extra small (4pt)
    static let xs: CGFloat = 4
    
    /// SM - small (8pt)
    static let sm: CGFloat = 8
    
    /// MD - medium (12pt) - base spacing
    static let md: CGFloat = 12
    
    /// LG - large (16pt)
    static let lg: CGFloat = 16
    
    /// XL - extra large (24pt)
    static let xl: CGFloat = 24
    
    /// XXL - extra extra large (32pt)
    static let xxl: CGFloat = 32
    
    /// XXXL - extra extra extra large (48pt)
    static let xxxl: CGFloat = 48
    
    /// Huge - huge spacing (64pt)
    static let huge: CGFloat = 64
    
    /// Massive - massive spacing (96pt)
    static let massive: CGFloat = 96
    
    // MARK: - Semantic Spacing
    
    /// Espaçamentos com significado semântico
    enum Semantic {
        /// Padding interno de cards
        static let cardPadding = DesignSpacing.lg
        
        /// Espaçamento entre seções
        static let sectionSpacing = DesignSpacing.xl
        
        /// Espaçamento entre items em lista
        static let listItemSpacing = DesignSpacing.md
        
        /// Padding de botões (horizontal)
        static let buttonPaddingHorizontal = DesignSpacing.lg
        
        /// Padding de botões (vertical)
        static let buttonPaddingVertical = DesignSpacing.sm
        
        /// Espaçamento entre ícone e texto
        static let iconTextSpacing = DesignSpacing.sm
        
        /// Padding de popover/modal
        static let popoverPadding = DesignSpacing.lg
        
        /// Margin da janela principal
        static let windowMargin = DesignSpacing.xl
    }
    
    // MARK: - Corner Radius
    
    /// Border radius (corner radius)
    enum CornerRadius {
        /// None - sem radius (0pt)
        static let none: CGFloat = 0
        
        /// XS - extra small (2pt)
        static let xs: CGFloat = 2
        
        /// SM - small (4pt)
        static let sm: CGFloat = 4
        
        /// MD - medium (8pt) - padrão
        static let md: CGFloat = 8
        
        /// LG - large (12pt)
        static let lg: CGFloat = 12
        
        /// XL - extra large (16pt)
        static let xl: CGFloat = 16
        
        /// XXL - extra extra large (24pt)
        static let xxl: CGFloat = 24
        
        /// Full - circular (999pt)
        static let full: CGFloat = 999
        
        /// Card - radius para cards
        static let card = md
        
        /// Button - radius para botões
        static let button = md
        
        /// Badge - radius para badges
        static let badge = sm
        
        /// Glass - radius para glass elements
        static let glass = lg
    }
    
    // MARK: - Border Width
    
    /// Larguras de borda
    enum BorderWidth {
        /// None - sem borda (0pt)
        static let none: CGFloat = 0
        
        /// Thin - fina (0.5pt)
        static let thin: CGFloat = 0.5
        
        /// Regular - normal (1pt)
        static let regular: CGFloat = 1
        
        /// Medium - média (1.5pt)
        static let medium: CGFloat = 1.5
        
        /// Thick - grossa (2pt)
        static let thick: CGFloat = 2
        
        /// Extra thick - extra grossa (3pt)
        static let extraThick: CGFloat = 3
    }
    
    // MARK: - Icon Sizes
    
    /// Tamanhos de ícones
    enum IconSize {
        /// XS - extra small (12pt)
        static let xs: CGFloat = 12
        
        /// SM - small (16pt)
        static let sm: CGFloat = 16
        
        /// MD - medium (20pt)
        static let md: CGFloat = 20
        
        /// LG - large (24pt)
        static let lg: CGFloat = 24
        
        /// XL - extra large (32pt)
        static let xl: CGFloat = 32
        
        /// XXL - extra extra large (48pt)
        static let xxl: CGFloat = 48
        
        /// Artwork small - capa pequena (60pt)
        static let artworkSmall: CGFloat = 60
        
        /// Artwork medium - capa média (80pt)
        static let artworkMedium: CGFloat = 80
        
        /// Artwork large - capa grande (120pt)
        static let artworkLarge: CGFloat = 120
        
        /// Artwork extra large - capa extra grande (200pt)
        static let artworkXL: CGFloat = 200
    }
}

// MARK: - View Extensions

extension View {
    /// Padding com valores do Design System
    func designPadding(_ value: CGFloat) -> some View {
        self.padding(value)
    }
    
    /// Padding semântico
    func cardPadding() -> some View {
        self.padding(DesignSpacing.Semantic.cardPadding)
    }
    
    /// Corner radius do Design System
    func designCornerRadius(_ radius: CGFloat) -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: radius))
    }
}

// MARK: - Preview

#if DEBUG
struct DesignSpacing_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Design System - Spacing")
                    .font(.title.bold())
                    .padding(.bottom)
                
                // Base spacing scale
                VStack(alignment: .leading, spacing: 16) {
                    Text("Base Spacing Scale")
                        .font(.headline)
                    
                    ForEach([
                        ("XXS", DesignSpacing.xxs),
                        ("XS", DesignSpacing.xs),
                        ("SM", DesignSpacing.sm),
                        ("MD", DesignSpacing.md),
                        ("LG", DesignSpacing.lg),
                        ("XL", DesignSpacing.xl),
                        ("XXL", DesignSpacing.xxl),
                        ("XXXL", DesignSpacing.xxxl),
                    ], id: \.0) { name, value in
                        HStack(spacing: 16) {
                            Text(name)
                                .frame(width: 60, alignment: .leading)
                                .font(.caption.monospacedDigit())
                            
                            Text("\(Int(value))pt")
                                .frame(width: 50, alignment: .leading)
                                .font(.caption.monospacedDigit())
                                .foregroundStyle(.secondary)
                            
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: value, height: 20)
                        }
                    }
                }
                
                Divider()
                
                // Corner radius
                VStack(alignment: .leading, spacing: 16) {
                    Text("Corner Radius")
                        .font(.headline)
                    
                    HStack(spacing: 16) {
                        ForEach([
                            ("SM", DesignSpacing.CornerRadius.sm),
                            ("MD", DesignSpacing.CornerRadius.md),
                            ("LG", DesignSpacing.CornerRadius.lg),
                            ("XL", DesignSpacing.CornerRadius.xl),
                        ], id: \.0) { name, radius in
                            VStack(spacing: 8) {
                                RoundedRectangle(cornerRadius: radius)
                                    .fill(Color.blue)
                                    .frame(width: 60, height: 60)
                                
                                Text(name)
                                    .font(.caption)
                                Text("\(Int(radius))pt")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                
                Divider()
                
                // Icon sizes
                VStack(alignment: .leading, spacing: 16) {
                    Text("Icon Sizes")
                        .font(.headline)
                    
                    HStack(alignment: .top, spacing: 24) {
                        ForEach([
                            ("XS", DesignSpacing.IconSize.xs),
                            ("SM", DesignSpacing.IconSize.sm),
                            ("MD", DesignSpacing.IconSize.md),
                            ("LG", DesignSpacing.IconSize.lg),
                            ("XL", DesignSpacing.IconSize.xl),
                        ], id: \.0) { name, size in
                            VStack(spacing: 8) {
                                Image(systemName: "music.note")
                                    .font(.system(size: size))
                                    .foregroundStyle(.blue)
                                
                                Text(name)
                                    .font(.caption)
                                Text("\(Int(size))pt")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                
                Divider()
                
                // Semantic spacing examples
                VStack(alignment: .leading, spacing: 16) {
                    Text("Semantic Examples")
                        .font(.headline)
                    
                    // Card example
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Card Padding")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        RoundedRectangle(cornerRadius: DesignSpacing.CornerRadius.card)
                            .fill(Color.blue.opacity(0.2))
                            .frame(height: 100)
                            .overlay(
                                Text("Content with card padding")
                                    .padding(DesignSpacing.Semantic.cardPadding)
                            )
                    }
                }
            }
            .padding()
        }
        .frame(width: 600, height: 1000)
    }
}
#endif
