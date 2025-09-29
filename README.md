<h1 align="center">🏴‍☠️ Mine Sacred Dotfiles of Power 🏴‍☠️</h1>

<p align="center">
  <a href="https://www.gnu.org/">
    <img src="https://upload.wikimedia.org/wikipedia/commons/8/83/The_GNU_logo.png" alt="GNU Logo" height="100"/>
  </a>
  <a href="https://youtu.be/SJ-Jbl-XCH4?si=tyLqQjFKZ1xl4_d8">
    <img src="https://miro.medium.com/v2/resize:fit:720/format:webp/1*_Vl2vhvWMUSctKZmxFACDw.png" alt="Dotfiles" height="100"/>
  </a>
</p>

<p align="center">
  <a href="https://archlinux.org/">
    <img src="https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white"/>
  </a>
  <a href="https://hyprland.org/">
    <img src="https://img.shields.io/badge/Hyprland-991B1B?style=for-the-badge&logo=wayland&logoColor=white"/>
  </a>
  <a href="https://www.lua.org/">
    <img src="https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white"/>
  </a>
  <a href="https://github.com/tmux/tmux">
    <img src="https://img.shields.io/badge/Tmux-1BB91F?style=for-the-badge&logo=tmux&logoColor=white"/>
  </a>
  <a href="https://github.com/ohmyzsh/ohmyzsh">
    <img src="https://img.shields.io/badge/Zsh-F15A24?style=for-the-badge&logo=zsh&logoColor=white"/>
  </a>
  <a href="https://starship.rs/">
    <img src="https://img.shields.io/badge/Starship-DD0B78?style=for-the-badge&logo=starship&logoColor=white"/>
  </a>
</p>

<p align="center">
  <em>"In the realm where no maidens dwell, these configurations shall serve thee well"</em> ⚔️
</p>
<p align="center">
  This repository doth contain the legendary dotfiles that transform thy mundane system into a realm of productivity and aesthetic glory! 🌟
</p>

## 📋 Table of Sacred Contents

- [⚡ Prerequisites of Power](#-prerequisites-of-power)
- [🎯 Required Artifacts](#-required-artifacts)
- [⚠ Ancient Wisdom & Compatibility Scrolls](#-ancient-wisdom--compatibility-scrolls)
- [🧙 The Great Zsh Transformation](#-the-great-zsh-transformation)
  - [🔮 Enchanting with Mystical Plugins](#-enchanting-with-mystical-plugins)
- [🚀 The Grand Installation Ritual](#-the-grand-installation-ritual)
- [🔧 Post-Installation Configuration (Sacred Rites)](#-post-installation-configuration-sacred-rites)
- [⌨ Mystical Keybindings](#-mystical-keybindings)
- [🎨 Customization Scrolls](#-customization-scrolls)
- [🎭 What Thou Shall Gain](#-what-thou-shall-gain)
- [🛡 Troubleshooting Scrolls](#-troubleshooting-scrolls)
- [❓ Frequently Asked Questions](#-frequently-asked-questions)
- [🏆 Hall of Fame (Acknowledgments)](#-hall-of-fame-acknowledgments)
- [🎯 Quick Start for the Impatient](#-quick-start-for-the-impatient)

## ⚡ Prerequisites of Power

Before embarking upon this noble quest, thou must first acquire the mighty **paru** (thy AUR companion):

```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

## 🎯 Required Artifacts

Ensure these sacred tools are present in thy digital armory:

| Artifact | Purpose | Power Level |
|----------|---------|-------------|
|**🎭Eww**|The widget weaver of wonders| ⭐⭐⭐⭐ |
|**⚡FastFetch**|The swift system herald| ⭐⭐⭐ |
|**👻Ghostty**|Terminal of the spirits| ⭐⭐⭐⭐ |
|**🖼️Gthumb**|The image realm guardian| ⭐⭐⭐ |
|**🪟Hyprland**|The wayland window wizard| ⭐⭐⭐⭐⭐ |
|**📜Okular**|The document scroll master| ⭐⭐⭐⭐ |
|**🛡️Proton VPN**|The privacy shield enchanter| ⭐⭐⭐⭐⭐ |
|**🌊qBittorrent**|The torrent tide controller| ⭐⭐⭐⭐ |
|**⭐Starship**|The cosmic prompt navigator| ⭐⭐⭐⭐ |
|**🔗Stow**|The symlink alchemist| ⭐⭐⭐⭐⭐ |
|**📱Telegram Desktop**|The encrypted message mystic| ⭐⭐⭐⭐ |
|**🖥️TMUX**|The session multiplier| ⭐⭐⭐⭐ |
|**💬ZapZap**|The WhatsApp whisper conduit| ⭐⭐⭐ |

**Summon them all with a single incantation:**

```bash
paru -S eww fastfetch ghostty gthumb hyprland okular proton-vpn-gtk-app qbittorrent starship stow telegram-desktop tmux zapzap
```

## ⚠ Ancient Wisdom & Compatibility Scrolls

### 🔮 EWW Widget Magic Disclaimer:
Beware, noble adventurer! The mystical **eww widgets** contained within these sacred dotfiles are enchanted to work their magic **ONLY** within specific realms:

#### ✅ **Blessed Territories** (Full Power):
- **🪟 Hyprland** (Recommended realm of choice)
- **🌊 Sway** and other wlroots compositors  
- **🌀 River**, **🌪️ Wayfire** compositors
- **🔷 KDE Plasma** (Wayland) with proper configuration

#### ❌ **Cursed Lands** (Widget Magic Forbidden):
- **🚫 GNOME** (Wayland) - *Layer shell protocol not supported*
- **🚫 Most traditional desktop environments** on Wayland
- **⚠ X11 environments** (limited widget support)

#### 🛡 **Universal Configurations** (Work Everywhere):
*Fear not! All other configurations work universally across all realms!* ✨
- **Zsh** configuration with Oh My Zsh
- **TMUX** session management  
- **Starship** prompt customization
- **Ghostty** terminal settings
- **Git** configuration
- **FastFetch** system information

## 🧙 The Great Zsh Transformation

### Installing the Ancient Oh My Zsh Magic

```
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 🔮 Enchanting with Mystical Plugins

These plugins shall grant thy shell supernatural abilities:

#### **The Suggestion Whisperer** 💭
*Completes thy commands before thou thinkest them*

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

#### **The Syntax Illuminator** 🌈  
*Highlights thy commands with the colors of power*

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 
```

#### **The Completion Oracle** 🔮
*Knows all possible completions across all realms*

```bash
git clone https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete
```

#### **The Alias Reminder Spirit** 👻
*Reminds thee of forgotten shortcuts*

```bash
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use
```

## 🚀 The Grand Installation Ritual

### Step 1: Acquire the Sacred Texts

```bash
git clone https://github.com/Sivabooshan/No_Maidens_UwU.git $HOME/No_Maidens_UwU
cd ~/No_Maidens_UwU/
```

### Step 2: Invoke the Symlink Sorcery

Backup existing configurations (Safety first!)

```bash
mkdir -p ~/.config/backup
cp -r ~/{.tmux.conf,.zshrc} ~/.config/{hypr,tmux,ghostty} ~/.config/backup/ 2>/dev/null || true
```

Cast the symlink spell

```bash
stow .
```

### Step 3: Witness the Transformation! ✨

Restart thy system and behold as thy system transforms into a beautiful, efficient powerhouse worthy of the gods themselves!

## 🔧 Post-Installation Configuration (Sacred Rites)

### **Hyprland Auto-Start Configuration**

Add these to `~/.config/hypr/hyprland.conf`:

### Essential daemons and applications:

exec-once = eww daemon && eww open countdown_window

## ⌨ Mystical Keybindings

### **Hyprland Window Management**
| Combination | Action | Power |
|-------------|--------|-------|
| `SUPER + Q` | Close window | 💥 |
| `SUPER + SHIFT + Q` | Kill window forcefully | ⚡ |
| `SUPER + T` | Open terminal | 📱 |
| `SUPER + E` | Open file manager | 📁 |
| `SUPER + W` | Open browser | 🌐 |
| `SUPER + C` | Open code editor | 💻 |
| `SUPER + F` | Toggle fullscreen | 🖥️ |
| `SUPER + D`| Fullscreen maximize | 🖥️ |
| `SUPER + SPACE` | Toggle floating | 🎈 |
| `SUPER + SHIFT + LEFT` | Move window left | 🪟⬅️ |
| `SUPER + SHIFT + RIGHT` | Move window right | 🪟➡️ |
| `CTRL + SUPER + SHIFT + LEFT` | Move window to workspace left | 📦⬅️ |
| `CTRL + SUPER + SHIFT + RIGHT` | Move window to workspace right | 📦⬅️|

### **Workspace Navigation**
| Combination | Action | Realm |
|-------------|--------|--------|
| `SUPER + [1-9]` | Switch to workspace | 🌐 |
| `SUPER + SHIFT + [1-9]` | Move window to workspace | 📦 |
| `SUPER + CTRL + LEFT/RIGHT` | Navigate workspaces | ⬅️➡️ |

### **System Controls**
| Combination | Action | Element |
|-------------|--------|---------|
| `SUPER + CTRL + R` | Restart/Reload Hyprland config & widgets | 🔄 |
| `SUPER + L` | Lock screen | 🔒 |
| `SUPER + SHIFT + L` | Suspend system | 😴 |
| `SUPER + CTRL + DEL` | Power off system | ⏻ |
