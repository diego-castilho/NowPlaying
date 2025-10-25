# NowPlaying

<p align="center">
  <img src="NowPlaying/Assets.xcassets/AppIcon.appiconset/NowPlaying.png" alt="NowPlaying Icon" width="200"/>
</p>

<p align="center">
  <strong>Um aplicativo macOS moderno e elegante que automaticamente registra suas músicas do Apple Music no Last.fm</strong>
</p>

<p align="center">
  <a href="#-recursos">Recursos</a> •
  <a href="#-requisitos">Requisitos</a> •
  <a href="#-instalação">Instalação</a> •
  <a href="#-configuração">Configuração</a> •
  <a href="#-desenvolvimento">Desenvolvimento</a> •
  <a href="#-contribuindo">Contribuindo</a> •
  <a href="#-licença">Licença</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-12.0+-blue.svg" alt="macOS 12.0+"/>
  <img src="https://img.shields.io/badge/Swift-5.9+-orange.svg" alt="Swift 5.9+"/>
  <img src="https://img.shields.io/badge/Xcode-15.6+-blue.svg" alt="Xcode 15.6+"/>
  <img src="https://img.shields.io/badge/version-0.9.2-blue.svg" alt="Version"/>
  <img src="https://img.shields.io/badge/moderniza%C3%A7%C3%A3o-6.7%25-yellow.svg" alt="Progress"/>
  <img src="https://img.shields.io/badge/release-v1.0%20Q1%202026-orange.svg" alt="Release"/>
</p>

---

## 📖 Sobre o Projeto

**NowPlaying** é um aplicativo nativo para macOS que faz scrobble automático das músicas que você ouve no Apple Music para sua conta do Last.fm. Com sistema robusto de segurança e interface moderna, NowPlaying oferece uma experiência elegante e perfeitamente integrada ao macOS.

### ✨ Destaques

- 🔒 **Seguro**: Credenciais protegidas no Keychain com sistema type-safe
- 🚀 **Automático**: Scrobble seguindo regras oficiais do Last.fm
- 🎯 **Menu Bar**: Acesso rápido via barra de menu com hover inteligente
- 📊 **Histórico Completo**: Logs detalhados com filtros e busca
- ⚙️ **Launch at Login**: Inicia automaticamente no macOS 13+
- 🌐 **API Moderna**: Cliente Last.fm robusto com retry automático

---

## ⚠️ STATUS DO PROJETO

> **🚧 EM DESENVOLVIMENTO ATIVO - VERSÃO 0.9.2**
>
> O projeto está em **modernização completa** para a versão 1.0.
>
> **Branch atual**: `feature/phase-1-security`  
> **Progresso**: 6.7% (2/30 atividades concluídas)

### 📊 Progresso das Fases
```
FASE 1: FUNDAÇÃO E SEGURANÇA [████░░░░░░] 40%

✅ v0.9.1 - Sistema de Configuração Seguro
✅ v0.9.2 - Modernização do Keychain
🔄 v0.9.3 - App Sandbox + Entitlements (PRÓXIMA)
⏳ v0.9.4 - Padrões Modernos Swift
⏳ v0.9.5 - Dependency Injection
⏳ Fase 2 - Interface Liquid Glass
⏳ Fase 3 - Widget de Desktop
⏳ Fase 4 - Recursos Avançados
⏳ Fase 5 - Qualidade e Polish
⏳ Fase 6 - Distribuição
🎯 v1.0.0 - Release Final (Q1 2026)
```

📖 **Documentação Completa**:
- [CHANGELOG.md](CHANGELOG.md) - Histórico detalhado de versões
- [ARCHITECTURE.md](ARCHITECTURE.md) - Documentação técnica da arquitetura

---

## 🎯 Recursos

### ✅ Funcionalidades Principais

**Scrobbling Automático**
- Scrobble automático seguindo regras do Last.fm (50% ou 4 min)
- Atualização "Now Playing" em tempo real
- Suporte completo para artwork de álbuns
- Retry automático em caso de falha
- Histórico persistente com Core Data

**Segurança e Configuração** *(novo em v0.9.1 e v0.9.2)*
- Sistema moderno de Keychain type-safe
- Migração automática de dados antigos
- ConfigurationManager centralizado
- Error handling robusto
- Logs seguros (não expõem credenciais)

**Interface**
- Menu Bar com popover hover automático
- Janela principal com histórico de músicas
- Logs filtráveis (tipo, status, busca)
- Dark Mode completo
- Exibição de capa atual

**Sistema**
- Launch at Login (macOS 13+)
- Integração com Apple Music via notificações
- OAuth completo do Last.fm
- Gerenciamento de sessão no Keychain

### 🔄 Em Desenvolvimento

- Design Liquid Glass (Fase 2)
- Widget de Desktop (Fase 3)
- Estatísticas avançadas (Fase 4)
- Gráficos de escuta (Fase 4)
- Testes unitários (Fase 5)

---

## 💻 Requisitos do Sistema

### Para Usuários

- **macOS**: 12.0 (Monterey) ou superior
- **Apple Music**: Instalado e funcionando
- **Last.fm**: Conta gratuita ([criar aqui](https://www.last.fm/join))
- **Espaço**: ~50 MB

### Para Desenvolvedores

- **macOS**: 12.0+ (recomendado 14.0+ Sonoma)
- **Xcode**: 15.6+
- **Swift**: 5.9+
- **Git**: Para clonar o repositório
- **Last.fm API Key**: [Obter credenciais](https://www.last.fm/api/account/create)

---

## 🚀 Instalação

### Opção 1: Download Direto

> 🚧 Builds pré-compilados estarão disponíveis na v1.0

### Opção 2: Compilar do Código-Fonte
```bash
# 1. Clonar repositório
git clone https://github.com/diego-castilho/NowPlaying.git
cd NowPlaying

# 2. Branch de desenvolvimento
git checkout feature/phase-1-security

# 3. Configurar credenciais Last.fm
cd Configuration
cp Secrets.template.xcconfig Secrets.xcconfig
nano Secrets.xcconfig  # Adicione suas credenciais

# 4. Abrir e compilar
open NowPlaying.xcodeproj
# No Xcode: Product → Run (⌘R)
```

---

## ⚙️ Configuração

### Primeira Execução

1. Abra o **NowPlaying**
2. Clique em **"Conectar ao Last.fm"**
3. Autorize no navegador
4. Volte ao app e clique **"Já autorizei — Concluir login"**
5. ✅ Scrobble automático ativado!

### Launch at Login (Opcional)

**macOS 13+**: 
- Preferências → Ativar "Iniciar no login" ✅

**macOS 12 e anteriores**:
- Preferências do Sistema → Usuários e Grupos → Itens de Login
- Adicionar NowPlaying manualmente

### Permissões

- ✅ **Apple Events**: Acesso ao Apple Music (obrigatório)
- ✅ **Rede**: Comunicação com Last.fm (obrigatório)

---

## 🛠️ Desenvolvimento

### Estrutura do Projeto
```
NowPlaying/
├── Sources/
│   ├── App/                      # Interface SwiftUI
│   │   ├── NowPlayingApp.swift
│   │   ├── ContentView.swift
│   │   ├── MenuBarPanelView.swift
│   │   ├── LogListView.swift
│   │   └── PreferencesView.swift
│   │
│   └── Core/                     # Lógica de negócio
│       ├── Models/
│       ├── Services/
│       │   ├── LastFMClient.swift
│       │   ├── MusicEventListener.swift
│       │   └── ScrobbleManager.swift
│       ├── Configuration/
│       │   └── ConfigurationManager.swift
│       ├── Keychain/             # v0.9.2
│       │   ├── KeychainService.swift
│       │   ├── KeychainItem.swift
│       │   └── KeychainError.swift
│       └── Persistence/
│           └── CoreDataStack.swift
│
├── Configuration/
│   ├── Secrets.template.xcconfig
│   └── Secrets.xcconfig          # Não versionado
│
└── Documentation/
    ├── CHANGELOG.md
    ├── ARCHITECTURE.md
    └── README.md
```

📖 Veja [ARCHITECTURE.md](ARCHITECTURE.md) para documentação técnica completa.

### Tecnologias

- **SwiftUI**: Interface moderna e reativa
- **Core Data**: Persistência de logs
- **Keychain Services**: Armazenamento seguro (v0.9.2)
- **Combine**: Programação reativa
- **Distributed Notifications**: Integração Apple Music
- **URLSession**: Comunicação HTTP

---

## 🧪 Testes

### Status (v0.9.2)
- **Cobertura**: 0% (testes planejados para Fase 5)
- **Validação**: Manual ✅

### Futuro (Fase 5)
```bash
# Todos os testes
xcodebuild test -scheme NowPlaying

# Unitários
xcodebuild test -scheme NowPlaying -only-testing:NowPlayingTests

# UI
xcodebuild test -scheme NowPlaying -only-testing:NowPlayingUITests
```

---

## 🤝 Contribuindo

Contribuições são bem-vindas!

### Como Contribuir

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'feat: adiciona MinhaFeature'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abra um Pull Request

### Diretrizes

- Siga o [Swift Style Guide](https://google.github.io/swift/)
- Use commits descritivos ([Conventional Commits](https://www.conventionalcommits.org/))
- Atualize documentação relevante
- Certifique-se de que compila sem warnings

---

## 📚 Documentação

- **[CHANGELOG.md](CHANGELOG.md)**: Histórico de versões e mudanças
- **[ARCHITECTURE.md](ARCHITECTURE.md)**: Arquitetura técnica detalhada
- **[Last.fm API](https://www.last.fm/api)**: Documentação oficial da API

---

## 🐛 Problemas Conhecidos

### v0.9.2
- ⚠️ Fallback hardcoded temporário (será removido em v1.0.0)
- ⚠️ Sem testes unitários (Fase 5)
- ⚠️ App Sandbox desabilitado (v0.9.3)
- ⚠️ Interface básica (Fase 2 implementará Liquid Glass)

Veja [CHANGELOG.md](CHANGELOG.md) para lista completa.

---

## 🗺️ Roadmap

### v0.9.x - Fundação (Q4 2025 - Q1 2026)
- ✅ v0.9.1: Sistema de Configuração
- ✅ v0.9.2: Keychain Moderno
- ⏳ v0.9.3: App Sandbox
- ⏳ v0.9.4: Swift Moderno
- ⏳ v0.9.5: Dependency Injection

### v1.0.0 - Release (Q1 2026)
- Fase 2: Interface Liquid Glass
- Fase 3: Widget de Desktop
- Fase 4: Recursos Avançados
- Fase 5: Qualidade e Polish
- Fase 6: Distribuição

### v1.1.0+ - Expansão (Q2-Q3 2026)
- Integração Spotify
- Control Center widget
- Apple Watch
- Themes customizáveis
- Shortcuts

---

## 📝 Licença

Este projeto está sob a licença MIT. Veja [LICENSE](LICENSE) para detalhes.

---

## 👤 Autor

**Diego Castilho**
- GitHub: [@diego-castilho](https://github.com/diego-castilho)

---

## 🙏 Agradecimentos

- [Last.fm](https://www.last.fm/) pela API
- Apple pelo macOS e Swift
- Comunidade open-source

---

## 📞 Suporte

- **Issues**: [GitHub Issues](https://github.com/diego-castilho/NowPlaying/issues)
- **Discussions**: [GitHub Discussions](https://github.com/diego-castilho/NowPlaying/discussions)

---

⭐ **Se este projeto te ajudou, considere dar uma estrela no GitHub!**

---

**Última Atualização**: 22 de outubro de 2025  
**Versão**: 0.9.2  
**Status**: 🚧 Em Desenvolvimento Ativo
