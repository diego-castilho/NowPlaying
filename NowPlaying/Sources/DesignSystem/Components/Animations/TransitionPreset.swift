//
//  TransitionEffects.swift
//  NowPlaying
//
//  Design System - Transition Effects
//  Transições suaves entre views e estados
//
//  Created by Diego Castilho on 14/11/25
//  Copyright © 2025 Diego Castilho. All rights reserved.
//

import SwiftUI

// MARK: - Transition Preset

/// Presets de transições predefinidas
indirect enum TransitionPreset {
    // Basic
    case fade
    case scale
    case slide(edge: Edge = .leading)
    case move(edge: Edge = .leading)
    
    // Combined
    case fadeScale
    case slideAndFade(edge: Edge = .leading)
    case scaleAndSlide(edge: Edge = .leading)
    
    // Advanced
    case blur
    case pivot(anchor: UnitPoint = .center)
    case flip(axis: Axis = .horizontal)
    case rotate3D(axis: (x: CGFloat, y: CGFloat, z: CGFloat) = (0, 1, 0))
    
    // Special
    case asymmetric(insertion: TransitionPreset, removal: TransitionPreset)
    case push(from: Edge = .leading)
    
    /// Retorna a Transition do SwiftUI
    var transition: AnyTransition {
        switch self {
        // Basic
        case .fade:
            return .opacity
            
        case .scale:
            return .scale(scale: 0.8)
            
        case .slide(let edge):
            return .slide
            
        case .move(let edge):
            return .move(edge: edge)
            
        // Combined
        case .fadeScale:
            return .opacity.combined(with: .scale(scale: 0.8))
            
        case .slideAndFade(let edge):
            return .slide.combined(with: .opacity)
            
        case .scaleAndSlide(let edge):
            return .scale(scale: 0.8).combined(with: .move(edge: edge))
            
        // Advanced
        case .blur:
            return .modifier(
                active: BlurTransitionModifier(blur: 10),
                identity: BlurTransitionModifier(blur: 0)
            )
            
        case .pivot(let anchor):
            return .scale(scale: 0.5, anchor: anchor)
                .combined(with: .opacity)
            
        case .flip(let axis):
            return .modifier(
                active: FlipTransitionModifier(angle: 90, axis: axis),
                identity: FlipTransitionModifier(angle: 0, axis: axis)
            )
            
        case .rotate3D(let axis):
            return .modifier(
                active: Rotate3DTransitionModifier(angle: 90, axis: axis),
                identity: Rotate3DTransitionModifier(angle: 0, axis: axis)
            )
            
        // Special
        case .asymmetric(let insertion, let removal):
            return .asymmetric(
                insertion: insertion.transition,
                removal: removal.transition
            )
            
        case .push(let edge):
            return .move(edge: edge)
        }
    }
    
    /// Enum para eixo de flip
    enum Axis {
        case horizontal
        case vertical
    }
}

// MARK: - Blur Transition Modifier

struct BlurTransitionModifier: ViewModifier {
    let blur: CGFloat
    
    func body(content: Content) -> some View {
        content
            .blur(radius: blur)
    }
}

// MARK: - Flip Transition Modifier

struct FlipTransitionModifier: ViewModifier {
    let angle: Double
    let axis: TransitionPreset.Axis
    
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(angle),
                axis: axis == .horizontal ? (0, 1, 0) : (1, 0, 0),
                perspective: 0.5
            )
    }
}

// MARK: - Rotate3D Transition Modifier

struct Rotate3DTransitionModifier: ViewModifier {
    let angle: Double
    let axis: (x: CGFloat, y: CGFloat, z: CGFloat)
    
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(angle),
                axis: axis,
                perspective: 0.5
            )
    }
}

// MARK: - Transition Manager

/// Gerencia transições entre views
struct TransitionManager {
    let preset: TransitionPreset
    let animation: AnimationPreset
    
    init(
        _ preset: TransitionPreset,
        animation: AnimationPreset = .springGentle
    ) {
        self.preset = preset
        self.animation = animation
    }
    
    /// Aplica transição com animação
    func apply<Content: View>(
        isVisible: Bool,
        @ViewBuilder content: () -> Content
    ) -> some View {
        Group {
            if isVisible {
                content()
                    .transition(preset.transition)
            }
        }
        .animation(animation.animation, value: isVisible)
    }
}

// MARK: - View Extensions

extension View {
    /// Aplica transição preset
    ///
    /// Uso:
    /// ```swift
    /// if isVisible {
    ///     Text("Hello")
    ///         .transition(.fadeScale)
    /// }
    /// ```
    func transition(_ preset: TransitionPreset) -> some View {
        self.transition(preset.transition)
    }
    
    /// Aplica transição com animação
    ///
    /// Uso:
    /// ```swift
    /// if isVisible {
    ///     Text("Hello")
    ///         .transitionWith(.fadeScale, animation: .springBouncy)
    /// }
    /// ```
    func transitionWith(
        _ preset: TransitionPreset,
        animation: AnimationPreset = .springGentle
    ) -> some View {
        self.transition(preset.transition)
    }
}

// MARK: - Conditional Transition

/// View que gerencia transição baseado em condição
struct ConditionalTransition<Content: View>: View {
    let isVisible: Bool
    let transition: TransitionPreset
    let animation: AnimationPreset
    let content: Content
    
    init(
        isVisible: Bool,
        transition: TransitionPreset = .fadeScale,
        animation: AnimationPreset = .springGentle,
        @ViewBuilder content: () -> Content
    ) {
        self.isVisible = isVisible
        self.transition = transition
        self.animation = animation
        self.content = content()
    }
    
    var body: some View {
        Group {
            if isVisible {
                content
                    .transition(transition.transition)
            }
        }
        .animation(animation.animation, value: isVisible)
    }
}

// MARK: - Page Transition

/// Transição de páginas (slides horizontalmente)
struct PageTransition<Content: View>: View {
    let currentPage: Int
    let direction: Direction
    let content: Content
    
    enum Direction {
        case forward
        case backward
    }
    
    init(
        currentPage: Int,
        direction: Direction = .forward,
        @ViewBuilder content: () -> Content
    ) {
        self.currentPage = currentPage
        self.direction = direction
        self.content = content()
    }
    
    var body: some View {
        content
            .transition(
                .asymmetric(
                    insertion: .move(edge: direction == .forward ? .trailing : .leading),
                    removal: .move(edge: direction == .forward ? .leading : .trailing)
                )
            )
            .id(currentPage)
    }
}

// MARK: - Modal Transition

/// Transição de modal (slide from bottom)
struct ModalTransition<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content
    
    init(
        isPresented: Binding<Bool>,
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = isPresented
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            if isPresented {
                // Backdrop
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(AnimationPreset.springGentle.animation) {
                            isPresented = false
                        }
                    }
                
                // Content
                VStack {
                    Spacer()
                    content
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .animation(AnimationPreset.springGentle.animation, value: isPresented)
    }
}

// MARK: - Card Stack Transition

/// Transição de cards empilhados
struct CardStackTransition: ViewModifier {
    let index: Int
    let total: Int
    let isExpanded: Bool
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isExpanded ? 1.0 : 1.0 - (CGFloat(index) * 0.05))
            .offset(y: isExpanded ? 0 : CGFloat(index) * -10)
            .opacity(isExpanded ? 1.0 : (index < 3 ? 1.0 : 0.0))
            .zIndex(Double(total - index))
    }
}

extension View {
    /// Aplica transição de card stack
    func cardStackTransition(
        index: Int,
        total: Int,
        isExpanded: Bool
    ) -> some View {
        modifier(CardStackTransition(
            index: index,
            total: total,
            isExpanded: isExpanded
        ))
    }
}

// MARK: - Preview

#if DEBUG
struct TransitionEffects_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: DesignSpacing.xl) {
                Text("Transition Effects")
                    .font(DesignTypography.title1)
                    .padding(.top)
                
                // Basic transitions
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Basic Transitions")
                        .font(DesignTypography.headline)
                    
                    TransitionDemoRow(preset: .fade, label: "Fade")
                    TransitionDemoRow(preset: .scale, label: "Scale")
                    TransitionDemoRow(preset: .slide(edge: .leading), label: "Slide")
                    TransitionDemoRow(preset: .move(edge: .leading), label: "Move")
                }
                .padding(.horizontal)
                
                Divider()
                
                // Combined transitions
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Combined Transitions")
                        .font(DesignTypography.headline)
                    
                    TransitionDemoRow(preset: .fadeScale, label: "Fade + Scale")
                    TransitionDemoRow(preset: .slideAndFade(), label: "Slide + Fade")
                    TransitionDemoRow(preset: .scaleAndSlide(), label: "Scale + Slide")
                }
                .padding(.horizontal)
                
                Divider()
                
                // Advanced transitions
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Advanced Transitions")
                        .font(DesignTypography.headline)
                    
                    TransitionDemoRow(preset: .blur, label: "Blur")
                    TransitionDemoRow(preset: .pivot(), label: "Pivot")
                    TransitionDemoRow(preset: .flip(), label: "Flip")
                    TransitionDemoRow(preset: .rotate3D(), label: "Rotate 3D")
                }
                .padding(.horizontal)
                
                Divider()
                
                // Modal demo
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Modal Transition")
                        .font(DesignTypography.headline)
                    
                    ModalTransitionDemo()
                }
                .padding(.horizontal)
                
                Divider()
                
                // Card stack demo
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Card Stack Transition")
                        .font(DesignTypography.headline)
                    
                    CardStackDemo()
                }
                .padding(.horizontal)
                
                Divider()
                
                // Page transition demo
                VStack(alignment: .leading, spacing: DesignSpacing.md) {
                    Text("Page Transition")
                        .font(DesignTypography.headline)
                    
                    PageTransitionDemo()
                }
                .padding(.horizontal)
                
                Spacer(minLength: 40)
            }
        }
        .frame(width: 500, height: 1400)
    }
}

// MARK: - Demo Components

struct TransitionDemoRow: View {
    let preset: TransitionPreset
    let label: String
    
    @State private var isVisible = true
    
    var body: some View {
        HStack(spacing: DesignSpacing.md) {
            Button(action: {
                isVisible.toggle()
            }) {
                Text(label)
                    .font(DesignTypography.body)
                    .frame(width: 150, alignment: .leading)
            }
            
            ZStack {
                if isVisible {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(DesignColor.Accent.primary)
                        .frame(width: 80, height: 80)
                        .transition(preset)
                }
            }
            .frame(width: 100, height: 100)
            .animation(AnimationPreset.springBouncy.animation, value: isVisible)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct ModalTransitionDemo: View {
    @State private var isPresented = false
    
    var body: some View {
        VStack {
            Button("Show Modal") {
                isPresented = true
            }
            
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 150)
                    .overlay(
                        Text("Tap button to show modal")
                            .font(DesignTypography.caption1)
                            .foregroundStyle(.secondary)
                    )
                
                ModalTransition(isPresented: $isPresented) {
                    VStack(spacing: DesignSpacing.md) {
                        Text("Modal Content")
                            .font(DesignTypography.title3)
                        
                        Text("Tap backdrop to dismiss")
                            .font(DesignTypography.caption1)
                            .foregroundStyle(.secondary)
                        
                        Button("Close") {
                            withAnimation(AnimationPreset.springGentle.animation) {
                                isPresented = false
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.background)
                    )
                    .padding()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct CardStackDemo: View {
    @State private var isExpanded = false
    
    let cards = ["Card 1", "Card 2", "Card 3", "Card 4"]
    
    var body: some View {
        VStack(spacing: DesignSpacing.sm) {
            Button("Toggle") {
                withAnimation(AnimationPreset.springBouncy.animation) {
                    isExpanded.toggle()
                }
            }
            
            ZStack {
                ForEach(cards.indices, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(DesignColor.Accent.primary.opacity(1.0 - Double(index) * 0.2))
                        .frame(height: 80)
                        .overlay(
                            Text(cards[index])
                                .font(DesignTypography.body)
                                .foregroundStyle(.white)
                        )
                        .cardStackTransition(
                            index: index,
                            total: cards.count,
                            isExpanded: isExpanded
                        )
                }
            }
            .frame(height: isExpanded ? 400 : 100)
        }
    }
}

struct PageTransitionDemo: View {
    @State private var currentPage = 0
    @State private var direction: PageTransition<AnyView>.Direction = .forward
    
    let pages = ["Page 1", "Page 2", "Page 3"]
    
    var body: some View {
        VStack(spacing: DesignSpacing.md) {
            HStack {
                Button("Previous") {
                    if currentPage > 0 {
                        direction = .backward
                        withAnimation(AnimationPreset.slideIn.animation) {
                            currentPage -= 1
                        }
                    }
                }
                .disabled(currentPage == 0)
                
                Spacer()
                
                Text("\(currentPage + 1) / \(pages.count)")
                    .font(DesignTypography.caption1)
                
                Spacer()
                
                Button("Next") {
                    if currentPage < pages.count - 1 {
                        direction = .forward
                        withAnimation(AnimationPreset.slideIn.animation) {
                            currentPage += 1
                        }
                    }
                }
                .disabled(currentPage == pages.count - 1)
            }
            
            PageTransition(currentPage: currentPage, direction: direction) {
                AnyView(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(DesignColor.Accent.primary)
                        .frame(height: 150)
                        .overlay(
                            Text(pages[currentPage])
                                .font(DesignTypography.title2)
                                .foregroundStyle(.white)
                        )
                )
            }
        }
    }
}
#endif
