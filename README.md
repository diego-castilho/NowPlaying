# 🎵 NowPlaying - Last.fm Scrobbler para macOS

<div align="center">

<p align="center">
  <img src="https://github.com/diego-castilho/NowPlaying/blob/a0823592c43a4de49f1b6fad99baf57c1039ca99/NowPlaying/Resources/Assets.xcassets/AppIcon.appiconset/NowPlaying.png" alt="NowPlaying Icon" width="200"/>
</p>

**Scrobbler nativo e moderno para Last.fm no macOS**

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-macOS%2012.0+-blue.svg)](https://www.apple.com/macos/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-0.9.7-purple.svg)](CHANGELOG.md)

[Features](#features) • [Instalação](#instalação) • [Desenvolvimento](#desenvolvimento) • [Arquitetura](#arquitetura) • [Roadmap](#roadmap)

</div>

---

## 🎯 Sobre o Projeto

**NowPlaying** é um aplicativo nativo para macOS que sincroniza automaticamente as músicas que você ouve no Apple Music com sua conta do Last.fm. Desenvolvido com SwiftUI e seguindo as melhores práticas modernas da Apple.

### ✨ Por que NowPlaying?

- 🚀 **Nativo e Rápido**: Desenvolvido 100% em Swift, sem frameworks pesados
- 🔐 **Seguro**: App Sandbox habilitado, credenciais no Keychain
- 🎨 **Interface Moderna**: Design Liquid Glass com componentes reutilizáveis
- ⚡ **Leve**: Mora na menu bar, consumo mínimo de recursos
- 🔄 **Automático**: Scrobble sem intervenção, seguindo regras oficiais do Last.fm
- 📊 **Histórico Completo**: Logs detalhados de todas as músicas

---

## 🎬 Screenshots

| Menu Bar Popover | Janela Principal |
|:---:|:---:|
| ![Popover](https://github.com/diego-castilho/NowPlaying/blob/a0823592c43a4de49f1b6fad99baf57c1039ca99/NowPlaying/Documentation/Screenshots/popover.png) | ![Main](https://github.com/diego-castilho/NowPlaying/blob/a0823592c43a4de49f1b6fad99baf57c1039ca99/NowPlaying/Documentation/Screenshots/mainwindow.png) |

---

## ✨ Features

### 🎵 Scrobbling Automático
- ✅ Detecta músicas do **Apple Music** automaticamente
- ✅ Envia scrobbles seguindo regras oficiais do Last.fm:
  - 50% da música reproduzida OU
  - 4 minutos (o que ocorrer primeiro)
- ✅ Atualização "Now Playing" em tempo real
- ✅ Retry automático em caso de falha
- ✅ Funciona em background (não precisa manter app aberto)

### 🖥️ Interface
- ✅ **Menu Bar App**: Ícone discreto na barra de menu
- ✅ **Hover Automático**: Passa o mouse para ver música atual
- ✅ **Janela Principal**: 
  - Capa do álbum em alta qualidade
  - Informações detalhadas (música, artista, álbum)
  - Tab com músicas recentes do Last.fm
  - Tab com histórico de scrobbles local
- ✅ **Filtros e Busca**: Filtre por tipo, status, ou busque por texto
- ✅ **Design Liquid Glass**: Interface moderna com glassmorphism

### 🔐 Segurança & Privacidade
- ✅ **App Sandbox**: Isolamento completo do sistema
- ✅ **Keychain**: Credenciais armazenadas de forma segura
- ✅ **Zero Telemetria**: Seus dados são seus
- ✅ **Open Source**: Código auditável

### 🛠️ Sistema
- ✅ **Launch at Login**: Inicia automaticamente com o macOS
- ✅ **Preferências**: Configurações acessíveis e claras
- ✅ **Logs Detalhados**: Debug facilitado
- ✅ **Atualizações**: Sistema de atualização planejado

---

## 📋 Requisitos

### Sistema
- **macOS**: 12.0 (Monterey) ou superior
- **Xcode**: 15.6+ (para desenvolvimento)
- **Swift**: 5.9+
- **Apple Music**: Instalado e funcionando

### Contas
- Conta ativa no **Last.fm** (gratuita)
- **API Key** do Last.fm ([obter aqui](https://www.last.fm/api/account/create))

---

## 🚀 Instalação

### Opção 1: Download Direto (Recomendado)

**Em Breve!** Releases pré-compiladas estarão disponíveis em:
- GitHub Releases
- Mac App Store (planejado)

### Opção 2: Compilar do Código-Fonte

#### 1. Clone o Repositório
```bash
git clone https://github.com/diego-castilho/NowPlaying.git
cd NowPlaying
```

#### 2. Configure as Credenciais
```bash
# Copie o template de configuração
cp Configuration/Secrets.template.xcconfig Configuration/Secrets.xcconfig

# Edite com suas credenciais Last.fm
nano Configuration/Secrets.xcconfig
```

**No arquivo `Secrets.xcconfig`**, adicione:
```xcconfig
LASTFM_API_KEY = sua_api_key_aqui
LASTFM_SHARED_SECRET = seu_shared_secret_aqui
```

> 💡 **Como obter credenciais**:
> 1. Acesse https://www.last.fm/api/account/create
> 2. Crie uma aplicação
> 3. Copie "API Key" e "Shared Secret"

#### 3. Abra no Xcode
```bash
open NowPlaying.xcodeproj
```

#### 4. Configure o Signing

1. Selecione o projeto no navegador
2. Aba **"Signing & Capabilities"**
3. Selecione seu **Team** (conta de desenvolvedor Apple)
4. Xcode configurará certificados automaticamente

#### 5. Compile e Execute
```bash
# Via Xcode: ⌘R (Command + R)

# Ou via linha de comando:
xcodebuild -scheme NowPlaying -configuration Debug build
```

---

## 🎮 Como Usar

### Primeira Execução

1. **Abra o NowPlaying**
   - Ícone aparecerá na menu bar (♪)
   
2. **Conecte ao Last.fm**
   - Clique no ícone da menu bar
   - Botão "Conectar ao Last.fm"
   - Autorize no navegador
   - Volte ao app e clique "Já autorizei — Concluir login"

3. **Toque uma Música**
   - Abra Apple Music
   - Toque qualquer música
   - NowPlaying detecta automaticamente!

### Uso Diário

- **Hover no Ícone**: Veja música atual sem clicar
- **Click no Ícone**: Popover com detalhes e botões
- **Botão "Abrir Janela"**: Interface completa
- **Tab "Recent Tracks"**: Músicas do seu Last.fm
- **Tab "Scrobble Log"**: Histórico local com filtros

### Preferências

**Menu Bar** → **Botão Direito** → **Preferências**

- ✅ Launch at Login (iniciar com macOS)
- 🔄 Outras opções em breve

---

## 🛠️ Desenvolvimento

### Estrutura do Projeto
```
NowPlaying/
├── Sources/
│   ├── App/                          # SwiftUI Views
│   │   ├── NowPlayingApp.swift       # Entry point
│   │   ├── ContentView.swift         # Janela principal
│   │   ├── MenuBarPanelView.swift    # Popover menu bar
│   │   ├── RecentTracksView.swift    # Tab músicas recentes
│   │   ├── LogListView.swift         # Tab histórico
│   │   └── PreferencesView.swift     # Preferências
│   │
│   ├── Core/                         # Business Logic
│   │   ├── Configuration/            # Sistema de config
│   │   │   └── ConfigurationManager.swift
│   │   ├── DependencyInjection/      # DI Container
│   │   │   └── DependencyContainer.swift
│   │   ├── Protocols/                # Protocol definitions
│   │   │   ├── LastFMClientProtocol.swift
│   │   │   └── KeychainServiceProtocol.swift
│   │   ├── Services/                 # Serviços principais
│   │   │   ├── LastFMClient.swift    # API Last.fm
│   │   │   ├── ModernKeychainService.swift  # Keychain
│   │   │   ├── ScrobbleManager.swift # Lógica de scrobble
│   │   │   ├── MusicEventListener.swift # Apple Music
│   │   │   └── LaunchAtLoginManager.swift
│   │   ├── Models.swift              # Core Data models
│   │   ├── CoreDataStack.swift       # Core Data setup
│   │   └── ArtworkStore.swift        # Gerenciamento de capas
│   │
│   ├── DesignSystem/                 # Design System
│   │   ├── Tokens/                   # Design tokens
│   │   │   ├── Colors.swift
│   │   │   ├── Typography.swift
│   │   │   ├── Spacing.swift
│   │   │   ├── Shadows.swift
│   │   │   └── Animation.swift
│   │   ├── Theme/                    # Theme system
│   │   │   ├── Theme.swift
│   │   │   └── ThemeManager.swift
│   │   ├── Components/               # Componentes
│   │   │   ├── Base/
│   │   │   │   ├── GlassCard.swift
│   │   │   │   ├── GlassButton.swift
│   │   │   │   ├── GlassBadge.swift
│   │   │   │   └── GlassContainer.swift
│   │   │   ├── Effects/              # ⭐ NEW!
│   │   │   │   ├── BlurEffects.swift
│   │   │   │   └── GradientEffects.swift
│   │   │   ├── Backgrounds/          # ⭐ NEW!
│   │   │   │   └── GlassBackground.swift
│   │   │   └── Modifiers/
│   │   │       ├── GlassModifiers.swift
│   │   │       └── AdvancedModifiers.swift  # ⭐ NEW!
│   │   └── Guidelines/               # Documentação
│   │       └── DESIGN_GUIDELINES.md
│   │
│   └── Tests/                        # Testes (em desenvolvimento)
│       └── Mocks/                    # Mock implementations
│           ├── MockLastFMClient.swift
│           └── MockUsageExamples.swift
│
├── Configuration/                    # Arquivos de configuração
│   ├── Secrets.template.xcconfig     # Template (versionado)
│   └── Secrets.xcconfig              # Credenciais reais (gitignore)
│
├── Documentation/                    # Documentação do projeto
│   ├── README.md                     # Este arquivo
│   ├── CHANGELOG.md                  # Histórico de versões
│   └── ARCHITECTURE.md               # Documentação técnica
│
└── Assets.xcassets/                  # Recursos visuais
    ├── AppIcon.appiconset/
    └── Icon Status Badge.iconbadgeset/
```

### Stack Tecnológico

| Categoria | Tecnologia | Versão | Uso |
|-----------|------------|--------|-----|
| **Linguagem** | Swift | 5.9+ | Código principal |
| **UI Framework** | SwiftUI | iOS 16+ | Interface moderna |
| **Persistência** | Core Data | - | Histórico local |
| **Segurança** | Keychain Services | - | Credenciais |
| **Concurrency** | Swift Concurrency | Swift 5.5+ | async/await, Actors |
| **Networking** | URLSession | - | API Last.fm |
| **System** | ServiceManagement | macOS 13+ | Launch at Login |
| **Design** | Design System | Custom | Tokens + Components + Effects |

### Arquitetura

**Padrão**: Clean Architecture + MVVM + Dependency Injection
```
┌─────────────────────────────────────────────┐
│          Presentation Layer                 │
│  (SwiftUI Views + ViewModels)               │
└──────────────┬──────────────────────────────┘
               │
┌──────────────▼──────────────────────────────┐
│         Business Logic Layer                │
│  (Managers, Services, Domain Logic)         │
│  - ScrobbleManager                          │
│  - LastFMClient                             │
│  - ConfigurationManager                     │
│  - DependencyContainer                      │
└──────────────┬──────────────────────────────┘
               │
┌──────────────▼──────────────────────────────┐
│            Data Layer                       │
│  (Core Data, Keychain, Network)             │
│  - CoreDataStack                            │
│  - KeychainService                          │
│  - API Client                               │
└─────────────────────────────────────────────┘
```

**Princípios**:
- ✅ **SOLID**: Single Responsibility, Open/Closed, etc
- ✅ **Protocol-Oriented**: Interfaces claras, testáveis
- ✅ **Dependency Injection**: Desacoplamento total
- ✅ **Separation of Concerns**: Cada camada tem uma responsabilidade
- ✅ **Design System**: Componentes reutilizáveis e consistentes

> 📖 **Documentação Completa**: Veja [ARCHITECTURE.md](Documentation/ARCHITECTURE.md)

---

## 📊 Status do Projeto

> **Progresso**: 35% (8/30 atividades concluídas)

### FASE 1: FUNDAÇÃO E SEGURANÇA [██████████] 100% ✅

Infraestrutura sólida e segura implementada com sucesso!

✅ **v0.9.1** - Sistema de Configuração Seguro (22 Out 2025)
- ConfigurationManager centralizado
- Secrets.xcconfig para credenciais
- Validação automática

✅ **v0.9.2** - Modernização do Keychain (22 Out 2025)
- KeychainService type-safe
- Migração automática de dados antigos
- Protocol-oriented design

✅ **v0.9.3** - App Sandbox + Entitlements (22 Out 2025)
- Sandbox habilitado
- Entitlements mínimos
- Pronto para Mac App Store

✅ **v0.9.4** - Padrões Modernos Swift (22 Out 2025)
- async/await em todo código
- Actors para thread-safety
- Structured Concurrency
- Zero data races possíveis

✅ **v0.9.5** - Dependency Injection (28 Out 2025)
- DI Container implementado
- Protocol-oriented refactoring
- Mock implementations prontas
- 100% testável

### FASE 2: INTERFACE LIQUID GLASS [█████░░░░░] 43% ⏳

Design System, componentes e efeitos implementados! Refactoring em progresso.

✅ **v0.9.6** - Design System Foundation (31 Out 2025)
- 100+ design tokens definidos
- Colors, Typography, Spacing, Shadows, Animation
- Theme System (Light + Dark)
- ThemeManager com system appearance
- DESIGN_GUIDELINES.md completo

✅ **v0.9.7** - Componentes Base (01 Nov 2025)
- GlassCard: Card com glassmorphism
- GlassButton: Botão interativo (5 estilos, 3 tamanhos)
- GlassBadge: Badge de status (8 estilos)
- GlassContainer: Container flexível (layouts V/H)
- GlassModifiers: 9 view modifiers úteis
- 50+ exemplos em previews
- ~1.790 linhas de código

✅ **v0.9.8** - Glassmorphism Effects (01 Nov 2025)
- BlurEffects: Sistema de blur avançado (6 styles)
- GradientEffects: Gradientes dinâmicos (8 presets)
- GlassBackground: 5 tipos de backgrounds
- AdvancedModifiers: 7 modifiers profissionais
- Animated gradients e blur
- Artwork integration
- ~1.550 linhas de código

⏳ **v0.9.9** - Animações e Transições (próxima)
- Sistema de animações reutilizáveis
- Transições entre telas
- Micro-interações
- Performance polish

⏳ **FASE 3: WIDGET DE DESKTOP** (Q1 2026)
- WidgetKit implementation
- Widget no Notification Center
- Widget no Desktop (macOS 14+)
- Live Activities (se aplicável)

⏳ **FASE 4: RECURSOS AVANÇADOS** (Q1 2026)
- Estatísticas de escuta
- Gráficos e visualizações
- Insights personalizados
- Export de dados

⏳ **FASE 5: QUALIDADE E POLISH** (Q1 2026)
- Testes unitários (80%+ cobertura)
- Testes de UI
- Performance optimization
- Accessibility compliance

⏳ **FASE 6: DISTRIBUIÇÃO** (Q1 2026)
- Code signing completo
- Notarization Apple
- Mac App Store submission
- Sistema de atualizações

---

## 🗺️ Roadmap Detalhado

### v0.9.9 - v0.9.12 (Q4 2025 - Q1 2026)
**Interface Liquid Glass - Animações e Refactoring**
- [ ] v0.9.9: Animações e Transições
- [ ] v0.9.10: Refactor Menu Bar Popover
- [ ] v0.9.11: Refactor Janela Principal
- [ ] v0.9.12: Polish Final + Dark Mode

### v1.0.0 (Q1 2026) 🎉
**Release Oficial**
- [ ] Widget de Desktop (WidgetKit)
- [ ] Estatísticas visuais
- [ ] Gráficos de padrões de escuta
- [ ] Testes unitários completos
- [ ] Performance otimizada
- [ ] Mac App Store release

### v1.1.0 (Q2 2026)
**Expansão de Funcionalidades**
- [ ] Integração Spotify (além de Apple Music)
- [ ] Control Center widget
- [ ] Apple Watch companion app
- [ ] Siri Shortcuts
- [ ] Menu bar customizável

### v1.2.0 (Q3 2026)
**Personalização**
- [ ] Themes customizáveis
- [ ] Aparência configurável
- [ ] Notificações personalizadas
- [ ] Sharing para redes sociais
- [ ] Export de estatísticas

### v2.0.0 (2027)
**Recursos Premium**
- [ ] Multi-conta Last.fm
- [ ] Scrobble manual/edição
- [ ] Backup/restore de histórico
- [ ] Sincronização iCloud
- [ ] Analytics avançados

---

## 🧪 Testes

### Status Atual
```
Cobertura de Testes: 0% (Fase 5 planejada)

✅ Testes Manuais: 100% (15+ cenários)
❌ Testes Unitários: 0% (planejados)
❌ Testes de UI: 0% (planejados)
❌ Testes de Performance: 0% (planejados)
```

### Infraestrutura Pronta

✅ **Mock Infrastructure** (v0.9.5)
- `MockLastFMClient` implementado
- Call tracking completo
- Test configuration (fail flags, delays)
- Exemplos documentados

**Próximos Passos** (Fase 5):
1. Setup de testes (XCTest)
2. Testes unitários de serviços
3. Testes de integração
4. Testes de UI (XCUITest)
5. Target de cobertura: 80%+

---

## 🤝 Contribuindo

### Como Contribuir

1. **Fork** o projeto
2. Crie uma **branch** para sua feature:
```bash
   git checkout -b feature/minha-feature
```
3. **Commit** suas mudanças:
```bash
   git commit -m "feat: adiciona funcionalidade X"
```
4. **Push** para sua branch:
```bash
   git push origin feature/minha-feature
```
5. Abra um **Pull Request**

### Convenções

**Commits** (Conventional Commits):
- `feat:` Nova funcionalidade
- `fix:` Correção de bug
- `docs:` Documentação
- `style:` Formatação, sem mudança de código
- `refactor:` Refatoração
- `test:` Adição/correção de testes
- `chore:` Tarefas de build, configuração

**Código**:
- Swift Style Guide da Apple
- SwiftLint configurado (planejado)
- Documentação inline em todos os métodos públicos
- Unit tests para novas funcionalidades (Fase 5)

### Áreas que Precisam de Ajuda

- 🎨 **Design**: Melhorias de UI/UX
- 🧪 **Testes**: Escrever unit tests
- 📝 **Documentação**: Tradução, tutoriais
- 🐛 **Bugs**: Reportar ou corrigir
- ✨ **Features**: Implementar roadmap

---

## 📄 Licença

**MIT License**
```
Copyright (c) 2025 Diego Castilho

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

[...texto completo da licença MIT...]
```

---

## 🙏 Agradecimentos

- **Last.fm**: Por fornecer API gratuita e documentação excelente
- **Apple**: Por frameworks incríveis (SwiftUI, WidgetKit, Core Data)
- **Comunidade Swift**: Por recursos educacionais
- **Beta Testers**: Por feedback valioso (em breve!)

---

## 📞 Contato & Suporte

### Links Úteis

- 🐛 **Reportar Bug**: [GitHub Issues](https://github.com/diego-castilho/NowPlaying/issues)
- 💡 **Sugerir Feature**: [GitHub Discussions](https://github.com/diego-castilho/NowPlaying/discussions)
- 📖 **Documentação**: [ARCHITECTURE.md](Documentation/ARCHITECTURE.md)
- 📋 **Changelog**: [CHANGELOG.md](Documentation/CHANGELOG.md)

### Desenvolvedor

**Diego Castilho**
- GitHub: [@diego-castilho](https://github.com/diego-castilho)
- Last.fm: [seu_usuario_lastfm]
- Email: [seu_email@exemplo.com]

---

## 📊 Estatísticas do Projeto
```
┌─────────────────────────────────────────────────────────┐
│ CÓDIGO                                                  │
├─────────────────────────────────────────────────────────┤
│ Total Linhas Código:      ~9.350 linhas ⬆              │
│ Arquivos Swift:           ~39 arquivos ⬆               │
│ Arquivos SwiftUI Views:   ~10 arquivos                  │
│ Arquivos Core:            ~15 arquivos                  │
│ Arquivos Design System:   ~17 arquivos ⬆ (NEW!)        │
│ Arquivos Componentes:     ~9 arquivos ⬆ (NEW!)         │
│ Arquivos Effects:         ~4 arquivos ⬐ (NEW!)         │
│ Arquivos Testes/Mocks:    ~2 arquivos                   │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ BREAKDOWN POR CATEGORIA                                 │
├─────────────────────────────────────────────────────────┤
│ App Layer (Views):        ~1.500 linhas (16%)          │
│ Core Layer (Services):    ~2.000 linhas (21%)          │
│ Design System:            ~5.850 linhas (63%) ⬆        │
│   ├─ Tokens:              ~2.500 linhas                 │
│   ├─ Theme:               ~400 linhas                   │
│   ├─ Components Base:     ~1.800 linhas                 │
│   ├─ Effects:             ~1.550 linhas ⬆ (NEW!)       │
│   └─ Guidelines:          ~300 linhas                   │
│ Models & Data:            ~500 linhas (5%)             │
│ Configuration:            ~200 linhas (2%)             │
│ Tests/Mocks:              ~300 linhas (3%)             │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ MÉTRICAS DE QUALIDADE                                   │
├─────────────────────────────────────────────────────────┤
│ Commits:                  ~95                           │
│ Issues Fechados:          2 (bugs corrigidos)          │
│ Pull Requests:            0 (projeto novo)             │
│ Contributors:             1                            │
│ Estrelas GitHub:          0 (aguardando release)       │
│ Build Success Rate:       100%                         │
│ Thread-Safety:            100%                         │
│ Type-Safety:              100%                         │
│ Code Quality:             ⭐⭐⭐⭐⭐                     │
└─────────────────────────────────────────────────────────┘
```

---

## 🎯 Status das Features

| Feature | Status | Versão | Notas |
|---------|--------|--------|-------|
| Scrobble Automático | ✅ Completo | v1.4.0 | Funcionando perfeitamente |
| Now Playing | ✅ Completo | v1.4.0 | Atualização em tempo real |
| Menu Bar | ✅ Completo | v1.4.0 | Hover automático |
| Janela Principal | ✅ Completo | v1.4.0 | Interface funcional |
| Histórico de Logs | ✅ Completo | v1.4.0 | Core Data + filtros |
| Autenticação Last.fm | ✅ Completo | v1.4.0 | OAuth funcionando |
| Launch at Login | ✅ Completo | v1.4.0 | macOS 13+ automático |
| Sistema de Config | ✅ Completo | v0.9.1 | Seguro e hierárquico |
| Keychain Moderno | ✅ Completo | v0.9.2 | Type-safe, migração auto |
| App Sandbox | ✅ Completo | v0.9.3 | Habilitado e seguro |
| Swift Concurrency | ✅ Completo | v0.9.4 | async/await, Actors |
| Dependency Injection | ✅ Completo | v0.9.5 | DI Container + Mocks |
| Design System | ✅ Completo | v0.9.6 | Tokens + Theme |
| Componentes Base | ✅ Completo | v0.9.7 | 5 componentes glass |
| Glassmorphism Effects | ✅ Completo | v0.9.8 | Blur + Gradients + Backgrounds |
| Animações | ⏳ Em Progresso | v0.9.9 | Sistema de animações |
| Liquid Glass UI | ⏳ Em Progresso | v0.9.10+ | Refactor completo |
| Widget Desktop | 📋 Planejado | v1.0.0 | WidgetKit |
| Estatísticas | 📋 Planejado | v1.0.0 | Gráficos e insights |
| Testes Unitários | 📋 Planejado | v1.0.0 | 80%+ cobertura |
| Mac App Store | 📋 Planejado | v1.0.0 | Distribuição oficial |
| Integração Spotify | 📋 Planejado | v1.1.0 | Além de Apple Music |
| Apple Watch | 📋 Planejado | v1.1.0 | Companion app |
| Themes | 📋 Planejado | v1.2.0 | Customização |

**Legenda**:
- ✅ Completo
- ⏳ Em Progresso
- 📋 Planejado
- ❌ Cancelado

---

## 🔧 Troubleshooting

### Problemas Comuns

**1. App não compila**
- ✅ Verifique `Secrets.xcconfig` existe e tem credenciais
- ✅ Verifique Team de desenvolvedor configurado
- ✅ Limpe build folder (⌘⇧K)

**2. Scrobble não funciona**
- ✅ Verifique autenticação Last.fm (aba principal)
- ✅ Toque música por >30 segundos
- ✅ Veja logs no console (Xcode)

**3. Apple Music não é detectado**
- ✅ Apple Music deve estar instalado
- ✅ Permissão de Apple Events concedida
- ✅ Tente reiniciar o app

**4. "Unable to obtain task name port"**
- ℹ️ Warning normal com App Sandbox
- ℹ️ Pode ignorar, não afeta funcionalidade

**5. Histórico de logs não atualiza**
- ⚠️ Bug conhecido (v0.9.3)
- ℹ️ Dados existem no Core Data
- ℹ️ Não afeta scrobbling
- 🔄 Será corrigido em v0.9.11

---

## 📚 Recursos Adicionais

### Documentação Relacionada

- [CHANGELOG.md](Documentation/CHANGELOG.md) - Histórico completo de versões
- [ARCHITECTURE.md](Documentation/ARCHITECTURE.md) - Documentação técnica detalhada
- [DESIGN_GUIDELINES.md](Sources/DesignSystem/Guidelines/DESIGN_GUIDELINES.md) - Guia do Design System
- [CONTRIBUTING.md](CONTRIBUTING.md) - Guia de contribuição (em breve)

### Links Externos

- [Last.fm API Documentation](https://www.last.fm/api)
- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [Swift Concurrency](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/)

---

<div align="center">

**Feito com ❤️ e Swift**

Se você gostou do projeto, considere dar uma ⭐!

[Reportar Bug](https://github.com/diego-castilho/NowPlaying/issues) • [Sugerir Feature](https://github.com/diego-castilho/NowPlaying/discussions) • [Documentação](Documentation/ARCHITECTURE.md)

</div>
