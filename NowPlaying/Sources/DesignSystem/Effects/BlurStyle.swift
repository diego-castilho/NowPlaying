//
//  BlurEffects.swift
//  NowPlaying
//
//  Design System - Blur Effects
//  Sistema avançado de blur para glassmorphism
//
//  Created by Diego Castilho on 01/11/25
//  Copyright © 2025 Diego Castilho. All rights reserved.//
//

import SwiftUI

// MARK: - Blur Style Enum

/// Estilos de blur disponíveis
enum BlurStyle {
    case ultraThin
    case thin
    case regular
    case thick
    case ultraThick
    case adaptive(intensity: Double)
    
    /// Material correspondente
    var material: Material {
        switch self {
        case .ultraThin:
            return .ultraThinMaterial
        case .thin:
            return .thinMaterial
        case .regular:
            return .regularMaterial
        case .thick:
            return .thickMaterial
        case .ultraThick:
            return .ultraThickMaterial
        case .adaptive(let intensity):
            // Escolhe material baseado na intensidade
            if intensity < 0.2 { return .ultraThinMaterial }
            else if intensity < 0.4 { return .thinMaterial }
            else if intensity < 0.6 { return .regularMaterial }
            else if intensity < 0.8 { return .thickMaterial }
            else { return .ultraThickMaterial }
        }
    }
    
    /// Radius para blur manual
    var radius: CGFloat {
        switch self {
        case .ultraThin: return 5
        case .thin: return 10
        case .regular: return 15
        case .thick: return 20
        case .ultraThick: return 30
        case .adaptive(let intensity): return CGFloat(intensity * 30)
        }
    }
}

// MARK: - Blur Modifier

/// Modifier que aplica blur com estilo
struct StyledBlurModifier: ViewModifier {
    let style: BlurStyle
    let useMaterial: Bool
    
    func body(content: Content) -> some View {
        if useMaterial {
            content.background(style.material)
        } else {
            content.blur(radius: style.radius)
        }
    }
}

extension View {
    /// Aplica blur estilizado
    ///
    /// Uso:
    /// ```swift
    /// Rectangle()
    ///     .styledBlur(.thick)
    /// ```
    func styledBlur(
        _ style: BlurStyle,
        useMaterial: Bool = true
    ) -> some View {
        modifier(StyledBlurModifier(style: style, useMaterial: useMaterial))
    }
}

// MARK: - Noise Texture

/// Gerador de noise texture para adicionar ao blur
struct NoiseTextureGenerator {
    
    /// Gera noise texture
    static func generate(
        size: CGSize = CGSize(width: 200, height: 200),
        intensity: Double = 0.1
    ) -> NSImage? {
        let width = Int(size.width)
        let height = Int(size.height)
        
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return nil }
        
        // Gerar noise pixel por pixel
        for y in 0..<height {
            for x in 0..<width {
                let noise = Double.random(in: 0...1) * intensity
                let gray = CGFloat(noise)
                context.setFillColor(
                    CGColor(
                        red: gray,
                        green: gray,
                        blue: gray,
                        alpha: 1.0
                    )
                )
                context.fill(CGRect(x: x, y: y, width: 1, height: 1))
            }
        }
        
        guard let cgImage = context.makeImage() else { return nil }
        return NSImage(cgImage: cgImage, size: size)
    }
}

// MARK: - Noise Blur Modifier

/// Modifier que adiciona noise ao blur
struct NoiseBlurModifier: ViewModifier {
    let intensity: Double
    let noiseIntensity: Double
    
    @State private var noiseTexture: NSImage?
    
    func body(content: Content) -> some View {
        content
            .blur(radius: CGFloat(intensity * 20))
            .overlay(
                Group {
                    if let texture = noiseTexture {
                        Image(nsImage: texture)
                            .resizable(resizingMode: .tile)
                            .opacity(noiseIntensity)
                            .allowsHitTesting(false)
                    }
                }
            )
            .onAppear {
                if noiseTexture == nil {
                    noiseTexture = NoiseTextureGenerator.generate(
                        intensity: noiseIntensity
                    )
                }
            }
    }
}

extension View {
    /// Aplica blur com noise texture
    ///
    /// Uso:
    /// ```swift
    /// Rectangle()
    ///     .noiseBlur(intensity: 0.8, noise: 0.1)
    /// ```
    func noiseBlur(
        intensity: Double = 0.5,
        noise: Double = 0.1
    ) -> some View {
        modifier(NoiseBlurModifier(
            intensity: intensity,
            noiseIntensity: noise
        ))
    }
}

// MARK: - Adaptive Blur

/// Blur que se adapta ao contexto
struct AdaptiveBlurView<Content: View>: View {
    let content: Content
    let baseIntensity: Double
    let respondsToHover: Bool
    
    @State private var currentIntensity: Double
    @State private var isHovered = false
    
    init(
        baseIntensity: Double = 0.5,
        respondsToHover: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.baseIntensity = baseIntensity
        self.respondsToHover = respondsToHover
        self._currentIntensity = State(initialValue: baseIntensity)
    }
    
    var body: some View {
        content
            .styledBlur(
                .adaptive(intensity: currentIntensity),
                useMaterial: true
            )
            .onHover { hovering in
                guard respondsToHover else { return }
                withAnimation(DesignAnimation.smooth) {
                    isHovered = hovering
                    currentIntensity = hovering ? baseIntensity * 1.2 : baseIntensity
                }
            }
    }
}

// MARK: - Blur Helpers

extension View {
    /// Blur adaptativo
    func adaptiveBlur(
        intensity: Double = 0.5,
        respondsToHover: Bool = false
    ) -> some View {
        AdaptiveBlurView(
            baseIntensity: intensity,
            respondsToHover: respondsToHover
        ) {
            self
        }
    }
}

// MARK: - Preview

#if DEBUG
struct BlurEffects_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            // Background colorido para ver blur
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
                    Text("Blur Effects")
                        .font(DesignTypography.title1)
                        .foregroundStyle(.white)
                        .padding(.top)
                    
                    // Material styles
                    VStack(alignment: .leading, spacing: DesignSpacing.md) {
                        Text("Material Styles")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        VStack(spacing: DesignSpacing.sm) {
                            ForEach([
                                ("Ultra Thin", BlurStyle.ultraThin),
                                ("Thin", BlurStyle.thin),
                                ("Regular", BlurStyle.regular),
                                ("Thick", BlurStyle.thick),
                                ("Ultra Thick", BlurStyle.ultraThick),
                            ], id: \.0) { name, style in
                                HStack {
                                    Text(name)
                                        .font(DesignTypography.body)
                                    Spacer()
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(style.material)
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider().background(.white.opacity(0.3))
                    
                    // Adaptive blur
                    VStack(alignment: .leading, spacing: DesignSpacing.md) {
                        Text("Adaptive Blur")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        VStack(spacing: DesignSpacing.sm) {
                            ForEach([0.2, 0.5, 0.8], id: \.self) { intensity in
                                HStack {
                                    Text("Intensity: \(String(format: "%.1f", intensity))")
                                        .font(DesignTypography.body)
                                    Spacer()
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(BlurStyle.adaptive(intensity: intensity).material)
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider().background(.white.opacity(0.3))
                    
                    // Noise blur
                    VStack(alignment: .leading, spacing: DesignSpacing.md) {
                        Text("Noise Blur (Hover me!)")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.3))
                            .frame(height: 100)
                            .overlay(
                                Text("Hover to see adaptive blur")
                                    .font(DesignTypography.body)
                            )
                            .adaptiveBlur(intensity: 0.5, respondsToHover: true)
                    }
                    .padding(.horizontal)
                    
                    Divider().background(.white.opacity(0.3))
                    
                    // Comparison
                    VStack(alignment: .leading, spacing: DesignSpacing.md) {
                        Text("Side by Side Comparison")
                            .font(DesignTypography.headline)
                            .foregroundStyle(.white)
                        
                        HStack(spacing: DesignSpacing.md) {
                            VStack(spacing: DesignSpacing.xs) {
                                Text("No Blur")
                                    .font(DesignTypography.caption1)
                                    .foregroundStyle(.white)
                                
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.3))
                                    .frame(height: 80)
                            }
                            
                            VStack(spacing: DesignSpacing.xs) {
                                Text("Regular Blur")
                                    .font(DesignTypography.caption1)
                                    .foregroundStyle(.white)
                                
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.3))
                                    .frame(height: 80)
                                    .styledBlur(.regular)
                            }
                            
                            VStack(spacing: DesignSpacing.xs) {
                                Text("Thick Blur")
                                    .font(DesignTypography.caption1)
                                    .foregroundStyle(.white)
                                
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.3))
                                    .frame(height: 80)
                                    .styledBlur(.thick)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .frame(width: 500, height: 1000)
    }
}
#endif
