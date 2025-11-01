//
//  GlassModifiers.swift
//  NowPlaying
//
//  Design System - Glass View Modifiers
//  Modifiers para adicionar efeitos glass a qualquer View
//
//  Created by Diego Castilho on 01/11/25
//  Copyright © 2025 Diego Castilho. All rights reserved.//
//

import SwiftUI

// MARK: - Glass Effect Modifier

/// Modifier que adiciona efeito glass a qualquer view
struct GlassEffectModifier: ViewModifier {
    let cornerRadius: CGFloat
    let backgroundColor: Color
    let borderColor: Color
    let borderWidth: CGFloat
    let shadow: ShadowStyle
    let useBlur: Bool
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    if useBlur {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(.ultraThinMaterial)
                    }
                    
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(backgroundColor)
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(borderColor, lineWidth: borderWidth)
            )
            .shadow(shadow)
    }
}

extension View {
    /// Aplica efeito glass na view
    ///
    /// Uso:
    /// ```swift
    /// Text("Hello")
    ///     .padding()
    ///     .glassEffect()
    /// ```
    func glassEffect(
        cornerRadius: CGFloat = DesignSpacing.CornerRadius.glass,
        backgroundColor: Color = DesignColor.Glass.surface1,
        borderColor: Color = DesignColor.Glass.border,
        borderWidth: CGFloat = DesignSpacing.BorderWidth.thin,
        shadow: ShadowStyle = DesignShadow.md,
        useBlur: Bool = true
    ) -> some View {
        modifier(GlassEffectModifier(
            cornerRadius: cornerRadius,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            borderWidth: borderWidth,
            shadow: shadow,
            useBlur: useBlur
        ))
    }
}

// MARK: - Hover Effect Modifier

/// Modifier que adiciona efeito hover interativo
struct HoverEffectModifier: ViewModifier {
    let scale: CGFloat
    let brightness: Double
    let animation: Animation
    
    @State private var isHovered = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isHovered ? scale : 1.0)
            .brightness(isHovered ? brightness : 0)
            .animation(animation, value: isHovered)
            .onHover { hovering in
                isHovered = hovering
            }
    }
}

extension View {
    /// Adiciona efeito hover com scale e brightness
    ///
    /// Uso:
    /// ```swift
    /// Button("Click") { }
    ///     .hoverEffect()
    /// ```
    func hoverEffect(
        scale: CGFloat = 1.05,
        brightness: Double = 0.1,
        animation: Animation = DesignAnimation.Semantic.buttonHover
    ) -> some View {
        modifier(HoverEffectModifier(
            scale: scale,
            brightness: brightness,
            animation: animation
        ))
    }
}

// MARK: - Press Effect Modifier

/// Modifier que adiciona efeito de press
struct PressEffectModifier: ViewModifier {
    let scale: CGFloat
    let animation: Animation
    
    @State private var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? scale : 1.0)
            .animation(animation, value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in isPressed = false }
            )
    }
}

extension View {
    /// Adiciona efeito press com scale
    ///
    /// Uso:
    /// ```swift
    /// Button("Click") { }
    ///     .pressEffect()
    /// ```
    func pressEffect(
        scale: CGFloat = 0.95,
        animation: Animation = DesignAnimation.Semantic.buttonPress
    ) -> some View {
        modifier(PressEffectModifier(
            scale: scale,
            animation: animation
        ))
    }
}

// MARK: - Shimmer Effect Modifier

/// Modifier que adiciona efeito shimmer (loading)
struct ShimmerEffectModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [
                        Color.clear,
                        Color.white.opacity(0.3),
                        Color.clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: phase)
                .mask(content)
            )
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 1.5)
                        .repeatForever(autoreverses: false)
                ) {
                    phase = 300
                }
            }
    }
}

extension View {
    /// Adiciona efeito shimmer (loading)
    ///
    /// Uso:
    /// ```swift
    /// RoundedRectangle(cornerRadius: 8)
    ///     .fill(Color.gray.opacity(0.3))
    ///     .frame(width: 200, height: 20)
    ///     .shimmer()
    /// ```
    func shimmer() -> some View {
        modifier(ShimmerEffectModifier())
    }
}

// MARK: - Pulse Effect Modifier

/// Modifier que adiciona efeito pulse
struct PulseEffectModifier: ViewModifier {
    let minOpacity: Double
    let maxScale: CGFloat
    let duration: Double
    
    @State private var isPulsing = false
    
    func body(content: Content) -> some View {
        content
            .opacity(isPulsing ? minOpacity : 1.0)
            .scaleEffect(isPulsing ? maxScale : 1.0)
            .animation(
                Animation.easeInOut(duration: duration)
                    .repeatForever(autoreverses: true),
                value: isPulsing
            )
            .onAppear {
                isPulsing = true
            }
    }
}

extension View {
    /// Adiciona efeito pulse (bate-bate)
    ///
    /// Uso:
    /// ```swift
    /// Circle()
    ///     .fill(Color.red)
    ///     .frame(width: 10, height: 10)
    ///     .pulse()
    /// ```
    func pulse(
        minOpacity: Double = 0.7,
        maxScale: CGFloat = 1.05,
        duration: Double = 0.8
    ) -> some View {
        modifier(PulseEffectModifier(
            minOpacity: minOpacity,
            maxScale: maxScale,
            duration: duration
        ))
    }
}

// MARK: - Conditional Modifier

extension View {
    /// Aplica modifier condicionalmente
    ///
    /// Uso:
    /// ```swift
    /// Text("Hello")
    ///     .if(isHighlighted) { view in
    ///         view.foregroundStyle(.blue)
    ///     }
    /// ```
    @ViewBuilder
    func `if`<Transform: View>(
        _ condition: Bool,
        transform: (Self) -> Transform
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    /// Aplica modifier com if-else
    ///
    /// Uso:
    /// ```swift
    /// Text("Hello")
    ///     .if(isDark,
    ///         then: { $0.foregroundStyle(.white) },
    ///         else: { $0.foregroundStyle(.black) }
    ///     )
    /// ```
    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        then trueTransform: (Self) -> TrueContent,
        else falseTransform: (Self) -> FalseContent
    ) -> some View {
        if condition {
            trueTransform(self)
        } else {
            falseTransform(self)
        }
    }
}

// MARK: - Card Style Modifier

extension View {
    /// Transforma view em card glass
    ///
    /// Uso:
    /// ```swift
    /// VStack {
    ///     Text("Title")
    ///     Text("Content")
    /// }
    /// .cardStyle()
    /// ```
    func cardStyle(
        padding: CGFloat = DesignSpacing.Semantic.cardPadding
    ) -> some View {
        self
            .padding(padding)
            .glassEffect()
    }
    
    /// Card style com sombra customizada
    func cardStyle(
        padding: CGFloat = DesignSpacing.Semantic.cardPadding,
        shadow: ShadowStyle
    ) -> some View {
        self
            .padding(padding)
            .glassEffect(shadow: shadow)
    }
}

// MARK: - Interactive Modifier

extension View {
    /// Adiciona efeitos interativos completos (hover + press)
    ///
    /// Uso:
    /// ```swift
    /// Text("Button")
    ///     .padding()
    ///     .glassEffect()
    ///     .interactive()
    /// ```
    func interactive(
        hoverScale: CGFloat = 1.05,
        pressScale: CGFloat = 0.95
    ) -> some View {
        self
            .hoverEffect(scale: hoverScale)
            .pressEffect(scale: pressScale)
    }
}

// MARK: - Glow Effect Modifier

/// Modifier que adiciona efeito glow (brilho)
struct GlowEffectModifier: ViewModifier {
    let color: Color
    let radius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.6), radius: radius, x: 0, y: 0)
            .shadow(color: color.opacity(0.4), radius: radius * 1.5, x: 0, y: 0)
            .shadow(color: color.opacity(0.2), radius: radius * 2, x: 0, y: 0)
    }
}

extension View {
    /// Adiciona efeito glow (brilho colorido)
    ///
    /// Uso:
    /// ```swift
    /// Text("NOW")
    ///     .glow(color: .blue, radius: 8)
    /// ```
    func glow(
        color: Color,
        radius: CGFloat = 8
    ) -> some View {
        modifier(GlowEffectModifier(color: color, radius: radius))
    }
}

// MARK: - Preview

#if DEBUG
struct GlassModifiers_Previews: PreviewProvider {
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
                    Text("Glass View Modifiers")
                        .font(DesignTypography.title1)
                        .foregroundStyle(.white)
                        .padding(.top)
                    
                    // Glass Effect
                    VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                        Text(".glassEffect()")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        Text("Transforma qualquer view em glass")
                            .padding()
                            .glassEffect()
                    }
                    .padding(.horizontal)
                    
                    // Hover Effect
                    VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                        Text(".hoverEffect()")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        Text("Hover me!")
                            .padding()
                            .glassEffect()
                            .hoverEffect()
                    }
                    .padding(.horizontal)
                    
                    // Press Effect
                    VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                        Text(".pressEffect()")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        Text("Click me!")
                            .padding()
                            .glassEffect()
                            .pressEffect()
                    }
                    .padding(.horizontal)
                    
                    // Interactive (hover + press)
                    VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                        Text(".interactive()")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        Text("Hover & Click me!")
                            .padding()
                            .glassEffect()
                            .interactive()
                    }
                    .padding(.horizontal)
                    
                    // Shimmer
                    VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                        Text(".shimmer()")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.3))
                            .frame(height: 40)
                            .shimmer()
                    }
                    .padding(.horizontal)
                    
                    // Pulse
                    VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                        Text(".pulse()")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        HStack(spacing: DesignSpacing.lg) {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 20, height: 20)
                                .pulse()
                            
                            Circle()
                                .fill(Color.green)
                                .frame(width: 20, height: 20)
                                .pulse(minOpacity: 0.5, maxScale: 1.1, duration: 0.6)
                            
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 20, height: 20)
                                .pulse(minOpacity: 0.8, maxScale: 1.15, duration: 1.0)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Glow
                    VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                        Text(".glow()")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        HStack(spacing: DesignSpacing.xl) {
                            Text("LIVE")
                                .font(DesignTypography.NowPlaying.badge)
                                .foregroundStyle(.white)
                                .padding(.horizontal, DesignSpacing.md)
                                .padding(.vertical, DesignSpacing.sm)
                                .background(Color.red)
                                .clipShape(RoundedRectangle(cornerRadius: DesignSpacing.CornerRadius.badge))
                                .glow(color: .red, radius: 10)
                            
                            Text("NEW")
                                .font(DesignTypography.NowPlaying.badge)
                                .foregroundStyle(.white)
                                .padding(.horizontal, DesignSpacing.md)
                                .padding(.vertical, DesignSpacing.sm)
                                .background(Color.blue)
                                .clipShape(RoundedRectangle(cornerRadius: DesignSpacing.CornerRadius.badge))
                                .glow(color: .blue, radius: 10)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Card Style
                    VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                        Text(".cardStyle()")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        VStack(alignment: .leading, spacing: DesignSpacing.xs) {
                            Text("Card Title")
                                .font(DesignTypography.headline)
                            Text("Card content with automatic padding and glass effect")
                                .font(DesignTypography.body)
                                .foregroundStyle(.secondary)
                        }
                        .cardStyle()
                    }
                    .padding(.horizontal)
                    
                    Divider().background(.white.opacity(0.3))
                    
                    // Composição
                    VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                        Text("Composição de Modifiers")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        Text("Interactive Card")
                            .font(DesignTypography.title3)
                            .padding()
                            .glassEffect()
                            .interactive()
                        
                        Text("Glowing Pulse")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                            .padding()
                            .background(DesignColor.Accent.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .glow(color: DesignColor.Accent.primary, radius: 12)
                            .pulse()
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
