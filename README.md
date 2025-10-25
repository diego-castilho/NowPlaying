# 🎵 NowPlaying

<p align="center">
  <img src="NowPlaying/Assets.xcassets/AppIcon.appiconset/NowPlaying.png" alt="NowPlaying Icon" width="200"/>
</p>

<p align="center">
  <strong>Aplicativo macOS moderno que registra automaticamente suas músicas do Apple Music no Last.fm</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-12.0+-blue?style=flat-square&logo=apple" alt="macOS">
  <img src="https://img.shields.io/badge/Swift-5.9+-orange?style=flat-square&logo=swift" alt="Swift">
  <img src="https://img.shields.io/badge/Xcode-15.6+-blue?style=flat-square&logo=xcode" alt="Xcode">
  <img src="https://img.shields.io/badge/Versão-0.9.1--alpha.1-green?style=flat-square" alt="Versão">
  <img src="https://img.shields.io/badge/Status-Em%20Desenvolvimento-yellow?style=flat-square" alt="Status">
  <img src="https://img.shields.io/github/stars/diego-castilho/NowPlaying?style=social" alt="Stars">
</p>

---

## 📖 Sobre o Projeto

**NowPlaying** é um aplicativo nativo para macOS que faz scrobble automático de músicas do Apple Music para o Last.fm. Desenvolvido em Swift com SwiftUI, oferece uma experiência moderna e integrada ao sistema.

### 🎯 Diferenciais

- **🎨 Design Liquid Glass**: Interface moderna seguindo diretrizes Apple
- **🔒 Segurança**: App Sandbox, credenciais protegidas no Keychain
- **📱 Widget Desktop**: Música atual direto no Desktop (em desenvolvimento)
- **🎯 Menu Bar**: Acesso via hover inteligente
- **📊 Estatísticas**: Análise de padrões de escuta
- **🌐 Automático**: Funciona em segundo plano
- **⚡ Leve**: Consumo mínimo de recursos

---

## ✨ Recursos Detalhados

### 🎵 Scrobbling
- Regras oficiais Last.fm (50% música ou 4min)
- Atualização "Now Playing" em tempo real
- Suporte completo a álbuns e artwork
- Retry automático em falhas
- Histórico local com Core Data
- Filtros avançados de busca

### 🎨 Interface
- Materiais translúcidos Liquid Glass
- Capas em alta qualidade
- Dark Mode nativo
- Animações fluidas
- Micro-interações
- Design responsivo

### 🖱️ Menu Bar
- Hover automático
- Info rápida da música
- Acesso a controles
- Indicadores de status

### 📱 Widget Desktop (Em Desenvolvimento)
- 4 tamanhos (Small, Medium, Large, Extra Large)
- Artwork dinâmico
- Atualização automática
- Design integrado

### 🪟 Janela Principal
- Histórico completo
- Busca e filtros avançados
- Estatísticas detalhadas
- Logs de scrobbles
- Layout com sidebar

### ⚙️ Preferências
- Launch at Login
- Customização de aparência
- Notificações configuráveis
- Gerenciamento de conta Last.fm
- Opções avançadas de scrobbling

---

## 🛠️ Desenvolvimento

### 📁 Estrutura do Projeto
```
NowPlaying/
├── Sources/
│   ├── App/                    # Interface SwiftUI
│   │   ├── Views/              # Views principais
│   │   ├── Components/         # Componentes reutilizáveis
│   │   ├── Design/             # Design System
│   │   └── NowPlayingApp.swift
│   │
│   ├── Core/                   # Lógica de negócio
│   │   ├── Models/             # Modelos de dados
│   │   ├── Services/           # Serviços (API, Music)
│   │   ├── Managers/           # Gerenciadores
│   │   └── Persistence/        # Core Data, Keychain
│   │
│   └── Widget/                 # Widget Extension
│
├── Configuration/
│   ├── Secrets.template.xcconfig
│   └── Secrets.xcconfig        # Não versionado
│
├── Tests/
│   ├── UnitTests/
│   └── UITests/
│
├── CHANGELOG.md
├── ARCHITECTURE.md
└── README.md
```

### 🏗️ Arquitetura

**Camadas da Aplicação:**

- **Presentation**: SwiftUI views e componentes
- **Business Logic**: Managers e regras de negócio
- **Data**: Core Data e Keychain
- **Network**: API clients e serviços

**Padrões:**
- Protocol-Oriented Design
- Dependency Injection
- MVVM onde aplicável
- Single Responsibility Principle

### 🔧 Tecnologias

**Frameworks Apple:**
- SwiftUI (Interface)
- WidgetKit (Widgets Desktop)
- Core Data (Persistência)
- Keychain Services (Segurança)
- MusicKit (Planejado)
- Swift Charts (Planejado)
- UserNotifications (Planejado)

**Linguagem:**
- Swift 5.9+
- Swift Concurrency (async/await)
- Combine (reactive programming)

**APIs Externas:**
- Last.fm API (Scrobbling)
- Apple Music (Notificações distribuídas)

### 🧪 Testes
```bash
# Executar testes
xcodebuild test -scheme NowPlaying -destination 'platform=macOS'
```

### 🔀 Git Workflow

**Branches:**
- `main` - Produção estável
- `develop` - Desenvolvimento ativo
- `feature/*` - Features específicas
- `fix/*` - Correções de bugs

**Commits:** [Conventional Commits](https://www.conventionalcommits.org/)
```
feat: adicionar widget desktop
fix: corrigir crash ao pausar
docs: atualizar README
refactor: modernizar Keychain
test: adicionar testes ScrobbleManager
```

### 📊 Status Desenvolvimento
```
FASE 1: FUNDAÇÃO E SEGURANÇA    [████░░░░░░] 20%
FASE 2: INTERFACE LIQUID GLASS  [░░░░░░░░░░]  0%
FASE 3: WIDGET DE DESKTOP       [░░░░░░░░░░]  0%
FASE 4: RECURSOS AVANÇADOS      [░░░░░░░░░░]  0%
FASE 5: QUALIDADE E POLISH      [░░░░░░░░░░]  0%
FASE 6: DISTRIBUIÇÃO            [░░░░░░░░░░]  0%

PROGRESSO TOTAL                 [██░░░░░░░░] 3.3%
```

---

## 💻 Requisitos do Sistema

### Mínimos
- macOS 12.0 (Monterey) ou superior
- Apple Music instalado
- Conta Last.fm gratuita
- Conexão com Internet

### Recomendados
- macOS 14.0 (Sonoma) ou superior
- 4 GB RAM disponíveis
- 100 MB espaço livre
- Apple Silicon (M1+) ou Intel i5+

### Para Desenvolvimento
- Xcode 15.6+
- Swift 5.9+
- Git
- Last.fm API Key ([obter aqui](https://www.last.fm/api/account/create))

---

## 🗺️ Roadmap

### v2.0.0 (Q1 2026) - Modernização Completa

**Fase 1: Fundação e Segurança (20% ✅)**
- [x] Sistema de configuração seguro
- [ ] Modernização do Keychain
- [ ] App Sandbox habilitado
- [ ] Padrões modernos Swift
- [ ] Dependency Injection

**Fase 2: Interface Liquid Glass**
- [ ] Design system completo
- [ ] Componentes reutilizáveis
- [ ] Menu bar redesenhado
- [ ] Janela principal moderna
- [ ] Preferences window

**Fase 3: Widget Desktop**
- [ ] Widget Extension
- [ ] 4 tamanhos de widget
- [ ] Sincronização eficiente
- [ ] Design consistente

**Fase 4: Recursos Avançados**
- [ ] Sistema de animações
- [ ] Notificações inteligentes
- [ ] Estatísticas avançadas
- [ ] Charts e visualizações

**Fase 5: Qualidade e Polish**
- [ ] Testes (70%+ coverage)
- [ ] Acessibilidade 100%
- [ ] Localização (PT/EN/ES)
- [ ] Performance otimizada

**Fase 6: Distribuição**
- [ ] Code signing
- [ ] Mac App Store (opcional)
- [ ] Website download
- [ ] Auto-update

### v2.1.0 (Q2 2026) - Expansão
- Integração Spotify
- Control Center widget
- Apple Watch companion
- Compartilhamento social
- Themes customizáveis

### v2.2.0 (Q3 2026) - Avançado
- Modo offline com sync
- Shortcuts macOS
- Badges de conquistas
- Import/Export dados
- API para desenvolvedores

---

## 📄 Licença

**Copyright © 2025 Diego Castilho. All Rights Reserved.**

Este software e seu código-fonte são propriedade exclusiva do autor. 

**Restrições:**
- ❌ Uso comercial não autorizado
- ❌ Redistribuição não autorizada
- ❌ Modificação não autorizada
- ❌ Uso sem permissão explícita

**Permissões:**
- ✅ Uso pessoal para fins educacionais
- ✅ Visualização do código-fonte
- ✅ Fork para contribuições (com PR)

Para solicitar licença comercial ou permissões especiais, entre em contato através do GitHub.

---

## 👥 Autores e Agradecimentos

### Desenvolvedor Principal
**Diego Castilho** - [@diego-castilho](https://github.com/diego-castilho)

### Agradecimentos Especiais
- **Apple** - Plataforma macOS e frameworks modernos
- **Last.fm** - API de scrobbling e comunidade
- **Swift Community** - Linguagem e recursos incríveis
- **Beta Testers** - Feedback valioso durante desenvolvimento

---

## 📞 Suporte e Recursos

### Obter Ajuda
- **Issues**: [GitHub Issues](https://github.com/diego-castilho/NowPlaying/issues)
- **Discussões**: GitHub Discussions (em breve)
- **Email**: Veja perfil GitHub

### Recursos Úteis

**Last.fm:**
- [Last.fm](https://www.last.fm) - Plataforma oficial
- [Criar Conta](https://www.last.fm/join) - Registro gratuito
- [API Docs](https://www.last.fm/api) - Documentação
- [API Account](https://www.last.fm/api/account/create) - Credenciais

**Apple Developer:**
- [SwiftUI](https://developer.apple.com/documentation/swiftui/)
- [WidgetKit](https://developer.apple.com/documentation/widgetkit)
- [MusicKit](https://developer.apple.com/documentation/musickit/)
- [HIG macOS](https://developer.apple.com/design/human-interface-guidelines/macos)

**Swift:**
- [Swift.org](https://swift.org)
- [Swift Evolution](https://github.com/apple/swift-evolution)
- [Swift Forums](https://forums.swift.org)

---

## 📊 Estatísticas e Badges

![GitHub stars](https://img.shields.io/github/stars/diego-castilho/NowPlaying?style=social)
![GitHub forks](https://img.shields.io/github/forks/diego-castilho/NowPlaying?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/diego-castilho/NowPlaying?style=social)

![Issues](https://img.shields.io/github/issues/diego-castilho/NowPlaying)
![Pull Requests](https://img.shields.io/github/issues-pr/diego-castilho/NowPlaying)
![Last Commit](https://img.shields.io/github/last-commit/diego-castilho/NowPlaying)
![Code Size](https://img.shields.io/github/languages/code-size/diego-castilho/NowPlaying)
![License](https://img.shields.io/badge/License-All%20Rights%20Reserved-red)

---

## 🔗 Links Importantes

- **Repositório**: [github.com/diego-castilho/NowPlaying](https://github.com/diego-castilho/NowPlaying)
- **Issues**: [Issues](https://github.com/diego-castilho/NowPlaying/issues)
- **Changelog**: [CHANGELOG.md](CHANGELOG.md)
- **Arquitetura**: [ARCHITECTURE.md](ARCHITECTURE.md)

---

<p align="center">
  <strong>Feito com ❤️ e Swift</strong>
</p>

<p align="center">
  <sub>Se você gosta deste projeto, considere dar uma ⭐</sub>
</p>

---

**Última atualização**: 22 de outubro de 2025 | **Versão**: 0.9.1
