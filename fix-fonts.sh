#!/bin/bash

# Font Troubleshooting Script for Alacritty
# Run this if JetBrains Mono or other fonts look horrible

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

print_header "=== Font Troubleshooting for Alacritty ==="
echo ""

# Check current font situation
print_status "Checking available fonts..."
echo ""

print_status "Currently installed monospace fonts:"
fc-list : family | grep -i -E "(mono|code|jetbrains|fira|cascadia|liberation|dejavu|noto)" | sort -u

echo ""
print_status "Checking specific fonts:"

# Check JetBrains Mono
if fc-list | grep -qi "jetbrains mono"; then
    print_success "✓ JetBrains Mono is installed"
    JETBRAINS_AVAILABLE=true
else
    print_warning "✗ JetBrains Mono is NOT installed"
    JETBRAINS_AVAILABLE=false
fi

# Check Fira Code
if fc-list | grep -qi "fira code"; then
    print_success "✓ Fira Code is installed"
    FIRA_AVAILABLE=true
else
    print_warning "✗ Fira Code is NOT installed"
    FIRA_AVAILABLE=false
fi

# Check Cascadia Code
if fc-list | grep -qi "cascadia"; then
    print_success "✓ Cascadia Code is installed"
    CASCADIA_AVAILABLE=true
else
    print_warning "✗ Cascadia Code is NOT installed"
    CASCADIA_AVAILABLE=false
fi

echo ""
print_header "Font Fixes:"

# Offer to switch to different fonts
echo "Choose a font option:"
echo "1) Use Fira Code (recommended if JetBrains Mono looks bad)"
echo "2) Use Cascadia Code"
echo "3) Use system monospace font"
echo "4) Reinstall JetBrains Mono"
echo "5) Install all missing fonts"
echo "6) Reset to default and test"
echo "7) Show current Alacritty config"
echo "q) Quit"

read -p "Enter your choice (1-7 or q): " choice

case $choice in
    1)
        if [ "$FIRA_AVAILABLE" = true ]; then
            print_status "Switching to Fira Code..."
            sed -i 's/family = "JetBrains Mono"/family = "Fira Code"/g' ~/.config/alacritty/alacritty.toml
            print_success "Switched to Fira Code. Restart Alacritty to see changes."
        else
            print_status "Installing Fira Code first..."
            sudo dnf install -y fira-code-fonts
            if [ $? -eq 0 ]; then
                sed -i 's/family = "JetBrains Mono"/family = "Fira Code"/g' ~/.config/alacritty/alacritty.toml
                print_success "Installed and switched to Fira Code. Restart Alacritty to see changes."
            else
                print_error "Failed to install Fira Code"
            fi
        fi
        ;;
    2)
        if [ "$CASCADIA_AVAILABLE" = true ]; then
            print_status "Switching to Cascadia Code..."
            sed -i 's/family = "JetBrains Mono"/family = "Cascadia Code"/g' ~/.config/alacritty/alacritty.toml
            sed -i 's/family = "Fira Code"/family = "Cascadia Code"/g' ~/.config/alacritty/alacritty.toml
            print_success "Switched to Cascadia Code. Restart Alacritty to see changes."
        else
            print_status "Installing Cascadia Code first..."
            sudo dnf install -y cascadia-code-fonts
            if [ $? -eq 0 ]; then
                sed -i 's/family = "JetBrains Mono"/family = "Cascadia Code"/g' ~/.config/alacritty/alacritty.toml
                sed -i 's/family = "Fira Code"/family = "Cascadia Code"/g' ~/.config/alacritty/alacritty.toml
                print_success "Installed and switched to Cascadia Code. Restart Alacritty to see changes."
            else
                print_error "Failed to install Cascadia Code"
            fi
        fi
        ;;
    3)
        print_status "Switching to system monospace font..."
        sed -i 's/family = "JetBrains Mono"/family = "monospace"/g' ~/.config/alacritty/alacritty.toml
        sed -i 's/family = "Fira Code"/family = "monospace"/g' ~/.config/alacritty/alacritty.toml
        sed -i 's/family = "Cascadia Code"/family = "monospace"/g' ~/.config/alacritty/alacritty.toml
        print_success "Switched to system monospace font. Restart Alacritty to see changes."
        ;;
    4)
        print_status "Reinstalling JetBrains Mono..."
        temp_dir=$(mktemp -d)
        cd "$temp_dir"
        
        if curl -L "https://github.com/JetBrains/JetBrainsMono/releases/latest/download/JetBrainsMono.zip" -o JetBrainsMono.zip; then
            unzip -q JetBrainsMono.zip
            mkdir -p ~/.local/share/fonts
            cp fonts/ttf/*.ttf ~/.local/share/fonts/
            fc-cache -f -v
            print_success "Reinstalled JetBrains Mono. Restart Alacritty to see changes."
        else
            print_error "Failed to download JetBrains Mono"
        fi
        
        cd - >/dev/null
        rm -rf "$temp_dir"
        ;;
    5)
        print_status "Installing all missing fonts..."
        
        # Install via DNF
        sudo dnf install -y fira-code-fonts cascadia-code-fonts liberation-mono-fonts dejavu-sans-mono-fonts google-noto-mono-fonts
        
        # Install JetBrains Mono manually if needed
        if [ "$JETBRAINS_AVAILABLE" = false ]; then
            temp_dir=$(mktemp -d)
            cd "$temp_dir"
            
            if curl -L "https://github.com/JetBrains/JetBrainsMono/releases/latest/download/JetBrainsMono.zip" -o JetBrainsMono.zip; then
                unzip -q JetBrainsMono.zip
                mkdir -p ~/.local/share/fonts
                cp fonts/ttf/*.ttf ~/.local/share/fonts/
            fi
            
            cd - >/dev/null
            rm -rf "$temp_dir"
        fi
        
        fc-cache -f -v
        print_success "Installed all fonts. Check available fonts and restart Alacritty."
        ;;
    6)
        print_status "Resetting to default configuration..."
        if [ -f "$SCRIPT_DIR/alacritty.toml" ]; then
            cp "$SCRIPT_DIR/alacritty.toml" ~/.config/alacritty/alacritty.toml
            print_success "Reset to default config. Restart Alacritty to test."
        else
            print_error "Original alacritty.toml not found in script directory"
        fi
        ;;
    7)
        print_status "Current Alacritty font configuration:"
        if [ -f ~/.config/alacritty/alacritty.toml ]; then
            grep -A 10 "^\[font\]" ~/.config/alacritty/alacritty.toml | head -15
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
echo "• Try increasing font size: edit ~/.config/alacritty/alacritty.toml and change 'size = 13.0' to 14.0 or 15.0"
echo "• Check your display scaling settings in GNOME Settings"
echo "• For HiDPI displays, you may need larger font sizes (16-18pt)"
echo "• If fonts are blurry, check that RGB sub-pixel ordering is set correctly"
echo "• Run 'fc-list | grep -i [fontname]' to verify a font is properly installed"

echo ""
print_status "After making changes, restart Alacritty to see the effects." 