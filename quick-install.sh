#!/bin/bash

#=============================================================================
# 🏴‍☠️ Mine Sacred Dotfiles of Power - Quick Installation Ritual 🏴‍☠️
#=============================================================================
# Author: typpo_24 (The Dotfile Pirate)
# Description: Automated installation ritual for No_Maidens_UwU sacred configs
# Version: 1.0 - "Project Raftel"
# Repository: https://github.com/Sivabooshan/No_Maidens_UwU
# License: MIT (Maidens-Inclusive Technology) # "NO" licence is not added in repo just thought of the name
# Last Modified: $(date +"%Y-%m-%d")
# Blessing: "In the realm where no maidens dwell, these configurations shall serve thee well" ⚔️
#=============================================================================

# 🛡️ IMMEDIATE ROOT PREVENTION - FIRST DEFENSE! 🛡️
if [[ "$EUID" -eq 0 ]]; then
  echo -e "\033[1;31m"
  echo "╔═══════════════════════════════════════════════════════════════════════════╗"
  echo "║                      💀 CURSE OF ROOT EXECUTION! 💀                       ║"
  echo "║                        FORBIDDEN RITUAL DETECTED!                         ║"
  echo "╚═══════════════════════════════════════════════════════════════════════════╝"
  echo -e "\033[0m"
  echo
  echo -e "\033[1;33m⚠️  ANCIENT CURSE WARNING: This script must NOT be run as root! ⚠️\033[0m"
  echo
  echo -e "\033[0;31m💀 CATASTROPHIC DAMAGE PREVENTED:\033[0m"
  echo -e "\033[0;37m  • Dotfiles would be installed in /root instead of your home\033[0m"
  echo -e "\033[0;37m  • File ownership would be corrupted (root-owned configs)\033[0m"
  echo -e "\033[0;37m  • Oh My Zsh would be installed for root, not your user\033[0m"
  echo -e "\033[0;37m  • Backup sanctuary would be created in wrong location\033[0m"
  echo -e "\033[0;37m  • Sacred scrolls (logs) would be inaccessible to your user\033[0m"
  echo
  echo -e "\033[1;32m🎯 PROPER SACRED INVOCATION:\033[0m"
  echo -e "\033[0;36m  # Run as your regular user (script uses sudo internally when needed)\033[0m"
  echo -e "\033[1;37m  ./quick-install.sh [DIVINE_FLAGS]\033[0m"
  echo
  echo -e "\033[1;36m⚔️  DIVINE COMMAND FLAGS:\033[0m"
  echo -e "\033[0;37m  -h, --help          Display these sacred help scrolls\033[0m"
  echo -e "\033[0;37m  -v, --version       Show version of this legendary script\033[0m"
  echo -e "\033[0;32m  --diagnose          Run comprehensive system diagnostics\033[0m"
  echo -e "\033[0;37m  --dry-run           Simulate the ritual without making changes\033[0m"
  echo -e "\033[0;37m  --force             Force installation even if conflicts arise\033[0m"
  echo -e "\033[0;37m  --verbose           Enable verbose output for debugging\033[0m"
  echo -e "\033[0;37m  --skip-aur          Skip AUR package installation\033[0m"
  echo
  echo -e "\033[0;36m  # NOT like this (will cause havoc):\033[0m"
  echo -e "\033[0;31m  sudo ./quick-install.sh  # ← FORBIDDEN!\033[0m"
  echo
  echo -e "\033[1;33m⚔️  \"With great power comes great responsibility - run as user!\" ⚔️\033[0m"
  echo
  exit 1
fi

set -euo pipefail # Exit on error, undefined vars, and pipe failures
IFS=$'\n\t'       # Secure Internal Field Separator for the Sacred Realm

# Colors of Power for Divine Output
readonly RED='\033[0;31m'    # Blood of Fallen Configs
readonly GREEN='\033[0;32m'  # Blessing of Success
readonly YELLOW='\033[1;33m' # Warning of the Wise
readonly BLUE='\033[0;34m'   # Waters of Progress
readonly PURPLE='\033[0;35m' # Royal Magic of Dotfiles
readonly CYAN='\033[0;36m'   # Sacred Steps
readonly WHITE='\033[1;37m'  # Divine Light
readonly NC='\033[0m'        # Return to Mortal Realm

# Sacred Version Information
readonly SCRIPT_VERSION="1.0.10"
readonly SCRIPT_NAME="No Maidens UwU Sacred Installer"
readonly SACRED_DATE="$(date +"%Y-%m-%d")"
readonly PIRATE_CAPTAIN="typpo_24"

# Sacred Configuration Variables
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SACRED_REPO_URL="https://github.com/Sivabooshan/No_Maidens_UwU.git"
readonly DOTFILES_SANCTUARY="$HOME/No_Maidens_UwU"
readonly BACKUP_VAULT="$HOME/.config/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
readonly SACRED_SCROLLS="$HOME/.local/log/dotfiles-ritual-$(date +%Y%m%d-%H%M%S).log"

# Command line sacred flags
DRY_RUN_MODE=false
FORCE_MODE=false
VERBOSE_MODE=false
SKIP_AUR=false

# Create the Hall of Records
mkdir -p "$(dirname "$SACRED_SCROLLS")"

#=============================================================================
# Divine Logging Functions of Power
#=============================================================================
inscribe_scroll() {
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  local message="$1"
  echo "[$timestamp] - $message" | tee -a "$SACRED_SCROLLS"

  if [[ "$VERBOSE_MODE" == "true" ]]; then
    echo -e "${BLUE}[VERBOSE] $message${NC}"
  fi
}

herald_beginning() {
  if [[ "$DRY_RUN_MODE" == "true" ]]; then
    echo -e "${YELLOW}"
    echo "╔═══════════════════════════════════════════════════════════════════════════╗"
    echo "║                🏴‍☠️ DRY RUN - SACRED RITUAL SIMULATION 🏴‍☠️                   ║"
    echo "║                    No actual changes will be made                         ║"
    echo "╚═══════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
  else
    echo -e "${PURPLE}"
    echo "╔═══════════════════════════════════════════════════════════════════════════╗"
    echo "║                  🏴‍☠️ Mine Sacred Dotfiles of Power 🏴‍☠️                      ║"
    echo "║                 No Maidens UwU - The Sacred Installer                     ║"
    echo "║        \"Where productivity meets the realm of the maidenless\"           ║"
    echo "╚═══════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
  fi
}

announce_quest() {
  echo -e "\n${CYAN}⚔️  $1${NC}"
  inscribe_scroll "SACRED QUEST: $1"
  if [[ "$DRY_RUN_MODE" == "true" ]]; then
    echo -e "${YELLOW}[DRY RUN] Would execute: $1${NC}"
  fi
}

celebrate_victory() {
  echo -e "${GREEN}🎯 $1${NC}"
  inscribe_scroll "VICTORY: $1"
}

whisper_warning() {
  echo -e "${YELLOW}⚠️  Ancient Wisdom: $1${NC}"
  inscribe_scroll "ANCIENT WARNING: $1"
}

cry_of_despair() {
  echo -e "${RED}💀 Curse of Failure: $1${NC}" >&2
  inscribe_scroll "CURSE: $1"
}

#=============================================================================
# 🔍 FOCUSED DIAGNOSTICS SYSTEM - PREREQUISITES ONLY 🔍
#=============================================================================
run_sacred_diagnostics() {
  echo -e "${PURPLE}"
  echo "╔═══════════════════════════════════════════════════════════════════════════╗"
  echo "║                      🔍 SACRED SYSTEM DIAGNOSTICS 🔍                      ║"
  echo "║                     No Maidens UwU - System Analysis                      ║"
  echo "╚═══════════════════════════════════════════════════════════════════════════╝"
  echo -e "${NC}"

  echo -e "${CYAN}🏴‍☠️ ESSENTIAL REALM VERIFICATION:${NC}"

  # Root check with actual username - FIXED!
  if [[ "$EUID" -eq 0 ]]; then
    echo "  ❌ Running as root - THIS IS THE PROBLEM!"
  else
    echo "  ✅ Running for user: $(whoami)"
  fi

  # Arch realm check
  if [[ -f /etc/arch-release ]]; then
    echo "  ✅ Sacred Arch realm detected"
  else
    echo "  ❌ Not in Arch realm - ritual will fail"
  fi

  # Ethereal connection check
  if ping -c 1 archlinux.org >/dev/null 2>&1; then
    echo "  ✅ Ethereal networks accessible"
  else
    echo "  ❌ Ethereal networks severed"
  fi

  # Essential artifacts (only what's needed to START the ritual)
  echo -e "\n${CYAN}🔧 ESSENTIAL ARTIFACTS:${NC}"
  local essential_tools=("git" "curl")
  local missing_tools=()

  for tool in "${essential_tools[@]}"; do
    if command -v "$tool" >/dev/null 2>&1; then
      echo "  ✅ $tool artifact present"
    else
      echo "  ❌ $tool artifact missing"
      missing_tools+=("$tool")
    fi
  done

  # Check base-devel group
  if pacman -Qq base-devel >/dev/null 2>&1; then
    echo "  ✅ base-devel group present"
  else
    echo "  ❌ base-devel group missing"
    missing_tools+=("base-devel")
  fi

  # AUR helper status
  echo -e "\n${CYAN}🏴‍☠️ AUR HELPER STATUS:${NC}"
  if command -v paru >/dev/null 2>&1; then
    echo "  ✅ Mighty Paru helper stands ready"
  else
    echo "  ❌ Paru helper absent - will be summoned during ritual"
  fi

  echo

  # System readiness assessment
  local total_issues=0

  # Check critical blockers
  if [[ "$EUID" -eq 0 ]]; then
    echo -e "${RED}🚨 CRITICAL: Cannot run as root!${NC}"
    ((total_issues++))
  fi

  if [[ ! -f /etc/arch-release ]]; then
    echo -e "${RED}🚨 CRITICAL: Not in Arch realm!${NC}"
    ((total_issues++))
  fi

  if ! ping -c 1 archlinux.org >/dev/null 2>&1; then
    echo -e "${RED}🚨 CRITICAL: No internet connection!${NC}"
    ((total_issues++))
  fi

  # Auto-install missing tools if system is ready
  if [[ $total_issues -eq 0 ]] && [[ ${#missing_tools[@]} -gt 0 ]]; then
    echo -e "${YELLOW}📦 Missing essential artifacts: ${missing_tools[*]}${NC}"
    echo -e "${CYAN}🔧 Installing missing artifacts automatically...${NC}"

    if sudo pacman -S --needed --noconfirm "${missing_tools[@]}"; then
      echo -e "${GREEN}✅ All missing artifacts successfully installed!${NC}"
    else
      echo -e "${RED}❌ Failed to install some artifacts${NC}"
      ((total_issues++))
    fi
  fi

  echo
  echo -e "${WHITE}💡 SACRED GUIDANCE:${NC}"
  if [[ $total_issues -eq 0 ]]; then
    echo -e "${GREEN}🎉 SYSTEM READY! All prerequisites satisfied.${NC}"
    echo -e "${CYAN}⚔️  Begin the sacred ritual: ./quick-install.sh${NC}"
  else
    echo -e "${RED}🛡️  System not ready - fix the issues above first${NC}"
  fi
}

#=============================================================================
# SACRED HELP & VERSION SCROLLS
#=============================================================================
display_sacred_help() {
  echo -e "${PURPLE}"
  echo "╔═════════════════════════════════════════════════════════════════════════╗"
  echo "║                   🏴‍☠️ Mine Sacred Dotfiles of Power 🏴‍☠️                   ║"
  echo "║                    No Maidens UwU - Sacred Installer                    ║"
  echo "╚═════════════════════════════════════════════════════════════════════════╝"
  echo -e "${NC}"

  echo -e "${WHITE}🏴‍☠️ SACRED USAGE:${NC}"
  echo -e "${CYAN}  $0 [DIVINE_FLAGS]${NC}"
  echo
  echo -e "${WHITE}⚔️  DIVINE COMMAND FLAGS:${NC}"
  echo -e "${GREEN}  -h, --help${NC}          Display these sacred help scrolls"
  echo -e "${GREEN}  -v, --version${NC}       Show version of this legendary script"
  echo -e "${GREEN}  --diagnose${NC}          Run system diagnostics (checks prerequisites only)"
  echo -e "${GREEN}  --dry-run${NC}           Simulate the ritual without making changes"
  echo -e "${GREEN}  --force${NC}             Force installation even if conflicts arise"
  echo -e "${GREEN}  --verbose${NC}           Enable verbose output for debugging"
  echo -e "${GREEN}  --skip-aur${NC}          Skip AUR package installation"
  echo
  echo -e "${WHITE}🏴‍☠️ SACRED TREASURES BESTOWED:${NC}"
  echo -e "${PURPLE}  🎭 eww, ⚡ fastfetch, 👻 ghostty, 🖼️ gthumb, 🪟 hyprland${NC}"
  echo -e "${PURPLE}  📜 okular, 🛡️ proton-vpn, 🌊 qbittorrent, ⭐ starship${NC}"
  echo -e "${PURPLE}  🔗 stow, 📱 telegram-desktop, 🖥️ tmux, 💬 zapzap${NC}"
  echo
  echo -e "${RED}❌ FORBIDDEN: sudo ./quick-install.sh${NC}"
  echo -e "${GREEN}✅ SACRED WAY: ./quick-install.sh${NC}"
  echo
  echo -e "${PURPLE}\"With great power comes great responsibility - and great dotfiles!\" ⚔️${NC}"
}

display_version_scroll() {
  echo -e "${PURPLE}"
  echo "╔═════════════════════════════════════════════════════════════════════════╗"
  echo "║                   🏴‍☠️ Mine Sacred Dotfiles of Power 🏴‍☠️                   ║"
  echo "║                    No Maidens UwU - Sacred Installer                    ║"
  echo "╚═════════════════════════════════════════════════════════════════════════╝"
  echo -e "${NC}"

  echo -e "${WHITE}🏴‍☠️ SACRED VERSION INFORMATION:${NC}"
  echo -e "${CYAN}  Script Name:${NC}     ${SCRIPT_NAME}"
  echo -e "${CYAN}  Version:${NC}        ${SCRIPT_VERSION}"
  echo -e "${CYAN}  Captain:${NC}        ${PIRATE_CAPTAIN}"
  echo -e "${CYAN}  Sacred Date:${NC}    ${SACRED_DATE}"
  echo -e "${CYAN}  Repository:${NC}     ${SACRED_REPO_URL}"
  echo -e "${CYAN}  License:${NC}        MIT (Maidens-Inclusive Technology)"
  echo
  echo -e "${PURPLE}\"May thy dotfiles be forever blessed with legendary power!\" ⚔️${NC}"
}

#=============================================================================
# SACRED ARGUMENT PROCESSING
#=============================================================================
process_sacred_arguments() {
  while [[ $# -gt 0 ]]; do
    case $1 in
    -h | --help)
      display_sacred_help
      exit 0
      ;;
    -v | --version)
      display_version_scroll
      exit 0
      ;;
    --diagnose)
      run_sacred_diagnostics
      exit 0
      ;;
    --dry-run)
      DRY_RUN_MODE=true
      whisper_warning "Dry run mode activated - no actual changes will be made"
      shift
      ;;
    --force)
      FORCE_MODE=true
      whisper_warning "Force mode activated - will override conflicts"
      shift
      ;;
    --verbose)
      VERBOSE_MODE=true
      whisper_warning "Verbose mode activated - detailed output enabled"
      shift
      ;;
    --skip-aur)
      SKIP_AUR=true
      whisper_warning "AUR treasure acquisition will be skipped"
      shift
      ;;
    *)
      cry_of_despair "Unknown sacred flag: $1"
      echo "Use --help for available divine commands"
      exit 1
      ;;
    esac
  done
}

#=============================================================================
# Realm Verification Rituals
#=============================================================================
verify_sacred_realm() {
  announce_quest "Verifying thou art in the sacred Arch realm..."

  if [[ "$DRY_RUN_MODE" == "true" ]]; then
    celebrate_victory "DRY RUN: Would verify sacred realm"
    return 0
  fi

  if [[ ! -f /etc/arch-release ]]; then
    cry_of_despair "These sacred configs only work in the Arch Realm and its vassal territories!"
    cry_of_despair "Current realm detected: $(lsb_release -d 2>/dev/null | cut -f2 || echo "Unknown lands")"
    exit 1
  fi
  celebrate_victory "Arch Linux realm verified - thou art in sacred territory"
}

test_ethereal_connection() {
  announce_quest "Testing connection to the sacred ethereal repositories..."

  if [[ "$DRY_RUN_MODE" == "true" ]]; then
    celebrate_victory "DRY RUN: Would test ethereal connection"
    return 0
  fi

  if ! ping -c 1 archlinux.org &>/dev/null; then
    cry_of_despair "The ethereal networks are severed! Thy connection to the sacred repositories has failed."
    exit 1
  fi
  celebrate_victory "Connection to the sacred repositories established"
}

summon_essential_artifacts() {
  announce_quest "Summoning essential artifacts for the sacred ritual..."

  if [[ "$DRY_RUN_MODE" == "true" ]]; then
    celebrate_victory "DRY RUN: Would summon essential artifacts"
    return 0
  fi

  local missing_artifacts=()
  local essential_tools=("git" "curl")

  for tool in "${essential_tools[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
      missing_artifacts+=("$tool")
    fi
  done

  # Check base-devel group
  if ! pacman -Qq base-devel >/dev/null 2>&1; then
    missing_artifacts+=("base-devel")
  fi

  if [[ ${#missing_artifacts[@]} -gt 0 ]]; then
    whisper_warning "Missing essential artifacts: ${missing_artifacts[*]}"
    announce_quest "Summoning the missing artifacts of power..."
    sudo pacman -S --needed --noconfirm "${missing_artifacts[@]}" || {
      cry_of_despair "Failed to summon the essential artifacts"
      exit 1
    }
  fi
  celebrate_victory "All essential artifacts of power are present"
}

verify_paru_presence() {
  announce_quest "Verifying the presence of the mighty Paru helper..."

  if [[ "$DRY_RUN_MODE" == "true" ]]; then
    celebrate_victory "DRY RUN: Would verify/install Paru"
    return 0
  fi

  if ! command -v paru &>/dev/null; then
    whisper_warning "The sacred Paru helper is not among thy tools"
    if [[ "$FORCE_MODE" == "true" ]]; then
      ritual_of_paru_summoning
    else
      read -p "$(echo -e "${YELLOW}Dost thou wish to summon the mighty Paru? (highly recommended) [Y/n]: ${NC}")" -n 1 -r
      echo
      if [[ $REPLY =~ ^[Nn]$ ]]; then
        whisper_warning "Skipping Paru summoning. Thou must manually acquire AUR treasures."
        return 1
      else
        ritual_of_paru_summoning
      fi
    fi
  fi
  celebrate_victory "The mighty Paru helper stands ready"
  return 0
}

ritual_of_paru_summoning() {
  announce_quest "Performing the ancient ritual of Paru summoning..."

  if [[ "$DRY_RUN_MODE" == "true" ]]; then
    celebrate_victory "DRY RUN: Would summon mighty Paru"
    return 0
  fi

  local temp_sanctuary=$(mktemp -d)
  cd "$temp_sanctuary"

  # Ensure base-devel is present for the ritual
  sudo pacman -S --needed --noconfirm base-devel

  # Clone with plain URL (no markdown formatting)
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si --noconfirm

  # Cleanse the temporary sanctuary
  cd "$HOME"
  rm -rf "$temp_sanctuary"

  celebrate_victory "Paru has been successfully summoned and bound to thy will"
}

#=============================================================================
# Sacred Backup Rituals
#=============================================================================
create_backup_sanctuary() {
  announce_quest "Creating a sanctuary for thy existing configurations..."

  if [[ "$DRY_RUN_MODE" == "true" ]]; then
    celebrate_victory "DRY RUN: Would create backup sanctuary"
    return 0
  fi

  mkdir -p "$BACKUP_VAULT"

  local sacred_configs=(
    "$HOME/.zshrc"
    "$HOME/.tmux.conf"
    "$HOME/.config/hypr"
    "$HOME/.config/tmux"
    "$HOME/.config/ghostty"
    "$HOME/.config/starship.toml"
    "$HOME/.config/eww"
  )

  local artifacts_preserved=0
  for config in "${sacred_configs[@]}"; do
    if [[ -e "$config" ]]; then
      cp -r "$config" "$BACKUP_VAULT/" 2>/dev/null || true
      artifacts_preserved=$((artifacts_preserved + 1))
    fi
  done

  if [[ $artifacts_preserved -gt 0 ]]; then
    celebrate_victory "Sacred backup vault created: $BACKUP_VAULT ($artifacts_preserved artifacts preserved)"
    inscribe_scroll "Backup sanctuary location: $BACKUP_VAULT"
  else
    whisper_warning "No existing configurations found to preserve (thou hast a clean slate)"
  fi
}

#=============================================================================
# Installation Rituals of Great Power
#=============================================================================
acquire_sacred_repository() {
  announce_quest "Acquiring the sacred repository from the digital realm..."

  if [[ "$DRY_RUN_MODE" == "true" ]]; then
    celebrate_victory "DRY RUN: Would acquire sacred repository"
    return 0
  fi

  if [[ -d "$DOTFILES_SANCTUARY" ]]; then
    whisper_warning "A sanctuary already exists at $DOTFILES_SANCTUARY"
    if [[ "$FORCE_MODE" == "true" ]]; then
      rm -rf "$DOTFILES_SANCTUARY"
    else
      read -p "$(echo -e "${YELLOW}Dost thou wish to purge and re-acquire the sacred texts? [y/N]: ${NC}")" -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$DOTFILES_SANCTUARY"
      else
        cry_of_despair "The ritual has been abandoned by thy will"
        exit 1
      fi
    fi
  fi

  git clone "$SACRED_REPO_URL" "$DOTFILES_SANCTUARY" || {
    cry_of_despair "Failed to acquire the sacred repository"
    exit 1
  }

  celebrate_victory "Sacred repository successfully acquired and bound to thy realm"
}

summon_oh_my_zsh() {
  announce_quest "Summoning the ancient Oh My Zsh magic..."

  if [[ "$DRY_RUN_MODE" == "true" ]]; then
    celebrate_victory "DRY RUN: Would summon Oh My Zsh magic"
    return 0
  fi

  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    whisper_warning "The Oh My Zsh magic is already bound to thy shell, proceeding..."
    return 0
  fi

  # Summon Oh My Zsh without mortal interaction
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || {
    cry_of_despair "The Oh My Zsh summoning ritual has failed"
    exit 1
  }

  celebrate_victory "Oh My Zsh magic successfully bound to thy shell"
}

bind_mystical_plugins() {
  announce_quest "Binding mystical Zsh plugins to enhance thy shell powers..."

  if [[ "$DRY_RUN_MODE" == "true" ]]; then
    celebrate_victory "DRY RUN: Would bind mystical plugins"
    return 0
  fi

  local plugin_artifacts=(
    "https://github.com/zsh-users/zsh-autosuggestions.git|zsh-autosuggestions|The Suggestion Whisperer"
    "https://github.com/zsh-users/zsh-syntax-highlighting.git|zsh-syntax-highlighting|The Syntax Illuminator"
    "https://github.com/marlonrichert/zsh-autocomplete.git|zsh-autocomplete|The Completion Oracle"
    "https://github.com/MichaelAquilina/zsh-you-should-use.git|you-should-use|The Alias Reminder Spirit"
  )

  local plugin_sanctuary="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

  for plugin_info in "${plugin_artifacts[@]}"; do
    IFS='|' read -r url name title <<<"$plugin_info"
    local plugin_home="$plugin_sanctuary/$name"

    if [[ ! -d "$plugin_home" ]]; then
      git clone "$url" "$plugin_home" || {
        whisper_warning "Failed to bind plugin: $title"
        continue
      }
      celebrate_victory "Successfully bound: $title"
    else
      whisper_warning "$title already bound to thy shell, skipping..."
    fi
  done
}

acquire_aur_treasures() {
  if [[ "$SKIP_AUR" == "true" ]]; then
    whisper_warning "Skipping AUR treasure acquisition as requested"
    return 0
  fi

  if ! verify_paru_presence; then
    whisper_warning "Skipping AUR treasure acquisition (Paru not available)"
    return 0
  fi

  announce_quest "Acquiring sacred treasures from the AUR realm (complete README collection)..."

  if [[ "$DRY_RUN_MODE" == "true" ]]; then
    celebrate_victory "DRY RUN: Would acquire all sacred treasures"
    return 0
  fi

  # COMPLETE LIST: All 13 sacred treasures
  local sacred_treasures=(
    "eww|The Widget Weaver of Wonders"
    "fastfetch|The Swift System Herald"
    "ghostty|Terminal of the Spirits"
    "gthumb|The Image Realm Guardian"
    "hyprland|The Wayland Window Wizard"
    "okular|The Document Scroll Master"
    "proton-vpn-gtk-app|The Privacy Shield Enchanter"
    "qbittorrent|The Torrent Tide Controller"
    "starship|The Cosmic Prompt Navigator"
    "stow|The Symlink Alchemist"
    "telegram-desktop|The Encrypted Message Mystic"
    "tmux|The Session Multiplier"
    "zapzap|The WhatsApp Whisper Conduit"
  )

  whisper_warning "This ritual may take considerable time depending on thy realm's power..."

  for treasure_info in "${sacred_treasures[@]}"; do
    IFS='|' read -r package title <<<"$treasure_info"
    announce_quest "Acquiring $title ($package)..."
    if paru -S --needed --noconfirm "$package"; then
      celebrate_victory "Successfully acquired: $title"
    else
      whisper_warning "Failed to acquire: $title (manual acquisition may be required)"
    fi
  done
}

deploy_sacred_configurations() {
  announce_quest "Deploying sacred configurations with the power of GNU Stow..."

  if [[ "$DRY_RUN_MODE" == "true" ]]; then
    celebrate_victory "DRY RUN: Would deploy configurations with GNU Stow"
    return 0
  fi

  cd "$DOTFILES_SANCTUARY"

  # Remove conflicting mortal configurations
  local conflicting_artifacts=(
    "$HOME/.zshrc"
    "$HOME/.tmux.conf"
  )

  for conflict in "${conflicting_artifacts[@]}"; do
    if [[ -f "$conflict" && ! -L "$conflict" ]]; then
      whisper_warning "Removing conflicting mortal artifact: $conflict"
      rm -f "$conflict"
    fi
  done

  # Deploy the sacred configurations
  if stow . 2>/dev/null; then
    celebrate_victory "Sacred configurations deployed successfully across thy realm"
  else
    cry_of_despair "Deployment ritual failed. Seeking the source of conflict..."

    # Divine the nature of conflicts
    stow --simulate . 2>&1 | grep -E "(conflict|existing)" || true

    if [[ "$FORCE_MODE" == "true" ]]; then
      stow --adopt . || {
        cry_of_despair "Even divine force failed to deploy the sacred configurations"
        exit 1
      }
      celebrate_victory "Sacred configurations force deployed with divine intervention"
    else
      read -p "$(echo -e "${YELLOW}Force deployment with divine power (may overwrite existing artifacts)? [y/N]: ${NC}")" -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        stow --adopt . || {
          cry_of_despair "Even divine force failed to deploy the sacred configurations"
          exit 1
        }
        celebrate_victory "Sacred configurations force deployed with divine intervention"
      else
        cry_of_despair "Deployment ritual abandoned by thy divine will"
        exit 1
      fi
    fi
  fi
}

transform_shell_realm() {
  announce_quest "Offering to transform thy shell to the sacred Zsh realm..."

  if [[ "$DRY_RUN_MODE" == "true" ]]; then
    celebrate_victory "DRY RUN: Would optionally transform shell to Zsh"
    return 0
  fi

  if [[ "$SHELL" == "$(which zsh)" ]]; then
    whisper_warning "Thy shell already dwells in the sacred Zsh realm"
    return 0
  fi

  if [[ "$FORCE_MODE" == "true" ]]; then
    chsh -s "$(which zsh)" || {
      whisper_warning "Shell transformation requires manual intervention: chsh -s $(which zsh)"
      return 0
    }
    celebrate_victory "Thy default shell has been transformed to the sacred Zsh realm"
  else
    read -p "$(echo -e "${YELLOW}Dost thou wish to make Zsh thy default shell realm? [Y/n]: ${NC}")" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
      whisper_warning "Keeping thy current shell realm: $SHELL"
      return 0
    fi

    chsh -s "$(which zsh)" || {
      whisper_warning "Shell transformation requires manual intervention: chsh -s $(which zsh)"
      return 0
    }

    celebrate_victory "Thy default shell has been transformed to the sacred Zsh realm"
  fi
}

#=============================================================================
# Restoration Rituals (For When Things Go Awry)
#=============================================================================
restore_from_sanctuary() {
  announce_quest "Performing restoration ritual from thy backup sanctuary..."

  if [[ -d "$BACKUP_VAULT" ]]; then
    announce_quest "Restoring artifacts from sanctuary: $BACKUP_VAULT"
    cp -r "$BACKUP_VAULT"/* "$HOME/" 2>/dev/null || true
    celebrate_victory "Ancient configurations restored from sanctuary"
  fi

  if [[ -d "$DOTFILES_SANCTUARY" ]]; then
    cd "$DOTFILES_SANCTUARY"
    stow -D . 2>/dev/null || true
    celebrate_victory "Sacred dotfiles have been unbound from thy realm"
  fi

  celebrate_victory "Restoration ritual completed"
}

#=============================================================================
# The Grand Installation Ceremony
#=============================================================================
begin_sacred_ritual() {
  # Process sacred arguments first
  process_sacred_arguments "$@"

  # Trap curses for divine cleanup
  trap 'cry_of_despair "The sacred ritual has failed! Consult $SACRED_SCROLLS for divine guidance."; restore_from_sanctuary; exit 1' ERR
  trap 'restore_from_sanctuary; exit 130' INT # Handle the Ctrl+C curse

  herald_beginning

  # Skip consent if dry run mode
  if [[ "$DRY_RUN_MODE" != "true" ]]; then
    # Seek mortal consent for the sacred ritual
    echo -e "${WHITE}🏴‍☠️ This sacred ritual shall bestow upon thee:${NC}"
    echo "• 🔍 Verification of thy realm's worthiness"
    echo "• 📦 Acquisition of essential artifacts and AUR treasures"
    echo "• 🧙 Binding of Oh My Zsh with mystical shell enhancement plugins"
    echo "• 🔗 Deployment of sacred configurations via GNU Stow"
    echo "• 💾 Creation of backup sanctuaries for thy existing configs"
    echo "• 🐚 Optional transformation of thy shell to the Zsh realm"
    echo
    echo -e "${YELLOW}⚠️  HEED THESE ANCIENT WARNINGS:${NC}"
    echo "• 🏴‍☠️ This ritual is crafted exclusively for the Arch realm and its territories"
    echo "• 💾 Existing configurations shall be preserved but may face transformation"
    echo "• ⏰ AUR treasure acquisition may require patience of mortal hours"
    echo "• 🔄 Thou may need to restart thy terminal/session after the ritual's completion"
    echo "• 🎯 EWW widgets work only in Wayland realms (Hyprland recommended)"
    echo
    echo -e "${PURPLE}\"In the realm where no maidens dwell, these configurations shall serve thee well\" ⚔️${NC}"
    echo

    read -p "$(echo -e "${WHITE}Dost thou wish to proceed with this sacred ritual? [y/N]: ${NC}")" -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      whisper_warning "The sacred ritual has been declined by thy divine will"
      exit 0
    fi
  fi

  inscribe_scroll "=== SACRED DOTFILES RITUAL COMMENCED ==="

  # Preliminary realm verification
  announce_quest "Performing preliminary realm verification rituals..."
  verify_sacred_realm
  test_ethereal_connection
  summon_essential_artifacts

  # The grand ceremony begins
  create_backup_sanctuary
  acquire_sacred_repository
  summon_oh_my_zsh
  bind_mystical_plugins
  acquire_aur_treasures
  deploy_sacred_configurations
  transform_shell_realm

  # Proclamation of victory
  echo -e "\n${GREEN}╔══════════════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║                    🎉 THE SACRED RITUAL IS COMPLETE! 🎉                   ║${NC}"
  echo -e "${GREEN}║                  🏴‍☠️ Welcome to the Maidenless Realm! 🏴‍☠️                   ║${NC}"
  echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════════════════╝${NC}"
  echo
  echo -e "${WHITE}🎯 Sacred Commands for Thy Next Journey:${NC}"
  echo -e "• ${CYAN}Restart thy terminal or invoke: ${WHITE}source ~/.zshrc${NC}"
  echo -e "• ${CYAN}Log out and return (or restart) for complete transformation${NC}"
  echo -e "• ${CYAN}Explore thy new configurations in: ${WHITE}~/.config/${NC}"
  echo -e "• ${CYAN}Backup sanctuary location: ${WHITE}$BACKUP_VAULT${NC}"
  echo -e "• ${CYAN}Sacred ritual scrolls: ${WHITE}$SACRED_SCROLLS${NC}"
  echo
  echo -e "${PURPLE}🏴‍☠️ \"With great power comes great responsibility - and great dotfiles!\" ⚔️${NC}"
  echo -e "${PURPLE}\nMay thy productivity be legendary and thy configurations forever blessed! 🌟${NC}"

  inscribe_scroll "=== SACRED DOTFILES RITUAL COMPLETED WITH DIVINE SUCCESS ==="
}

#=============================================================================
# Sacred Script Execution
#=============================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  begin_sacred_ritual "$@"
fi
