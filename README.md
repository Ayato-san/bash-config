# PowerShell Configuration Repository

This repository contains scripts and configurations for setting up a development environment on Windows, primarily focused on:

## Key Components

- **Terminal Setup**: PowerShell script (`terminal-install.ps1`) for installing:

  - Git for Windows
  - Zsh shell
  - Oh My Zsh
  - Powerlevel10k theme
  - Custom fonts (MesloLGS NF)

- **Shell Configuration**:

  - `.zshrc` configuration file
  - `.p10k.zsh` theme configuration
  - Custom plugins and aliases
  - Shell completions for common tools:
    - docker
    - eza
    - gh (GitHub CLI)
    - golang
    - node/npm
    - terraform
    - yarn

- **VS Code Integration**:
  - Terminal profile settings for Git Bash and Zsh
  - Font and appearance configurations

The repository provides an automated setup for a modern development environment with Zsh on Windows, including shell customizations and developer tool integrations.

## Quick Start

To download and run the terminal setup script directly:

```powershell
irm https://raw.githubusercontent.com/Ayato-san/bash-config/refs/heads/main/terminal-install.ps1 | iex
```

This command downloads and executes the installation script, which will set up your development environment automatically.
