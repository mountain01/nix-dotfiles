# dotfiles

Nix-based macOS configuration using [nix-darwin](https://github.com/nix-darwin/nix-darwin) and [Home Manager](https://github.com/nix-community/home-manager). Manages system settings, installed applications, shell environment, and developer tools declaratively.

## Prerequisites

1. **Install Nix** (with flakes support):
   ```sh
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. **Install Homebrew** (used for GUI apps and some brews):
   ```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. **Clone this repo**:
   ```sh
   git clone <repo-url> ~/dotfiles
   cd ~/dotfiles
   ```

4. **Install nix-darwin** (first time only):
   ```sh
   nix run nix-darwin/nix-darwin-25.05 -- switch --flake .#Matts-MacBook-Pro
   ```

   On subsequent rebuilds, use the alias:
   ```sh
   rebuild
   ```
   Which expands to: `sudo -i darwin-rebuild switch --flake ~/dotfiles`

> **Note:** The first run will install all Homebrew casks, brews, and Mac App Store apps. This can take a while.

---

## Repository Structure

```
dotfiles/
├── flake.nix           # Entry point — declares all inputs and the Darwin configuration
├── flake.lock          # Locked dependency versions (nixpkgs, nix-darwin, home-manager)
├── darwin.nix          # System-level config: packages, macOS defaults, Homebrew, keyboard
├── aerospace/
│   └── aerospace.toml  # AeroSpace tiling window manager config (available but not active)
└── home/
    └── home.nix        # User-level config: shell, CLI tools, git, SSH, aliases
```

---

## What Each File Does

### `flake.nix`

The root entry point. Declares all external dependencies (inputs) and wires together nix-darwin and Home Manager into a single Darwin system configuration named `Matts-MacBook-Pro`.

**Inputs pinned to the `25.05` release channel:**
- `nixpkgs` — package collection
- `nix-darwin` — macOS system configuration framework
- `home-manager` — user-level dotfiles and program management
- `claude-code-nix` — third-party flake providing the Claude Code CLI

---

### `darwin.nix`

System-level configuration applied via nix-darwin (requires `sudo`).

**macOS Defaults**
| Setting | Value |
|---|---|
| Show all file extensions | enabled |
| Show hidden files | enabled |
| Finder path bar | visible |
| Dock auto-hide | enabled |
| Dock magnification | enabled |

**Keyboard**
Swaps two modifier keys using HID key codes (Right Command ↔ Right Option). Key mapping is enabled system-wide.

**Security**
Touch ID is enabled for `sudo` authentication.

**Vim** (system-wide)
Installed with plugins: `surround`, `vim-nix`, `easymotion`. Configured with 2-space tabs, syntax highlighting, and relative line numbers.

**Shell Aliases**
- `rebuild` — rebuilds and activates the full system configuration

**Homebrew**

Homebrew is managed by nix-darwin. Running `rebuild` will install, update, or remove anything not in this list (`cleanup = "zap"`).

*Casks (GUI apps):*
| App | Purpose |
|---|---|
| `aerospace` | Tiling window manager |
| `android-studio` | Android development |
| `cursor` | AI-powered code editor |
| `discord` | Chat |
| `google-chrome` | Browser |
| `messenger` | Facebook Messenger |
| `microsoft-teams` | Work chat |
| `raycast` | Spotlight replacement / launcher |
| `steam` | Gaming |
| `visual-studio-code` | Code editor |
| `vlc` | Media player |
| `zoom` | Video calls |

*Brews (CLI tools):*
| Tool | Purpose |
|---|---|
| `cocoapods` | iOS/macOS dependency manager |

*Mac App Store:*
| App | Purpose |
|---|---|
| Advanced Screen Share | Enhanced screen sharing |

---

### `home/home.nix`

User-level configuration managed by Home Manager. No `sudo` required.

**Shell — Zsh**
- Tab completion and syntax highlighting enabled
- Homebrew environment sourced at login
- `fnm` (Fast Node Manager) initialized with `--use-on-cd` so `.nvmrc` / `.node-version` files are respected automatically
- Node.js v24 is installed and set as the default on first activation

**Shell Aliases**
- `reload` — re-sources `~/.zshrc`
- `lg` — opens `lazygit`

**CLI Tools**

| Tool | Purpose |
|---|---|
| `bat` | `cat` with syntax highlighting |
| `fzf` | Fuzzy finder (Zsh integration enabled) |
| `fnm` | Fast Node Manager — manages Node.js versions |
| `lazydocker` | Terminal UI for Docker |
| `lazygit` | Terminal UI for Git |
| `starship` | Cross-shell prompt |
| `utm` | Virtual machine manager for macOS |
| `zoxide` | Smart `cd` that learns your most-visited directories |
| `claude` | Claude Code CLI (AI coding assistant) |

**Git**
- Name: Matt Edwards
- Email: edwardsjm01@gmail.com

**SSH**

A named host block is configured:
```
Host: arm
  Hostname: 192.168.86.36
  User: matt
  IdentityFile: ~/.ssh/arm
```
Connect with `ssh arm`.

---

### `aerospace/aerospace.toml`

Configuration for [AeroSpace](https://github.com/nikitabobko/AeroSpace), a tiling window manager for macOS. The nix-darwin service integration is currently commented out, but the app is installed via Homebrew cask and this config file can be symlinked or referenced manually.

**Key bindings (Alt-based):**
- `Alt+h/j/k/l` — focus window (vim-style)
- `Alt+Shift+h/j/k/l` — move window
- `Alt+1–9` — switch workspace
- `Alt+Shift+1–9` — move window to workspace
- `Alt+Tab` — cycle workspaces
- `Alt+Shift+;` — enter service mode (reload config, flatten layout, etc.)

---

## Updating

To update all flake inputs to their latest versions:
```sh
nix flake update
rebuild
```

To update a single input (e.g., nixpkgs only):
```sh
nix flake update nixpkgs
rebuild
```
