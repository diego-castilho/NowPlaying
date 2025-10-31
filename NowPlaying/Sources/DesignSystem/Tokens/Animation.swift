//
//  DesignAnimation.swift
//  NowPlaying
//
//  Created by Diego Castilho on 31/10/25.
//


//
//  Animation.swift
//  NowPlaying
//
//  Design System - Animation Tokens
//  Sistema de animações e transições fluidas
//
//  Created by Diego Castilho on 31/10/25
//  Copyright © 2025 Diego Castilho. All rights reserved.
//

import SwiftUI

/// Namespace para todas as animações do Design System
///
/// Uso:
/// ```swift
/// withAnimation(DesignAnimation.smooth) {
///     isExpanded.toggle()
/// }
/// ```
enum DesignAnimation {
    
    // MARK: - Duration
    
    /// Durações de animação
    enum Duration {
        /// Instant - sem animação (0s)
        static let instant: Double = 0
        
        /// Fast - rápida (0.15s)
        static let fast: Double = 0.15
        
        /// Normal - normal (0.25s)
        static let normal: Double = 0.25
        
        /// Moderate - moderada (0.35s)
        static let moderate: Double = 0.35
        
        /// Slow - lenta (0.5s)
        static let slow: Double = 0.5
        
        /// Very slow - muito lenta (0.75s)
        static let verySlow: Double = 0.75
        
        /// Extra slow - extra lenta (1.0s)
        static let extraSlow: Double = 1.0
    }
    
    // MARK: - Easing Curves
    
    /// Curvas de easing (timing functions)
    enum Curve {
        /// Linear - sem easing
        static let linear = Animation.linear
        
        /// Ease in - começa devagar
        static let easeIn = Animation.easeIn
        
        /// Ease out - termina devagar
        static let easeOut = Animation.easeOut
        
        /// Ease in-out - começa e termina devagar (padrão)
        static let easeInOut = Animation.easeInOut
        
        /// Spring - mola natural (recomendado para UI)
        static let spring = Animation.spring(response: 0.5, dampingFraction: 0.7)
        
        /// Snappy spring - mola rápida e responsiva
        static let snappySpring = Animation.spring(response: 0.3, dampingFraction: 0.7)
        
        /// Bouncy spring - mola com bounce
        static let bouncySpring = Animation.spring(response: 0.5, dampingFraction: 0.6)
        
        /// Smooth spring - mola muito suave
        static let smoothSpring = Animation.spring(response: 0.6, dampingFraction: 0.8)
        
        /// Interactive spring - para gestos/drag
        static let interactiveSpring = Animation.interactiveSpring(response: 0.3, dampingFraction: 0.7)
    }
    
    // MARK: - Predefined Animations
    
    /// Instant - sem animação
    static let instant = Animation.linear(duration: Duration.instant)
    
    /// Fast - animação rápida
    static let fast = Animation.easeInOut(duration: Duration.fast)
    
    /// Normal - animação padrão
    static let normal = Animation.easeInOut(duration: Duration.normal)
    
    /// Smooth - animação suave (recomendado para maioria dos casos)
    static let smooth = Animation.spring(response: 0.5, dampingFraction: 0.7)
    
    /// Snappy - animação rápida e responsiva
    static let snappy = Animation.spring(response: 0.3, dampingFraction: 0.7)
    
    /// Bouncy - animação com bounce
    static let bouncy = Animation.spring(response: 0.5, dampingFraction: 0.6)
    
    /// Gentle - animação muito suave
    static let gentle = Animation.spring(response: 0.6, dampingFraction: 0.8)
    
    /// Interactive - para interações do usuário
    static let interactive = Animation.interactiveSpring(response: 0.3, dampingFraction: 0.7)
    
    // MARK: - Semantic Animations
    
    /// Animações com significado semântico
    enum Semantic {
        /// Button press - pressionar botão
        static let buttonPress = DesignAnimation.fast
        
        /// Button hover - hover em botão
        static let buttonHover = DesignAnimation.snappy
        
        /// Card appear - aparecer card
        static let cardAppear = DesignAnimation.smooth
        
        /// Card dismiss - dispensar card
        static let cardDismiss = DesignAnimation.fast
        
        /// Modal present - apresentar modal
        static let modalPresent = DesignAnimation.smooth
        
        /// Modal dismiss - dispensar modal
        static let modalDismiss = DesignAnimation.snappy
        
        /// Menu open - abrir menu
        static let menuOpen = DesignAnimation.snappy
        
        /// Menu close - fechar menu
        static let menuClose = DesignAnimation.fast
        
        /// Tab switch - trocar tab
        static let tabSwitch = DesignAnimation.smooth
        
        /// Content load - carregar conteúdo
        static let contentLoad = DesignAnimation.gentle
        
        /// Artwork change - trocar artwork
        static let artworkChange = DesignAnimation.smooth
        
        /// Glass effect - efeito glass
        static let glassEffect = DesignAnimation.gentle
        
        /// Scrobble success - sucesso no scrobble
        static let scrobbleSuccess = DesignAnimation.bouncy
        
        /// Drag gesture - gesture de arrastar
        static let drag = DesignAnimation.interactive
    }
    
    // MARK: - Transitions
    
    /// Transições predefinidas
    enum Transition {
        /// Fade - fade in/out
        static let fade = AnyTransition.opacity
        
        /// Scale - escala
        static let scale = AnyTransition.scale
        
        /// Scale and fade - escala + fade
        static let scaleAndFade = AnyTransition.scale.combined(with: .opacity)
        
        /// Slide - deslizar
        static func slide(edge: Edge) -> AnyTransition {
            .move(edge: edge)
        }
        
        /// Push - empurrar (com fade)
        static func push(from edge: Edge) -> AnyTransition {
            .asymmetric(
                insertion: .move(edge: edge).combined(with: .opacity),
                removal: .opacity
            )
        }
        
        /// Card - para cards (scale + fade + offset)
        static let card = AnyTransition.asymmetric(
            insertion: .scale(scale: 0.9).combined(with: .opacity),
            removal: .scale(scale: 0.95).combined(with: .opacity)
        )
        
        /// Glass - para glass elements (blur + fade)
        static let glass = AnyTransition.opacity
    }
    
    // MARK: - Delays
    
    /// Delays para animações staggered
    enum Delay {
        /// No delay
        static let none: Double = 0
        
        /// Tiny delay - 0.05s
        static let tiny: Double = 0.05
        
        /// Small delay - 0.1s
        static let small: Double = 0.1
        
        /// Medium delay - 0.15s
        static let medium: Double = 0.15
        
        /// Large delay - 0.2s
        static let large: Double = 0.2
        
        /// Stagger increment - para listas (0.05s)
        static let stagger: Double = 0.05
    }
}

// MARK: - View Extensions

extension View {
    /// Animação smooth padrão
    func smoothAnimation() -> some View {
        self.animation(DesignAnimation.smooth, value: UUID())
    }
    
    /// Animação com delay
    func animateWithDelay(_ animation: Animation, delay: Double) -> some View {
        self.animation(animation.delay(delay), value: UUID())
    }
    
    /// Transição de card
    func cardTransition() -> some View {
        self.transition(DesignAnimation.Transition.card)
    }
    
    /// Efeito de hover animado
    func hoverEffect(isHovered: Bool, scale: CGFloat = 1.05) -> some View {
        self
            .scaleEffect(isHovered ? scale : 1.0)
            .animation(DesignAnimation.Semantic.buttonHover, value: isHovered)
    }
    
    /// Efeito de press animado
    func pressEffect(isPressed: Bool, scale: CGFloat = 0.95) -> some View {
        self
            .scaleEffect(isPressed ? scale : 1.0)
            .animation(DesignAnimation.Semantic.buttonPress, value: isPressed)
    }
}

// MARK: - Animation Helpers

extension Animation {
    /// Helper para criar spring customizado
    static func designSpring(
        response: Double = 0.5,
        dampingFraction: Double = 0.7,
        blendDuration: Double = 0
    ) -> Animation {
        .spring(
            response: response,
            dampingFraction: dampingFraction,
            blendDuration: blendDuration
        )
    }
    
    /// Helper para criar easeInOut customizado
    static func designEaseInOut(duration: Double) -> Animation {
        .easeInOut(duration: duration)
    }
}

// MARK: - Preview

#if DEBUG
struct DesignAnimation_Previews: PreviewProvider {
    struct AnimationDemo: View {
        @State private var isAnimating = false
        @State private var selectedAnimation = 0
        
        let animations: [(String, Animation)] = [
            ("Instant", DesignAnimation.instant),
            ("Fast", DesignAnimation.fast),
            ("Normal", DesignAnimation.normal),
            ("Smooth", DesignAnimation.smooth),
            ("Snappy", DesignAnimation.snappy),
            ("Bouncy", DesignAnimation.bouncy),
            ("Gentle", DesignAnimation.gentle),
        ]
        
        var body: some View {
            VStack(spacing: 32) {
                Text("Design System - Animations")
                    .font(.title.bold())
                
                // Animation selector
                Picker("Animation", selection: $selectedAnimation) {
                    ForEach(animations.indices, id: \.self) { index in
                        Text(animations[index].0)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Demo box
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 300, height: 200)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue)
                        .frame(width: 80, height: 80)
                        .offset(x: isAnimating ? 80 : -80, y: 0)
                        .animation(animations[selectedAnimation].1, value: isAnimating)
                }
                
                // Controls
                Button {
                    isAnimating.toggle()
                } label: {
                    Text(isAnimating ? "Reset" : "Animate")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                Divider()
                    .padding(.horizontal)
                
                // Animation info
                VStack(alignment: .leading, spacing: 12) {
                    Text("Current: \(animations[selectedAnimation].0)")
                        .font(.headline)
                    
                    Text("Try different animations to see the motion curves")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Duration examples
                VStack(alignment: .leading, spacing: 12) {
                    Text("Durations")
                        .font(.headline)
                    
                    HStack(spacing: 16) {
                        ForEach([
                            ("Fast", DesignAnimation.Duration.fast),
                            ("Normal", DesignAnimation.Duration.normal),
                            ("Slow", DesignAnimation.Duration.slow),
                        ], id: \.0) { name, duration in
                            VStack(spacing: 4) {
                                Text(name)
                                    .font(.caption)
                                Text(String(format: "%.2fs", duration))
                                    .font(.caption2.monospacedDigit())
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.vertical)
        }
    }
    
    static var previews: some View {
        AnimationDemo()
            .frame(width: 500, height: 700)
    }
}
#endif
