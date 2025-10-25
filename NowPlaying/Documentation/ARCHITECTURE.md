# Architecture Documentation

Documentação técnica completa da arquitetura do **NowPlaying**.

---

## 📑 Índice

- [Visão Geral](#-visão-geral)
- [Arquitetura em Camadas](#-arquitetura-em-camadas)
- [Estrutura de Diretórios](#-estrutura-de-diretórios)
- [Componentes Principais](#-componentes-principais)
- [Fluxo de Dados](#-fluxo-de-dados)
- [Segurança](#-segurança)
- [Persistência](#-persistência)
- [Networking](#-networking)
- [Tecnologias](#-tecnologias)
- [Padrões e Convenções](#-padrões-e-convenções)
- [Testes](#-testes)
- [Performance](#-performance)
- [Deployment](#-deployment)

---

## 🏛️ Visão Geral

O **NowPlaying** segue uma arquitetura em camadas com separação clara de responsabilidades, baseada em princípios de **Clean Architecture** e **SOLID**.

### Princípios Arquiteturais

1. **Separation of Concerns**: Cada camada tem responsabilidades bem definidas
2. **Dependency Inversion**: Camadas superiores dependem de abstrações, não implementações
3. **Single Responsibility**: Cada componente tem uma única razão para mudar
4. **Protocol-Oriented**: Uso extensivo de protocols para abstração e testabilidade
5. **Unidirectional Data Flow**: Dados fluem em uma direção clara

### Diagrama de Alto Nível
```
┌─────────────────────────────────────────────────┐
│         Presentation Layer (SwiftUI)            │
│  Views, ViewModels, UI Components, User Input   │
└─────────────────────────────────────────────────┘
                      ↓ ↑
┌─────────────────────────────────────────────────┐
│          Business Logic Layer                   │
│  Managers, Services, Use Cases, Domain Logic    │
└─────────────────────────────────────────────────┘
                      ↓ ↑
┌─────────────────────────────────────────────────┐
│             Data Layer                          │
│  Core Data, Keychain, UserDefaults, Cache       │
└─────────────────────────────────────────────────┘
                      ↓ ↑
┌─────────────────────────────────────────────────┐
│            Network Layer                        │
│  API Clients, HTTP, URL Session                 │
└─────────────────────────────────────────────────┘
                      ↓ ↑
┌─────────────────────────────────────────────────┐
│         External Services                       │
│  Last.fm API, Apple Music, System Services      │
└─────────────────────────────────────────────────┘
```

---

## 🏗️ Arquitetura em Camadas

### 1. Presentation Layer

**Responsabilidade**: Interface do usuário e interação

**Componentes**:
- SwiftUI Views (ContentView, LogListView, PreferencesView)
- ViewModels (@ObservedObject, @StateObject)
- UI Components reutilizáveis (ArtworkWidgetView)
- Menu Bar (NSStatusItem, NSPopover)

**Tecnologias**: SwiftUI, AppKit (Menu Bar)

**Características**:
- Declarativa (SwiftUI)
- Reativa (Combine, @Published)
- State-driven
- Sem lógica de negócio

**Exemplo**:
```swift
struct ContentView: View {
    @EnvironmentObject var lastfm: LastFMClient
    @EnvironmentObject var artwork: ArtworkStore
    
    var body: some View {
        VStack {
            // UI declarativa
        }
        .onAppear {
            // Inicialização mínima
        }
    }
}
```

### 2. Business Logic Layer

**Responsabilidade**: Lógica de negócio, orquestração, casos de uso

**Componentes**:
- **ScrobbleManager**: Gerencia lógica de scrobbling
  - Thresholds (50% ou 4 min)
  - Timers para scrobble automático
  - Estado da música atual
  - Comunicação com LastFMClient
  
- **LastFMClient**: Cliente da API Last.fm
  - Autenticação OAuth
  - Now Playing updates
  - Scrobble submissions
  - Recent tracks fetch
  - Artwork fetch
  
- **MusicEventListener**: Escuta eventos do Apple Music
  - Distributed Notifications
  - Parsing de metadata
  - Estado (Playing/Paused/Stopped)
  
- **ConfigurationManager** (v0.9.1): Gerenciamento de configurações
  - Carregamento hierárquico
  - Validação
  - Type-safe access
  
- **KeychainService** (v0.9.2): Gerenciamento de credenciais
  - CRUD operations
  - Migração automática
  - Type-safe storage
  
- **LaunchAtLoginManager**: Gerencia launch at login
  - ServiceManagement framework (macOS 13+)
  - Fallback manual (macOS 12-)

**Padrões**:
- Manager pattern
- Observer pattern (Combine)
- Strategy pattern (configuration loading)
- Protocol-oriented design

**Exemplo**:
```swift
@MainActor
final class ScrobbleManager: ObservableObject {
    private let lastfm: LastFMClient
    private let context: NSManagedObjectContext
    
    func handle(_ np: NowPlayingInfo) {
        // Lógica de scrobbling
        // Thresholds, timers, states
    }
}
```

### 3. Data Layer

**Responsabilidade**: Persistência e gerenciamento de dados locais

**Componentes**:
- **CoreDataStack**: Stack de Core Data
  - NSPersistentContainer
  - Managed Object Model programático
  - Thread-safe contexts
  
- **KeychainService** (v0.9.2): Armazenamento seguro
  - Credenciais Last.fm (session, username)
  - API credentials
  - Type-safe structs (KeychainItem)
  - Error handling robusto (KeychainError)
  
- **KeychainHelper** (deprecated): Sistema antigo
  - Mantido para compatibilidade
  - Será removido em v1.0.0
  
- **Models**: Entidades de domínio
  - LogEntry (Core Data)
  - NowPlayingInfo (struct)
  - KeychainItem (struct)

**Características**:
- Thread-safe
- Transactional (Core Data)
- Encrypted (Keychain)
- Type-safe (v0.9.2+)

**Exemplo**:
```swift
final class CoreDataStack {
    static let shared = CoreDataStack()
    let container: NSPersistentContainer
    
    private init() {
        // Configuração programática
    }
}
```

### 4. Network Layer

**Responsabilidade**: Comunicação HTTP e gerenciamento de rede

**Componentes**:
- **LastFMClient**: Cliente HTTP Last.fm
  - URLSession customizado
  - Request building
  - Response parsing
  - Error handling
  - MD5 signing (API signature)
  
- **Utilities**:
  - Crypto+MD5: Hashing para API signatures
  - Error types (LastFMError)

**Características**:
- Async/await ready (parcial em v0.9.2)
- Error handling estruturado
- Retry logic (planejado)
- Rate limiting (planejado)

**Exemplo**:
```swift
@MainActor
final class LastFMClient: ObservableObject {
    private let api = "https://ws.audioscrobbler.com/2.0/"
    
    func scrobble(artist: String, track: String, ...) async throws {
        // HTTP POST com signing
    }
}
```

### 5. External Services

**Responsabilidade**: Integração com serviços externos

**Serviços**:
- **Last.fm API**: Scrobbling e metadata
- **Apple Music**: Eventos de reprodução (Distributed Notifications)
- **System Services**: Keychain, ServiceManagement, etc.

---

## 📁 Estrutura de Diretórios
```
NowPlaying/
│
├── Sources/
│   │
│   ├── App/                          # 🎨 Presentation Layer
│   │   ├── NowPlayingApp.swift       # Entry point, app lifecycle
│   │   ├── ContentView.swift         # View principal
│   │   ├── MenuBarPanelView.swift    # Popover do menu bar
│   │   ├── LogListView.swift         # Lista de logs com filtros
│   │   ├── RecentTracksView.swift    # Lista de tracks recentes
│   │   ├── PreferencesView.swift     # Tela de preferências
│   │   ├── ArtworkWidgetView.swift   # Widget de artwork compacto
│   │   └── LaunchAtLoginManager.swift # Manager de launch at login
│   │
│   └── Core/                         # 🧠 Business Logic + Data Layer
│       │
│       ├── Models/                   # Domain models
│       │   └── Models.swift          # LogEntry (Core Data entity)
│       │
│       ├── Services/                 # Business logic services
│       │   ├── LastFMClient.swift    # Cliente API Last.fm
│       │   ├── MusicEventListener.swift # Escuta Apple Music
│       │   └── ScrobbleManager.swift # Lógica de scrobbling
│       │
│       ├── Configuration/            # 🔧 Configuration (v0.9.1)
│       │   ├── ConfigurationManager.swift # Gerenciador central
│       │   └── Config.swift          # Config legada (deprecated)
│       │
│       ├── Keychain/                 # 🔐 Keychain (v0.9.2)
│       │   ├── KeychainError.swift   # Sistema de erros
│       │   ├── KeychainItem.swift    # Structs type-safe
│       │   ├── KeychainServiceProtocol.swift # Abstração
│       │   ├── ModernKeychainService.swift # Implementação
│       │   └── KeychainHelper.swift  # Legacy (deprecated)
│       │
│       ├── Persistence/              # 💾 Data persistence
│       │   └── CoreDataStack.swift   # Core Data stack
│       │
│       └── Utilities/                # 🛠️ Utilities
│           ├── ArtworkStore.swift    # Gerencia artworks (@MainActor)
│           ├── Crypto+MD5.swift      # MD5 hashing
│           └── Date+Fmt.swift        # Date formatters
│
├── Configuration/                    # ⚙️ Build configuration (v0.9.1)
│   ├── Secrets.template.xcconfig     # Template versionado
│   └── Secrets.xcconfig              # Credenciais reais (não versionado)
│
├── Resources/                        # 🎨 Assets e recursos
│   └── Assets.xcassets/
│       ├── AppIcon.appiconset/
│       └── Icon Status Badge.iconset/
│
├── Tests/                            # 🧪 Testes (Fase 5)
│   ├── UnitTests/
│   └── UITests/
│
├── Documentation/                    # 📚 Documentação
│   ├── CHANGELOG.md
│   ├── ARCHITECTURE.md
│   └── CONTRIBUTING.md
│
├── NowPlaying.xcodeproj/
├── NowPlaying.entitlements           # Entitlements
├── Info.plist
├── .gitignore
└── README.md
```

---

## 🔧 Componentes Principais

### LastFMClient

**Responsabilidade**: Cliente da API Last.fm

**Funcionalidades**:
- Autenticação OAuth
  - `getToken()`: Obtém token temporário
  - `authURL(token:)`: URL de autorização
  - `getSession(with:)`: Troca token por session key
  - `signOut()`: Remove credenciais
  
- Scrobbling
  - `updateNowPlaying()`: Atualiza "Now Playing"
  - `scrobble()`: Submete scrobble
  - `fetchRecentTracks()`: Busca histórico
  
- Artwork
  - `fetchArtworkURL()`: Busca URL de artwork (track.getInfo, album.getInfo)

**Estado**:
- `@Published var sessionKey: String?`
- `@Published var username: String?`

**Persistência**:
- Session key e username no Keychain (via KeychainService)

**Segurança**:
- API signature via MD5 (apiSig method)
- HTTPS obrigatório
- Credenciais no Keychain

**Exemplo de uso**:
```swift
let client = LastFMClient()
await client.getSession(with: token)
try await client.scrobble(artist: "Artist", track: "Track", timestamp: ts)
```

### ScrobbleManager

**Responsabilidade**: Orquestração de scrobbling

**Lógica de Negócio**:
1. **Estado da Música**:
   - Tracking de música atual (key = "artist|track|album")
   - Data de início (`currentStartDate`)
   - Duração total (`currentTotalSec`)

2. **Thresholds**:
   - Mínimo: 30 segundos
   - Ideal: 50% da música OU 4 minutos (240 seg)
   - Máximo: 240 segundos

3. **Timer Automático**:
   - Agenda scrobble quando threshold é atingido
   - Cancela se música pausa/para
   - Scrobble imediato se música muda

4. **Now Playing**:
   - Atualiza quando música inicia
   - Busca artwork automaticamente
   - Persiste no ArtworkStore

5. **Logging**:
   - Cria LogEntry para cada operação
   - Status: "ok" ou "failed"
   - Extra info para erros

**Estados**:
- Playing → Inicia tracking, agenda timer
- Paused → Cancela timer
- Stopped → Verifica threshold, scrobble se necessário

**Exemplo**:
```swift
let manager = ScrobbleManager(lastfm: client, context: context, artwork: artwork)
manager.handle(nowPlayingInfo)
```

### MusicEventListener

**Responsabilidade**: Escuta eventos do Apple Music

**Mecanismo**:
- Distributed Notifications (`com.apple.Music.playerInfo`)
- Polling: Não, event-driven ✅
- Thread: Main queue

**Dados Capturados**:
```swift
struct NowPlayingInfo {
    let state: String        // "Playing", "Paused", "Stopped"
    let name: String?        // Título da música
    let artist: String?      // Nome do artista
    let album: String?       // Nome do álbum
    let totalMs: Int?        // Duração total em milissegundos
}
```

**Uso**:
```swift
MusicEventListener.shared.start { info in
    scrobbleManager.handle(info)
}
```

### ConfigurationManager (v0.9.1)

**Responsabilidade**: Gerenciamento centralizado de configurações

**Hierarquia de Carregamento**:
1. **Environment Variables** (runtime, máxima prioridade)
2. **Info.plist** (build-time via xcconfig)
3. **Keychain** (credenciais sensíveis) ← v0.9.2
4. **Fallback hardcoded** (temporário)
5. **Default value**

**Configurações**:
- `lastFMAPIKey`: API Key do Last.fm
- `lastFMSharedSecret`: Shared Secret do Last.fm
- `lastFMAPIEndpoint`: URL da API
- `logLevel`: Nível de log (debug, info, warning, error)
- `analyticsEnabled`: Flag de analytics

**Validação**:
```swift
try ConfigurationManager.shared.validate()
// Lança ConfigurationError se inválido
```

**Uso**:
```swift
let config = ConfigurationManager.shared
let apiKey = config.lastFMAPIKey
let credentials = config.lastFMCredentials
```

### KeychainService (v0.9.2)

**Responsabilidade**: Armazenamento seguro type-safe de credenciais

**Protocol-Oriented**:
```swift
protocol KeychainServiceProtocol {
    func save(_ item: KeychainItem) throws
    func load(account: String, service: String) throws -> KeychainItem
    func update(_ item: KeychainItem) throws
    func delete(account: String, service: String) throws
    func exists(account: String, service: String) -> Bool
}
```

**Implementação**:
```swift
@MainActor
final class KeychainService: KeychainServiceProtocol {
    static let shared = KeychainService()
    
    // CRUD operations usando Security framework
    // Error handling robusto
    // Migration support
}
```

**Type-Safe Structs**:
```swift
struct KeychainItem {
    let account: String
    let service: String
    let data: Data
    let accessGroup: String?
    let accessibility: Accessibility
}

enum Accessibility {
    case whenUnlocked
    case afterFirstUnlock
    // ...
}
```

**Factory Methods**:
```swift
KeychainItem.lastFMSession(sessionKey: "...")
KeychainItem.lastFMUsername(username: "...")
```

**Error Handling**:
```swift
enum KeychainError: LocalizedError {
    case itemNotFound
    case accessDenied
    case duplicateItem
    case invalidData
    // ...
}
```

**Uso**:
```swift
let service = KeychainService.shared
try service.saveLastFMSession("session_key")
let sessionKey = try service.loadLastFMSession()
```

### CoreDataStack

**Responsabilidade**: Gestão do Core Data

**Configuração**:
- Modelo programático (sem .xcdatamodeld)
- NSPersistentContainer
- SQLite backend
- Localização: ~/Library/Application Support/NowPlaying/

**Entidades**:
- **LogEntry**: Histórico de scrobbles
  - id (UUID)
  - date (Date)
  - kind (String): "nowPlaying" ou "scrobble"
  - status (String): "ok" ou "failed"
  - track, artist, album (String)
  - extra (String?): Mensagem de erro

**Thread-Safety**:
- viewContext: Main thread
- backgroundContext: Background thread (se necessário)

**Uso**:
```swift
let context = CoreDataStack.shared.container.viewContext
LogEntry.create(context: context, kind: "scrobble", status: "ok", ...)
```

---

## 🔄 Fluxo de Dados

### Fluxo de Scrobbling
```
┌─────────────────────┐
│   Apple Music       │ Reproduz música
└──────────┬──────────┘
           │
           │ Distributed Notification
           │ (com.apple.Music.playerInfo)
           ↓
┌─────────────────────┐
│ MusicEventListener  │ Captura evento
└──────────┬──────────┘
           │
           │ NowPlayingInfo
           ↓
┌─────────────────────┐
│  ScrobbleManager    │ Analisa estado
└──────────┬──────────┘
           │
           ├─→ Playing: Inicia tracking, agenda timer
           ├─→ Paused: Cancela timer
           └─→ Stopped: Verifica threshold, scrobble
           
           │
           │ async/await
           ↓
┌─────────────────────┐
│   LastFMClient      │ HTTP requests
└──────────┬──────────┘
           │
           ├─→ updateNowPlaying() → Last.fm API
           └─→ scrobble() → Last.fm API
           
           │
           │ Resultado
           ↓
┌─────────────────────┐
│   CoreDataStack     │ Persiste log
└─────────────────────┘
```

### Fluxo de Autenticação
```
┌─────────────────────┐
│    ContentView      │ User clica "Conectar"
└──────────┬──────────┘
           │
           │ Task { await startAuth() }
           ↓
┌─────────────────────┐
│   LastFMClient      │ getToken()
└──────────┬──────────┘
           │
           │ token
           ↓
┌─────────────────────┐
│   NSWorkspace       │ Abre navegador
└─────────────────────┘
           
           [User autoriza no navegador]
           
┌─────────────────────┐
│    ContentView      │ User clica "Já autorizei"
└──────────┬──────────┘
           │
           │ Task { await completeAuth() }
           ↓
┌─────────────────────┐
│   LastFMClient      │ getSession(with: token)
└──────────┬──────────┘
           │
           │ session key, username
           ↓
┌─────────────────────┐
│  KeychainService    │ Salva credenciais
└─────────────────────┘
           │
           │ @Published update
           ↓
┌─────────────────────┐
│    ContentView      │ UI atualiza
└─────────────────────┘
```

### Fluxo de Configuração (v0.9.1)
```
┌─────────────────────┐
│ NowPlayingApp.swift │ applicationDidFinishLaunching()
└──────────┬──────────┘
           │
           │ validate()
           ↓
┌─────────────────────────────────────────┐
│      ConfigurationManager               │
└──────────┬──────────────────────────────┘
           │
           │ Carrega hierarquicamente:
           │
           ├─→ 1. Environment Variables
           │      ProcessInfo.processInfo.environment
           │
           ├─→ 2. Info.plist
           │      Bundle.main.infoDictionary
           │      (populado via Secrets.xcconfig)
           │
           ├─→ 3. Keychain (v0.9.2)
           │      KeychainService.shared.loadString()
           │
           ├─→ 4. Fallback hardcoded
           │      Valores temporários
           │
           └─→ 5. Default value
                  Valor padrão do método
           
           │
           │ Validação
           ↓
┌─────────────────────┐
│  LastFMClient       │ Usa configurações
└─────────────────────┘
```

---

## 🔐 Segurança

### Estratégia de Segurança (v0.9.1 + v0.9.2)

#### 1. Credenciais Protegidas

**API Credentials**:
- ✅ Removidas do código-fonte (v0.9.1)
- ✅ Carregadas via ConfigurationManager
- ✅ Migradas para Keychain (v0.9.2)
- ✅ Secrets.xcconfig não versionado
- ⚠️ Fallback temporário (será removido em v1.0.0)

**User Credentials**:
- ✅ Session key no Keychain (type-safe)
- ✅ Username no Keychain (type-safe)
- ✅ Nunca logados completamente
- ✅ Acessibilidade: `whenUnlocked`

#### 2. Keychain (v0.9.2)

**Type-Safety**:
```swift
// ❌ Antes (v1.4)
KeychainHelper.shared.set("value", for: "key")
let value = KeychainHelper.shared.get("key") // String?

// ✅ Agora (v0.9.2)
let item = KeychainItem.lastFMSession(sessionKey: "value")
try KeychainService.shared.save(item)
let sessionKey = try KeychainService.shared.loadLastFMSession() // String
```

**Error Handling**:
```swift
do {
    let item = try KeychainService.shared.load(account: "...", service: "...")
} catch KeychainError.itemNotFound {
    // Item não existe
} catch KeychainError.accessDenied {
    // Sem permissão
} catch {
    // Outro erro
}
```

**Níveis de Acessibilidade**:
- `whenUnlocked`: Dados acessíveis apenas quando dispositivo desbloqueado (padrão)
- `afterFirstUnlock`: Acessível após primeiro desbloqueio (para background)
- `whenUnlockedThisDeviceOnly`: Não sincroniza via iCloud

#### 3. App Sandbox

**Status Atual** (v0.9.2):
- ⚠️ **Desabilitado**: `com.apple.security.app-sandbox: false`
- **Razão**: Facilitar desenvolvimento inicial
- **Planejado**: v0.9.3 (Fase 1.3) habilitará sandbox

**Futuro** (v0.9.3):
- ✅ App Sandbox habilitado
- ✅ Entitlements mínimos necessários
- ✅ Network: Client only
- ✅ Apple Events: Somente Apple Music
- ✅ Keychain: Grupo próprio do app

#### 4. Logs Seguros

**Princípios**:
- Nunca logar credenciais completas
- Mascarar valores sensíveis
- Logs informativos sem comprometer segurança

**Exemplos**:
```swift
// ✅ Bom
print("API Key: \(apiKey.prefix(8))...")  // "3201db2d..."

// ✅ Bom
print("✅ Session key carregada do Keychain")

// ❌ Ruim
print("API Key: \(apiKey)")  // Expõe credencial completa
```

#### 5. Validação

**Configuração** (v0.9.1):
```swift
try ConfigurationManager.shared.validate()
// Verifica:
// - API Key existe e >= 20 chars
// - Shared Secret existe e >= 20 chars
// - Endpoint é HTTPS válido
// - Não usa placeholders
```

**Keychain** (v0.9.2):
```swift
KeychainService.shared.validateKeychainAccess()
// Testa:
// - Salvar item
// - Carregar item
// - Deletar item
// Retorna: Bool (sucesso/falha)
```

---

## 💾 Persistência

### Core Data

**Stack**:
- NSPersistentContainer
- SQLite backend
- Modelo programático

**Localização**:
```
~/Library/Application Support/NowPlaying/Scrobble.sqlite
```

**Schema**:

**LogEntry**:
| Campo   | Tipo     | Obrigatório | Descrição                    |
|---------|----------|-------------|------------------------------|
| id      | UUID     | ✅          | Identificador único          |
| date    | Date     | ✅          | Data/hora do evento          |
| kind    | String   | ✅          | "nowPlaying" ou "scrobble"   |
| status  | String   | ✅          | "ok" ou "failed"             |
| track   | String   | ✅          | Nome da música               |
| artist  | String   | ✅          | Nome do artista              |
| album   | String   | ❌          | Nome do álbum (opcional)     |
| extra   | String   | ❌          | Info extra (erro, etc)       |

**Queries**:
```swift
// Buscar 200 mais recentes
let req = LogEntry.fetchRequestRecent(limit: 200)
// Ordenado por: date DESC

// Criar novo log
LogEntry.create(
    context: context,
    kind: "scrobble",
    status: "ok",
    track: "Song",
    artist: "Artist",
    album: "Album",
    extra: nil
)
```

**Thread-Safety**:
- viewContext: @MainActor
- Saves automáticos após create

### Keychain (v0.9.2)

**Items Armazenados**:
| Account              | Tipo    | Descrição            |
|----------------------|---------|----------------------|
| lastfm_session_key   | String  | Session key Last.fm  |
| lastfm_username      | String  | Username Last.fm     |

**Service**: Bundle ID do app (`com.diegocastilho.NowPlaying`)

**Acessibilidade**: `whenUnlocked` (padrão)

**Migration**:
- Detecta dados antigos (`KeychainHelper`)
- Migra automaticamente no primeiro launch
- Remove formato antigo após migração

### UserDefaults

**Uso Atual**: Mínimo

**Dados**:
- Launch at login preference (macOS 12 fallback)
- Window state (futuro)

**Princípios**:
- Não armazenar dados sensíveis
- Apenas preferências de UI
- Validar ao carregar

---

## 🌐 Networking

### Last.fm API Client

**Base URL**: `https://ws.audioscrobbler.com/2.0/`

**Autenticação**:
- OAuth-like flow (token → session)
- API signature via MD5
- Session key persistente

**Endpoints Usados**:

| Método                  | Endpoint                | Descrição                  |
|-------------------------|-------------------------|----------------------------|
| auth.getToken           | POST /2.0/              | Obtém token temporário     |
| auth.getSession         | POST /2.0/              | Troca token por session    |
| track.updateNowPlaying  | POST /2.0/              | Atualiza "Now Playing"     |
| track.scrobble          | POST /2.0/              | Submete scrobble           |
| user.getRecentTracks    | POST /2.0/              | Busca histórico            |
| track.getInfo           | POST /2.0/              | Busca info da música       |
| album.getInfo           | POST /2.0/              | Busca info do álbum        |

**API Signature**:
```swift
// Parâmetros ordenados alfabeticamente (exceto format, callback)
// Concatenados como: key1value1key2value2...
// Append shared secret
// MD5 hash do resultado
let signature = md5Hex(sortedParams + sharedSecret)
```

**Request Format**:
```swift
// Content-Type: application/x-www-form-urlencoded
// Body: key1=value1&key2=value2&api_sig=abc123&format=json

var request = URLRequest(url: url)
request.httpMethod = "POST"
request.setValue("application/x-www-form-urlencoded; charset=utf-8", 
                 forHTTPHeaderField: "Content-Type")
request.httpBody = params.encoded
```

**Response Format**:
```json
{
  "track": {
    "name": "Song Name",
    "artist": { "#text": "Artist Name" },
    "album": { "#text": "Album Name" }
  }
}
```

**Error Handling**:
```swift
struct LastFMError: LocalizedError {
    let code: Int
    let message: String
}

// Parsing de erros da API:
// { "error": 9, "message": "Invalid session key" }
```

**Retry Logic**:
- ❌ Não implementado ainda
- Planejado para v0.9.4 ou Fase 4

**Rate Limiting**:
- ❌ Não implementado
- Last.fm permite ~5 requests/second
- Planejado para Fase 4

---

## 🛠️ Tecnologias

### Frameworks Apple

| Framework            | Uso                                      | Versão     |
|----------------------|------------------------------------------|------------|
| SwiftUI              | Interface declarativa                    | iOS 14+    |
| AppKit               | Menu bar (NSStatusItem, NSPopover)       | macOS 12+  |
| Combine              | Programação reativa (@Published)         | iOS 13+    |
| Core Data            | Persistência de logs                     | macOS 12+  |
| Security             | Keychain Services                        | macOS 12+  |
| Foundation           | URLSession, Date, Bundle, etc            | macOS 12+  |
| ServiceManagement    | Launch at Login (macOS 13+)              | macOS 13+  |
| CryptoKit            | MD5 hashing (Insecure.MD5)               | macOS 10.15+ |

### Linguagem

- **Swift**: 5.9+
- **Xcode**: 15.6+
- **Deployment Target**: macOS 12.0 (Monterey)
- **SDK**: macOS 15.6

### Concurrency

**Atual** (v0.9.2):
- `async/await`: Parcialmente adotado (LastFMClient)
- `@MainActor`: Usado em views e managers
- Completion handlers: Ainda presente em alguns lugares

**Futuro** (v0.9.4):
- Swift Concurrency 100%
- Actors para isolamento
- TaskGroup para operações paralelas

### Dependency Management

**Atual**: Nenhum
- Sem SPM, CocoaPods, ou Carthage
- Frameworks Apple apenas

**Futuro**:
- SPM considerado para bibliotecas externas
- Mantém dependências mínimas

---

## 📏 Padrões e Convenções

### Código

**Naming**:
- Classes: PascalCase (`LastFMClient`)
- Métodos: camelCase (`updateNowPlaying`)
- Variáveis: camelCase (`sessionKey`)
- Constantes: camelCase (`apiEndpoint`)
- Enums: PascalCase (`KeychainError`)

**Organização**:
- MARK: para seções
- Extensões para conformance de protocols
- Computed properties antes de métodos
- Private no final

**Exemplo**:
```swift
final class MyClass {
    // MARK: - Properties
    
    private let service: Service
    var publicProperty: String
    
    // MARK: - Initialization
    
    init(service: Service) {
        self.service = service
    }
    
    // MARK: - Public Methods
    
    func publicMethod() {}
    
    // MARK: - Private Methods
    
    private func privateMethod() {}
}

// MARK: - Protocol Conformance

extension MyClass: SomeProtocol {
    func protocolMethod() {}
}
```

### Arquitetura

**Princípios**:
- Protocol-oriented design
- Dependency Injection (em progresso)
- Single Responsibility
- Separation of Concerns
- Testability

**Patterns**:
- Manager/Service pattern
- Observer (Combine)
- Singleton (controlado, com DI no futuro)
- Factory (KeychainItem)
- Strategy (ConfigurationManager)

### Git

**Branches**:
- `main`: Código estável
- `feature/*`: Features em desenvolvimento
- `hotfix/*`: Correções urgentes

**Commits**: [Conventional Commits](https://www.conventionalcommits.org/)
```
feat: adiciona nova funcionalidade
fix: corrige bug
docs: atualiza documentação
refactor: refatora código
test: adiciona testes
chore: tarefas diversas
```

**Tags**: Semantic Versioning
```
v0.9.2
v1.0.0
```

### Documentação

**Código**:
- Comments para lógica complexa
- DocC style para APIs públicas
- MARK para organização

**Projeto**:
- README.md: Overview
- CHANGELOG.md: Histórico de versões
- ARCHITECTURE.md: Este arquivo
- CONTRIBUTING.md: Guia de contribuição (futuro)

---

## 🧪 Testes

### Status Atual (v0.9.2)

- **Cobertura**: 0%
- **Testes Unitários**: Não implementados
- **Testes de UI**: Não implementados
- **Testes de Integração**: Não implementados

### Estratégia de Testes (Fase 5)

#### Testes Unitários

**Target de Cobertura**: 80%+

**Prioridade**:
1. **Alta** (> 90%):
   - KeychainService
   - ConfigurationManager
   - LastFMClient (métodos core)
   - ScrobbleManager (lógica de threshold)

2. **Média** (> 70%):
   - Models (LogEntry)
   - Utilities (MD5, Date formatters)

3. **Baixa** (> 50%):
   - Views (SwiftUI)
   - UI logic

**Mocks Necessários**:
```swift
// KeychainServiceProtocol mock
class MockKeychainService: KeychainServiceProtocol {
    var savedItems: [String: KeychainItem] = [:]
    
    func save(_ item: KeychainItem) throws {
        savedItems[item.account] = item
    }
    
    func load(account: String, service: String) throws -> KeychainItem {
        guard let item = savedItems[account] else {
            throw KeychainError.itemNotFound
        }
        return item
    }
}

// LastFMClient mock
class MockLastFMClient: LastFMClient {
    var scrobbleCallCount = 0
    var shouldFail = false
    
    override func scrobble(...) async throws {
        scrobbleCallCount += 1
        if shouldFail { throw LastFMError(...) }
    }
}
```

#### Testes de UI

**Framework**: XCTest UI Testing

**Cenários**:
- Login flow completo
- Scrobble de uma música
- Filtros de log
- Preferências

#### Testes de Integração

**Cenários**:
- Autenticação Last.fm end-to-end (staging)
- Persistência Core Data + Keychain
- Migração de dados antigos

---

## ⚡ Performance

### Otimizações Atuais

**Carregamento Lazy**:
- ConfigurationManager: Properties lazy
- Core Data: Fetch on demand

**Main Thread**:
- @MainActor para UI
- Background processing mínimo

**Memory**:
- Artwork cache in-memory (ArtworkStore)
- Core Data batch sizes (limit: 200)

### Métricas (Informal)

**Startup Time**: < 1 segundo
**Memory Usage**: ~30-50 MB
**CPU Usage**: < 1% (idle), < 5% (scrobbling)
**Network**: Apenas quando necessário

### Planos Futuros

**Fase 5** (Performance optimization):
- Profiling com Instruments
- Redução de allocations
- Otimização de queries Core Data
- Image caching otimizado
- Background fetch strategies

---

## 🚀 Deployment

### Build Configuration

**Debug**:
- Optimizations: `-Onone`
- Assertions: Enabled
- Logging: Verbose

**Release**:
- Optimizations: `-O`
- Assertions: Disabled
- Logging: Errors only

### Deployment Target

- **Atual**: macOS 12.0 (Monterey)
- **Recomendado**: macOS 14.0+ (Sonoma)
- **Reasoning**: Manter compatibilidade ampla

### Entitlements

**Atual** (v0.9.2):
```xml
<key>com.apple.security.app-sandbox</key>
<false/>
<key>com.apple.security.automation.apple-events</key>
<true/>
<key>com.apple.security.network.client</key>
<true/>
```

**Futuro** (v0.9.3):
```xml
<key>com.apple.security.app-sandbox</key>
<true/>
<key>com.apple.security.network.client</key>
<true/>
<key>com.apple.security.automation.apple-events</key>
<true/>
<key>com.apple.security.application-groups</key>
<array>
    <string>group.com.diegocastilho.NowPlaying</string>
</array>
```

### Distribution

**Planejado** (Fase 6):
- **Mac App Store**: Objetivo principal
- **Notarization**: Obrigatório
- **Code Signing**: Certificado Developer ID
- **Sandboxing**: Habilitado

---

## 🗺️ Roadmap Arquitetural

### Fase 1: Fundação e Segurança (40% completo)

- ✅ v0.9.1: Sistema de Configuração Seguro
- ✅ v0.9.2: Modernização do Keychain
- ⏳ v0.9.3: App Sandbox + Entitlements
- ⏳ v0.9.4: Padrões Modernos Swift (async/await, actors)
- ⏳ v0.9.5: Dependency Injection

### Fase 2: Interface Liquid Glass (0%)

- Design System
- Componentes reutilizáveis
- Animações fluidas
- Micro-interações

### Fase 3: Widget de Desktop (0%)

- WidgetKit integration
- App Intents
- Timeline provider
- Configuração

### Fase 4: Recursos Avançados (0%)

- Estatísticas avançadas
- Gráficos de escuta
- Insights de padrões
- Exportação de dados

### Fase 5: Qualidade e Polish (0%)

- Testes unitários (80%+ coverage)
- Testes de UI
- Performance optimization
- Accessibility

### Fase 6: Distribuição (0%)

- Mac App Store submission
- Code signing
- Notarization
- Release notes

---

## 📚 Referências

### Apple Documentation

- [SwiftUI](https://developer.apple.com/documentation/swiftui)
- [Core Data](https://developer.apple.com/documentation/coredata)
- [Keychain Services](https://developer.apple.com/documentation/security/keychain_services)
- [App Sandbox](https://developer.apple.com/documentation/security/app_sandbox)
- [Distributed Notifications](https://developer.apple.com/documentation/foundation/distributednotificationcenter)

### Last.fm API

- [API Documentation](https://www.last.fm/api)
- [Authentication](https://www.last.fm/api/authentication)
- [Scrobbling](https://www.last.fm/api/scrobbling)

### Best Practices

- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- [Keep a Changelog](https://keepachangelog.com/)
- [Semantic Versioning](https://semver.org/)
- [Conventional Commits](https://www.conventionalcommits.org/)

---

**Última Atualização**: 22 de outubro de 2025  
**Versão**: 0.9.2  
**Mantenedor**: Diego Castilho
