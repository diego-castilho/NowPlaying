//
//  Colors.swift
//  NowPlaying
//
//  Design System - Color Tokens
//  Paleta de cores centralizada para todo o app
//
//  Created by Diego Castilho on 30/10/25
//  Copyright © 2025 Diego Castilho. All rights reserved.
//

import SwiftUI

/// Namespace para todas as cores do Design System
///
/// Uso:
/// ```swift
/// Text("Hello")
///     .foregroundStyle(DesignColor.text.primary)
///     .background(DesignColor.glass.surface)
/// ```
enum DesignColor {
    
    // MARK: - Glass Surfaces
    
    /// Cores para efeitos de Glassmorphism
    enum Glass {
        /// Glass light - para light mode
        /// Branco semi-transparente com blur
        static let light = Color(.sRGB, white: 1.0, opacity: 0.75)
        
        /// Glass dark - para dark mode
        /// Preto semi-transparente com blur
        static let dark = Color(.sRGB, white: 0.1, opacity: 0.70)
        
        /// Surface 1 - mais clara/leve
        static let surface1 = Color(.sRGB, white: 0.95, opacity: 0.85)
        
        /// Surface 2 - intermediária
        static let surface2 = Color(.sRGB, white: 0.90, opacity: 0.90)
        
        /// Surface 3 - mais escura/sólida
        static let surface3 = Color(.sRGB, white: 0.85, opacity: 0.95)
        
        /// Border - borda sutil para glass cards
        static let border = Color(.sRGB, white: 1.0, opacity: 0.3)
        
        /// Border dark - borda para dark mode
        static let borderDark = Color(.sRGB, white: 1.0, opacity: 0.1)
    }
    
    // MARK: - Accent Colors
    
    /// Cores de destaque principais do app
    enum Accent {
        /// Primary accent - azul vibrante
        static let primary = Color(red: 0.0, green: 0.48, blue: 1.0)
        
        /// Secondary accent - roxo elegante
        static let secondary = Color(red: 0.69, green: 0.32, blue: 0.87)
        
        /// Tertiary accent - rosa suave
        static let tertiary = Color(red: 1.0, green: 0.27, blue: 0.63)
        
        /// Music accent - laranja vibrante (Last.fm inspired)
        static let music = Color(red: 0.91, green: 0.30, blue: 0.24)
    }
    
    // MARK: - Status Colors
    
    /// Cores para indicar status/estado
    enum Status {
        /// Success - verde
        static let success = Color(red: 0.20, green: 0.78, blue: 0.35)
        
        /// Warning - amarelo/laranja
        static let warning = Color(red: 1.0, green: 0.58, blue: 0.0)
        
        /// Error - vermelho
        static let error = Color(red: 1.0, green: 0.23, blue: 0.19)
        
        /// Info - azul claro
        static let info = Color(red: 0.35, green: 0.78, blue: 0.98)
        
        /// Neutral - cinza
        static let neutral = Color(.sRGB, white: 0.60, opacity: 1.0)
    }
    
    // MARK: - Text Colors
    
    /// Cores para texto
    enum Text {
        /// Primary text - máximo contraste
        static let primary = Color.primary
        
        /// Secondary text - médio contraste
        static let secondary = Color.secondary
        
        /// Tertiary text - baixo contraste
        static let tertiary = Color(.sRGB, white: 0.50, opacity: 1.0)
        
        /// Disabled text - muito baixo contraste
        static let disabled = Color(.sRGB, white: 0.60, opacity: 0.5)
        
        /// On accent - texto sobre cores de destaque
        static let onAccent = Color.white
        
        /// On dark - texto garantido para fundos escuros
        static let onDark = Color.white
        
        /// On light - texto garantido para fundos claros
        static let onLight = Color.black
    }
    
    // MARK: - Background Colors
    
    /// Cores para fundos
    enum Background {
        /// Primary background - fundo principal do app
        static let primary = Color(.sRGB, white: 0.98, opacity: 1.0)
        
        /// Secondary background - cards, sections
        static let secondary = Color(.sRGB, white: 0.94, opacity: 1.0)
        
        /// Tertiary background - nested elements
        static let tertiary = Color(.sRGB, white: 0.90, opacity: 1.0)
        
        /// Elevated - elementos que flutuam
        static let elevated = Color.white
        
        /// Overlay - para modals, popovers
        static let overlay = Color.black.opacity(0.3)
    }
    
    // MARK: - Semantic Colors
    
    /// Cores com significado semântico específico
    enum Semantic {
        /// Now Playing indicator
        static let nowPlaying = Accent.music
        
        /// Scrobble success
        static let scrobbled = Status.success
        
        /// Scrobble failed
        static let scrobbleFailed = Status.error
        
        /// Loading/Processing
        static let loading = Accent.primary
        
        /// Last.fm brand color
        static let lastfm = Color(red: 0.83, green: 0.0, blue: 0.0)
        
        /// Apple Music brand color
        static let appleMusic = Color(red: 0.98, green: 0.22, blue: 0.44)
    }
    
    // MARK: - Gradients
    
    /// Gradientes prontos para uso
    enum Gradients {
        /// Gradient glassmorphism - para borders
        static let glassBorder = LinearGradient(
            colors: [
                Color.white.opacity(0.5),
                Color.white.opacity(0.2),
                Color.white.opacity(0.1)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        /// Gradient accent - primary to secondary
        static let accent = LinearGradient(
            colors: [Accent.primary, Accent.secondary],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        /// Gradient music - warm vibrant
        static let music = LinearGradient(
            colors: [Accent.music, Accent.tertiary],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        /// Gradient subtle - para fundos discretos
        static let subtle = LinearGradient(
            colors: [
                Background.primary,
                Background.secondary
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// MARK: - Preview Helpers

#if DEBUG
extension DesignColor {
    /// Todas as cores para preview/documentação
    static var allColors: [(String, Color)] {
        [
            // Glass
            ("Glass Light", Glass.light),
            ("Glass Dark", Glass.dark),
            ("Surface 1", Glass.surface1),
            ("Surface 2", Glass.surface2),
            ("Surface 3", Glass.surface3),
            
            // Accent
            ("Primary Accent", Accent.primary),
            ("Secondary Accent", Accent.secondary),
            ("Tertiary Accent", Accent.tertiary),
            ("Music Accent", Accent.music),
            
            // Status
            ("Success", Status.success),
            ("Warning", Status.warning),
            ("Error", Status.error),
            ("Info", Status.info),
            
            // Text
            ("Text Primary", Text.primary),
            ("Text Secondary", Text.secondary),
            ("Text Tertiary", Text.tertiary),
            
            // Background
            ("BG Primary", Background.primary),
            ("BG Secondary", Background.secondary),
            ("BG Elevated", Background.elevated),
            
            // Semantic
            ("Now Playing", Semantic.nowPlaying),
            ("Scrobbled", Semantic.scrobbled),
            ("Last.fm", Semantic.lastfm),
        ]
    }
}

// Preview
struct DesignColor_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Design System - Colors")
                    .font(.title.bold())
                    .padding(.bottom)
                
                ForEach(DesignColor.allColors, id: \.0) { name, color in
                    HStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(color)
                            .frame(width: 60, height: 60)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        
                        Text(name)
                            .font(.headline)
                        
                        Spacer()
                    }
                }
            }
            .padding()
        }
        .frame(width: 400, height: 800)
    }
}
#endif
