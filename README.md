# NowPlaying

![NowPlaying Icon](NowPlaying/Resources/Assets.xcassets/AppIcon.appiconset/NowPlaying.pnggit)

Um aplicativo macOS moderno e elegante que automaticamente registra suas músicas do Apple Music no Last.fm

[![Version](https://img.shields.io/badge/version-0.9.3-blue.svg)](https://github.com/diego-castilho/NowPlaying/releases/tag/v0.9.3)
[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-macOS%2012.0+-lightgrey.svg)](https://www.apple.com/macos/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Progress](https://img.shields.io/badge/progress-10%25-yellow.svg)](CHANGELOG.md)

[Recursos](#-recursos) • [Desenvolvimento](#-desenvolvimento) • [Requisitos do Sistema](#-requisitos-do-sistema) • [Roadmap](#-roadmap)

---

## ⚠️ STATUS DO PROJETO

> **🚧 EM DESENVOLVIMENTO ATIVO - VERSÃO 0.9.3**
>
> O projeto está em **modernização completa** para a versão 1.0.
>
> **Branch atual**: `feature/phase-1-security`  
> **Progresso**: 10% (3/30 atividades concluídas)

### 📊 Progresso das Fases
```
FASE 1: FUNDAÇÃO E SEGURANÇA [██████░░░░] 60%

✅ v0.9.1 - Sistema de Configuração Seguro
✅ v0.9.2 - Modernização do Keychain
✅ v0.9.3 - App Sandbox + Entitlements
⏳ v0.9.4 - Padrões Modernos Swift (PRÓXIMA)
⏳ v0.9.5 - Dependency Injection
⏳ Fase 2 - Interface Liquid Glass
⏳ Fase 3 - Widget de Desktop
⏳ Fase 4 - Recursos Avançados
⏳ Fase 5 - Qualidade e Polish
⏳ Fase 6 - Distribuição
🎯 v1.0.0 - Release Final (Q1 2026)
```

**Documentação Completa**:
- 📋 [CHANGELOG.md](Documentation/CHANGELOG.md) - Histórico detalhado de todas as versões
- 🏗️ [ARCHITECTURE.md](Documentation/ARCHITECTURE.md) - Documentação técnica da arquitetura

---

## 📖 Sobre o Projeto

NowPlaying é um aplicativo nativo para macOS que faz scrobble automático das músicas que você ouve no Apple Music para sua conta do Last.fm. Com uma interface moderna usando design Liquid Glass da Apple e suporte para Widgets de Desktop, NowPlaying oferece uma experiência elegante e integrada ao macOS.

### ✨ Destaques

- 🎨 **Design Liquid Glass**: Interface moderna seguindo as últimas diretrizes da Apple
- 🔒 **Seguro**: App Sandbox habilitado, credenciais protegidas no Keychain
- 📱 **Widget de Desktop**: Veja a música atual direto no seu Desktop
- 🎯 **Menu Bar**: Acesso rápido via barra de menu com hover inteligente
- 📊 **Estatísticas**: Acompanhe suas músicas mais ouvidas e padrões de escuta
- 🌐 **Automático**: Funciona em segundo plano sem necessidade de interação
- 🇧🇷 **Multilíngue**: Suporte para Português, Inglês e Espanhol

---

## 🎯 Recursos

### 🎵 Scrobbling

- ✅ Scrobble automático seguindo regras do Last.fm (50% da música ou 4 minutos)
- ✅ Atualização "Now Playing" em tempo real
- ✅ Suporte para álbuns e artwork
- ✅ Retry automático em caso de falha
- ✅ Histórico completo de scrobbles

### 🎨 Interface

- 🎨 Design Liquid Glass com materiais translúcidos
- 🖼️ Exibição de capas de álbum em alta qualidade
- 🌓 Suporte completo para Dark Mode
- ⚡ Animações fluidas e naturais
- 🎭 Hover effects e micro-interações

### 🎯 Menu Bar

- 🖱️ Hover automático para ver música atual
- 🎵 Popover compacto com informações essenciais
- ⚡ Acesso rápido a controles e preferências
- 🔔 Indicadores visuais de status

### 📱 Widget de Desktop

- 📐 4 tamanhos disponíveis (Small, Medium, Large, Extra Large)
- 🖼️ Exibição de artwork e informações da música
- 🔄 Atualização automática e eficiente
- 🎨 Design consistente com o app principal

### 📊 Histórico e Estatísticas

- 📋 Histórico completo de músicas tocadas
- 🔍 Busca e filtros avançados
- 📊 Estatísticas e insights de escuta
- 🗂️ Visualização de logs de scrobble
- 🎨 Layout moderno com sidebar

### ⚙️ Preferências

- 🚀 Iniciar automaticamente no login
- 🎨 Customização de aparência
- 🔔 Configuração de notificações
- 🔐 Gerenciamento de conta Last.fm
- ⚙️ Opções avançadas de scrobbling

---

## 🔐 Segurança

### v0.9.3 - App Sandbox Habilitado

- ✅ **App Sandbox Completo**: Isolamento do sistema operacional
- ✅ **Entitlements Mínimos**: Apenas 5 permissões necessárias
- ✅ **Keychain Seguro**: Credenciais protegidas com type-safety
- ✅ **Network Controlado**: Apenas comunicação HTTPS com Last.fm
- ✅ **Zero Acesso a Hardware**: Camera, microphone, USB desabilitados
- ✅ **Dados Pessoais Protegidos**: Sem acesso a contacts, calendar, photos, location

**Permissões Utilizadas**:
1. `app-sandbox` - Isolamento completo
2. `network.client` - Comunicação Last.fm API
3. `automation.apple-events` - Integração Apple Music
4. `keychain-access-groups` - Acesso seguro ao Keychain
5. `application-identifier` - Identificador único (automático)

**Mac App Store Ready**: O app está preparado para distribuição na Mac App Store.

---

## 💻 Requisitos do Sistema

### Mínimos

- **macOS**: 12.0 (Monterey) ou superior
- **Apple Music**: Instalado e com músicas
- **Last.fm**: Conta gratuita ([criar aqui](https://www.last.fm/join))
- **Xcode**: 15.6+ (apenas para desenvolvimento)

### Recomendados

- **macOS**: 14.0 (Sonoma) ou superior para melhor experiência
- **Memória**: 8 GB RAM
- **Espaço**: 100 MB livres

---

## 🚀 Instalação

### Para Usuários

> ⚠️ **Em desenvolvimento**: Binários de release ainda não disponíveis.
>
> A versão 1.0 será distribuída via Mac App Store (Q1 2026).

### Para Desenvolvedores

#### 1. Clone o Repositório
```bash
git clone https://github.com/diego-castilho/NowPlaying.git
cd NowPlaying
```

#### 2. Configurar Branch de Desenvolvimento
```bash
# Mudar para branch de desenvolvimento
git checkout feature/phase-1-security

# Ver status
git status
```

#### 3. Configurar Credenciais Last.fm

**Criar conta de desenvolvedor**:
1. Acesse: https://www.last.fm/api/account/create
2. Crie uma API account
3. Anote o **API Key** e **Shared Secret**

**Configurar no projeto**:
```bash
# Copiar template
cp Configuration/Secrets.template.xcconfig Configuration/Secrets.xcconfig

# Editar com suas credenciais
nano Configuration/Secrets.xcconfig
```

**Adicione suas credenciais**:
```
LASTFM_API_KEY = sua_api_key_aqui
LASTFM_SHARED_SECRET = seu_shared_secret_aqui
```

**Importante**: `Secrets.xcconfig` já está no `.gitignore` e não será commitado.

#### 4. Abrir no Xcode
```bash
open NowPlaying.xcodeproj
```

#### 5. Configurar Signing

No Xcode:
1. Selecione o projeto **NowPlaying** no Navigator
2. Selecione o target **NowPlaying**
3. Vá para **Signing & Capabilities**
4. Configure seu **Team** (Apple Developer Account)

#### 6. Build e Run
```
⌘R - Run
⌘B - Build
⌘⇧K - Clean Build Folder
```

---

## 📚 Desenvolvimento

### Estrutura do Projeto
```
NowPlaying/
├── Sources/
│   ├── App/                    # Presentation Layer
│   │   ├── Views/              # SwiftUI Views
│   │   ├── Components/         # Componentes reutilizáveis
│   │   └── Managers/           # UI-specific managers
│   │
│   └── Core/                   # Business Logic + Data
│       ├── Models/             # Domain models
│       ├── Services/           # Business logic services
│       ├── Configuration/      # Config management
│       ├── Keychain/           # Secure storage
│       ├── Persistence/        # Core Data
│       └── Utilities/          # Helpers
│
├── Configuration/              # Build configuration
│   ├── Secrets.template.xcconfig
│   └── Secrets.xcconfig        # Não versionado
│
├── Resources/                  # Assets
│   └── Assets.xcassets/
│
├── Documentation/              # Docs
│   ├── CHANGELOG.md
│   ├── ARCHITECTURE.md
│   └── README.md
│
└── NowPlaying.xcodeproj/
```

Veja [ARCHITECTURE.md](Documentation/ARCHITECTURE.md) para documentação técnica completa.

### Tecnologias

- **SwiftUI**: Interface declarativa
- **AppKit**: Menu bar e integração macOS
- **Combine**: Programação reativa
- **Core Data**: Persistência local
- **Keychain Services**: Armazenamento seguro
- **URLSession**: Networking
- **ServiceManagement**: Launch at Login (macOS 13+)
- **CryptoKit**: Criptografia (MD5 para API signatures)

### Git Workflow
```bash
# Branch principal de desenvolvimento
git checkout feature/phase-1-security

# Ver progresso
git log --oneline --graph

# Ver tags de versão
git tag
```

### Convenções de Commit

Seguimos [Conventional Commits](https://www.conventionalcommits.org/):
```
feat: nova funcionalidade
fix: correção de bug
docs: documentação
refactor: refatoração
test: testes
chore: tarefas diversas
security: melhorias de segurança
```

---

## 🗺️ Roadmap

### v0.9.4 - Padrões Modernos Swift (Próxima)

- Swift Concurrency completo (async/await)
- Actors para thread-safety
- Structured concurrency
- Task groups
- MainActor optimization

### v0.9.5 - Dependency Injection

- DI container
- Protocol-oriented refactoring
- Testabilidade aprimorada

### Fase 2: Interface Liquid Glass (v0.9.6 - v0.9.10)

- Design System completo
- Refatoração de segurança (App Sandbox)

### Fase 3: Widget de Desktop (v0.9.11 - v0.9.14)

- Widget de Desktop (4 tamanhos)

### Fase 4: Recursos Avançados (v0.9.15 - v0.9.20)

- Estatísticas avançadas
- Gráficos de escuta com Swift Charts
- Sistema de notificações

### Fase 5: Qualidade e Polish (v0.9.21 - v0.9.26)

- Testes unitários (80%+ cobertura)
- Testes de UI
- Performance optimization
- Accessibility

### Fase 6: Distribuição (v0.9.27 - v1.0.0)

- Code signing
- Notarization
- Mac App Store submission

### v1.0.0 - Release Final (Q1 2026)

- Release completa
- Disponível na Mac App Store
- Documentação completa
- Tutoriais em vídeo

### Futuro (v1.1+)

- Integração com Spotify
- Suporte para outros serviços de streaming
- Modo offline com sincronização posterior
- Themes customizáveis
- Shortcuts do macOS
- Control Center widget
- Integração com Apple Watch
- Compartilhamento social
- Badges de conquistas
- Import/Export de dados
- API para desenvolvedores

---

## 🐛 Problemas Conhecidos

### v0.9.3

- ⚠️ **Histórico de Logs UI**: Interface pode não atualizar corretamente (não afeta scrobbling)
- ⚠️ **Credenciais com fallback**: ConfigurationManager usa fallback hardcoded (será removido em v1.0.0)
- ⚠️ **Testes unitários ausentes**: Testes serão adicionados na Fase 5
- ⚠️ **Interface básica**: Design Liquid Glass será implementado na Fase 2

Veja [CHANGELOG.md](Documentation/CHANGELOG.md) para lista completa de débitos técnicos.

---

## 🤝 Contribuindo

> **🚧 Contribuições não aceitas no momento**
>
> O projeto está em modernização ativa. Contribuições serão bem-vindas após v1.0.0.

### Para o Futuro (v1.0+)

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'feat: add amazing feature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

---

## 📄 Licença

Este projeto está licenciado sob a licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

---

## 🙏 Agradecimentos

- **Last.fm**: Pela API incrível e documentação
- **Apple**: Pelo macOS e frameworks excelentes
- **Comunidade Swift**: Pelas bibliotecas e recursos

---

## 📞 Contato

- **GitHub**: [@diego-castilho](https://github.com/diego-castilho)
- **Issues**: [Reportar problema](https://github.com/diego-castilho/NowPlaying/issues)
- **Last.fm API**: [Documentação](https://www.last.fm/api)

---

## 📊 Status do Projeto
```
Versão Atual:    0.9.3
Progresso:       10% (3/30 atividades)
Fase Atual:      Fase 1 - Fundação e Segurança (60%)
Próxima Release: v0.9.4 (Padrões Modernos Swift)
Release Final:   v1.0.0 (Q1 2026)

Funcionalidade Core:  ████████░░ 80% (funcional)
Interface:            ████░░░░░░ 40% (básica)
Features Avançadas:   ░░░░░░░░░░  0% (planejadas)
Testes:               ░░░░░░░░░░  0% (Fase 5)
Documentação:         ████████░░ 80% (boa)
Segurança:            ████████░░ 80% (robusta)
```

---

## 🎯 Marcos do Projeto

- ✅ **2025-10-22**: v0.9.1 - Sistema de Configuração Seguro
- ✅ **2025-10-22**: v0.9.2 - Modernização do Keychain
- ✅ **2025-10-22**: v0.9.3 - App Sandbox + Entitlements
- ⏳ **2025-10-25**: v0.9.4 - Padrões Modernos Swift (estimado)
- ⏳ **2025-10-30**: v0.9.5 - Dependency Injection (estimado)
- ⏳ **2025-11-10**: Fase 1 Completa (estimado)
- 🎯 **2026-02-01**: v1.0.0 - Release Final (target)

---

**Desenvolvido com ❤️ por Diego Castilho**

Veja o [CHANGELOG.md](Documentation/CHANGELOG.md) para histórico completo de versões.
