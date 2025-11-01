//
//  Typography.swift
//  NowPlaying
//
//  Design System - Typography Tokens
//  Sistema de tipografia centralizado com escalas e pesos
//

import SwiftUI

/// Namespace para todas as definições de tipografia do Design System
///
/// Uso:
/// ```swift
/// Text("Hello")
///     .font(DesignTypography.title1)
///
/// Text("Subtitle")
///     .font(DesignTypography.body)
///     .foregroundStyle(DesignTypography.Color.secondary)
/// ```
enum DesignTypography {
    
    // MARK: - Font Sizes
    
    /// Tamanhos base de fonte
    enum Size {
        /// Display - para títulos muito grandes (48pt)
        static let display: CGFloat = 48
        
        /// Title 1 - título principal (34pt)
        static let title1: CGFloat = 34
        
        /// Title 2 - título secundário (28pt)
        static let title2: CGFloat = 28
        
        /// Title 3 - título terciário (22pt)
        static let title3: CGFloat = 22
        
        /// Headline - cabeçalhos (17pt)
        static let headline: CGFloat = 17
        
        /// Body - texto padrão (15pt)
        static let body: CGFloat = 15
        
        /// Callout - texto de destaque menor (14pt)
        static let callout: CGFloat = 14
        
        /// Subheadline - subtítulos (13pt)
        static let subheadline: CGFloat = 13
        
        /// Footnote - notas de rodapé (12pt)
        static let footnote: CGFloat = 12
        
        /// Caption 1 - legendas (11pt)
        static let caption1: CGFloat = 11
        
        /// Caption 2 - legendas menores (10pt)
        static let caption2: CGFloat = 10
    }
    
    // MARK: - Font Weights
    
    /// Pesos de fonte
    enum Weight {
        static let ultraLight = Font.Weight.ultraLight
        static let thin = Font.Weight.thin
        static let light = Font.Weight.light
        static let regular = Font.Weight.regular
        static let medium = Font.Weight.medium
        static let semibold = Font.Weight.semibold
        static let bold = Font.Weight.bold
        static let heavy = Font.Weight.heavy
        static let black = Font.Weight.black
    }
    
    // MARK: - Predefined Styles
    
    /// Display - para títulos hero muito grandes
    static let display = Font.system(size: Size.display, weight: Weight.black)
    
    /// Title 1 - título principal
    static let title1 = Font.system(size: Size.title1, weight: Weight.bold)
    
    /// Title 2 - título secundário
    static let title2 = Font.system(size: Size.title2, weight: Weight.bold)
    
    /// Title 3 - título terciário
    static let title3 = Font.system(size: Size.title3, weight: Weight.semibold)
    
    /// Headline - cabeçalhos
    static let headline = Font.system(size: Size.headline, weight: Weight.semibold)
    
    /// Body - texto padrão
    static let body = Font.system(size: Size.body, weight: Weight.regular)
    
    /// Body Emphasized - texto padrão com ênfase
    static let bodyEmphasized = Font.system(size: Size.body, weight: Weight.medium)
    
    /// Callout - texto de destaque menor
    static let callout = Font.system(size: Size.callout, weight: Weight.regular)
    
    /// Callout Emphasized - callout com ênfase
    static let calloutEmphasized = Font.system(size: Size.callout, weight: Weight.medium)
    
    /// Subheadline - subtítulos
    static let subheadline = Font.system(size: Size.subheadline, weight: Weight.regular)
    
    /// Footnote - notas de rodapé
    static let footnote = Font.system(size: Size.footnote, weight: Weight.regular)
    
    /// Caption 1 - legendas
    static let caption1 = Font.system(size: Size.caption1, weight: Weight.regular)
    
    /// Caption 2 - legendas menores
    static let caption2 = Font.system(size: Size.caption2, weight: Weight.regular)
    
    // MARK: - Design System Specific
    
    /// Estilos específicos do NowPlaying
    enum NowPlaying {
        /// Track name - nome da música (destaque)
        static let trackName = Font.system(size: Size.title2, weight: Weight.bold)
        
        /// Artist name - nome do artista
        static let artistName = Font.system(size: Size.headline, weight: Weight.semibold)
        
        /// Album name - nome do álbum
        static let albumName = Font.system(size: Size.subheadline, weight: Weight.regular)
        
        /// Timestamp - data/hora
        static let timestamp = Font.system(size: Size.caption1, weight: Weight.regular)
        
        /// Badge - badges de status (NOW, OK, FAILED)
        static let badge = Font.system(size: Size.caption2, weight: Weight.bold)
        
        /// Button - botões
        static let button = Font.system(size: Size.body, weight: Weight.medium)
        
        /// Button Small - botões pequenos
        static let buttonSmall = Font.system(size: Size.callout, weight: Weight.medium)
        
        /// Menu Item - itens de menu
        static let menuItem = Font.system(size: Size.body, weight: Weight.regular)
        
        /// Stats Number - números de estatísticas
        static let statsNumber = Font.system(size: Size.title1, weight: Weight.bold)
        
        /// Stats Label - labels de estatísticas
        static let statsLabel = Font.system(size: Size.caption1, weight: Weight.medium)
    }
    
    // MARK: - Line Height
    
    /// Line heights (spacing entre linhas)
    enum LineHeight {
        /// Tight - apertado (1.2x)
        static let tight: CGFloat = 1.2
        
        /// Normal - normal (1.4x)
        static let normal: CGFloat = 1.4
        
        /// Relaxed - relaxado (1.6x)
        static let relaxed: CGFloat = 1.6
        
        /// Loose - solto (1.8x)
        static let loose: CGFloat = 1.8
    }
    
    // MARK: - Letter Spacing
    
    /// Letter spacing (kerning)
    enum LetterSpacing {
        /// Tight - apertado (-0.5pt)
        static let tight: CGFloat = -0.5
        
        /// Normal - normal (0pt)
        static let normal: CGFloat = 0
        
        /// Relaxed - relaxado (0.5pt)
        static let relaxed: CGFloat = 0.5
        
        /// Wide - largo (1pt)
        static let wide: CGFloat = 1.0
        
        /// Extra wide - extra largo (2pt)
        static let extraWide: CGFloat = 2.0
    }
}

// MARK: - View Modifiers

extension View {
    /// Aplica estilo de tipografia com configurações adicionais
    ///
    /// Exemplo:
    /// ```swift
    /// Text("Hello")
    ///     .typography(
    ///         font: DesignTypography.title1,
    ///         color: DesignColor.Text.primary,
    ///         lineHeight: DesignTypography.LineHeight.tight,
    ///         letterSpacing: DesignTypography.LetterSpacing.tight
    ///     )
    /// ```
    func typography(
        font: Font,
        color: Color? = nil,
        lineHeight: CGFloat? = nil,
        letterSpacing: CGFloat? = nil
    ) -> some View {
        self
            .font(font)
            .if(color != nil) { view in
                view.foregroundStyle(color!)
            }
            .if(lineHeight != nil) { view in
                view.lineSpacing((lineHeight! - 1.0) * 10) // Aproximação
            }
            .if(letterSpacing != nil) { view in
                view.tracking(letterSpacing!)
            }
    }
}

// MARK: - Preview

#if DEBUG
struct DesignTypography_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Design System - Typography")
                    .font(.title.bold())
                    .padding(.bottom)
                
                // Display
                VStack(alignment: .leading, spacing: 8) {
                    Text("Display")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("The quick brown fox")
                        .font(DesignTypography.display)
                }
                
                Divider()
                
                // Titles
                Group {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title 1")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("The quick brown fox")
                            .font(DesignTypography.title1)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title 2")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("The quick brown fox")
                            .font(DesignTypography.title2)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title 3")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("The quick brown fox")
                            .font(DesignTypography.title3)
                    }
                }
                
                Divider()
                
                // Body text
                Group {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Headline")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("The quick brown fox jumps over the lazy dog")
                            .font(DesignTypography.headline)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Body")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("The quick brown fox jumps over the lazy dog. Lorem ipsum dolor sit amet.")
                            .font(DesignTypography.body)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Callout")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("The quick brown fox jumps over the lazy dog")
                            .font(DesignTypography.callout)
                    }
                }
                
                Divider()
                
                // Small text
                Group {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Subheadline")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("The quick brown fox jumps over the lazy dog")
                            .font(DesignTypography.subheadline)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Footnote")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("The quick brown fox jumps over the lazy dog")
                            .font(DesignTypography.footnote)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Caption 1")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("The quick brown fox jumps over the lazy dog")
                            .font(DesignTypography.caption1)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Caption 2")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("The quick brown fox jumps over the lazy dog")
                            .font(DesignTypography.caption2)
                    }
                }
                
                Divider()
                
                // NowPlaying specific
                VStack(alignment: .leading, spacing: 16) {
                    Text("NowPlaying Specific Styles")
                        .font(.headline)
                        .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Track Name")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("Bohemian Rhapsody")
                            .font(DesignTypography.NowPlaying.trackName)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Artist Name")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("Queen")
                            .font(DesignTypography.NowPlaying.artistName)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Album Name")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("A Night at the Opera")
                            .font(DesignTypography.NowPlaying.albumName)
                    }
                    
                    HStack(spacing: 16) {
                        Text("NOW")
                            .font(DesignTypography.NowPlaying.badge)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(6)
                        
                        Text("Button")
                            .font(DesignTypography.NowPlaying.button)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .foregroundStyle(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
        .frame(width: 500, height: 1200)
    }
}
#endif
