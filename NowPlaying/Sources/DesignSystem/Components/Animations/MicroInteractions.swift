//
//  MicroInteractions.swift
//  NowPlaying
//
//  Design System - Micro Interactions
//  Feedback visual para interações do usuário
//
//  Created by Diego Castilho on 14/11/25
//  Copyright © 2025 Diego Castilho. All rights reserved.
//

import SwiftUI

// MARK: - Button Press Effect

/// Modifier que adiciona efeito de press ao botão
struct ButtonPressModifier: ViewModifier {
    let isPressed: Bool
    let scale: CGFloat
    let brightness: Double
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? scale : 1.0)
            .brightness(isPressed ? brightness : 0)
            .animation(AnimationPreset.buttonPress.animation, value: isPressed)
    }
}

extension View {
    /// Adiciona efeito visual de press
    ///
    /// Uso:
    /// ```swift
    /// Button("Tap") { }
    ///     .buttonPress(scale: 0.95)
    /// ```
    func buttonPress(
        scale: CGFloat = 0.96,
        brightness: Double = -0.1
    ) -> some View {
        ButtonPressWrapper(scale: scale, brightness: brightness) {
            self
        }
    }
}

struct ButtonPressWrapper<Content: View>: View {
    @State private var isPressed = false
    
    let scale: CGFloat
    let brightness: Double
    let content: Content
    
    init(
        scale: CGFloat = 0.96,
        brightness: Double = -0.1,
        @ViewBuilder content: () -> Content
    ) {
        self.scale = scale
        self.brightness = brightness
        self.content = content()
    }
    
    var body: some View {
        content
            .modifier(ButtonPressModifier(
                isPressed: isPressed,
                scale: scale,
                brightness: brightness
            ))
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in isPressed = false }
            )
    }
}

// MARK: - Haptic-Style Bounce

/// Modifier que adiciona bounce haptic-style
struct HapticBounceModifier: ViewModifier {
    @Binding var trigger: Bool
    let intensity: CGFloat
    
    @State private var scale: CGFloat = 1.0
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .onChange(of: trigger) { _, newValue in
                if newValue {
                    // Bounce animation
                    withAnimation(AnimationPreset.springBouncy.animation) {
                        scale = 1.0 + intensity
                    }
                    
                    // Return to normal
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(AnimationPreset.springBouncy.animation) {
                            scale = 1.0
                        }
                    }
                }
            }
    }
}

extension View {
    /// Adiciona bounce haptic-style quando trigger muda
    ///
    /// Uso:
    /// ```swift
    /// Text("Hello")
    ///     .hapticBounce(trigger: $didSave, intensity: 0.1)
    /// ```
    func hapticBounce(
        trigger: Binding<Bool>,
        intensity: CGFloat = 0.15
    ) -> some View {
        modifier(HapticBounceModifier(trigger: trigger, intensity: intensity))
    }
}

// MARK: - Success Checkmark

/// View animada de checkmark de sucesso
struct SuccessCheckmark: View {
    @State private var progress: CGFloat = 0
    @State private var scale: CGFloat = 0
    
    let size: CGFloat
    let color: Color
    
    init(size: CGFloat = 60, color: Color = .green) {
        self.size = size
        self.color = color
    }
    
    var body: some View {
        ZStack {
            // Circle background
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 4)
                .frame(width: size, height: size)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
            
            // Checkmark
            Image(systemName: "checkmark")
                .font(.system(size: size * 0.5, weight: .bold))
                .foregroundStyle(color)
                .scaleEffect(scale)
        }
        .onAppear {
            // Animate circle
            withAnimation(AnimationPreset.easeOut.animation.delay(0.1)) {
                progress = 1.0
            }
            
            // Animate checkmark
            withAnimation(AnimationPreset.springBouncy.animation.delay(0.3)) {
                scale = 1.0
            }
        }
    }
}

// MARK: - Error Shake

/// Modifier que adiciona shake de erro
struct ErrorShakeModifier: ViewModifier {
    @Binding var trigger: Bool
    
    @State private var offset: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .offset(x: offset)
            .onChange(of: trigger) { _, newValue in
                if newValue {
                    // Shake animation
                    let animation = Animation.linear(duration: 0.1).repeatCount(3, autoreverses: true)
                    
                    withAnimation(animation) {
                        offset = 10
                    }
                    
                    // Return to center
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(AnimationPreset.springSnappy.animation) {
                            offset = 0
                        }
                        trigger = false
                    }
                }
            }
    }
}

extension View {
    /// Adiciona shake de erro quando trigger muda
    ///
    /// Uso:
    /// ```swift
    /// TextField("Password", text: $password)
    ///     .errorShake(trigger: $showError)
    /// ```
    func errorShake(trigger: Binding<Bool>) -> some View {
        modifier(ErrorShakeModifier(trigger: trigger))
    }
}

// MARK: - Loading Pulse

/// Modifier que adiciona pulse de loading
struct LoadingPulseModifier: ViewModifier {
    let isLoading: Bool
    let minOpacity: Double
    let maxOpacity: Double
    
    @State private var opacity: Double = 1.0
    
    func body(content: Content) -> some View {
        content
            .opacity(isLoading ? opacity : 1.0)
            .onAppear {
                if isLoading {
                    startPulsing()
                }
            }
            .onChange(of: isLoading) { _, newValue in
                if newValue {
                    startPulsing()
                } else {
                    opacity = 1.0
                }
            }
    }
    
    private func startPulsing() {
        withAnimation(
            Animation.easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true)
        ) {
            opacity = minOpacity
        }
    }
}

extension View {
    /// Adiciona pulse de loading
    ///
    /// Uso:
    /// ```swift
    /// Text("Loading...")
    ///     .loadingPulse(isLoading: true)
    /// ```
    func loadingPulse(
        isLoading: Bool,
        minOpacity: Double = 0.3,
        maxOpacity: Double = 1.0
    ) -> some View {
        modifier(LoadingPulseModifier(
            isLoading: isLoading,
            minOpacity: minOpacity,
            maxOpacity: maxOpacity
        ))
    }
}

// MARK: - Skeleton Shimmer

/// Modifier que adiciona shimmer de skeleton loading
struct SkeletonShimmerModifier: ViewModifier {
    let isLoading: Bool
    
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if isLoading {
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0),
                                Color.white.opacity(0.3),
                                Color.white.opacity(0)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .offset(x: phase)
                        .mask(content)
                    }
                }
            )
            .onAppear {
                if isLoading {
                    startShimmering()
                }
            }
            .onChange(of: isLoading) { _, newValue in
                if newValue {
                    startShimmering()
                } else {
                    phase = 0
                }
            }
    }
    
    private func startShimmering() {
        withAnimation(
            Animation.linear(duration: 1.5)
                .repeatForever(autoreverses: false)
        ) {
            phase = 300
        }
    }
}

extension View {
    /// Adiciona shimmer de skeleton
    ///
    /// Uso:
    /// ```swift
    /// RoundedRectangle(cornerRadius: 8)
    ///     .fill(Color.gray.opacity(0.3))
    ///     .frame(height: 20)
    ///     .skeletonShimmer(isLoading: true)
    /// ```
    func skeletonShimmer(isLoading: Bool) -> some View {
        modifier(SkeletonShimmerModifier(isLoading: isLoading))
    }
}

// MARK: - Attention Seeker

/// Modifier que chama atenção (wiggle)
struct AttentionSeekerModifier: ViewModifier {
    @Binding var trigger: Bool
    
    @State private var rotation: Double = 0
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(rotation))
            .onChange(of: trigger) { _, newValue in
                if newValue {
                    // Wiggle animation
                    let animation = Animation.linear(duration: 0.1).repeatCount(4, autoreverses: true)
                    
                    withAnimation(animation) {
                        rotation = 5
                    }
                    
                    // Return to normal
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        withAnimation(AnimationPreset.springSnappy.animation) {
                            rotation = 0
                        }
                        trigger = false
                    }
                }
            }
    }
}

extension View {
    /// Adiciona wiggle para chamar atenção
    ///
    /// Uso:
    /// ```swift
    /// Button("Important") { }
    ///     .attentionSeeker(trigger: $needsAttention)
    /// ```
    func attentionSeeker(trigger: Binding<Bool>) -> some View {
        modifier(AttentionSeekerModifier(trigger: trigger))
    }
}

// MARK: - Progress Indicator

/// Indicador de progresso animado
struct ProgressIndicator: View {
    let progress: Double  // 0.0 to 1.0
    let color: Color
    let showPercentage: Bool
    
    init(
        progress: Double,
        color: Color = DesignColor.Accent.primary,
        showPercentage: Bool = true
    ) {
        self.progress = progress
        self.color = color
        self.showPercentage = showPercentage
    }
    
    var body: some View {
        VStack(spacing: DesignSpacing.xs) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color.opacity(0.2))
                    
                    // Progress
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * CGFloat(progress))
                        .animation(AnimationPreset.easeOut.animation, value: progress)
                }
            }
            .frame(height: 8)
            
            if showPercentage {
                Text("\(Int(progress * 100))%")
                    .font(DesignTypography.caption1)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Floating Action Button

/// FAB com animações
struct FloatingActionButton: View {
    let icon: String
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var scale: CGFloat = 0
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(DesignColor.Accent.primary)
                        .shadow(
                            color: DesignColor.Accent.primary.opacity(0.4),
                            radius: isPressed ? 8 : 12,
                            y: isPressed ? 2 : 4
                        )
                )
                .scaleEffect(isPressed ? 0.9 : (scale * 1.0))
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(AnimationPreset.buttonPress.animation) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(AnimationPreset.springBouncy.animation) {
                        isPressed = false
                    }
                }
        )
        .onAppear {
            withAnimation(AnimationPreset.springBouncy.animation.delay(0.1)) {
                scale = 1.0
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct MicroInteractions_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: DesignSpacing.xl) {
                Text("Micro Interactions")
                    .font(DesignTypography.title1)
                    .padding(.top)
                
                // Button Press
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Button Press Effect")
                        .font(DesignTypography.headline)
                    
                    Button("Press Me") { }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(DesignColor.Accent.primary)
                        )
                        .foregroundStyle(.white)
                        .buttonPress()
                }
                .padding(.horizontal)
                
                Divider()
                
                // Haptic Bounce
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Haptic Bounce")
                        .font(DesignTypography.headline)
                    
                    HapticBounceDemo()
                }
                .padding(.horizontal)
                
                Divider()
                
                // Success Checkmark
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Success Checkmark")
                        .font(DesignTypography.headline)
                    
                    SuccessCheckmark(size: 80)
                }
                .padding(.horizontal)
                
                Divider()
                
                // Error Shake
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Error Shake")
                        .font(DesignTypography.headline)
                    
                    ErrorShakeDemo()
                }
                .padding(.horizontal)
                
                Divider()
                
                // Loading Pulse
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Loading Pulse")
                        .font(DesignTypography.headline)
                    
                    Text("Loading content...")
                        .font(DesignTypography.body)
                        .loadingPulse(isLoading: true)
                }
                .padding(.horizontal)
                
                Divider()
                
                // Skeleton Shimmer
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Skeleton Shimmer")
                        .font(DesignTypography.headline)
                    
                    VStack(spacing: DesignSpacing.sm) {
                        ForEach(0..<3) { _ in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 20)
                                .skeletonShimmer(isLoading: true)
                        }
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // Attention Seeker
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Attention Seeker")
                        .font(DesignTypography.headline)
                    
                    AttentionSeekerDemo()
                }
                .padding(.horizontal)
                
                Divider()
                
                // Progress Indicator
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Progress Indicator")
                        .font(DesignTypography.headline)
                    
                    ProgressIndicatorDemo()
                }
                .padding(.horizontal)
                
                Divider()
                
                // Floating Action Button
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Floating Action Button")
                        .font(DesignTypography.headline)
                    
                    FloatingActionButton(icon: "plus") {
                        print("FAB tapped")
                    }
                }
                .padding(.horizontal)
                
                Spacer(minLength: 40)
            }
        }
        .frame(width: 500, height: 1400)
    }
}

// MARK: - Demo Components

struct HapticBounceDemo: View {
    @State private var trigger = false
    
    var body: some View {
        VStack(spacing: DesignSpacing.sm) {
            Button("Trigger Bounce") {
                trigger.toggle()
            }
            
            Circle()
                .fill(DesignColor.Accent.primary)
                .frame(width: 60, height: 60)
                .hapticBounce(trigger: $trigger, intensity: 0.2)
        }
    }
}

struct ErrorShakeDemo: View {
    @State private var showError = false
    
    var body: some View {
        VStack(spacing: DesignSpacing.sm) {
            Button("Trigger Error") {
                showError = true
            }
            
            RoundedRectangle(cornerRadius: 12)
                .fill(DesignColor.Status.error.opacity(0.2))
                .frame(height: 60)
                .overlay(
                    Text("Error Message")
                        .font(DesignTypography.body)
                        .foregroundStyle(DesignColor.Status.error)
                )
                .errorShake(trigger: $showError)
        }
    }
}

struct AttentionSeekerDemo: View {
    @State private var needsAttention = false
    
    var body: some View {
        VStack(spacing: DesignSpacing.sm) {
            Button("Need Attention") {
                needsAttention = true
            }
            
            Image(systemName: "bell.fill")
                .font(.system(size: 40))
                .foregroundStyle(DesignColor.Accent.primary)
                .attentionSeeker(trigger: $needsAttention)
        }
    }
}

struct ProgressIndicatorDemo: View {
    @State private var progress: Double = 0.0
    
    var body: some View {
        VStack(spacing: DesignSpacing.md) {
            ProgressIndicator(progress: progress)
            
            HStack {
                Button("Reset") {
                    progress = 0.0
                }
                
                Button("Add 25%") {
                    progress = min(1.0, progress + 0.25)
                }
            }
        }
    }
}
#endif
