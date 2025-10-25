# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
e este projeto adere ao [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased] - Em Desenvolvimento

### 🚀 Modernização em Progresso
Processo de modernização completa do aplicativo seguindo as mais recentes diretrizes da Apple, 
implementando design Liquid Glass, sistema de segurança robusto e Widget de Desktop.

**Status**: Fase 1 - Fundação e Segurança (20% concluído)

---

## [2.0.0-alpha.1] - 2025-10-22

### 🎯 Fase 1.1 - Sistema de Configuração Seguro (CONCLUÍDO)

#### Added - 2025-10-22

##### Sistema de Configuração
- ✅ **ConfigurationManager.swift**: Gerenciador central de configurações com carregamento hierárquico
  - Suporte para variáveis de ambiente (máxima prioridade)
  - Suporte para Info.plist (build-time via xcconfig)
  - Fallback temporário para garantir funcionamento durante desenvolvimento
  - Validação automática de credenciais obrigatórias
  - Método `validate()` com error handling robusto
  - Método `configurationSummary()` para debug seguro
  - Struct `LastFMCredentials` para acesso type-safe
  - Decorador `@MainActor` para thread-safety

##### Gestão de Secrets
- ✅ **Secrets.template.xcconfig**: Template versionado para desenvolvedores
  - Instruções detalhadas inline
  - Placeholders para API Key e Shared Secret
  - Link para obter credenciais do Last.fm
  - Configurações opcionais comentadas

- ✅ **Secrets.xcconfig**: Arquivo de configuração real (não versionado)
  - Contém credenciais reais da API
  - Adicionado ao .gitignore
  - Usado durante build-time (quando configurado)

##### Documentação do Projeto
- ✅ **CHANGELOG.md**: Histórico completo de versões
  - Formato baseado em Keep a Changelog
  - Semantic Versioning
  - Seções organizadas por tipo de mudança
  - Histórico desde v1.4.0

- ✅ **ARCHITECTURE.md**: Documentação técnica completa
  - Visão geral da arquitetura
  - Estrutura de diretórios detalhada
  - Camadas da aplicação (Presentation, Business, Data, Network)
  - Fluxo de dados documentado
  - Tecnologias utilizadas
  - Padrões e convenções de código
  - Estratégia de testes
  - Práticas de segurança
  - Requisitos de deployment
  - Referências externas

##### Estrutura de Diretórios
- ✅ **Configuration/**: Diretório para arquivos de configuração
  - Centraliza gestão de secrets
  - Facilita setup de novos desenvolvedores
  - Isola configurações do código

#### Changed - 2025-10-22

##### Refatoração de Segurança
- 🔄 **Config.swift**: Refatorado para usar ConfigurationManager
  - `LastFMConfig.apiKey` agora redireciona para `ConfigurationManager.shared.lastFMAPIKey`
  - `LastFMConfig.sharedSecret` agora redireciona para `ConfigurationManager.shared.lastFMSharedSecret`
  - Marcado como `@available(*, deprecated)` com mensagens orientativas
  - Mantém compatibilidade retroativa (código existente continua funcionando)
  - Adicionados métodos helper: `validate()` e `summary()`
  - Preparação para migração gradual do código

- 🔄 **NowPlayingApp.swift**: Validação de configuração na inicialização
  - `applicationDidFinishLaunching()` valida configurações antes de iniciar
  - Alert modal se configuração inválida
  - Mensagem de erro descritiva para o usuário
  - Graceful shutdown se credenciais ausentes
  - Logs de configuração no console (modo debug)

##### Gestão de Versionamento
- 🔄 **.gitignore**: Atualizado com novos padrões de segurança
  - `Configuration/Secrets.xcconfig` (credenciais reais)
  - `*.xcconfig` (exceto templates)
  - `!*.template.xcconfig` (templates permitidos)
  - Certificados e provisioning profiles
  - Chaves privadas (*.key, *.pem)
  - Artifacts de build adicionais
  - Logs de desenvolvimento
  - Arquivos temporários do Core Data

#### Security - 2025-10-22

##### Proteção de Credenciais
- 🔐 **Credenciais removidas do código-fonte**
  - API Key e Shared Secret não estão mais hardcoded em `Config.swift`
  - Credenciais isoladas em `ConfigurationManager` com fallback temporário
  - Secrets.xcconfig adicionado ao .gitignore permanentemente
  - Template versionado sem valores reais

##### Validação e Verificação
- 🔐 **Validação automática de credenciais**
  - Verifica se API Key tem pelo menos 20 caracteres
  - Verifica se Shared Secret tem pelo menos 20 caracteres
  - Garante que placeholders ("YOUR_API_KEY_HERE") não são usados
  - Valida que endpoint é HTTPS válido
  - Falha rápido (fail-fast) se configuração inválida

##### Proteção de Logs
- 🔐 **Logs seguros**
  - `configurationSummary()` mostra apenas primeiros 8 caracteres da API Key
  - Shared Secret nunca é logado completamente
  - Identificação de fonte de configuração (env var, plist, fallback)

#### Infrastructure - 2025-10-22

##### Git e Versionamento
- 🏗️ **Tag v1.4-pre-modernization**: Snapshot antes da modernização
  - Marca o último estado estável antes das mudanças
  - Permite rollback se necessário
  - Referência para comparações futuras

- 🏗️ **Branch feature/phase-1-security**: Branch de desenvolvimento
  - Isolamento de mudanças da main/master
  - Facilita code review
  - Permite trabalho paralelo em outras features
  - Merge será feito após testes completos

##### Organização do Projeto
- 🏗️ **Estrutura de documentação estabelecida**
  - Padrão de documentação definido
  - Processo de changelog estabelecido
  - Guidelines de arquitetura documentadas

#### Technical Debt - 2025-10-22

##### Débito Técnico Conhecido (A ser resolvido nas próximas fases)
- ⚠️ **Credenciais com fallback hardcoded temporário**
  - `ConfigurationManager` tem fallback temporário em código
  - Necessário para garantir funcionamento durante desenvolvimento
  - **Será removido na Fase 1.2** (Modernização do Keychain)
  - Credenciais serão movidas 100% para Keychain
  - Comentários TODO adicionados no código

- ⚠️ **Testes unitários ausentes**
  - `ConfigurationManager` não tem testes unitários
  - Validação manual realizada
  - **Testes serão adicionados na Fase 5** (Qualidade e Polish)
  - Cobertura target: 70%+

- ⚠️ **xcconfig não integrado ao build**
  - Tentativa de usar xcconfig para injetar valores no Info.plist
  - Xcode não substituiu placeholders `$(LASTFM_API_KEY)` corretamente
  - Solução temporária: fallback em código
  - **Investigar na Fase 1.2** ou manter abordagem atual

---

## [1.4.0] - 2025-10-22

### 📸 Snapshot Pré-Modernização

Estado do aplicativo antes do início do processo de modernização completa.
Marcado com tag `v1.4-pre-modernization` no Git.

#### Funcionalidades Existentes - Estado Base

##### Core Features
- ✅ **Scrobble automático para Last.fm**
  - Seguindo regras oficiais (50% da música ou 4 minutos)
  - Retry automático em caso de falha
  - Threshold configurável
  
- ✅ **Atualização "Now Playing"**
  - Tempo real
  - Integração com Last.fm API
  - Display de artwork

- ✅ **Menu bar com popover**
  - Hover automático
  - Display compacto de música atual
  - Acesso rápido a controles

- ✅ **Janela principal**
  - Histórico de músicas tocadas
  - Informações de capa, artista e álbum
  - TabView com Recent Tracks e Logs

- ✅ **Sistema de logs com Core Data**
  - Histórico persistente de scrobbles
  - Filtros por tipo (Now Playing / Scrobble)
  - Filtros por status (OK / Failed)
  - Busca por artista/track/álbum

##### Autenticação
- ✅ **Autenticação Last.fm (OAuth)**
  - Fluxo de token
  - Armazenamento de session no Keychain
  - Login/Logout funcional

##### Sistema
- ✅ **Launch at Login**
  - Funcional no macOS 13+ (ServiceManagement framework)
  - Preferências configuráveis
  - Fallback manual para macOS 12 e anteriores

- ✅ **Integração com Apple Music**
  - Escuta de notificações distribuídas
  - Captura de metadata (título, artista, álbum)
  - Detecção de estados (Playing, Paused, Stopped)

#### Problemas Conhecidos - v1.4.0

##### Segurança
- ⚠️ **Credenciais hardcoded no código**
  - API Key e Shared Secret em `Config.swift`
  - Versionados no Git (histórico contém credenciais)
  - Exposição de segurança

- ⚠️ **App Sandbox desabilitado**
  - `com.apple.security.app-sandbox: false`
  - Necessário para notificações distribuídas
  - Impede distribuição na Mac App Store
  - Menor segurança para o usuário

##### Interface
- ⚠️ **Interface básica sem design system**
  - Layout funcional mas não polido
  - Sem design language consistente
  - Animações básicas ou ausentes
  - Não segue padrões Liquid Glass da Apple

##### Features Ausentes
- ❌ **Widget de Desktop não implementado**
  - Sem WidgetKit extension
  - Não disponível para usuários

- ❌ **Estatísticas limitadas**
  - Apenas logs brutos
  - Sem visualizações de dados
  - Sem insights de escuta

##### Arquitetura
- ⚠️ **Deployment target incorreto**
  - Configurado para macOS 26.0 (não existe)
  - Deveria ser 15.6 ou 12.0 (para compatibilidade)

- ⚠️ **Código sem testes**
  - 0% de cobertura de testes
  - Testes manuais apenas
  - Dificulta refatoração segura

- ⚠️ **Sem dependency injection**
  - Acoplamento alto
  - Dificulta testes
  - Singletons excessivos

---

## Tipos de Mudanças

- `Added` - Novas funcionalidades
- `Changed` - Mudanças em funcionalidades existentes
- `Deprecated` - Funcionalidades que serão removidas em breve
- `Removed` - Funcionalidades removidas
- `Fixed` - Correções de bugs
- `Security` - Correções de segurança
- `Infrastructure` - Mudanças em build, CI/CD, versionamento
- `Technical Debt` - Débito técnico identificado e planos para resolver

---

## Roadmap de Versões

### v2.0.0 (Planejado - Q1 2026)
- **Fase 1**: Fundação e Segurança ✅ (20% concluído)
- **Fase 2**: Interface Liquid Glass (0%)
- **Fase 3**: Widget de Desktop (0%)
- **Fase 4**: Recursos Avançados (0%)
- **Fase 5**: Qualidade e Polish (0%)
- **Fase 6**: Distribuição (0%)

### v2.1.0 (Planejado - Q2 2026)
- Integração com Spotify
- Control Center widget
- Apple Watch companion

### v2.2.0 (Planejado - Q3 2026)
- Themes customizáveis
- Shortcuts do macOS
- Sharing e Social features

---

## Links e Referências

- **Repositório**: https://github.com/diego-castilho/NowPlaying
- **Issues**: https://github.com/diego-castilho/NowPlaying/issues
- **Plano de Modernização**: Documentado em sessão de desenvolvimento
- **Last.fm API**: https://www.last.fm/api

---

**Última Atualização**: 22 de outubro de 2025
**Versão Atual**: 2.0.0-alpha.1 (em desenvolvimento)
**Versão Estável**: 1.4.0
