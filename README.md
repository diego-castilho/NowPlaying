#App em Desenvolvimento

# 🎵 NowPlaying - Last.fm Scrobbler para macOS

<div align="center">

<p align="center">
  <img src="https://github.com/diego-castilho/NowPlaying/blob/a0823592c43a4de49f1b6fad99baf57c1039ca99/NowPlaying/Resources/Assets.xcassets/AppIcon.appiconset/NowPlaying.png" alt="NowPlaying Icon" width="200"/>
</p>

**Scrobbler nativo e moderno para Last.fm no macOS**

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-macOS%2012.0+-blue.svg)](https://www.apple.com/macos/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-0.9.7.Beta-purple.svg)]([CHANGELOG.md](https://github.com/diego-castilho/NowPlaying/blob/ef5e910bddcbfab3f3be2109f39c1be4ec6f6d17/NowPlaying/Documentation/CHANGELOG.md))

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
