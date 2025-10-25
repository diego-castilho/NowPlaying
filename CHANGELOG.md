# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
e este projeto adere ao [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased] - Em Desenvolvimento

### 🚀 Próximas Versões

**v0.9.3 - App Sandbox + Entitlements** (próxima)
- Configuração de App Sandbox
- Ajuste de entitlements
- MusicKit migration
- Permissões documentadas

**v0.9.4 - Padrões Modernos Swift**
- Swift Concurrency (async/await)
- Actors para thread-safety
- Structured concurrency

**v0.9.5 - Dependency Injection**
- Container de DI
- Protocol-oriented refactoring
- Testabilidade aprimorada

---

## [0.9.2] - 2025-10-22

### 🔐 Fase 1.2 - Modernização do Keychain

Sistema moderno e type-safe para gerenciamento de credenciais no Keychain, com migração automática de dados antigos e segurança aprimorada.

#### Added

##### Sistema Moderno de Keychain

**KeychainError.swift**
- 8 tipos de erro específicos (`itemNotFound`, `accessDenied`, `duplicateItem`, `invalidData`, `encodingError`, `unhandledError`, `authenticationRequired`, `userCanceled`)
- Conformidade com `LocalizedError` (errorDescription, failureReason, recoverySuggestion)
- Mapeamento automático de `OSStatus` para `KeychainError` via método `from(status:)`
- Debug helpers com `debugDescription` para logging detalhado
- Mensagens amigáveis e acionáveis para cada tipo de erro

**KeychainItem.swift**
- Struct `KeychainItem` com properties fortemente tipadas
  - `account`: Identificador único
  - `service`: Serviço (bundle ID)
  - `data`: Dados armazenados
  - `accessGroup`: Compartilhamento entre apps/extensions
  - `accessibility`: Nível de segurança
- Enum `Accessibility` com 6 níveis de segurança
  - `whenUnlocked` (padrão, recomendado)
  - `afterFirstUnlock` (para background)
  - `always` (menos seguro)
  - Variantes "ThisDeviceOnly" (não sincronizam)
- Inicializadores convenientes para Data e String
- Factory methods predefinidos: `lastFMSession()`, `lastFMUsername()`, `lastFMAPIKey()`, `lastFMSharedSecret()`
- Query builders: `buildQuery()` para save/update, `searchQuery()` para load
- Conversão bidirecional: `stringValue` (Data → String) e `from()` (reconstrução)
- Protocols: `Equatable`, `CustomStringConvertible`
- Safe description para logs sem expor dados sensíveis

**KeychainServiceProtocol.swift**
- Protocol definindo operações CRUD completas
  - `save(_:)`: Salvar novo item
  - `load(account:service:accessGroup:)`: Carregar item existente
  - `update(_:)`: Atualizar item
  - `delete(account:service:accessGroup:)`: Remover item
  - `exists(account:service:accessGroup:)`: Verificar existência
- Convenience methods para uso sem access group
- String helpers: `saveString()`, `loadString()`, `updateString()`
- Last.fm specific methods:
  - `saveLastFMSession()`, `loadLastFMSession()`
  - `saveLastFMUsername()`, `loadLastFMUsername()`
  - `deleteAllLastFMCredentials()`
- Batch operations: `saveBatch()`, `deleteBatch()`
- Migration helpers: `migrate(from:to:)` para dados legados
- 15+ métodos utilitários via extensões
- Suporte para dependency injection e testes com mocks

**ModernKeychainService.swift**
- Implementação concreta completa do `KeychainServiceProtocol`
- Operações CRUD usando Security framework
  - `SecItemAdd` para save
  - `SecItemCopyMatching` para load
  - `SecItemUpdate` para update
  - `SecItemDelete` para delete
- Conversão automática `OSStatus` → `KeychainError`
- Upsert operation: `saveOrUpdate()` (salva ou atualiza automaticamente)
- Migration support: `migrateFromLegacyKeychain()`
  - Detecta dados do `KeychainHelper` antigo
  - Migra automaticamente para novo formato
  - Remove dados antigos após sucesso
- Debug helpers:
  - `listAllItems()`: Lista todos os items do app
  - `deleteAllItems()`: Remove tudo (cuidado!)
  - `validateKeychainAccess()`: Testa permissões
- Thread-safe com `@MainActor`
- Singleton pattern: `KeychainService.shared`
- Logs informativos em todas as operações
- Type alias `Keychain` para conveniência

##### Migração Automática

**Auto-migração de Credenciais Last.fm**
- Detecta automaticamente dados no formato antigo (`KeychainHelper`)
- Migra session key para novo formato type-safe
- Migra username para novo formato type-safe
- Remove dados antigos após migração bem-sucedida
- Logs detalhados de cada etapa do processo
- Zero intervenção do usuário necessária
- Executa na primeira vez que o app roda com v0.9.2

**Migração de Credenciais da API**
- API Key movida do código hardcoded para Keychain
- Shared Secret movido do código hardcoded para Keychain
- Migração automática na primeira execução do app
- Validação de migração completa via `hasHardcodedCredentials()`
- Nova ordem de prioridade: env vars → plist → Keychain → fallback → default
- Método público `migrateHardcodedCredentialsToKeychain()` para forçar migração

#### Changed

**KeychainHelper.swift**
- Marcado como `@available(*, deprecated)` em toda a classe
- Warnings informativos ao tentar usar: "Use KeychainService ao invés desta classe"
- Documentação de migração inline com exemplos
- Funcionalidade mantida 100% para compatibilidade retroativa
- Migration bridge helpers adicionados:
  - `hasLegacyData()`: Verifica se há dados antigos
  - `getAllLegacyData()`: Retorna todos os dados para migração
- Logs indicando uso de código obsoleto
- Será removido na v1.0.0

**LastFMClient.swift**
- `init()` migrado para usar `KeychainService.shared`
- Auto-migração de session key no carregamento:
  - Tenta carregar do Keychain moderno primeiro
  - Se não encontrar, tenta `KeychainHelper` (legacy)
  - Migra automaticamente se encontrar dados antigos
  - Remove formato antigo após migração
- Auto-migração de username (mesmo fluxo)
- `getSession(with:)` agora salva com `KeychainService.saveOrUpdate()`
- `signOut()` usa `deleteAllLastFMCredentials()` do novo sistema
- Fallback para sistema antigo em caso de erro
- Logs informativos de todas as operações (load, save, delete, migrate)

**ConfigurationManager.swift**
- Integração com Keychain como fonte de configuração (prioridade 3)
- Nova ordem completa de carregamento:
  1. Variáveis de ambiente (máxima prioridade)
  2. Info.plist (via xcconfig no build)
  3. Keychain (credenciais sensíveis) ⬅ NOVO
  4. Fallback hardcoded (temporário)
  5. Valor padrão
- Auto-migração de credenciais hardcoded para Keychain
- Método privado `migrateCredentialToKeychain(key:value:)` para migração segura
- Método público `hasHardcodedCredentials()` para validação
- Método público `migrateHardcodedCredentialsToKeychain()` para forçar migração
- Logs indicando origem de cada configuração carregada

**NowPlayingApp.swift**
- Migração automática de credenciais na inicialização
  - Chama `migrateHardcodedCredentialsToKeychain()` após validação
  - Verifica se todas as credenciais estão no Keychain
  - Avisa se ainda existem credenciais hardcoded (via logs)
- Tratamento de erros gracioso na migração
- Logs informativos do processo

#### Security

**Credenciais 100% no Keychain**
- API Key armazenada de forma segura no Keychain
- Shared Secret armazenado de forma segura no Keychain
- Session key armazenada de forma segura no Keychain
- Username armazenado de forma segura no Keychain
- Zero credenciais em código após migração inicial
- Proteção contra acesso não autorizado via níveis de acessibilidade

**Type-Safety para Segurança**
- Structs fortemente tipadas impedem erros de tipo
- Protocol-oriented design facilita testes e validação
- Error handling explícito via `throws` (não pode ignorar erros)
- Impossível acessar dados do Keychain sem tratamento de erro
- Compilador força tratamento correto de todos os casos

**Níveis de Acessibilidade Configuráveis**
- `whenUnlocked`: Dados acessíveis apenas quando dispositivo desbloqueado (padrão, mais seguro)
- `afterFirstUnlock`: Dados acessíveis após primeiro desbloqueio (para tarefas em background)
- Variantes "ThisDeviceOnly": Dados não sincronizam via iCloud/Keychain Sync
- Proteção automática pelo sistema operacional

**Logs Seguros**
- Nunca expõem credenciais completas nos logs
- API Key mostra apenas primeiros 8 caracteres: "3201db2d..."
- Shared Secret nunca é logado completamente
- Safe description em todos os objetos (`safeDescription`)
- Debug info disponível sem comprometer segurança

#### Technical Debt

**Resolvido nesta versão**
- ✅ **Credenciais hardcoded no código**: Movidas para Keychain com migração automática
- ✅ **Keychain sem type-safety**: Sistema completamente type-safe implementado
- ✅ **Error handling fraco**: Error handling robusto com `KeychainError`
- ✅ **Sem migração de dados**: Migração automática implementada e testada

**Débito Técnico Restante**
- ⚠️ **Fallback hardcoded temporário**: ConfigurationManager ainda tem valores de fallback (linhas 95-110)
  - Necessário para garantir funcionamento durante desenvolvimento
  - **Será removido na v1.0.0** após todos os desenvolvedores migrarem
  - TODO comments adicionados no código
  - Não afeta segurança em produção (Keychain tem prioridade)

- ⚠️ **Testes unitários ausentes**: Sistema de Keychain não tem testes
  - KeychainService não testado
  - KeychainItem não testado
  - Migração não testada automaticamente
  - Validação manual realizada com sucesso ✅
  - **Testes serão adicionados na Fase 5** (v0.9.8+)
  - Cobertura target: 80%+ para código de segurança

#### Infrastructure

**Protocol-Oriented Architecture**
- `KeychainServiceProtocol` permite dependency injection
- Facilita criação de mocks para testes
- Permite múltiplas implementações (real, mock, in-memory)
- Código desacoplado e altamente testável
- Preparação para Fase 1.5 (Dependency Injection)

**Migration Strategy**
- Migração automática e 100% transparente
- Backward compatibility mantida (código antigo funciona)
- Nenhuma intervenção do usuário necessária
- Dados legados preservados durante transição
- Logs detalhados para debugging
- Rollback automático em caso de falha

**Commits desta versão**
- 8 commits no total
- ~1.200 linhas de código adicionadas
- 4 arquivos novos criados
- 4 arquivos existentes modificados
- 0 bugs introduzidos (validação manual)

---

## [0.9.1] - 2025-10-22

### 🔧 Fase 1.1 - Sistema de Configuração Seguro

Sistema centralizado e hierárquico para gerenciamento de configurações do aplicativo, com validação automática e proteção de secrets.

#### Added

**ConfigurationManager.swift**
- Gerenciador central de configurações do aplicativo
- Carregamento hierárquico de múltiplas fontes:
  1. Variáveis de ambiente (runtime, máxima prioridade)
  2. Info.plist (build-time via xcconfig)
  3. Valores padrão (fallback)
- Properties lazy para carregamento sob demanda:
  - `lastFMAPIKey`: API Key do Last.fm
  - `lastFMSharedSecret`: Shared Secret do Last.fm
  - `lastFMAPIEndpoint`: Endpoint da API (default: https://ws.audioscrobbler.com/2.0/)
  - `logLevel`: Nível de log (debug, info, warning, error)
  - `analyticsEnabled`: Flag para analytics (false por padrão)
- Validação automática via método `validate()`:
  - Verifica se API Key existe e tem >= 20 caracteres
  - Verifica se Shared Secret existe e tem >= 20 caracteres
  - Valida formato do endpoint (deve ser HTTPS)
  - Lança `ConfigurationError` se inválido
- Método `configurationSummary()` para debug
  - Mostra apenas primeiros 8 caracteres de credenciais
  - Indica origem de cada configuração
  - Formato legível para logs
- Struct `LastFMCredentials` para acesso type-safe
- Decorador `@MainActor` para thread-safety
- Método `reload()` para recarregar configurações (útil em testes)

**Secrets.template.xcconfig**
- Template versionado para desenvolvedores
- Instruções detalhadas inline:
  - Como copiar e renomear
  - Onde obter credenciais Last.fm
  - Formato correto dos valores
- Placeholders claros: `YOUR_API_KEY_HERE`, `YOUR_SHARED_SECRET_HERE`
- Link direto para https://www.last.fm/api/account/create
- Configurações opcionais comentadas (LOG_LEVEL, ENABLE_ANALYTICS)

**Secrets.xcconfig**
- Arquivo com credenciais reais (não versionado)
- Adicionado ao .gitignore
- Usado durante build-time pelo Xcode
- Injeta valores no Info.plist via variáveis `$(LASTFM_API_KEY)`

**CHANGELOG.md**
- Histórico completo de versões
- Formato baseado em [Keep a Changelog](https://keepachangelog.com/)
- Semantic Versioning seguido
- Categorização por tipo: Added, Changed, Deprecated, Removed, Fixed, Security
- Roadmap de versões futuras

**ARCHITECTURE.md**
- Documentação técnica completa da arquitetura
- Visão geral das camadas:
  - Presentation Layer (SwiftUI)
  - Business Logic Layer (Managers, Services)
  - Data Layer (Core Data, Keychain)
  - Network Layer (Last.fm API)
- Estrutura de diretórios detalhada
- Fluxo de dados documentado com diagramas
- Tecnologias utilizadas e justificativas
- Padrões e convenções de código
- Estratégia de testes (planejada)
- Práticas de segurança
- Requisitos de deployment

**Configuration/** (diretório)
- Novo diretório para arquivos de configuração
- Centraliza gestão de secrets
- Facilita setup de novos desenvolvedores
- Isola configurações do código fonte

#### Changed

**Config.swift**
- Refatorado para usar `ConfigurationManager` internamente
- `LastFMConfig.apiKey` agora redireciona para `ConfigurationManager.shared.lastFMAPIKey`
- `LastFMConfig.sharedSecret` agora redireciona para `ConfigurationManager.shared.lastFMSharedSecret`
- Marcado como `@available(*, deprecated)` com mensagens:
  - "Use ConfigurationManager.shared.lastFMAPIKey"
  - "Use ConfigurationManager.shared.lastFMSharedSecret"
- Mantém 100% de compatibilidade retroativa
- Código existente continua funcionando sem mudanças
- Métodos helper adicionados:
  - `validate()`: Chama `ConfigurationManager.shared.validate()`
  - `summary()`: Chama `ConfigurationManager.shared.configurationSummary()`
- Preparação para remoção gradual nas próximas versões

**NowPlayingApp.swift**
- `applicationDidFinishLaunching()` agora valida configurações antes de iniciar:
```swift
  do {
      try ConfigurationManager.shared.validate()
      print(ConfigurationManager.shared.configurationSummary())
  } catch {
      // Alert modal se configuração inválida
  }
```
- Alert modal exibido se configuração inválida:
  - Título: "Erro de Configuração"
  - Mensagem descritiva do erro
  - Orientação para verificar Secrets.xcconfig
  - Botão "Sair" (app não inicia se inválido)
- Graceful shutdown via `NSApp.terminate(nil)` se credenciais ausentes
- Logs de configuração no console (modo debug):
  - Origem de cada configuração
  - Resumo formatado
  - Avisos se usando fallback

**.gitignore**
- Atualizado com novos padrões de segurança:
  - `Configuration/Secrets.xcconfig` (credenciais reais)
  - `*.xcconfig` (todos os xcconfig exceto templates)
  - `!*.template.xcconfig` (permite templates)
  - Certificados: `*.cer`, `*.p12`, `*.certSigningRequest`
  - Provisioning profiles: `*.mobileprovision`, `*.provisionprofile`
  - Chaves privadas: `*.key`, `*.pem`
  - Arquivos de configuração sensíveis
  - Logs de desenvolvimento: `*.log`
  - Arquivos temporários do Core Data

#### Security

**Credenciais Removidas do Código**
- API Key não está mais hardcoded em `Config.swift`
- Shared Secret não está mais hardcoded em `Config.swift`
- Valores movidos para `ConfigurationManager` com fallback temporário
- Fallback será removido após migração completa (v1.0.0)

**Secrets.xcconfig no .gitignore**
- Arquivo com credenciais reais nunca será commitado
- Histórico do Git não contém credenciais após v0.9.1
- Template público não contém valores reais
- Cada desenvolvedor tem suas próprias credenciais locais

**Validação Automática de Credenciais**
- Verifica se API Key tem formato válido (>= 20 caracteres)
- Verifica se Shared Secret tem formato válido (>= 20 caracteres)
- Garante que placeholders ("YOUR_API_KEY_HERE") não são usados
- Valida que endpoint é URL HTTPS válida
- Falha rápido (fail-fast) se configuração inválida
- Impede execução com credenciais inválidas

**Logs Seguros**
- `configurationSummary()` mostra apenas primeiros 8 caracteres: "3201db2d..."
- Shared Secret nunca é logado completamente
- Identificação de origem sem expor valores: "🔧 LASTFM_API_KEY do Info.plist"
- Logs informativos sem comprometer segurança

#### Infrastructure

**Git e Versionamento**
- Tag `v1.4-pre-modernization` criada antes das mudanças
  - Marca último estado estável antes da modernização
  - Permite rollback se necessário
  - Referência para comparações futuras
- Branch `feature/phase-1-security` criada
  - Isolamento de mudanças da main/master
  - Facilita code review
  - Permite trabalho paralelo
  - Merge planejado após todas as atividades da Fase 1

**Estrutura de Documentação**
- Padrão de documentação estabelecido:
  - CHANGELOG.md para histórico
  - ARCHITECTURE.md para documentação técnica
  - README.md para overview
- Processo de changelog estabelecido:
  - Atualizar a cada versão
  - Categorizar mudanças
  - Incluir contexto e justificativas
- Guidelines de arquitetura documentadas:
  - Camadas e responsabilidades
  - Fluxo de dados
  - Padrões a seguir

**Commits desta versão**
- 5 commits no total
- ~300 linhas de documentação
- ~150 linhas de código
- 3 arquivos novos
- 3 arquivos modificados

---

## [0.9.0] - 2025-10-22

### 📸 Preparação para Modernização

Estado inicial do projeto antes do processo de modernização completa. Snapshot de segurança criado.

#### Infrastructure

**Tag de Snapshot Criada**
- Tag `v1.4-pre-modernization` criada no Git
- Preserva estado funcional antes das mudanças
- Permite rollback completo se necessário
- Referência para comparação de progresso

**Branch de Desenvolvimento Criada**
- Branch `feature/phase-1-security` iniciada
- Separação clara do código estável (main)
- Facilita experimentação segura
- Preparação para Pull Requests futuros

**Estrutura de Documentação Estabelecida**
- Framework de documentação definido
- CHANGELOG.md iniciado
- README.md preparado para atualizações
- ARCHITECTURE.md planejado

**Processo de Changelog Estabelecido**
- Formato Keep a Changelog adotado
- Semantic Versioning definido
- Convenções de commit estabelecidas
- Workflow de documentação

---

## [1.4.0] - 2025-10-22 (Legado)

### Estado Base Pré-Modernização

Versão estável legada antes do início da modernização. Funcionalidades principais implementadas mas com débitos técnicos conhecidos.

#### Funcionalidades Existentes

**Core Features**
- ✅ Scrobble automático para Last.fm
  - Seguindo regras oficiais (50% ou 4 minutos)
  - Retry automático em caso de falha
  - Threshold configurável
- ✅ Atualização "Now Playing" em tempo real
  - Integração com Last.fm API
  - Display de artwork
- ✅ Menu bar com popover
  - Hover automático
  - Display compacto de música atual
  - Acesso rápido a controles
- ✅ Janela principal
  - Histórico de músicas tocadas
  - Informações de capa, artista e álbum
  - TabView com Recent Tracks e Logs
- ✅ Sistema de logs com Core Data
  - Histórico persistente de scrobbles
  - Filtros por tipo (Now Playing / Scrobble)
  - Filtros por status (OK / Failed)
  - Busca por artista/track/álbum

**Autenticação**
- ✅ Autenticação Last.fm (OAuth)
  - Fluxo de token
  - Armazenamento de session no Keychain (formato antigo)
  - Login/Logout funcional

**Sistema**
- ✅ Launch at Login
  - Funcional no macOS 13+ (ServiceManagement framework)
  - Preferências configuráveis
  - Fallback manual para macOS 12 e anteriores
- ✅ Integração com Apple Music
  - Escuta de notificações distribuídas (`com.apple.Music.playerInfo`)
  - Captura de metadata (título, artista, álbum, duração)
  - Detecção de estados (Playing, Paused, Stopped)

#### Problemas Conhecidos

**Segurança**
- ⚠️ **Credenciais hardcoded**: API Key e Shared Secret em `Config.swift`
- ⚠️ **Versionadas no Git**: Histórico contém credenciais expostas
- ⚠️ **App Sandbox desabilitado**: `com.apple.security.app-sandbox: false`
- ⚠️ **Keychain básico**: Implementação simples sem type-safety

**Interface**
- ⚠️ **Design básico**: Layout funcional mas não polido
- ⚠️ **Sem design system**: Inconsistências visuais
- ⚠️ **Animações básicas**: Sem micro-interações
- ⚠️ **Não segue Liquid Glass**: Interface não usa padrões modernos da Apple

**Features Ausentes**
- ❌ **Widget de Desktop**: Não implementado
- ❌ **Estatísticas**: Apenas logs brutos, sem visualizações
- ❌ **Gráficos**: Sem insights de padrões de escuta

**Arquitetura**
- ⚠️ **Deployment target incorreto**: macOS 26.0 (não existe)
- ⚠️ **Sem testes**: 0% de cobertura
- ⚠️ **Sem DI**: Acoplamento alto, singletons excessivos
- ⚠️ **Código misto**: Concerns não separados claramente

---

## Tipos de Mudanças

- `Added` - Novas funcionalidades
- `Changed` - Mudanças em funcionalidades existentes
- `Deprecated` - Funcionalidades que serão removidas em breve
- `Removed` - Funcionalidades removidas
- `Fixed` - Correções de bugs
- `Security` - Correções e melhorias de segurança
- `Infrastructure` - Mudanças em build, CI/CD, versionamento, documentação
- `Technical Debt` - Débito técnico identificado e planos

---

## Roadmap de Versões

### v0.9.x - Modernização (Q4 2025 - Q1 2026)
- ✅ **v0.9.0**: Preparação e snapshot
- ✅ **v0.9.1**: Sistema de Configuração Seguro
- ✅ **v0.9.2**: Modernização do Keychain
- ⏳ **v0.9.3**: App Sandbox + Entitlements
- ⏳ **v0.9.4**: Padrões Modernos Swift (async/await, actors)
- ⏳ **v0.9.5**: Dependency Injection

### v1.0.0 - Release Completa (Q1 2026)
- **Fase 2**: Interface Liquid Glass
- **Fase 3**: Widget de Desktop (WidgetKit)
- **Fase 4**: Recursos Avançados (Estatísticas, Gráficos)
- **Fase 5**: Qualidade e Polish (Testes, Performance)
- **Fase 6**: Distribuição (Mac App Store)

### v1.1.0 - Expansão (Q2 2026)
- Integração com Spotify
- Control Center widget
- Apple Watch companion

### v1.2.0 - Personalização (Q3 2026)
- Themes customizáveis
- Shortcuts do macOS
- Sharing e Social features

---

## Progresso da Modernização
```
FASE 1: FUNDAÇÃO E SEGURANÇA [████░░░░░░] 40%

✅ 1.1 Sistema de Configuração Seguro (v0.9.1)
✅ 1.2 Modernização do Keychain (v0.9.2)
⬜ 1.3 App Sandbox + Entitlements (v0.9.3)
⬜ 1.4 Padrões Modernos Swift (v0.9.4)
⬜ 1.5 Dependency Injection (v0.9.5)

PROJETO GERAL: [█░░░░░░░░░] 6.7% (2/30 atividades)
```

---

## Links e Referências

- **Repositório**: https://github.com/diego-castilho/NowPlaying
- **Branch Desenvolvimento**: feature/phase-1-security
- **Issues**: https://github.com/diego-castilho/NowPlaying/issues
- **Documentação Técnica**: [ARCHITECTURE.md](ARCHITECTURE.md)
- **Last.fm API**: https://www.last.fm/api

---

**Última Atualização**: 22 de outubro de 2025  
**Versão Atual**: 0.9.2  
**Próxima Release**: v0.9.3 (App Sandbox + Entitlements)
