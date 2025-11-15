//
//  AnimationPresets.swift
//  NowPlaying
//
//  Design System - Animation Presets
//  Sistema avançado de animações reutilizáveis
//
//  Created by Diego Castilho on 14/11/25
//  Copyright © 2025 Diego Castilho. All rights reserved.
//

import SwiftUI

// MARK: - Animation Presets

/// Presets de animações avançadas
enum AnimationPreset {
    // Spring animations
    case springGentle
    case springBouncy
    case springSnappy
    case springHeavy
    
    // Timing-based animations
    case easeIn
    case easeOut
    case easeInOut
    case linear
    
    // Special effects
    case elastic
    case overshoot
    case anticipate
    case wiggle
    
    // Contextual
    case buttonPress
    case cardFlip
    case slideIn
    case fadeInOut
    
    /// Retorna a Animation do SwiftUI
    var animation: Animation {
        switch self {
        // Spring animations
        case .springGentle:
            return .spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)
            
        case .springBouncy:
            return .spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0)
            
        case .springSnappy:
            return .spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0)
            
        case .springHeavy:
            return .spring(response: 0.6, dampingFraction: 0.9, blendDuration: 0)
            
        // Timing-based
        case .easeIn:
            return .easeIn(duration: 0.3)
            
        case .easeOut:
            return .easeOut(duration: 0.3)
            
        case .easeInOut:
            return .easeInOut(duration: 0.3)
            
        case .linear:
            return .linear(duration: 0.3)
            
        // Special effects
        case .elastic:
            return .interpolatingSpring(
                mass: 1.0,
                stiffness: 100,
                damping: 10,
                initialVelocity: 0
            )
            
        case .overshoot:
            return .interpolatingSpring(
                mass: 1.0,
                stiffness: 200,
                damping: 15,
                initialVelocity: 5
            )
            
        case .anticipate:
            return .interpolatingSpring(
                mass: 0.8,
                stiffness: 150,
                damping: 12,
                initialVelocity: -2
            )
            
        case .wiggle:
            return .interpolatingSpring(
                mass: 0.5,
                stiffness: 300,
                damping: 8,
                initialVelocity: 0
            )
            
        // Contextual
        case .buttonPress:
            return .spring(response: 0.2, dampingFraction: 0.8)
            
        case .cardFlip:
            return .easeInOut(duration: 0.5)
            
        case .slideIn:
            return .spring(response: 0.4, dampingFraction: 0.75)
            
        case .fadeInOut:
            return .easeInOut(duration: 0.25)
        }
    }
    
    /// Duração aproximada em segundos
    var duration: TimeInterval {
        switch self {
        case .springGentle: return 0.5
        case .springBouncy: return 0.4
        case .springSnappy: return 0.3
        case .springHeavy: return 0.6
        case .easeIn, .easeOut, .easeInOut, .linear: return 0.3
        case .elastic: return 0.8
        case .overshoot: return 0.6
        case .anticipate: return 0.5
        case .wiggle: return 0.4
        case .buttonPress: return 0.2
        case .cardFlip: return 0.5
        case .slideIn: return 0.4
        case .fadeInOut: return 0.25
        }
    }
}

// MARK: - Animation Chaining

/// Chain de animações sequenciais
struct AnimationChain {
    private var steps: [(animation: Animation, delay: TimeInterval, action: () -> Void)] = []
    
    /// Adiciona um step ao chain
    mutating func add(
        animation: AnimationPreset,
        delay: TimeInterval = 0,
        action: @escaping () -> Void
    ) {
        steps.append((animation.animation, delay, action))
    }
    
    /// Executa o chain de animações
    func execute() {
        var totalDelay: TimeInterval = 0
        
        for step in steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + totalDelay + step.delay) {
                withAnimation(step.animation) {
                    step.action()
                }
            }
            totalDelay += step.delay
        }
    }
}

// MARK: - Repeating Animation

/// Animação que se repete
struct RepeatingAnimation {
    let preset: AnimationPreset
    let repeatCount: Int?  // nil = forever
    let autoreverses: Bool
    
    init(
        _ preset: AnimationPreset,
        repeatCount: Int? = nil,
        autoreverses: Bool = true
    ) {
        self.preset = preset
        self.repeatCount = repeatCount
        self.autoreverses = autoreverses
    }
    
    var animation: Animation {
        var anim = preset.animation
        
        if let count = repeatCount {
            anim = anim.repeatCount(count, autoreverses: autoreverses)
        } else {
            anim = anim.repeatForever(autoreverses: autoreverses)
        }
        
        return anim
    }
}

// MARK: - View Extensions

extension View {
    /// Aplica animação preset
    ///
    /// Uso:
    /// ```swift
    /// Text("Hello")
    ///     .animateWith(.springBouncy, value: isVisible)
    /// ```
    func animateWith<V: Equatable>(
        _ preset: AnimationPreset,
        value: V
    ) -> some View {
        self.animation(preset.animation, value: value)
    }
    
    /// Executa ação com animação preset
    ///
    /// Uso:
    /// ```swift
    /// Button("Tap") {
    ///     performAnimated(.springBouncy) {
    ///         isExpanded.toggle()
    ///     }
    /// }
    /// ```
    func performAnimated(
        _ preset: AnimationPreset,
        action: @escaping () -> Void
    ) {
        withAnimation(preset.animation) {
            action()
        }
    }
}

// MARK: - Animated Value Wrapper

/// Wrapper que anima mudanças automaticamente
@propertyWrapper
struct Animated<Value> {
    private var value: Value
    private let preset: AnimationPreset
    
    var wrappedValue: Value {
        get { value }
        set {
            withAnimation(preset.animation) {
                value = newValue
            }
        }
    }
    
    init(wrappedValue: Value, _ preset: AnimationPreset = .springGentle) {
        self.value = wrappedValue
        self.preset = preset
    }
}

// MARK: - Staggered Animation

/// Helper para animações em cascata (staggered)
struct StaggeredAnimation {
    let preset: AnimationPreset
    let staggerDelay: TimeInterval
    
    init(
        _ preset: AnimationPreset = .springGentle,
        staggerDelay: TimeInterval = 0.05
    ) {
        self.preset = preset
        self.staggerDelay = staggerDelay
    }
    
    /// Retorna animation com delay para índice
    func animation(for index: Int) -> Animation {
        preset.animation.delay(TimeInterval(index) * staggerDelay)
    }
}

// MARK: - Preview

#if DEBUG
struct AnimationPresets_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: DesignSpacing.xl) {
                Text("Animation Presets")
                    .font(DesignTypography.title1)
                    .padding(.top)
                
                // Spring animations
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Spring Animations")
                        .font(DesignTypography.headline)
                    
                    AnimationDemoRow(preset: .springGentle, label: "Spring Gentle")
                    AnimationDemoRow(preset: .springBouncy, label: "Spring Bouncy")
                    AnimationDemoRow(preset: .springSnappy, label: "Spring Snappy")
                    AnimationDemoRow(preset: .springHeavy, label: "Spring Heavy")
                }
                .padding(.horizontal)
                
                Divider()
                
                // Timing-based
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Timing-Based")
                        .font(DesignTypography.headline)
                    
                    AnimationDemoRow(preset: .easeIn, label: "Ease In")
                    AnimationDemoRow(preset: .easeOut, label: "Ease Out")
                    AnimationDemoRow(preset: .easeInOut, label: "Ease In Out")
                    AnimationDemoRow(preset: .linear, label: "Linear")
                }
                .padding(.horizontal)
                
                Divider()
                
                // Special effects
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Special Effects")
                        .font(DesignTypography.headline)
                    
                    AnimationDemoRow(preset: .elastic, label: "Elastic")
                    AnimationDemoRow(preset: .overshoot, label: "Overshoot")
                    AnimationDemoRow(preset: .anticipate, label: "Anticipate")
                    AnimationDemoRow(preset: .wiggle, label: "Wiggle")
                }
                .padding(.horizontal)
                
                Divider()
                
                // Contextual
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Contextual")
                        .font(DesignTypography.headline)
                    
                    AnimationDemoRow(preset: .buttonPress, label: "Button Press")
                    AnimationDemoRow(preset: .cardFlip, label: "Card Flip")
                    AnimationDemoRow(preset: .slideIn, label: "Slide In")
                    AnimationDemoRow(preset: .fadeInOut, label: "Fade In Out")
                }
                .padding(.horizontal)
                
                Divider()
                
                // Staggered demo
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Staggered Animation")
                        .font(DesignTypography.headline)
                    
                    StaggeredAnimationDemo()
                }
                .padding(.horizontal)
                
                Spacer(minLength: 40)
            }
        }
        .frame(width: 500, height: 1200)
    }
}

// MARK: - Demo Components

struct AnimationDemoRow: View {
    let preset: AnimationPreset
    let label: String
    
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: DesignSpacing.md) {
            Button(action: {
                isAnimating.toggle()
            }) {
                Text(label)
                    .font(DesignTypography.body)
                    .frame(width: 150, alignment: .leading)
            }
            
            Circle()
                .fill(DesignColor.Accent.primary)
                .frame(width: 30, height: 30)
                .offset(x: isAnimating ? 200 : 0)
                .animation(preset.animation, value: isAnimating)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct StaggeredAnimationDemo: View {
    @State private var isVisible = false
    
    let staggered = StaggeredAnimation(.springBouncy, staggerDelay: 0.1)
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSpacing.sm) {
            Button("Toggle") {
                isVisible.toggle()
            }
            
            ForEach(0..<5) { index in
                RoundedRectangle(cornerRadius: 8)
                    .fill(DesignColor.Accent.secondary)
                    .frame(height: 40)
                    .opacity(isVisible ? 1 : 0)
                    .offset(x: isVisible ? 0 : -50)
                    .animation(staggered.animation(for: index), value: isVisible)
            }
        }
    }
}
#endif
