//
//  AnimatedComponents.swift
//  NowPlaying
//
//  Design System - Animated Components
//  Componentes prontos com animações integradas
//
//  Created by Diego Castilho on 14/11/25
//  Copyright © 2025 Diego Castilho. All rights reserved.
//

import SwiftUI

// MARK: - Spinning Loader

/// Indicador de loading circular animado
struct SpinningLoader: View {
    let size: CGFloat
    let lineWidth: CGFloat
    let color: Color
    
    @State private var isAnimating = false
    
    init(
        size: CGFloat = 40,
        lineWidth: CGFloat = 4,
        color: Color = DesignColor.Accent.primary
    ) {
        self.size = size
        self.lineWidth = lineWidth
        self.color = color
    }
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .frame(width: size, height: size)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 1.0)
                        .repeatForever(autoreverses: false)
                ) {
                    isAnimating = true
                }
            }
    }
}

// MARK: - Dots Loader

/// Indicador de loading com dots animados
struct DotsLoader: View {
    let dotSize: CGFloat
    let spacing: CGFloat
    let color: Color
    
    @State private var animatingDot = 0
    
    init(
        dotSize: CGFloat = 10,
        spacing: CGFloat = 8,
        color: Color = DesignColor.Accent.primary
    ) {
        self.dotSize = dotSize
        self.spacing = spacing
        self.color = color
    }
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(color)
                    .frame(width: dotSize, height: dotSize)
                    .scaleEffect(animatingDot == index ? 1.3 : 1.0)
                    .opacity(animatingDot == index ? 1.0 : 0.5)
            }
        }
        .onAppear {
            startAnimating()
        }
    }
    
    private func startAnimating() {
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
            withAnimation(AnimationPreset.springBouncy.animation) {
                animatingDot = (animatingDot + 1) % 3
            }
        }
    }
}

// MARK: - Pulse Loader

/// Indicador de loading com pulso
struct PulseLoader: View {
    let size: CGFloat
    let color: Color
    
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    
    init(
        size: CGFloat = 60,
        color: Color = DesignColor.Accent.primary
    ) {
        self.size = size
        self.color = color
    }
    
    var body: some View {
        ZStack {
            // Outer pulse
            Circle()
                .fill(color.opacity(0.3))
                .frame(width: size, height: size)
                .scaleEffect(scale)
                .opacity(opacity)
            
            // Inner circle
            Circle()
                .fill(color)
                .frame(width: size * 0.6, height: size * 0.6)
        }
        .onAppear {
            withAnimation(
                Animation.easeOut(duration: 1.5)
                    .repeatForever(autoreverses: false)
            ) {
                scale = 1.5
                opacity = 0
            }
        }
    }
}

// MARK: - Progress Ring

/// Anel de progresso animado
struct ProgressRing: View {
    let progress: Double  // 0.0 to 1.0
    let size: CGFloat
    let lineWidth: CGFloat
    let color: Color
    let showPercentage: Bool
    
    @State private var animatedProgress: Double = 0
    
    init(
        progress: Double,
        size: CGFloat = 100,
        lineWidth: CGFloat = 8,
        color: Color = DesignColor.Accent.primary,
        showPercentage: Bool = true
    ) {
        self.progress = progress
        self.size = size
        self.lineWidth = lineWidth
        self.color = color
        self.showPercentage = showPercentage
    }
    
    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)
            
            // Progress ring
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            
            // Percentage text
            if showPercentage {
                Text("\(Int(animatedProgress * 100))%")
                    .font(.system(size: size * 0.25, weight: .bold, design: .rounded))
                    .foregroundStyle(color)
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(AnimationPreset.easeOut.animation) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(AnimationPreset.easeOut.animation) {
                animatedProgress = newValue
            }
        }
    }
}

// MARK: - Skeleton Card

/// Card skeleton para loading
struct SkeletonCard: View {
    let width: CGFloat?
    let height: CGFloat
    let cornerRadius: CGFloat
    
    init(
        width: CGFloat? = nil,
        height: CGFloat = 100,
        cornerRadius: CGFloat = 12
    ) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSpacing.sm) {
            // Title
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .skeletonShimmer(isLoading: true)
            
            // Subtitle
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 150, height: 16)
                .skeletonShimmer(isLoading: true)
            
            Spacer()
            
            // Footer
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 100, height: 14)
                .skeletonShimmer(isLoading: true)
        }
        .padding()
        .frame(width: width, height: height)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

// MARK: - Animated Counter

/// Contador animado
struct AnimatedCounter: View {
    let value: Int
    let duration: TimeInterval
    let font: Font
    let color: Color
    
    @State private var displayValue: Int = 0
    
    init(
        value: Int,
        duration: TimeInterval = 0.8,
        font: Font = DesignTypography.title1,
        color: Color = .primary
    ) {
        self.value = value
        self.duration = duration
        self.font = font
        self.color = color
    }
    
    var body: some View {
        Text("\(displayValue)")
            .font(font)
            .foregroundStyle(color)
            .onAppear {
                animateCounter()
            }
            .onChange(of: value) { _, _ in
                animateCounter()
            }
    }
    
    private func animateCounter() {
        let steps = 30
        let stepValue = value / steps
        let stepDuration = duration / Double(steps)
        
        displayValue = 0
        
        for step in 1...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + stepDuration * Double(step)) {
                if step == steps {
                    displayValue = value
                } else {
                    displayValue += stepValue
                }
            }
        }
    }
}

// MARK: - Breath Animation

/// Componente que "respira" (cresce e diminui)
struct BreathingView<Content: View>: View {
    let content: Content
    let duration: TimeInterval
    let scaleRange: ClosedRange<CGFloat>
    
    @State private var scale: CGFloat = 1.0
    
    init(
        duration: TimeInterval = 2.0,
        scaleRange: ClosedRange<CGFloat> = 0.95...1.05,
        @ViewBuilder content: () -> Content
    ) {
        self.duration = duration
        self.scaleRange = scaleRange
        self.content = content()
    }
    
    var body: some View {
        content
            .scaleEffect(scale)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: duration)
                        .repeatForever(autoreverses: true)
                ) {
                    scale = scaleRange.upperBound
                }
            }
    }
}

// MARK: - Typing Indicator

/// Indicador de digitação (três dots)
struct TypingIndicator: View {
    let dotSize: CGFloat
    let spacing: CGFloat
    let color: Color
    
    @State private var animationOffsets: [CGFloat] = [0, 0, 0]
    
    init(
        dotSize: CGFloat = 8,
        spacing: CGFloat = 6,
        color: Color = DesignColor.Accent.primary
    ) {
        self.dotSize = dotSize
        self.spacing = spacing
        self.color = color
    }
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(color)
                    .frame(width: dotSize, height: dotSize)
                    .offset(y: animationOffsets[index])
            }
        }
        .onAppear {
            startAnimating()
        }
    }
    
    private func startAnimating() {
        for index in 0..<3 {
            withAnimation(
                Animation.easeInOut(duration: 0.6)
                    .repeatForever(autoreverses: true)
                    .delay(Double(index) * 0.2)
            ) {
                animationOffsets[index] = -8
            }
        }
    }
}

// MARK: - Animated Badge

/// Badge com animação de entrada
struct AnimatedBadge: View {
    let text: String
    let color: Color
    let delay: TimeInterval
    
    @State private var scale: CGFloat = 0
    @State private var opacity: Double = 0
    
    init(
        text: String,
        color: Color = DesignColor.Accent.primary,
        delay: TimeInterval = 0
    ) {
        self.text = text
        self.color = color
        self.delay = delay
    }
    
    var body: some View {
        Text(text)
            .font(DesignTypography.caption1.bold())
            .padding(.horizontal, DesignSpacing.sm)
            .padding(.vertical, DesignSpacing.xs)
            .background(
                Capsule()
                    .fill(color)
            )
            .foregroundStyle(.white)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    AnimationPreset.springBouncy.animation
                        .delay(delay)
                ) {
                    scale = 1.0
                    opacity = 1.0
                }
            }
    }
}

// MARK: - Wave Animation

/// Efeito de onda (múltiplos círculos expandindo)
struct WaveAnimation: View {
    let size: CGFloat
    let color: Color
    let waveCount: Int
    
    @State private var animatingWaves: [Bool]
    
    init(
        size: CGFloat = 100,
        color: Color = DesignColor.Accent.primary,
        waveCount: Int = 3
    ) {
        self.size = size
        self.color = color
        self.waveCount = waveCount
        self._animatingWaves = State(initialValue: Array(repeating: false, count: waveCount))
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<waveCount, id: \.self) { index in
                Circle()
                    .stroke(color.opacity(0.5), lineWidth: 2)
                    .frame(width: size, height: size)
                    .scaleEffect(animatingWaves[index] ? 1.5 : 0.5)
                    .opacity(animatingWaves[index] ? 0 : 1)
            }
        }
        .onAppear {
            startAnimating()
        }
    }
    
    private func startAnimating() {
        for index in 0..<waveCount {
            withAnimation(
                Animation.easeOut(duration: 2.0)
                    .repeatForever(autoreverses: false)
                    .delay(Double(index) * 0.6)
            ) {
                animatingWaves[index] = true
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct AnimatedComponents_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: DesignSpacing.xl) {
                Text("Animated Components")
                    .font(DesignTypography.title1)
                    .padding(.top)
                
                // Loaders
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Loading Indicators")
                        .font(DesignTypography.headline)
                    
                    HStack(spacing: DesignSpacing.xl) {
                        VStack(spacing: DesignSpacing.xs) {
                            SpinningLoader()
                            Text("Spinning")
                                .font(DesignTypography.caption1)
                                .foregroundStyle(.secondary)
                        }
                        
                        VStack(spacing: DesignSpacing.xs) {
                            DotsLoader()
                            Text("Dots")
                                .font(DesignTypography.caption1)
                                .foregroundStyle(.secondary)
                        }
                        
                        VStack(spacing: DesignSpacing.xs) {
                            PulseLoader(size: 40)
                            Text("Pulse")
                                .font(DesignTypography.caption1)
                                .foregroundStyle(.secondary)
                        }
                        
                        VStack(spacing: DesignSpacing.xs) {
                            TypingIndicator()
                            Text("Typing")
                                .font(DesignTypography.caption1)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // Progress Ring
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Progress Ring")
                        .font(DesignTypography.headline)
                    
                    HStack(spacing: DesignSpacing.xl) {
                        ProgressRing(progress: 0.25, size: 80)
                        ProgressRing(progress: 0.5, size: 80, color: .green)
                        ProgressRing(progress: 0.75, size: 80, color: .orange)
                        ProgressRing(progress: 1.0, size: 80, color: .red)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // Skeleton Cards
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Skeleton Loading")
                        .font(DesignTypography.headline)
                    
                    VStack(spacing: DesignSpacing.md) {
                        SkeletonCard(height: 100)
                        SkeletonCard(height: 100)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // Animated Counter
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Animated Counter")
                        .font(DesignTypography.headline)
                    
                    AnimatedCounterDemo()
                }
                .padding(.horizontal)
                
                Divider()
                
                // Breathing Animation
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Breathing Animation")
                        .font(DesignTypography.headline)
                    
                    BreathingView {
                        Circle()
                            .fill(DesignColor.Accent.primary)
                            .frame(width: 80, height: 80)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // Animated Badges
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Animated Badges")
                        .font(DesignTypography.headline)
                    
                    HStack(spacing: DesignSpacing.sm) {
                        AnimatedBadge(text: "New", color: .blue, delay: 0)
                        AnimatedBadge(text: "Featured", color: .purple, delay: 0.1)
                        AnimatedBadge(text: "Hot", color: .red, delay: 0.2)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // Wave Animation
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Wave Animation")
                        .font(DesignTypography.headline)
                    
                    WaveAnimation(size: 80, waveCount: 3)
                }
                .padding(.horizontal)
                
                Spacer(minLength: 40)
            }
        }
        .frame(width: 500, height: 1400)
    }
}

// MARK: - Demo Components

struct AnimatedCounterDemo: View {
    @State private var value = 0
    
    var body: some View {
        VStack(spacing: DesignSpacing.md) {
            AnimatedCounter(value: value)
            
            HStack {
                Button("Reset") {
                    value = 0
                }
                
                Button("+100") {
                    value += 100
                }
                
                Button("+1000") {
                    value += 1000
                }
            }
        }
    }
}
#endif
