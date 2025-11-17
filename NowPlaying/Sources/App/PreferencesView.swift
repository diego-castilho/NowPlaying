//
//  PreferencesView.swift
//  NowPlaying
//
//  Preferences View - Liquid Glass Design
//
//  Created by Diego Castilho on 17/11/25
//  Copyright © 2025 Diego Castilho. All rights reserved.
//

import SwiftUI

/// View de preferências/configurações do aplicativo
struct PreferencesView: View {
    @ObservedObject private var launchManager = LaunchAtLoginManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Background
            Color.clear
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
            
            // Content
            VStack(spacing: 0) {
                // Header
                headerSection
                    .padding(.top, DesignSpacing.xl)
                    .padding(.horizontal, DesignSpacing.xl)
                
                Divider()
                    .padding(.vertical, DesignSpacing.lg)
                    .padding(.horizontal, DesignSpacing.xl)
                
                // Settings sections
                ScrollView {
                    VStack(spacing: DesignSpacing.lg) {
                        generalSettingsSection
                        
                        infoSection
                    }
                    .padding(.horizontal, DesignSpacing.xl)
                    .padding(.bottom, DesignSpacing.xl)
                }
                
                // Footer
                footerSection
                    .padding(.horizontal, DesignSpacing.xl)
                    .padding(.bottom, DesignSpacing.lg)
            }
        }
        .frame(width: 500, height: 400)
        .onAppear {
            launchManager.initialize()
        }
    }
    
    // MARK: - Header
    
    @ViewBuilder
    private var headerSection: some View {
        HStack(spacing: DesignSpacing.md) {
            Image(systemName: "gear")
                .font(.system(size: 32))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            DesignColor.Accent.primary,
                            DesignColor.Accent.secondary
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(alignment: .leading, spacing: DesignSpacing.xxs) {
                Text("Preferências")
                    .font(DesignTypography.title2)
                    .foregroundStyle(DesignColor.Text.primary)
                
                Text("Configure o NowPlaying")
                    .font(DesignTypography.body)
                    .foregroundStyle(DesignColor.Text.secondary)
            }
            
            Spacer()
        }
    }
    
    // MARK: - General Settings
    
    @ViewBuilder
    private var generalSettingsSection: some View {
        VStack(alignment: .leading, spacing: DesignSpacing.md) {
            // Section title
            Text("Configurações Gerais")
                .font(DesignTypography.headline)
                .foregroundStyle(DesignColor.Text.secondary)
            
            // Launch at login setting
            GlassCard(
                padding: DesignSpacing.lg,
                cornerRadius: DesignSpacing.CornerRadius.lg,
                shadow: .prominent,
                backgroundColor: DesignColor.Glass.surface1.opacity(0.4)
            ) {
                HStack(alignment: .top, spacing: DesignSpacing.md) {
                    // Icon
                    Image(systemName: "power.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(DesignColor.Accent.primary)
                    
                    // Info
                    VStack(alignment: .leading, spacing: DesignSpacing.xs) {
                        Text("Iniciar no login")
                            .font(DesignTypography.body)
                            .fontWeight(.semibold)
                            .foregroundStyle(DesignColor.Text.primary)
                        
                        Text("O aplicativo será iniciado automaticamente quando você fizer login no macOS")
                            .font(DesignTypography.caption1)
                            .foregroundStyle(DesignColor.Text.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer()
                    
                    // Toggle
                    Toggle("", isOn: $launchManager.isEnabled)
                        .toggleStyle(.switch)
                        .labelsHidden()
                }
            }
            .frostEffect(intensity: 0.6)
        }
    }
    
    // MARK: - Info Section
    
    @ViewBuilder
    private var infoSection: some View {
        GlassCard(
            padding: DesignSpacing.lg,
            cornerRadius: DesignSpacing.CornerRadius.lg,
            shadow: .prominent,
            backgroundColor: DesignColor.Glass.surface2.opacity(0.3)
        ) {
            VStack(alignment: .leading, spacing: DesignSpacing.md) {
                // Header
                HStack(spacing: DesignSpacing.xs) {
                    Image(systemName: "info.circle.fill")
                        .font(DesignTypography.body)
                        .foregroundStyle(DesignColor.Accent.primary)
                    
                    Text("Informações")
                        .font(DesignTypography.headline)
                        .foregroundStyle(DesignColor.Text.primary)
                }
                
                // Info items
                VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                    infoItem(
                        icon: "circle.fill",
                        text: "O aplicativo será executado em segundo plano na barra de menu",
                        color: DesignColor.Accent.primary
                    )
                    
                    infoItem(
                        icon: "circle.fill",
                        text: "Você pode fechá-lo a qualquer momento usando a opção 'Sair' no menu",
                        color: DesignColor.Accent.secondary
                    )
                    
                    infoItem(
                        icon: "circle.fill",
                        text: "Funciona automaticamente no macOS 13+ (Ventura e posteriores)",
                        color: DesignColor.Status.success
                    )
                    
                    Divider()
                        .padding(.vertical, DesignSpacing.xs)
                    
                    infoItem(
                        icon: "exclamationmark.triangle.fill",
                        text: "No macOS 12 e anteriores, configure manualmente nas Preferências do Sistema",
                        color: DesignColor.Status.warning,
                        italic: true
                    )
                }
            }
        }
        .frostEffect(intensity: 0.5)
    }
    
    @ViewBuilder
    private func infoItem(icon: String, text: String, color: Color, italic: Bool = false) -> some View {
        HStack(alignment: .top, spacing: DesignSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 6))
                .foregroundStyle(color)
                .padding(.top, 6)
            
            Text(text)
                .font(DesignTypography.caption1)
                .foregroundStyle(DesignColor.Text.secondary)
                .italic(italic)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    // MARK: - Footer
    
    @ViewBuilder
    private var footerSection: some View {
        HStack(spacing: DesignSpacing.sm) {
            // Version info
            VStack(alignment: .leading, spacing: DesignSpacing.xxs) {
                Text("NowPlaying v1.4")
                    .font(DesignTypography.caption1)
                    .foregroundStyle(DesignColor.Text.tertiary)
                
                Text("Fase 2 - Design System v0.9.12")
                    .font(DesignTypography.caption2)
                    .foregroundStyle(DesignColor.Text.tertiary)
            }
            
            Spacer()
            
            // Close button
            GlassButton(
                "Fechar",
                style: .secondary,
                size: .medium
            ) {
                dismiss()
            }
            .keyboardShortcut(.cancelAction)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Light mode
            PreferencesView()
                .preferredColorScheme(.light)
            
            // Dark mode
            PreferencesView()
                .preferredColorScheme(.dark)
        }
    }
}
#endif
