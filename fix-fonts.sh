#!/bin/bash

# Font Troubleshooting Script for Alacritty
# Run this if the terminal font looks wrong (proportional, ugly, or blurry)

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_header() { echo -e "${PURPLE}$1${NC}"; }

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ALACRITTY_CONF="$HOME/.config/alacritty/alacritty.toml"
NERD_FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.tar.xz"

# True if fontconfig has a font with exactly this family name
font_installed() {
    fc-list : family | tr ',' '\n' | grep -qixF "$1"
}

# Family used by the active (uncommented) normal font line in alacritty.toml
configured_family() {
    sed -n -E 's/^normal = \{ family = "([^"]*)".*/\1/p' "$ALACRITTY_CONF" 2>/dev/null | head -1
}

# Point every active font style at the given family, whatever it was before.
# Only touches the [font] section; --follow-symlinks edits the repo copy when
# the config is symlinked by install.sh.
set_family() {
    local family="$1"
    if [ ! -f "$ALACRITTY_CONF" ]; then
        print_error "Alacritty config not found at $ALACRITTY_CONF (run ./install.sh first)"
        return 1
    fi
    sed -i --follow-symlinks -E \
        "/^\[font\]/,/^\[/ s/^((normal|bold|italic|bold_italic) = \{ family = \")[^\"]*(\")/\1${family}\3/" \
        "$ALACRITTY_CONF"
    print_success "Alacritty now uses \"$family\". It live-reloads; restart it if nothing changed."
}

install_nerd_font() {
    if font_installed "FiraCode Nerd Font"; then
        return 0
    fi
    print_status "Installing FiraCode Nerd Font..."
    local tmp
    tmp=$(mktemp -d)
    if curl -fsSL -o "$tmp/FiraCode.tar.xz" "$NERD_FONT_URL"; then
        mkdir -p "$HOME/.local/share/fonts/FiraCodeNerdFont"
        tar -xJf "$tmp/FiraCode.tar.xz" -C "$HOME/.local/share/fonts/FiraCodeNerdFont" \
            --wildcards 'FiraCodeNerdFont-*.ttf' 'FiraCodeNerdFontMono-*.ttf'
        fc-cache -f
    else
        print_error "Failed to download FiraCode Nerd Font"
    fi
    rm -rf "$tmp"
    font_installed "FiraCode Nerd Font"
}

# Install a font (dnf package) if the family is missing, then select it
use_packaged_font() {
    local family="$1" package="$2"
    if ! font_installed "$family"; then
        print_status "Installing $package..."
        sudo dnf install -y "$package" || { print_error "Failed to install $package"; return 1; }
        fc-cache -f
    fi
    set_family "$family"
}

print_header "=== Font Troubleshooting for Alacritty ==="
echo ""

# Diagnose: does the configured family actually exist?
current="$(configured_family)"
print_status "Alacritty is configured to use: ${current:-<unknown>}"
if [ -n "$current" ] && [ "$current" != "monospace" ]; then
    if font_installed "$current"; then
        print_success "✓ \"$current\" is installed"
    else
        resolved="$(fc-match -f '%{family}' "$current")"
        print_error "✗ \"$current\" is NOT installed; fontconfig falls back to \"$resolved\""
        print_status "That fallback is the usual cause of ugly/proportional terminal text."
    fi
fi

echo ""
print_status "Status of known fonts:"
for family in "FiraCode Nerd Font" "Fira Code" "JetBrains Mono" "Cascadia Code"; do
    if font_installed "$family"; then
        print_success "✓ $family"
    else
        print_warning "✗ $family (not installed)"
    fi
done

echo ""
print_header "Font Fixes:"
echo "Choose a font option:"
echo "1) FiraCode Nerd Font (recommended; installs it if missing)"
echo "2) Fira Code"
echo "3) JetBrains Mono"
echo "4) Cascadia Code"
echo "5) System monospace font"
echo "6) Reset alacritty.toml to the repo default"
echo "7) Show current Alacritty font configuration"
echo "q) Quit"

read -p "Enter your choice (1-7 or q): " choice

case $choice in
    1)
        if install_nerd_font; then
            set_family "FiraCode Nerd Font"
        else
            print_error "FiraCode Nerd Font is unavailable; config left unchanged"
        fi
        ;;
    2) use_packaged_font "Fira Code" "fira-code-fonts" ;;
    3) use_packaged_font "JetBrains Mono" "jetbrains-mono-fonts" ;;
    4) use_packaged_font "Cascadia Code" "cascadia-code-fonts" ;;
    5) set_family "monospace" ;;
    6)
        print_status "Resetting to repo default configuration..."
        if [ -f "$SCRIPT_DIR/alacritty.toml" ]; then
            mkdir -p "$(dirname "$ALACRITTY_CONF")"
            ln -sf "$SCRIPT_DIR/alacritty.toml" "$ALACRITTY_CONF"
            print_success "Linked repo alacritty.toml. The default needs FiraCode Nerd Font; pick option 1 if it is missing."
        else
            print_error "Original alacritty.toml not found in script directory"
        fi
        ;;
    7)
        print_status "Current Alacritty font configuration:"
        if [ -f "$ALACRITTY_CONF" ]; then
            sed -n '/^\[font\]/,/^\[colors\]/p' "$ALACRITTY_CONF" | grep -v '^#' | grep -v '^$'
        else
            print_error "Alacritty config file not found"
        fi
        ;;
    q)
        print_status "Exiting..."
        exit 0
        ;;
    *)
        print_error "Invalid choice"
        ;;
esac

echo ""
print_header "Additional troubleshooting tips:"
echo "• Adjust 'size' in the [font] section of $ALACRITTY_CONF (11-14 suits a 1440p monitor)"
echo "• ~/.config/fontconfig/fonts.conf should not force rgba=rgb; GNOME uses grayscale antialiasing"
echo "• Verify a font resolves: fc-match 'FiraCode Nerd Font'  (should NOT print Noto Sans)"
echo "• Rebuild the cache after adding fonts: fc-cache -f"
