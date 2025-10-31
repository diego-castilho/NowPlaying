//
//  ThemeManager.swift
//  NowPlaying
//
//  Design System - Theme Manager
//  Gerencia tema ativo e mudanças de tema
//
//  Created by Diego Castilho on 31/10/25
//  Copyright © 2025 Diego Castilho. All rights reserved.
//

import SwiftUI
import Combine

/// Gerenciador de temas do Design System
///
/// Uso:
/// ```swift
/// @EnvironmentObject var themeManager: ThemeManager
///
/// Text("Hello")
///     .foregroundStyle(themeManager.theme.colors.textPrimary)
/// ```
@MainActor
final class ThemeManager: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = ThemeManager()
    
    // MARK: - Published Properties
    
    /// Tema atual ativo
    @Published private(set) var theme: Theme
    
    /// Color scheme do sistema
    @Published var systemColorScheme: ColorScheme = .light
    
    /// Se deve seguir o sistema ou usar tema manual
    @Published var followSystemAppearance: Bool {
        didSet {
            updateTheme()
            savePreference()
        }
    }
    
    /// Tema manual escolhido (quando não segue sistema)
    @Published var manualTheme: ColorScheme {
        didSet {
            if !followSystemAppearance {
                updateTheme()
                savePreference()
            }
        }
    }
    
    // MARK: - Private Properties
    
    private let userDefaultsKey = "NowPlaying.ThemePreference"
    
    // MARK: - Initialization
    
    private init() {
        // CORREÇÃO: Inicializar TODAS as propriedades primeiro
        let savedFollowSystem = UserDefaults.standard.object(forKey: "NowPlaying.ThemePreference.followSystem") as? Bool ?? true
        let savedManualTheme = (UserDefaults.standard.string(forKey: "NowPlaying.ThemePreference.manual") == "dark") ? ColorScheme.dark : ColorScheme.light
        
        // Inicializar propriedades published
        self.followSystemAppearance = savedFollowSystem
        self.manualTheme = savedManualTheme
        
        // Agora podemos inicializar o tema
        if savedFollowSystem {
            self.theme = Theme.current(for: .light) // Será atualizado depois
        } else {
            self.theme = Theme.current(for: savedManualTheme)
        }
        
        print("🎨 ThemeManager: Inicializado com tema \(theme.name)")
    }
    
    // MARK: - Public Methods
    
    /// Atualiza o tema baseado nas preferências
    func updateTheme() {
        let newTheme = followSystemAppearance
        ? Theme.current(for: systemColorScheme)
        : Theme.current(for: manualTheme)
        
        if newTheme.name != theme.name {
            withAnimation(DesignAnimation.smooth) {
                theme = newTheme
            }
            print("🎨 ThemeManager: Tema alterado para \(theme.name)")
        }
    }
    
    /// Altera para tema específico (desativa follow system)
    func setTheme(_ colorScheme: ColorScheme) {
        followSystemAppearance = false
        manualTheme = colorScheme
    }
    
    /// Volta a seguir o sistema
    func followSystem() {
        followSystemAppearance = true
    }
    
    /// Toggle entre light e dark
    func toggleTheme() {
        if followSystemAppearance {
            followSystemAppearance = false
            manualTheme = systemColorScheme == .light ? .dark : .light
        } else {
            manualTheme = manualTheme == .light ? .dark : .light
        }
    }
    
    /// Atualiza baseado no system color scheme
    func updateSystemColorScheme(_ newScheme: ColorScheme) {
        if systemColorScheme != newScheme {
            systemColorScheme = newScheme
            if followSystemAppearance {
                updateTheme()
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func savePreference() {
        UserDefaults.standard.set(followSystemAppearance, forKey: userDefaultsKey + ".followSystem")
        UserDefaults.standard.set(manualTheme == .dark ? "dark" : "light", forKey: userDefaultsKey + ".manual")
        print("🎨 ThemeManager: Preferência salva")
    }
}

// MARK: - Environment Key

struct ThemeKey: EnvironmentKey {
    static let defaultValue: Theme = Theme.light
}

extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

// MARK: - View Extension

extension View {
    /// Injeta o tema no environment
    func withTheme(_ theme: Theme) -> some View {
        self.environment(\.theme, theme)
    }
    
    /// Injeta o ThemeManager no environment
    func withThemeManager(_ manager: ThemeManager = .shared) -> some View {
        self
            .environmentObject(manager)
            .environment(\.theme, manager.theme)
    }
}
