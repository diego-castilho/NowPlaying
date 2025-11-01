//
//  GlassContainer.swift
//  NowPlaying
//
//  Design System - Glass Container Component
//  Container genérico com glassmorphism para layouts
//
//  Created by Diego Castilho on 01/11/25
//  Copyright © 2025 Diego Castilho. All rights reserved.//
//

import SwiftUI

/// Container genérico com efeito glassmorphism
///
/// Uso básico:
/// ```swift
/// GlassContainer {
///     Text("Content")
/// }
/// ```
///
/// Com configuração:
/// ```swift
/// GlassContainer(
///     axis: .horizontal,
///     spacing: 16,
///     alignment: .center,
///     padding: 20
/// ) {
///     Text("Item 1")
///     Text("Item 2")
/// }
/// ```
struct GlassContainer<Content: View>: View {
    
    // MARK: - Properties
    
    /// Conteúdo do container
    let content: Content
    
    /// Eixo do layout (vertical ou horizontal)
    let axis: Axis
    
    /// Espaçamento entre elementos
    let spacing: CGFloat?
    
    /// Alinhamento dos elementos
    let alignment: Alignment
    
    /// Padding interno
    let padding: EdgeInsets
    
    /// Corner radius
    let cornerRadius: CGFloat
    
    /// Estilo de background
    let backgroundStyle: BackgroundStyle
    
    /// Tipo de sombra
    let shadow: ShadowType
    
    /// Se deve ter borda
    let showBorder: Bool
    
    // MARK: - Enums
    
    enum Axis {
        case horizontal
        case vertical
    }
    
    enum BackgroundStyle {
        case glass      // Glass surface com blur
        case solid      // Cor sólida
        case clear      // Transparente
        case custom(Color)
        
        func color() -> Color {
            switch self {
            case .glass:
                return DesignColor.Glass.surface1
            case .solid:
                return DesignColor.Background.elevated
            case .clear:
                return Color.clear
            case .custom(let color):
                return color
            }
        }
        
        var useBlur: Bool {
            switch self {
            case .glass:
                return true
            default:
                return false
            }
        }
    }
    
    enum ShadowType {
        case none
        case small
        case medium
        case large
        
        var style: ShadowStyle {
            switch self {
            case .none: return DesignShadow.none
            case .small: return DesignShadow.sm
            case .medium: return DesignShadow.md
            case .large: return DesignShadow.lg
            }
        }
    }
    
    // MARK: - Initialization
    
    init(
        axis: Axis = .vertical,
        spacing: CGFloat? = nil,
        alignment: Alignment = .center,
        padding: EdgeInsets = EdgeInsets(
            top: DesignSpacing.lg,
            leading: DesignSpacing.lg,
            bottom: DesignSpacing.lg,
            trailing: DesignSpacing.lg
        ),
        cornerRadius: CGFloat = DesignSpacing.CornerRadius.glass,
        backgroundStyle: BackgroundStyle = .glass,
        shadow: ShadowType = .medium,
        showBorder: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.backgroundStyle = backgroundStyle
        self.shadow = shadow
        self.showBorder = showBorder
        self.content = content()
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Background com blur (se habilitado)
            if backgroundStyle.useBlur {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
            }
            
            // Background color
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(backgroundStyle.color())
            
            // Content com layout apropriado
            Group {
                if axis == .vertical {
                    VStack(alignment: alignment.horizontal, spacing: spacing) {
                        content
                    }
                } else {
                    HStack(alignment: alignment.vertical, spacing: spacing) {
                        content
                    }
                }
            }
            .padding(padding)
        }
        .overlay(
            showBorder
                ? RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(DesignColor.Glass.border, lineWidth: DesignSpacing.BorderWidth.thin)
                : nil
        )
        .shadow(shadow.style)
    }
}

// MARK: - Convenience Initializers

extension GlassContainer {
    /// Container vertical básico
    init(
        spacing: CGFloat? = DesignSpacing.md,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            axis: .vertical,
            spacing: spacing,
            alignment: .center,
            content: content
        )
    }
    
    /// Container horizontal
    static func horizontal(
        spacing: CGFloat? = DesignSpacing.md,
        alignment: Alignment = .center,
        @ViewBuilder content: () -> Content
    ) -> GlassContainer {
        GlassContainer(
            axis: .horizontal,
            spacing: spacing,
            alignment: alignment,
            content: content
        )
    }
    
    /// Container sem padding
    static func noPadding(
        @ViewBuilder content: () -> Content
    ) -> GlassContainer {
        GlassContainer(
            padding: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
            content: content
        )
    }
    
    /// Container sem borda
    static func noBorder(
        @ViewBuilder content: () -> Content
    ) -> GlassContainer {
        GlassContainer(
            showBorder: false,
            content: content
        )
    }
    
    /// Container sólido (sem glass)
    static func solid(
        @ViewBuilder content: () -> Content
    ) -> GlassContainer {
        GlassContainer(
            backgroundStyle: .solid,
            content: content
        )
    }
}

// MARK: - Alignment Extensions

extension Alignment {
    var horizontal: HorizontalAlignment {
        switch self {
        case .leading, .topLeading, .bottomLeading:
            return .leading
        case .trailing, .topTrailing, .bottomTrailing:
            return .trailing
        default:
            return .center
        }
    }
    
    var vertical: VerticalAlignment {
        switch self {
        case .top, .topLeading, .topTrailing:
            return .top
        case .bottom, .bottomLeading, .bottomTrailing:
            return .bottom
        default:
            return .center
        }
    }
}

// MARK: - Preview

#if DEBUG
struct GlassContainer_Previews: PreviewProvider {
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
                    Text("Glass Container Components")
                        .font(DesignTypography.title1)
                        .foregroundStyle(.white)
                        .padding(.top)
                    
                    // Vertical básico
                    VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                        Text("Vertical Container (Default)")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        GlassContainer {
                            Text("Item 1")
                                .font(DesignTypography.headline)
                            Text("Item 2")
                                .font(DesignTypography.body)
                            Text("Item 3")
                                .font(DesignTypography.caption1)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Horizontal
                    VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                        Text("Horizontal Container")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        GlassContainer.horizontal {
                            Text("A")
                            Text("B")
                            Text("C")
                        }
                    }
                    .padding(.horizontal)
                    
                    // Sem padding
                    VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                        Text("No Padding")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        GlassContainer.noPadding {
                            Text("Full width content")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.2))
                        }
                    }
                    .padding(.horizontal)
                    
                    // Sem borda
                    VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                        Text("No Border")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        GlassContainer.noBorder {
                            Text("Container sem borda")
                            Text("Mais limpo visualmente")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Sólido
                    VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                        Text("Solid Background")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        GlassContainer.solid {
                            Text("Background sólido")
                            Text("Sem blur, melhor performance")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider().background(.white.opacity(0.3))
                    
                    // Alinhamentos
                    VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                        Text("Alignments")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        HStack(spacing: DesignSpacing.md) {
                            GlassContainer(
                                alignment: .leading,
                                padding: EdgeInsets(
                                    top: DesignSpacing.md,
                                    leading: DesignSpacing.md,
                                    bottom: DesignSpacing.md,
                                    trailing: DesignSpacing.md
                                )
                            ) {
                                Text("Leading")
                                    .font(DesignTypography.caption1)
                                Text("Aligned")
                                    .font(DesignTypography.caption2)
                            }
                            .frame(width: 100)
                            
                            GlassContainer(
                                alignment: .center,
                                padding: EdgeInsets(
                                    top: DesignSpacing.md,
                                    leading: DesignSpacing.md,
                                    bottom: DesignSpacing.md,
                                    trailing: DesignSpacing.md
                                )
                            ) {
                                Text("Center")
                                    .font(DesignTypography.caption1)
                                Text("Aligned")
                                    .font(DesignTypography.caption2)
                            }
                            .frame(width: 100)
                            
                            GlassContainer(
                                alignment: .trailing,
                                padding: EdgeInsets(
                                    top: DesignSpacing.md,
                                    leading: DesignSpacing.md,
                                    bottom: DesignSpacing.md,
                                    trailing: DesignSpacing.md
                                )
                            ) {
                                Text("Trailing")
                                    .font(DesignTypography.caption1)
                                Text("Aligned")
                                    .font(DesignTypography.caption2)
                            }
                            .frame(width: 100)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider().background(.white.opacity(0.3))
                    
                    // Uso real - Form-like
                    VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                        Text("Real Use Case - Form")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        GlassContainer(spacing: DesignSpacing.lg) {
                            VStack(alignment: .leading, spacing: DesignSpacing.xs) {
                                Text("Username")
                                    .font(DesignTypography.caption1)
                                    .foregroundStyle(.secondary)
                                Text("diego_castilho")
                                    .font(DesignTypography.body)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: DesignSpacing.xs) {
                                Text("Status")
                                    .font(DesignTypography.caption1)
                                    .foregroundStyle(.secondary)
                                HStack {
                                    GlassBadge.success("Connected")
                                    Spacer()
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Divider()
                            
                            GlassContainer.horizontal(spacing: DesignSpacing.md) {
                                GlassButton.secondary("Settings", icon: "gear") {
                                    print("Settings")
                                }
                                
                                GlassButton.primary("Save", icon: "checkmark") {
                                    print("Save")
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Uso real - Stats
                    VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                        Text("Real Use Case - Stats")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        GlassContainer.horizontal(spacing: DesignSpacing.md, alignment: .top) {
                            GlassContainer(
                                spacing: DesignSpacing.xs,
                                padding: EdgeInsets(
                                    top: DesignSpacing.md,
                                    leading: DesignSpacing.md,
                                    bottom: DesignSpacing.md,
                                    trailing: DesignSpacing.md
                                )
                            ) {
                                Text("1,234")
                                    .font(DesignTypography.title2)
                                Text("Scrobbles")
                                    .font(DesignTypography.caption1)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            
                            GlassContainer(
                                spacing: DesignSpacing.xs,
                                padding: EdgeInsets(
                                    top: DesignSpacing.md,
                                    leading: DesignSpacing.md,
                                    bottom: DesignSpacing.md,
                                    trailing: DesignSpacing.md
                                )
                            ) {
                                Text("567")
                                    .font(DesignTypography.title2)
                                Text("Artists")
                                    .font(DesignTypography.caption1)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            
                            GlassContainer(
                                spacing: DesignSpacing.xs,
                                padding: EdgeInsets(
                                    top: DesignSpacing.md,
                                    leading: DesignSpacing.md,
                                    bottom: DesignSpacing.md,
                                    trailing: DesignSpacing.md
                                )
                            ) {
                                Text("89")
                                    .font(DesignTypography.title2)
                                Text("Albums")
                                    .font(DesignTypography.caption1)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                        }
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
