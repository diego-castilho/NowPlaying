# Arquitetura do NowPlaying

Documentação técnica da arquitetura do aplicativo NowPlaying para macOS.

**Última Atualização**: 22 de outubro de 2025
**Versão**: 2.0 (Modernização)

---

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Estrutura do Projeto](#estrutura-do-projeto)
3. [Camadas da Aplicação](#camadas-da-aplicação)
4. [Fluxo de Dados](#fluxo-de-dados)
5. [Tecnologias Utilizadas](#tecnologias-utilizadas)
6. [Padrões e Convenções](#padrões-e-convenções)

---

## 🎯 Visão Geral

NowPlaying é um aplicativo macOS que faz scrobble automático de músicas do Apple Music para o Last.fm, 
com interface moderna usando design Liquid Glass e suporte para Widgets de Desktop.

### Princípios Arquiteturais

- **Separation of Concerns**: Separação clara entre UI, lógica de negócio e dados
- **Protocol-Oriented**: Uso extensivo de protocols para abstração
- **Dependency Injection**: Dependências injetadas para facilitar testes
- **Single Responsibility**: Cada classe/struct tem uma responsabilidade única
- **Modern Swift**: Swift Concurrency, async/await, actors

---

## 📁 Estrutura do Projeto
```
NowPlaying/
├── Sources/
│   ├── App/                    # Interface SwiftUI e Views
│   │   ├── Views/              # Views principais
│   │   ├── Components/         # Componentes reutilizáveis
│   │   ├── Design/             # Design System (Liquid Glass)
│   │   └── NowPlayingApp.swift # Entry point
│   │
│   ├── Core/                   # Lógica de negócio
│   │   ├── Models/             # Modelos de dados
│   │   ├── Services/           # Serviços (API, Music, etc)
│   │   ├── Managers/           # Gerenciadores (Scrobble, Config, etc)
│   │   └── Persistence/        # Core Data, Keychain
│   │
│   └── Widget/                 # Widget Extension
│       ├── Views/              # Views do Widget
│       ├── Timeline/           # Timeline Provider
│       └── Shared/             # Código compartilhado
│
├── Resources/
│   ├── Assets.xcassets/
│   └── Localizations/
│
├── Configuration/
│   ├── Secrets.template.xcconfig
│   └── Secrets.xcconfig (gitignored)
│
└── Tests/
    ├── UnitTests/
    └── UITests/
```

---

## 🏗️ Camadas da Aplicação

### 1. Presentation Layer (App/)
**Responsabilidade**: Interface do usuário e interação

- SwiftUI Views
- ViewModels (quando necessário)
- Design System components
- Navigation e routing

### 2. Business Logic Layer (Core/)
**Responsabilidade**: Lógica de negócio e regras

- ScrobbleManager: Lógica de scrobble
- MusicAccessManager: Integração com Apple Music
- AnalyticsEngine: Cálculo de estatísticas
- ConfigurationManager: Gerenciamento de configurações

### 3. Data Layer (Core/Persistence/)
**Responsabilidade**: Persistência e acesso a dados

- Core Data Stack
- Keychain Helper
- UserDefaults wrapper
- App Group shared data

### 4. Network Layer (Core/Services/)
**Responsabilidade**: Comunicação externa

- LastFMClient: API do Last.fm
- Network protocols e DTOs
- Error handling

---

## 🔄 Fluxo de Dados
```
Apple Music
    ↓
MusicAccessManager (observa mudanças)
    ↓
ScrobbleManager (processa e decide)
    ↓
LastFMClient (envia para API)
    ↓
Core Data (salva log)
    ↓
Views (atualizam UI via @Published)
    ↓
Widget (atualiza via App Group)
```

---

## 🛠️ Tecnologias Utilizadas

### Frameworks Apple
- **SwiftUI**: Interface declarativa
- **WidgetKit**: Widgets de Desktop
- **Core Data**: Persistência local
- **Keychain**: Armazenamento seguro
- **MusicKit**: Integração com Apple Music (macOS 12+)
- **Swift Charts**: Visualização de dados
- **UserNotifications**: Notificações ao usuário

### Linguagem e Paradigmas
- **Swift 5.9+**: Linguagem principal
- **Swift Concurrency**: async/await, actors
- **Combine**: Reactive programming (onde necessário)
- **Protocol-Oriented**: Design baseado em protocols

### Segurança
- **App Sandbox**: Habilitado
- **Hardened Runtime**: Habilitado
- **Keychain Services**: Credenciais seguras
- **External Configuration**: Secrets não versionados

---

## 📐 Padrões e Convenções

### Naming Conventions
- **Classes**: PascalCase (ex: `ScrobbleManager`)
- **Protocols**: PascalCase + "Protocol" suffix (ex: `MusicServiceProtocol`)
- **Variables**: camelCase (ex: `currentTrack`)
- **Constants**: camelCase (ex: `maxRetries`)
- **Enums**: PascalCase (ex: `ScrobbleStatus`)

### Code Organization
- Um arquivo por tipo (classe, struct, enum)
- Agrupar por funcionalidade, não por tipo
- Extensions em arquivos separados quando extensas
- Marks (`// MARK:`) para organizar código dentro de arquivos

### SwiftUI Best Practices
- Views pequenas e focadas (< 200 linhas)
- Extract subviews quando necessário
- Usar `@MainActor` em ViewModels
- Preferir composition sobre herança

### Async/Await
- Usar async/await para operações assíncronas
- Evitar completion handlers quando possível
- Tratar erros com `try`/`catch`
- Usar `Task` para bridge com código síncrono

---

## 🧪 Testes

### Estratégia
- **Unit Tests**: Lógica de negócio (70%+ coverage)
- **UI Tests**: Fluxos críticos
- **Integration Tests**: Interação entre camadas

### Mocking
- Usar protocols para facilitar mocks
- Dependency injection para testes
- Mocks isolados para cada teste

---

## 🔐 Segurança

### Credenciais
- Nunca versionar credenciais
- Usar `Secrets.xcconfig` (gitignored)
- Validar na inicialização

### Dados Sensíveis
- Session keys no Keychain
- Nunca logar credenciais
- HTTPS para todas as requests

### App Sandbox
- Permissões mínimas necessárias
- Documentar exceções temporárias
- Revisar entitlements regularmente

---

## 🚀 Deployment

### Requisitos
- **macOS**: 12.0+ (para MusicKit)
- **Xcode**: 15.6+
- **Swift**: 5.9+

### Build Configurations
- **Debug**: Development, verbose logging
- **Release**: Production, optimized, no logs

---

## 📚 Referências

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [WidgetKit Documentation](https://developer.apple.com/documentation/widgetkit)
- [Swift Concurrency](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html)
- [Last.fm API Documentation](https://www.last.fm/api)

---

**Nota**: Este documento evolui com o projeto. Mantenha-o atualizado conforme mudanças significativas são feitas.
