//
//  Theme.swift
//  NowPlaying
//
//  Design System - Theme Definition
//  Define temas light e dark com todos os tokens
//
//  Created by Diego Castilho on 31/10/25
//  Copyright © 2025 Diego Castilho. All rights reserved.
//

import SwiftUI

/// Tema do Design System
///
/// Contém todos os tokens de design organizados por categoria
struct Theme {
    // MARK: - Properties
    
    let name: String
    let appearance: ColorScheme
    
    // Colors
    let colors: ColorTokens
    
    // Typography
    let typography: TypographyTokens
    
    // Spacing
    let spacing: SpacingTokens
    
    // Shadows
    let shadows: ShadowTokens
    
    // Animations
    let animations: AnimationTokens
    
    // MARK: - Initialization
    
    init(
        name: String,
        appearance: ColorScheme,
        colors: ColorTokens,
        typography: TypographyTokens = .standard,
        spacing: SpacingTokens = .standard,
        shadows: ShadowTokens = .standard,
        animations: AnimationTokens = .standard
    ) {
        self.name = name
        self.appearance = appearance
        self.colors = colors
        self.typography = typography
        self.spacing = spacing
        self.shadows = shadows
        self.animations = animations
    }
}

// MARK: - Color Tokens

struct ColorTokens {
    // Glass
    let glassLight: Color
    let glassDark: Color
    let glassSurface1: Color
    let glassSurface2: Color
    let glassSurface3: Color
    let glassBorder: Color
    
    // Accent
    let accentPrimary: Color
    let accentSecondary: Color
    let accentTertiary: Color
    let accentMusic: Color
    
    // Status
    let statusSuccess: Color
    let statusWarning: Color
    let statusError: Color
    let statusInfo: Color
    
    // Text
    let textPrimary: Color
    let textSecondary: Color
    let textTertiary: Color
    let textOnAccent: Color
    
    // Background
    let backgroundPrimary: Color
    let backgroundSecondary: Color
    let backgroundElevated: Color
    let backgroundOverlay: Color
    
    // Semantic
    let nowPlaying: Color
    let scrobbled: Color
    let scrobbleFailed: Color
}

// MARK: - Typography Tokens

struct TypographyTokens {
    let display: Font
    let title1: Font
    let title2: Font
    let title3: Font
    let headline: Font
    let body: Font
    let callout: Font
    let subheadline: Font
    let footnote: Font
    let caption1: Font
    let caption2: Font
    
    static let standard = TypographyTokens(
        display: DesignTypography.display,
        title1: DesignTypography.title1,
        title2: DesignTypography.title2,
        title3: DesignTypography.title3,
        headline: DesignTypography.headline,
        body: DesignTypography.body,
        callout: DesignTypography.callout,
        subheadline: DesignTypography.subheadline,
        footnote: DesignTypography.footnote,
        caption1: DesignTypography.caption1,
        caption2: DesignTypography.caption2
    )
}

// MARK: - Spacing Tokens

struct SpacingTokens {
    let xxs: CGFloat
    let xs: CGFloat
    let sm: CGFloat
    let md: CGFloat
    let lg: CGFloat
    let xl: CGFloat
    let xxl: CGFloat
    
    let cardPadding: CGFloat
    let sectionSpacing: CGFloat
    let cornerRadiusCard: CGFloat
    let cornerRadiusButton: CGFloat
    
    static let standard = SpacingTokens(
        xxs: DesignSpacing.xxs,
        xs: DesignSpacing.xs,
        sm: DesignSpacing.sm,
        md: DesignSpacing.md,
        lg: DesignSpacing.lg,
        xl: DesignSpacing.xl,
        xxl: DesignSpacing.xxl,
        cardPadding: DesignSpacing.Semantic.cardPadding,
        sectionSpacing: DesignSpacing.Semantic.sectionSpacing,
        cornerRadiusCard: DesignSpacing.CornerRadius.card,
        cornerRadiusButton: DesignSpacing.CornerRadius.button
    )
}

// MARK: - Shadow Tokens

struct ShadowTokens {
    let card: ShadowStyle
    let button: ShadowStyle
    let glass: ShadowStyle
    let popover: ShadowStyle
    
    static let standard = ShadowTokens(
        card: DesignShadow.Semantic.card,
        button: DesignShadow.Semantic.button,
        glass: DesignShadow.Semantic.glass,
        popover: DesignShadow.Semantic.popover
    )
}

// MARK: - Animation Tokens

struct AnimationTokens {
    let smooth: Animation
    let snappy: Animation
    let gentle: Animation
    let buttonPress: Animation
    let cardAppear: Animation
    
    static let standard = AnimationTokens(
        smooth: DesignAnimation.smooth,
        snappy: DesignAnimation.snappy,
        gentle: DesignAnimation.gentle,
        buttonPress: DesignAnimation.Semantic.buttonPress,
        cardAppear: DesignAnimation.Semantic.cardAppear
    )
}

// MARK: - Predefined Themes

extension Theme {
    /// Tema Light - padrão claro
    static let light = Theme(
        name: "Light",
        appearance: .light,
        colors: ColorTokens(
            // Glass
            glassLight: DesignColor.Glass.light,
            glassDark: DesignColor.Glass.dark,
            glassSurface1: DesignColor.Glass.surface1,
            glassSurface2: DesignColor.Glass.surface2,
            glassSurface3: DesignColor.Glass.surface3,
            glassBorder: DesignColor.Glass.border,
            
            // Accent
            accentPrimary: DesignColor.Accent.primary,
            accentSecondary: DesignColor.Accent.secondary,
            accentTertiary: DesignColor.Accent.tertiary,
            accentMusic: DesignColor.Accent.music,
            
            // Status
            statusSuccess: DesignColor.Status.success,
            statusWarning: DesignColor.Status.warning,
            statusError: DesignColor.Status.error,
            statusInfo: DesignColor.Status.info,
            
            // Text
            textPrimary: DesignColor.Text.primary,
            textSecondary: DesignColor.Text.secondary,
            textTertiary: DesignColor.Text.tertiary,
            textOnAccent: DesignColor.Text.onAccent,
            
            // Background
            backgroundPrimary: DesignColor.Background.primary,
            backgroundSecondary: DesignColor.Background.secondary,
            backgroundElevated: DesignColor.Background.elevated,
            backgroundOverlay: DesignColor.Background.overlay,
            
            // Semantic
            nowPlaying: DesignColor.Semantic.nowPlaying,
            scrobbled: DesignColor.Semantic.scrobbled,
            scrobbleFailed: DesignColor.Semantic.scrobbleFailed
        )
    )
    
    /// Tema Dark - padrão escuro
    static let dark = Theme(
        name: "Dark",
        appearance: .dark,
        colors: ColorTokens(
            // Glass - ajustado para dark mode
            glassLight: DesignColor.Glass.dark,
            glassDark: DesignColor.Glass.light.opacity(0.1),
            glassSurface1: Color(.sRGB, white: 0.15, opacity: 0.85),
            glassSurface2: Color(.sRGB, white: 0.20, opacity: 0.90),
            glassSurface3: Color(.sRGB, white: 0.25, opacity: 0.95),
            glassBorder: DesignColor.Glass.borderDark,
            
            // Accent - mantém vibrante
            accentPrimary: DesignColor.Accent.primary,
            accentSecondary: DesignColor.Accent.secondary,
            accentTertiary: DesignColor.Accent.tertiary,
            accentMusic: DesignColor.Accent.music,
            
            // Status
            statusSuccess: DesignColor.Status.success,
            statusWarning: DesignColor.Status.warning,
            statusError: DesignColor.Status.error,
            statusInfo: DesignColor.Status.info,
            
            // Text - ajustado para dark mode
            textPrimary: DesignColor.Text.onDark,
            textSecondary: Color.white.opacity(0.7),
            textTertiary: Color.white.opacity(0.5),
            textOnAccent: DesignColor.Text.onAccent,
            
            // Background - escuro
            backgroundPrimary: Color(.sRGB, white: 0.08, opacity: 1.0),
            backgroundSecondary: Color(.sRGB, white: 0.12, opacity: 1.0),
            backgroundElevated: Color(.sRGB, white: 0.18, opacity: 1.0),
            backgroundOverlay: Color.black.opacity(0.5),
            
            // Semantic
            nowPlaying: DesignColor.Semantic.nowPlaying,
            scrobbled: DesignColor.Semantic.scrobbled,
            scrobbleFailed: DesignColor.Semantic.scrobbleFailed
        )
    )
    
    /// Tema atual baseado no ColorScheme do sistema
    static func current(for colorScheme: ColorScheme) -> Theme {
        colorScheme == .dark ? .dark : .light
    }
}
