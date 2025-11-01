//
//  GlassButton.swift
//  NowPlaying
//
//  Design System - Glass Button Component
//  Botão com efeito glassmorphism e interações
//
//  Created by Diego Castilho on 01/11/25
//  Copyright © 2025 Diego Castilho. All rights reserved.//
//

import SwiftUI

/// Botão com efeito glassmorphism
///
/// Uso básico:
/// ```swift
/// GlassButton("Click me") {
///     print("Clicked!")
/// }
/// ```
///
/// Com customização:
/// ```swift
/// GlassButton(
///     "Save",
///     icon: "checkmark.circle",
///     style: .primary,
///     size: .large
/// ) {
///     save()
/// }
/// ```
struct GlassButton: View {
    
    // MARK: - Properties
    
    /// Título do botão
    let title: String
    
    /// Ícone SF Symbol (opcional)
    let icon: String?
    
    /// Posição do ícone
    let iconPosition: IconPosition
    
    /// Estilo do botão
    let style: ButtonStyle
    
    /// Tamanho do botão
    let size: ButtonSize
    
    /// Se está desabilitado
    let isDisabled: Bool
    
    /// Action ao clicar
    let action: () -> Void
    
    // MARK: - State
    
    @State private var isHovered = false
    @State private var isPressed = false
    
    // MARK: - Enums
    
    enum IconPosition {
        case leading
        case trailing
    }
    
    enum ButtonStyle {
        case primary      // Accent color
        case secondary    // Glass with border
        case subtle       // Transparent
        case success      // Green
        case destructive  // Red
        
        func backgroundColor(isHovered: Bool, isPressed: Bool) -> Color {
            switch self {
            case .primary:
                if isPressed { return DesignColor.Accent.primary.opacity(0.8) }
                if isHovered { return DesignColor.Accent.primary.opacity(0.9) }
                return DesignColor.Accent.primary
                
            case .secondary:
                if isPressed { return DesignColor.Glass.surface2.opacity(0.7) }
                if isHovered { return DesignColor.Glass.surface2.opacity(0.9) }
                return DesignColor.Glass.surface1
                
            case .subtle:
                if isPressed { return DesignColor.Glass.surface1.opacity(0.3) }
                if isHovered { return DesignColor.Glass.surface1.opacity(0.5) }
                return Color.clear
                
            case .success:
                if isPressed { return DesignColor.Status.success.opacity(0.8) }
                if isHovered { return DesignColor.Status.success.opacity(0.9) }
                return DesignColor.Status.success
                
            case .destructive:
                if isPressed { return DesignColor.Status.error.opacity(0.8) }
                if isHovered { return DesignColor.Status.error.opacity(0.9) }
                return DesignColor.Status.error
            }
        }
        
        func foregroundColor() -> Color {
            switch self {
            case .primary, .success, .destructive:
                return DesignColor.Text.onAccent
            case .secondary:
                return DesignColor.Text.primary
            case .subtle:
                return DesignColor.Text.secondary
            }
        }
        
        func borderColor() -> Color? {
            switch self {
            case .secondary:
                return DesignColor.Glass.border
            case .subtle:
                return DesignColor.Glass.border.opacity(0.5)
            default:
                return nil
            }
        }
    }
    
    enum ButtonSize {
        case small
        case medium
        case large
        
        var height: CGFloat {
            switch self {
            case .small: return 32
            case .medium: return 40
            case .large: return 48
            }
        }
        
        var horizontalPadding: CGFloat {
            switch self {
            case .small: return DesignSpacing.md
            case .medium: return DesignSpacing.lg
            case .large: return DesignSpacing.xl
            }
        }
        
        var font: Font {
            switch self {
            case .small: return DesignTypography.NowPlaying.buttonSmall
            case .medium: return DesignTypography.NowPlaying.button
            case .large: return DesignTypography.NowPlaying.button
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .small: return DesignSpacing.IconSize.sm
            case .medium: return DesignSpacing.IconSize.md
            case .large: return DesignSpacing.IconSize.lg
            }
        }
    }
    
    // MARK: - Initialization
    
    init(
        _ title: String,
        icon: String? = nil,
        iconPosition: IconPosition = .leading,
        style: ButtonStyle = .primary,
        size: ButtonSize = .medium,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.iconPosition = iconPosition
        self.style = style
        self.size = size
        self.isDisabled = isDisabled
        self.action = action
    }
    
    // MARK: - Body
    
    var body: some View {
        Button(action: {
            if !isDisabled {
                action()
            }
        }) {
            HStack(spacing: DesignSpacing.sm) {
                if let icon = icon, iconPosition == .leading {
                    Image(systemName: icon)
                        .font(.system(size: size.iconSize))
                }
                
                Text(title)
                    .font(size.font)
                
                if let icon = icon, iconPosition == .trailing {
                    Image(systemName: icon)
                        .font(.system(size: size.iconSize))
                }
            }
            .foregroundStyle(isDisabled ? style.foregroundColor().opacity(0.5) : style.foregroundColor())
            .frame(height: size.height)
            .padding(.horizontal, size.horizontalPadding)
            .background(
                RoundedRectangle(cornerRadius: DesignSpacing.CornerRadius.button)
                    .fill(isDisabled
                          ? style.backgroundColor(isHovered: false, isPressed: false).opacity(0.5)
                          : style.backgroundColor(isHovered: isHovered, isPressed: isPressed)
                         )
            )
            .overlay(
                RoundedRectangle(cornerRadius: DesignSpacing.CornerRadius.button)
                    .strokeBorder(
                        style.borderColor() ?? Color.clear,
                        lineWidth: style.borderColor() != nil ? DesignSpacing.BorderWidth.regular : 0
                    )
            )
            .shadow(
                isPressed
                ? DesignShadow.Semantic.buttonPressed
                : (isHovered ? DesignShadow.Semantic.buttonHover : DesignShadow.Semantic.button)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(DesignAnimation.Semantic.buttonPress, value: isPressed)
            .animation(DesignAnimation.Semantic.buttonHover, value: isHovered)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .onHover { hovering in
            if !isDisabled {
                isHovered = hovering
            }
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isDisabled {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }
}

// MARK: - Convenience Initializers

extension GlassButton {
    /// Botão primário (padrão)
    static func primary(
        _ title: String,
        icon: String? = nil,
        action: @escaping () -> Void
    ) -> GlassButton {
        GlassButton(title, icon: icon, style: .primary, action: action)
    }
    
    /// Botão secundário
    static func secondary(
        _ title: String,
        icon: String? = nil,
        action: @escaping () -> Void
    ) -> GlassButton {
        GlassButton(title, icon: icon, style: .secondary, action: action)
    }
    
    /// Botão sutil
    static func subtle(
        _ title: String,
        icon: String? = nil,
        action: @escaping () -> Void
    ) -> GlassButton {
        GlassButton(title, icon: icon, style: .subtle, action: action)
    }
    
    /// Botão de sucesso
    static func success(
        _ title: String,
        icon: String? = nil,
        action: @escaping () -> Void
    ) -> GlassButton {
        GlassButton(title, icon: icon, style: .success, action: action)
    }
    
    /// Botão destrutivo
    static func destructive(
        _ title: String,
        icon: String? = nil,
        action: @escaping () -> Void
    ) -> GlassButton {
        GlassButton(title, icon: icon, style: .destructive, action: action)
    }
}

// MARK: - Preview

#if DEBUG
struct GlassButton_Previews: PreviewProvider {
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
                    Text("Glass Button Components")
                        .font(DesignTypography.title1)
                        .foregroundStyle(.white)
                        .padding(.top)
                    
                    // Estilos
                    VStack(alignment: .leading, spacing: DesignSpacing.md) {
                        Text("Button Styles")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        VStack(spacing: DesignSpacing.md) {
                            GlassButton.primary("Primary Button", icon: "checkmark.circle") {
                                print("Primary clicked")
                            }
                            
                            GlassButton.secondary("Secondary Button", icon: "square.and.arrow.up") {
                                print("Secondary clicked")
                            }
                            
                            GlassButton.subtle("Subtle Button", icon: "ellipsis.circle") {
                                print("Subtle clicked")
                            }
                            
                            GlassButton.success("Success Button", icon: "checkmark.circle.fill") {
                                print("Success clicked")
                            }
                            
                            GlassButton.destructive("Destructive Button", icon: "trash") {
                                print("Destructive clicked")
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider().background(.white.opacity(0.3))
                    
                    // Tamanhos
                    VStack(alignment: .leading, spacing: DesignSpacing.md) {
                        Text("Button Sizes")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        VStack(spacing: DesignSpacing.md) {
                            GlassButton("Small", icon: "star.fill", size: .small) {
                                print("Small clicked")
                            }
                            
                            GlassButton("Medium", icon: "star.fill", size: .medium) {
                                print("Medium clicked")
                            }
                            
                            GlassButton("Large", icon: "star.fill", size: .large) {
                                print("Large clicked")
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider().background(.white.opacity(0.3))
                    
                    // Posição do ícone
                    VStack(alignment: .leading, spacing: DesignSpacing.md) {
                        Text("Icon Position")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        VStack(spacing: DesignSpacing.md) {
                            GlassButton("Icon Leading", icon: "arrow.left", iconPosition: .leading) {
                                print("Leading clicked")
                            }
                            
                            GlassButton("Icon Trailing", icon: "arrow.right", iconPosition: .trailing) {
                                print("Trailing clicked")
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider().background(.white.opacity(0.3))
                    
                    // Estados
                    VStack(alignment: .leading, spacing: DesignSpacing.md) {
                        Text("Button States")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        VStack(spacing: DesignSpacing.md) {
                            GlassButton("Enabled", icon: "power") {
                                print("Enabled clicked")
                            }
                            
                            GlassButton("Disabled", icon: "power", isDisabled: true) {
                                print("Should not print")
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider().background(.white.opacity(0.3))
                    
                    // Exemplo real
                    VStack(alignment: .leading, spacing: DesignSpacing.md) {
                        Text("Real Use Case")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        GlassCard {
                            VStack(spacing: DesignSpacing.lg) {
                                VStack(spacing: DesignSpacing.xs) {
                                    Text("Conectar ao Last.fm")
                                        .font(DesignTypography.title3)
                                    
                                    Text("Autentique para começar a fazer scrobble")
                                        .font(DesignTypography.body)
                                        .foregroundStyle(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                                
                                HStack(spacing: DesignSpacing.md) {
                                    GlassButton.secondary("Cancelar") {
                                        print("Cancelar")
                                    }
                                    
                                    GlassButton.primary("Conectar", icon: "link") {
                                        print("Conectar")
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .frame(width: 500, height: 1100)
    }
}
#endif
