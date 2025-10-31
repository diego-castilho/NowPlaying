# Design System - Guidelines

Guia de uso do Design System do NowPlaying

---

## 🎨 Visão Geral

O Design System do NowPlaying é baseado em **Liquid Glass** (Glassmorphism), um estilo moderno que combina transparência, blur e profundidade para criar interfaces elegantes e funcionais.

---

## 📦 Estrutura
```
DesignSystem/
├── Tokens/          # Tokens de design (cores, tipografia, etc)
├── Theme/           # Sistema de temas
└── Guidelines/      # Este arquivo
```

---

## 🎨 Colors

### Uso Básico
```swift
import SwiftUI

// Usando cores diretamente
Text("Hello")
    .foregroundStyle(DesignColor.Text.primary)
    .background(DesignColor.Glass.surface1)

// Usando cores do tema
@Environment(\.theme) var theme

Text("Hello")
    .foregroundStyle(theme.colors.textPrimary)
```

### Paleta Principal

**Glass Surfaces** - Para efeitos de glassmorphism
- `Glass.light` - Fundo glass claro
- `Glass.dark` - Fundo glass escuro
- `Glass.surface1/2/3` - Superfícies graduais
- `Glass.border` - Bordas sutis

**Accent Colors** - Cores de destaque
- `Accent.primary` - Azul principal
- `Accent.secondary` - Roxo elegante
- `Accent.music` - Laranja Last.fm

**Status Colors** - Estados
- `Status.success` - Verde (sucesso)
- `Status.error` - Vermelho (erro)
- `Status.warning` - Laranja (aviso)

---

## ✍️ Typography

### Escala Tipográfica
```swift
// Títulos
Text("Hero").font(DesignTypography.display)
Text("Title").font(DesignTypography.title1)
Text("Subtitle").font(DesignTypography.title2)

// Corpo
Text("Body text").font(DesignTypography.body)
Text("Small").font(DesignTypography.caption1)

// NowPlaying específico
Text("Bohemian Rhapsody").font(DesignTypography.NowPlaying.trackName)
Text("Queen").font(DesignTypography.NowPlaying.artistName)
```

### Hierarquia Recomendada

1. **Display** - Títulos hero (raro)
2. **Title 1** - Títulos principais de tela
3. **Title 2** - Subtítulos importantes
4. **Headline** - Cabeçalhos de seção
5. **Body** - Texto padrão (80% do conteúdo)
6. **Caption** - Metadados, timestamps

---

## 📏 Spacing

### Escala Base
```swift
// Espaçamento
VStack(spacing: DesignSpacing.md) {
    Text("Item 1")
    Text("Item 2")
}

// Padding
Text("Hello")
    .padding(DesignSpacing.lg)

// Semantic
RoundedRectangle(cornerRadius: DesignSpacing.CornerRadius.card)
    .padding(DesignSpacing.Semantic.cardPadding)
```

### Quando Usar Cada Tamanho

- **xs/sm** - Padding interno de badges, botões pequenos
- **md** - Espaçamento padrão entre elementos
- **lg** - Padding de cards, espaçamento entre seções
- **xl/xxl** - Margens de janela, separadores principais

---

## 🌑 Shadows

### Aplicar Sombras
```swift
// Sombra simples
RoundedRectangle(cornerRadius: 12)
    .fill(Color.white)
    .shadow(DesignShadow.md)

// Sombra semântica
RoundedRectangle(cornerRadius: 12)
    .fill(Color.white)
    .cardShadow()

// Sombra dupla (realista)
RoundedRectangle(cornerRadius: 12)
    .fill(Color.white)
    .layeredShadow(
        primary: DesignShadow.lg,
        secondary: DesignShadow.xs
    )
```

### Hierarquia de Elevação

- **none/xs** - Elementos flat
- **sm** - Botões, badges
- **md** - Cards padrão
- **lg** - Glass elements, hover states
- **xl/xxl** - Modals, popovers, menus

---

## ⚡ Animations

### Uso Básico
```swift
// Animação simples
withAnimation(DesignAnimation.smooth) {
    isExpanded.toggle()
}

// Animação com delay
withAnimation(DesignAnimation.smooth.delay(0.1)) {
    showDetail = true
}

// Transition
Text("Hello")
    .transition(DesignAnimation.Transition.card)
```

### Escolhendo a Animação Certa

**Smooth** - Uso geral (80% dos casos)
```swift
withAnimation(DesignAnimation.smooth) { }
```

**Snappy** - Interações rápidas (botões, menus)
```swift
withAnimation(DesignAnimation.snappy) { }
```

**Bouncy** - Feedback positivo (scrobble success)
```swift
withAnimation(DesignAnimation.bouncy) { }
```

**Gentle** - Mudanças sutis (glass effects)
```swift
withAnimation(DesignAnimation.gentle) { }
```

---

## 🪟 Glass Effects

### Card Glass Básico
```swift
RoundedRectangle(cornerRadius: DesignSpacing.CornerRadius.glass)
    .fill(DesignColor.Glass.surface1)
    .overlay(
        RoundedRectangle(cornerRadius: DesignSpacing.CornerRadius.glass)
            .stroke(DesignColor.Glass.border, lineWidth: 1)
    )
    .glassShadow()
    .padding(DesignSpacing.lg)
```

### Background Blur
```swift
ZStack {
    // Conteúdo de fundo
    Image("background")
        .resizable()
    
    // Glass overlay
    Rectangle()
        .fill(.ultraThinMaterial) // SwiftUI native blur
        .overlay(
            // Seu conteúdo aqui
        )
}
```

---

## 🎭 Theme System

### Uso com EnvironmentObject
```swift
@EnvironmentObject var themeManager: ThemeManager

var body: some View {
    VStack {
        Text("Current theme: \(themeManager.theme.name)")
        
        Button("Toggle Theme") {
            themeManager.toggleTheme()
        }
    }
}
```

### Injetar Theme
```swift
// No App
@main
struct NowPlayingApp: App {
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .withThemeManager(themeManager)
        }
    }
}
```

---

## ✅ Best Practices

### DO ✅

- Use tokens semânticos quando possível (`Semantic.cardPadding`)
- Anime mudanças de estado
- Use glassmorphism para cards principais
- Mantenha hierarquia visual clara
- Teste em light e dark mode

### DON'T ❌

- Não hardcode valores de cores/espaçamento
- Não use animações longas (>0.5s) para interações
- Não abuse de glassmorphism (causa performance issues)
- Não misture estilos (seja consistente)
- Não ignore acessibilidade

---

## 🎨 Exemplos Completos

### Glass Card
```swift
VStack(alignment: .leading, spacing: DesignSpacing.md) {
    Text("Now Playing")
        .font(DesignTypography.headline)
        .foregroundStyle(DesignColor.Text.secondary)
    
    Text("Bohemian Rhapsody")
        .font(DesignTypography.NowPlaying.trackName)
        .foregroundStyle(DesignColor.Text.primary)
    
    Text("Queen")
        .font(DesignTypography.NowPlaying.artistName)
        .foregroundStyle(DesignColor.Text.secondary)
}
.padding(DesignSpacing.Semantic.cardPadding)
.background(DesignColor.Glass.surface1)
.clipShape(RoundedRectangle(cornerRadius: DesignSpacing.CornerRadius.glass))
.overlay(
    RoundedRectangle(cornerRadius: DesignSpacing.CornerRadius.glass)
        .stroke(DesignColor.Glass.border, lineWidth: 1)
)
.shadow(DesignShadow.Semantic.glass)
```

### Button com Hover
```swift
struct GlassButton: View {
    let title: String
    let action: () -> Void
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(DesignTypography.NowPlaying.button)
                .foregroundStyle(DesignColor.Text.onAccent)
                .padding(.horizontal, DesignSpacing.lg)
                .padding(.vertical, DesignSpacing.sm)
                .background(DesignColor.Accent.primary)
                .clipShape(RoundedRectangle(cornerRadius: DesignSpacing.CornerRadius.button))
                .shadow(isHovered ? DesignShadow.Semantic.buttonHover : DesignShadow.Semantic.button)
                .scaleEffect(isHovered ? 1.05 : 1.0)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(DesignAnimation.Semantic.buttonHover) {
                isHovered = hovering
            }
        }
    }
}
```

---

## 📚 Recursos

- [Glassmorphism Guide](https://uxdesign.cc/glassmorphism-in-user-interfaces-1f39bb1308c9)
- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
                                                                                       
---
                                                                                       
**Última Atualização**: v0.9.6
**Autor**: Diego Castilho
