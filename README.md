<div align="center">

# 🎵 Now Playing

### Scrobble automático do Apple Music para Last.fm no macOS

[![macOS](https://img.shields.io/badge/macOS-12.0+-blue.svg)](https://www.apple.com/macos/)
[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-native-green.svg)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-2.0--beta-yellow.svg)](CHANGELOG.md)

<img src="NowPlaying/Assets.xcassets/AppIcon.appiconset/NowPlaying.png" width="200" alt="NowPlaying Icon">

**Um aplicativo macOS moderno e elegante que automaticamente registra suas músicas do Apple Music no Last.fm**

[Recursos](#-recursos) • [Desenvolvimento](#-desenvolvimento) • [Requisitos do Sistema](#-requisitos-do-sistema) • [Roadmap](#-roadmap)

</div>

---

## 📖 Sobre

**NowPlaying** é um aplicativo nativo para macOS que faz scrobble automático das músicas que você ouve no Apple Music para sua conta do Last.fm. Com uma interface moderna usando design **Liquid Glass** da Apple e suporte para **Widgets de Desktop**, NowPlaying oferece uma experiência elegante e integrada ao macOS.

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

### Scrobbling Inteligente
- ✅ Scrobble automático seguindo regras do Last.fm (50% da música ou 4 minutos)
- ✅ Atualização "Now Playing" em tempo real
- ✅ Suporte para álbuns e artwork
- ✅ Retry automático em caso de falha
- ✅ Histórico completo de scrobbles

### Interface Moderna
- 🎨 Design Liquid Glass com materiais translúcidos
- 🖼️ Exibição de capas de álbum em alta qualidade
- 🌓 Suporte completo para Dark Mode
- ⚡ Animações fluidas e naturais
- 🎭 Hover effects e micro-interações

### Menu Bar
- 🖱️ Hover automático para ver música atual
- 🎵 Popover compacto com informações essenciais
- ⚡ Acesso rápido a controles e preferências
- 🔔 Indicadores visuais de status

### Widget de Desktop
- 📐 4 tamanhos disponíveis (Small, Medium, Large, Extra Large)
- 🖼️ Exibição de artwork e informações da música
- 🔄 Atualização automática e eficiente
- 🎨 Design consistente com o app principal

### Janela Principal
- 📋 Histórico completo de músicas tocadas
- 🔍 Busca e filtros avançados
- 📊 Estatísticas e insights de escuta
- 🗂️ Visualização de logs de scrobble
- 🎨 Layout moderno com sidebar

### Preferências
- 🚀 Iniciar automaticamente no login
- 🎨 Customização de aparência
- 🔔 Configuração de notificações
- 🔐 Gerenciamento de conta Last.fm
- ⚙️ Opções avançadas de scrobbling

---

## 📋 Requisitos do Sistema

- **macOS**: 12.0 (Monterey) ou superior
- **Apple Music**: Instalado e com músicas
- **Last.fm**: Conta gratuita ([criar aqui](https://www.last.fm/join))
- **Xcode**: 15.6+ (apenas para desenvolvimento)

---

<!-- ## 💾 Instalação

### Opção 1: Download Direto (Recomendado)

1. Baixe a última versão em [Releases](https://github.com/seuusuario/NowPlaying/releases)
2. Abra o arquivo `.dmg` baixado
3. Arraste **NowPlaying.app** para a pasta Aplicativos
4. Abra o app (pode ser necessário permitir nas Configurações de Segurança)
5. Siga o assistente de configuração

### Opção 2: Compilar do Código-Fonte
```bash
# Clone o repositório
git clone https://github.com/seuusuario/NowPlaying.git
cd NowPlaying

# Crie o arquivo de configuração (veja seção Desenvolvimento)
cp Configuration/Secrets.template.xcconfig Configuration/Secrets.xcconfig
# Edite Secrets.xcconfig com suas credenciais da API Last.fm

# Abra no Xcode
open NowPlaying.xcodeproj

# Compile e execute (⌘R)
```

---

## 🚀 Como Usar

### Primeira Configuração

1. **Inicie o NowPlaying**
   - Abra o aplicativo pela primeira vez
   - O ícone aparecerá na barra de menu (🎵)

2. **Conecte ao Last.fm**
   - Clique no ícone da barra de menu
   - Clique em "Conectar ao Last.fm"
   - Você será redirecionado para autorizar o app
   - Volte ao app e clique em "Já autorizei — Concluir login"

3. **Comece a Ouvir**
   - Abra o Apple Music
   - Toque qualquer música
   - O scrobble acontecerá automaticamente!

### Usando o Widget

1. **Adicionar Widget ao Desktop**
   - Clique com botão direito no Desktop
   - Selecione "Editar Widgets"
   - Busque por "NowPlaying"
   - Arraste para o Desktop
   - Escolha o tamanho desejado

2. **Configurar Widget**
   - Clique com botão direito no widget
   - Selecione "Editar Widget"
   - Ajuste as preferências de exibição

### Atalhos de Teclado

- `⌘,` - Abrir Preferências
- `⌘W` - Fechar janela
- `⌘Q` - Sair do aplicativo
- `⌘⇧M` - Mostrar/ocultar popover da barra de menu

---

## 🔧 Desenvolvimento

### Configurando o Ambiente

1. **Clone o repositório**
```bash
   git clone https://github.com/seuusuario/NowPlaying.git
   cd NowPlaying
```

2. **Obtenha credenciais da API Last.fm**
   - Acesse [Last.fm API](https://www.last.fm/api/account/create)
   - Crie uma aplicação
   - Copie `API Key` e `Shared Secret`

3. **Configure secrets**
```bash
   # Copie o template
   cp Configuration/Secrets.template.xcconfig Configuration/Secrets.xcconfig
   
   # Edite com suas credenciais
   nano Configuration/Secrets.xcconfig
```
   
   Conteúdo do arquivo:
```
   LASTFM_API_KEY = SUA_API_KEY_AQUI
   LASTFM_SHARED_SECRET = SEU_SHARED_SECRET_AQUI
```

4. **Abra no Xcode**
```bash
   open NowPlaying.xcodeproj
```

5. **Compile e execute**
   - Pressione `⌘R` ou clique no botão Play

### Estrutura do Projeto
```
NowPlaying/
├── Sources/
│   ├── App/              # Interface SwiftUI
│   │   ├── Views/        # Views principais
│   │   ├── Components/   # Componentes reutilizáveis
│   │   └── Design/       # Design System (Liquid Glass)
│   │
│   ├── Core/             # Lógica de negócio
│   │   ├── Models/       # Modelos de dados
│   │   ├── Services/     # Serviços (API, Music, etc)
│   │   ├── Managers/     # Gerenciadores
│   │   └── Persistence/  # Core Data, Keychain
│   │
│   └── Widget/           # Widget Extension
│
├── Resources/
│   ├── Assets.xcassets/
│   └── Localizations/
│
├── Configuration/
│   └── Secrets.xcconfig  # Suas credenciais (não versionado)
│
└── Tests/
    ├── UnitTests/
    └── UITests/
```

### Tecnologias Utilizadas

- **Swift 5.9+**: Linguagem principal
- **SwiftUI**: Framework de UI
- **WidgetKit**: Widgets de Desktop
- **Core Data**: Persistência local
- **MusicKit**: Integração com Apple Music
- **Swift Charts**: Gráficos e visualizações
- **Combine**: Programação reativa
- **KeychainAccess**: Armazenamento seguro

### Executando Testes
```bash
# Executar testes unitários
xcodebuild test -scheme NowPlaying -destination 'platform=macOS'

# Ou no Xcode
# Pressione ⌘U
```

### Code Style

Este projeto segue as convenções do [Swift Style Guide](https://swift.org/documentation/api-design-guidelines/):

- **Indentação**: 4 espaços
- **Naming**: PascalCase para tipos, camelCase para variáveis
- **Line Length**: Máximo 120 caracteres
- **Documentation**: DocC para APIs públicas

Recomendamos usar [SwiftLint](https://github.com/realm/SwiftLint) e [SwiftFormat](https://github.com/nicklockwood/SwiftFormat).

---

## 🤝 Contribuir

Contribuições são muito bem-vindas! Existem várias formas de ajudar:

### Reportando Bugs

1. Verifique se o bug já foi reportado em [Issues](https://github.com/seuusuario/NowPlaying/issues)
2. Crie uma nova issue com:
   - Descrição clara do problema
   - Passos para reproduzir
   - Comportamento esperado vs. atual
   - Screenshots (se aplicável)
   - Versão do macOS e do app

### Sugerindo Funcionalidades

1. Verifique se já existe uma sugestão similar
2. Abra uma issue com tag `enhancement`
3. Descreva claramente a funcionalidade e casos de uso

### Contribuindo com Código

1. **Fork** o repositório
2. Crie uma **branch** para sua feature (`git checkout -b feature/MinhaFeature`)
3. **Commit** suas mudanças (`git commit -m 'feat: adiciona MinhaFeature'`)
4. **Push** para a branch (`git push origin feature/MinhaFeature`)
5. Abra um **Pull Request**

#### Convenções de Commit

Usamos [Conventional Commits](https://www.conventionalcommits.org/):
```
feat: adiciona nova funcionalidade
fix: corrige bug
docs: atualiza documentação
style: formatação, ponto e vírgula, etc
refactor: refatoração de código
test: adiciona ou atualiza testes
chore: atualiza build, dependências, etc
```

### Documentação

Ajude a melhorar a documentação:
- Corrigir erros de digitação
- Adicionar exemplos
- Traduzir para outros idiomas
- Melhorar explicações

--- -->

## 📊 Roadmap

### v2.0 (Atual - Em Desenvolvimento)
- [x] Design Liquid Glass completo
- [x] Refatoração de segurança (App Sandbox)
- [ ] Widget de Desktop (4 tamanhos)
- [ ] Estatísticas avançadas
- [ ] Gráficos de escuta com Swift Charts
- [ ] Sistema de notificações

### v2.1 (Futuro)
- [ ] Integração com Spotify
- [ ] Suporte para outros serviços de streaming
- [ ] Modo offline com sincronização posterior
- [ ] Themes customizáveis
- [ ] Shortcuts do macOS
- [ ] Control Center widget

### v2.2 (Futuro)
- [ ] Integração com Apple Watch
- [ ] Compartilhamento social
- [ ] Badges de conquistas
- [ ] Import/Export de dados
- [ ] API para desenvolvedores

Veja o [CHANGELOG.md](CHANGELOG.md) para histórico completo de versões.

---

<!-- ## 🐛 Problemas Conhecidos

- **macOS 12.x**: MusicKit tem funcionalidade limitada, usa fallback para notificações distribuídas
- **Apple Music Classical**: Pode não ser detectado corretamente em algumas versões
- **Sandbox**: Requer permissões especiais que podem gerar avisos no primeiro uso

Veja todas as issues abertas em [Issues](https://github.com/seuusuario/NowPlaying/issues).

---

## 📄 Licença

Este projeto está licenciado sob a licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.
```
MIT License

Copyright (c) 2025 Diego Castilho

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 🙏 Agradecimentos

- [Last.fm](https://www.last.fm) pela API pública
- Apple pela excelente documentação e ferramentas
- Comunidade Swift e SwiftUI
- Todos os [contribuidores](https://github.com/seuusuario/NowPlaying/graphs/contributors)

---

## 📞 Contato e Suporte

- **GitHub Issues**: [Reportar problema](https://github.com/seuusuario/NowPlaying/issues)
- **Email**: seuemail@exemplo.com
- **Twitter**: [@seutwitter](https://twitter.com/seutwitter)
- **Last.fm**: [Seu perfil](https://www.last.fm/user/seuusuario)

---

## 🔗 Links Úteis

- [Documentação Completa](https://github.com/seuusuario/NowPlaying/wiki)
- [FAQ - Perguntas Frequentes](https://github.com/seuusuario/NowPlaying/wiki/FAQ)
- [Guia de Troubleshooting](https://github.com/seuusuario/NowPlaying/wiki/Troubleshooting)
- [Changelog Detalhado](CHANGELOG.md)
- [Documentação da Arquitetura](ARCHITECTURE.md)
- [Last.fm API Docs](https://www.last.fm/api)
- [Apple Music API](https://developer.apple.com/documentation/musickit)

---

## ⭐ Star History

Se você gostou deste projeto, considere dar uma ⭐!

[![Star History Chart](https://api.star-history.com/svg?repos=seuusuario/NowPlaying&type=Date)](https://star-history.com/#seuusuario/NowPlaying&Date)

---

## 📸 Screenshots

<div align="center">

### Menu Bar Popover
<img src="docs/screenshots/menubar-popover.png" width="400" alt="Menu Bar Popover">

### Janela Principal
<img src="docs/screenshots/main-window.png" width="600" alt="Janela Principal">

### Widget de Desktop
<img src="docs/screenshots/desktop-widget.png" width="600" alt="Widget de Desktop">

### Preferências
<img src="docs/screenshots/preferences.png" width="600" alt="Preferências">

### Estatísticas
<img src="docs/screenshots/statistics.png" width="600" alt="Estatísticas">

</div>

---

<div align="center">

**Feito com ❤️ e ☕ por [Diego Castilho](https://github.com/seuusuario)**

[⬆ Voltar ao topo](#-nowplaying)

</div> -->
