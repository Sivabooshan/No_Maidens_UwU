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
|**📚Calibre**|The digital tome keeper and novel realm guardian| ⭐⭐⭐⭐ |
|**👁️Entr**|The ever-watching eye that empowers tmux-autoreload's magic| ⭐⭐⭐ |
|**⚡FastFetch**|The swift system herald| ⭐⭐⭐ |
|**👻Ghostty**|Terminal of the spirits| ⭐⭐⭐⭐ |
|**🖼️Gthumb**|The image realm guardian| ⭐⭐⭐ |
|**🪟Hyprland**|The wayland window wizard| ⭐⭐⭐⭐⭐ |
|**📜Okular**|The document scroll master| ⭐⭐⭐⭐ |
|**🛡️Proton VPN**|The privacy shield enchanter| ⭐⭐⭐⭐⭐ |
|**🌊qBittorrent**|The torrent tide controller| ⭐⭐⭐⭐ |
|**🎭Quickshell**|The widget weaver of wonders| ⭐⭐⭐⭐ |
|**📥Stacher7**|The modern video downloader GUI| ⭐⭐⭐⭐ |
|**⭐Starship**|The cosmic prompt navigator| ⭐⭐⭐⭐ |
|**🔗Stow**|The symlink alchemist| ⭐⭐⭐⭐⭐ |
|**📱Telegram Desktop**|The encrypted message mystic| ⭐⭐⭐⭐ |
|**⏬Yt-dlp**|The powerful video download core| ⭐⭐⭐⭐⭐ |
|**🖥️TMUX**|The session multiplier| ⭐⭐⭐⭐ |
|**💬ZapZap**|The WhatsApp whisper conduit| ⭐⭐⭐ |
|**🐚Zsh**|The mystical shell of infinite power| ⭐⭐⭐⭐⭐ |

**Summon them all with a single incantation:**

```bash
paru -S calibre entr fastfetch ghostty gthumb hyprland okular proton-vpn-gtk-app qbittorrent quickshell stacher7 starship stow telegram-desktop tmux yt-dlp zapzap zsh
```

## ⚠ Ancient Wisdom & Compatibility Scrolls

### 🔮 Quickshell Widget Magic Disclaimer:
Beware, noble adventurer! The mystical **quickshell widgets** contained within these sacred dotfiles are enchanted to work their magic **ONLY** within specific realms:

#### ✅ **Blessed Territories** (Full Power):
- **🪟 Hyprland** (Recommended realm of choice)
- **🌊 Sway** and other wlroots compositors
- **🌀 River**, **🌪️ Wayfire** compositors
- **🔷 KDE Plasma** (Wayland) with proper configuration
- **⚡ Niri** and other modern Wayland compositors

#### ❌ **Cursed Lands** (Widget Magic Forbidden):
- **🚫 GNOME** (Wayland) - *Layer shell protocol not supported*
- **🚫 Most traditional desktop environments** on Wayland

#### 🔧 **Partial Magic Realms** (Limited Powers):

- 📟 **X11 Desktop Environments** - QuickShell works but cannot anchor widgets to screen edges like true Wayland magic


#### 🛡 **Universal Configurations** (Work Everywhere):
*Fear not! All other configurations work universally across all realms!* ✨
- **Zsh** configuration with Oh My Zsh
- **TMUX** session management  
- **Starship** prompt customization
- **Ghostty** terminal settings
- **Git** configuration
- **FastFetch** system information

⚡ QuickShell's Qt Magic: QuickShell harnesses the power of QtQuick and QML, offering superior performance and hot-reloading capabilities, but faces the  ancient curse of layer shell protocol limitations in GNOME's domain.

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

exec-once = quickshell

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

---

## ❓ Frequently Asked Questions

### **🤔 "Can I use this on other distributions?"**
These dotfiles are optimized for Arch Linux and derivatives. Other distributions may require package name adjustments and dependency installations.

### **🔄 "How do I update the dotfiles?"** 

```bash
cd ~/No_Maidens_UwU
git pull origin master
stow . # Restow to update symlinks
```

### **🎨 "Can I customize the colors/themes?"**
Absolutely! Edit the respective config files:
- **Terminal**: `~/.config/ghostty/config`
- **Prompt**: `~/.config/starship.toml`
- **Widgets**: `~/.config/quickshell/`

### **💾 "Will this overwrite my existing configs?"**
Stow will warn about conflicts. Always backup your configs first:

```bash
mkdir ~/.config/backup
cp -r ~/.config/{important-app} ~/.config/backup/
```

### **🚀 "How do I add my own customizations?"**
1. Add a star to the repository
2. Fork this repository
3. Make your changes
4. Commit and push to your fork
5. Use your fork's URL in installation

## 🏆 Hall of Fame (Acknowledgments)

These legendary warriors provided inspiration and code:
- **Hyprland Team** - Architects of the ultimate compositor
- **Starship Team** - Cosmic prompt engineers
- **Oh My Zsh Community** - Shell enhancement wizards
- **Outfoxxed** - Creator of the mighty QuickShell QtQuick toolkit
- **QT Team** - Masters of the QtQuick/QML framework
- **Grip** - The markdown preview sorcerers

## 🎯 Quick Start for the Impatient

### ⚡ One-Incantation Installation (For the Fearless Pirates)

```bash
curl -sSL https://raw.githubusercontent.com/Sivabooshan/No_Maidens_UwU/main/quick-install.sh | bash
```

🛡️ Safer Approach (Blessed by Ancient Wisdom)

```bash
# Acquire the sacred ritual script first
curl -sSL https://raw.githubusercontent.com/Sivabooshan/No_Maidens_UwU/main/quick-install.sh -o quick-install.sh

# Grant it executable powers
chmod +x quick-install.sh

# Check thy system's readiness (highly recommended)
./quick-install.sh --diagnose

# Commence the sacred installation ritual
./quick-install.sh
```

### 🎯 PROPER SACRED INVOCATION:

```bash
./quick-install.sh [DIVINE_FLAGS]
```


### ⚔️ **Divine Command Flags:**

- `-h, --help` - Display these sacred help scrolls
- `-v, --version` - Show version of this legendary script  
- `--diagnose` - Run comprehensive system diagnostics
- `--dry-run` - Simulate the ritual without making changes
- `--force` - Force installation even if conflicts arise
- `--verbose` - Enable verbose output for debugging
- `--skip-aur` - Skip AUR package installation

## ⚠️ **Sacred Precautions & Realm Requirements**

### 🏴‍☠️ **Before Thou Embarkest Upon This Quest:**

- **🗺️ ARCH REALM ONLY**: This sacred ritual works exclusively in the Arch Linux realm and its vassal territories (EndeavourOS, Manjaro, ArcoLinux, etc.)
- **💾 PRESERVE THY ARTIFACTS**: The script creates divine backup vaults, but manual preservation of critical configs is always wise
- **⏰ TIME OF POWER**: Allow 15-30 minutes for the complete ritual (depending on thy realm's ethereal connection and computational prowess)
- **🌐 ETHEREAL BONDS REQUIRED**: Stable connection to the sacred repositories is essential
- **🚫 NEVER INVOKE WITH SUDO**: The script has bulletproof root prevention and will banish itself if invoked with sudo powers

### 💀 **Potential Curses & Their Solutions:**

- **⚔️ Configuration Conflicts**: Existing dotfiles may clash with new sacred configs (script handles this with backup sanctuaries)
- **📦 AUR Artifact Failures**: Some treasures from the AUR realm might fail to forge on certain systems
- **🌐 Network Realm Issues**: Installation may falter if repositories become unreachable
- **🔐 Permission Curses**: Running as root is **FORBIDDEN** - script will reject thee with dramatic warnings

## 🔧 **Post-Ritual Sacred Rites**

### ✨ **Immediate Divine Actions:**

Awaken thy new shell powers

```bash
source ~/.zshrc
```

Or restart thy terminal sanctuary completely (highly recommended)


### 🔄 **If Curses Befall Thee:**

Consult the sacred ritual scrolls

```bash
cat ~/.local/log/dotfiles-ritual-*.log
```

Manual restoration ritual if needed

```bash
cd ~/No_Maidens_UwU
stow -D . # Unbind the sacred symlinks
cp -r ~/.config/dotfiles-backup-/ ~/ # Restore from thy sanctuary
```


## ⚡ **Sacred Features & Divine Protections**

| Sacred Power | Divine Description | Protection Level |
|--------------|-------------------|------------------|
| 🛡️ **Root Prevention** | Dramatic banishment if run with sudo | ⭐⭐⭐⭐⭐ |
| 🔍 **Smart Diagnostics** | Focused prerequisite checking only | ⭐⭐⭐⭐⭐ |
| 💾 **Auto Sanctuaries** | All existing configs preserved in vaults | ⭐⭐⭐⭐⭐ |
| 🔄 **Restoration Magic** | Can undo all changes if cursed | ⭐⭐⭐⭐ |
| 📜 **Divine Scrolls** | Everything inscribed with holy timestamps | ⭐⭐⭐⭐⭐ |
| ⚔️ **Conflict Resolution** | Handles clashing configurations with wisdom | ⭐⭐⭐⭐ |
| 🙏 **Mortal Consent** | Seeks thy blessing before major transformations | ⭐⭐⭐⭐⭐ |
| 🧪 **Dry Run Testing** | Safe simulation mode for cautious pirates | ⭐⭐⭐⭐ |

## 🏃‍♀️ **TL;DR for the Extremely Impatient Pirates**

```bash
curl -sSL https://raw.githubusercontent.com/Sivabooshan/No_Maidens_UwU/main/quick-install.sh | bash && source ~/.zshrc
```

### ⚠️ **Only invoke the one-liner incantation if thou:**

- **Trustest the source** with thy digital soul completely
- **Art upon a fresh Arch Linux installation**
- **Possessest recent backups** of thy sacred realm
- **Understandest the risks** of piping ethereal content to bash

## 🏴‍☠️ **Project Megiddo v1.0 - Enhanced Powers**

**New in this legendary release:**

- 🔍 **Smart Diagnostics**: `--diagnose` flag for system readiness
- 🛡️ **Bulletproof Root Prevention**: Dramatic warnings if invoked incorrectly
- 🧪 **Dry Run Mode**: Test safely with `--dry-run`
- 📝 **Enhanced Logging**: Detailed ritual scrolls with timestamps
- ⚡ **Auto-Install Prerequisites**: Missing tools installed automatically

---

### 🎯 **Legendary Pro Tip:**

For production realms or if uncertainty plagues thee, always use the **safer blessed approach** - acquire the script first, run `--diagnose` to verify thy system, then execute within thy own sanctuary!

**🏴‍☠️ "With great power comes great responsibility - and great dotfiles!" ⚔️**

**"May thy terminal be swift, thy configs be blessed, and thy productivity legendary!" 🌟**

---

<div align="center">

### ⭐ **Star this repository if it serves thee well!** ⭐

**Share thy screenshots in [Discussions](https://github.com/Sivabooshan/No_Maidens_UwU/discussions) to inspire fellow adventurers!** 📸

</div>
