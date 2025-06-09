#!/bin/bash

# Dotfiles Installation Script for Fedora Workstation
# This script will symlink dotfiles from this repository to your home directory

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${PURPLE}$1${NC}"
}

# Function to create backup of existing files
backup_file() {
    local file="$1"
    if [[ -e "$file" ]] || [[ -L "$file" ]]; then
        if [[ ! -d "$BACKUP_DIR" ]]; then
            mkdir -p "$BACKUP_DIR"
            print_status "Created backup directory: $BACKUP_DIR"
        fi
        
        local filename=$(basename "$file")
        cp -P "$file" "$BACKUP_DIR/$filename" 2>/dev/null
        print_warning "Backed up existing $filename to $BACKUP_DIR"
        rm -rf "$file"
    fi
}

# Function to create symlink
create_symlink() {
    local source="$1"
    local target="$2"
    local name="$3"
    
    if [[ ! -f "$source" ]]; then
        print_error "Source file $source does not exist!"
        return 1
    fi
    
    backup_file "$target"
    
    if ln -sf "$source" "$target"; then
        print_success "Linked $name"
    else
        print_error "Failed to link $name"
        return 1
    fi
}

# Function to install package if not already installed
install_package() {
    local package="$1"
    if ! rpm -q "$package" &>/dev/null; then
        print_status "Installing $package..."
        if sudo dnf install -y "$package"; then
            print_success "Installed $package"
        else
            print_error "Failed to install $package"
            return 1
        fi
    else
        print_status "$package is already installed"
    fi
}

# Function to install Vim plugins
install_vim_plugins() {
    print_header "Setting up Vim plugins..."
    
    # Create vim directories if they don't exist
    mkdir -p "$HOME/.vim/"{autoload,bundle}
    
    # Install pathogen if not already installed
    if [[ ! -f "$HOME/.vim/autoload/pathogen.vim" ]]; then
        print_status "Installing pathogen..."
        curl -fLso "$HOME/.vim/autoload/pathogen.vim" --create-dirs \
            https://tpo.pe/pathogen.vim
        if [[ $? -eq 0 ]]; then
            print_success "Installed pathogen"
        else
            print_error "Failed to install pathogen"
            return 1
        fi
    else
        print_status "Pathogen is already installed"
    fi
    
    # Install recommended plugins
    local plugins=(
        "https://github.com/tpope/vim-sensible.git|vim-sensible"
        "https://github.com/tpope/vim-surround.git|vim-surround"
        "https://github.com/tpope/vim-commentary.git|vim-commentary"
        "https://github.com/preservim/nerdtree.git|nerdtree"
        "https://github.com/vim-airline/vim-airline.git|vim-airline"
        "https://github.com/vim-airline/vim-airline-themes.git|vim-airline-themes"
        "https://github.com/morhetz/gruvbox.git|gruvbox"
        "https://github.com/airblade/vim-gitgutter.git|vim-gitgutter"
        "https://github.com/ctrlpvim/ctrlp.vim.git|ctrlp.vim"
    )
    
    for plugin_info in "${plugins[@]}"; do
        IFS='|' read -r url name <<< "$plugin_info"
        plugin_dir="$HOME/.vim/bundle/$name"
        
        if [[ ! -d "$plugin_dir" ]]; then
            print_status "Installing Vim plugin: $name..."
            if git clone "$url" "$plugin_dir"; then
                print_success "Installed $name"
            else
                print_error "Failed to install $name"
            fi
        else
            print_status "Vim plugin $name is already installed"
        fi
    done
}

# Function to setup font rendering
setup_font_rendering() {
    print_header "Setting up font rendering..."
    
    # Install font rendering packages for better appearance
    local font_packages=(
        "fontconfig"
        "freetype"
        "cairo"
        "pango" 
        "fontconfig-devel"
        "freetype-devel"
    )
    
    for package in "${font_packages[@]}"; do
        if ! rpm -q "$package" &>/dev/null; then
            print_status "Installing font rendering package: $package..."
            sudo dnf install -y "$package" &>/dev/null || true
        fi
    done
    
    # Create fontconfig directory if it doesn't exist
    mkdir -p "$HOME/.config/fontconfig"
    
    # Create improved fontconfig for better rendering
    cat > "$HOME/.config/fontconfig/fonts.conf" << 'EOF'
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
    <!-- Enable anti-aliasing -->
    <match target="font">
        <edit name="antialias" mode="assign">
            <bool>true</bool>
        </edit>
    </match>
    
    <!-- Enable hinting -->
    <match target="font">
        <edit name="hinting" mode="assign">
            <bool>true</bool>
        </edit>
    </match>
    
    <!-- Hinting style -->
    <match target="font">
        <edit name="hintstyle" mode="assign">
            <const>hintslight</const>
        </edit>
    </match>
    
    <!-- Sub-pixel rendering -->
    <match target="font">
        <edit name="rgba" mode="assign">
            <const>rgb</const>
        </edit>
    </match>
    
    <!-- LCD filter -->
    <match target="font">
        <edit name="lcdfilter" mode="assign">
            <const>lcddefault</const>
        </edit>
    </match>
    
    <!-- Prefer specific fonts for better rendering -->
    <alias>
        <family>monospace</family>
        <prefer>
            <family>Fira Code</family>
            <family>JetBrains Mono</family>
            <family>Cascadia Code</family>
            <family>Liberation Mono</family>
        </prefer>
    </alias>
</fontconfig>
EOF
    
    print_success "Font rendering configured for better display"
}

# Function to install multiple font options
install_fonts() {
    print_header "Installing programming fonts..."
    
    # Create fonts directory
    mkdir -p "$HOME/.local/share/fonts"
    
    # Install system fonts
    local font_packages=(
        "fira-code-fonts"
        "jetbrains-mono-fonts" 
        "cascadia-code-fonts"
        "liberation-fonts"
        "google-noto-fonts"
        "google-noto-emoji-fonts"
    )
    
    for font in "${font_packages[@]}"; do
        if ! rpm -q "$font" &>/dev/null; then
            print_status "Installing font package: $font..."
            sudo dnf install -y "$font" &>/dev/null || print_warning "Could not install $font"
        else
            print_status "Font $font is already installed"
        fi
    done
    
    # Update font cache
    print_status "Updating font cache..."
    fc-cache -fv &>/dev/null || true
    
    print_success "Fonts installed and cache updated"
}

# Function to setup Alacritty configuration
setup_alacritty() {
    print_header "Setting up Alacritty terminal..."
    
    # Install Alacritty if not already installed
    install_package "alacritty"
    
    # Create Alacritty config directory
    mkdir -p "$HOME/.config/alacritty"
    
    # Create symlink for Alacritty configuration
    create_symlink "$DOTFILES_DIR/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml" "Alacritty configuration"
    
    print_success "Alacritty configured with bash as default shell"
}

# Function to setup Git configuration
setup_git() {
    print_header "Setting up Git configuration..."
    
    # Install Git if not already installed
    install_package "git"
    
    # Install GPG packages for commit signing
    install_package "gpg"
    install_package "gpg2"
    install_package "gnupg2"
    
    # Create symlink for Git configuration
    create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig" "Git configuration"
    
    print_success "Git configuration completed with GPG signing enabled"
}

# Function to setup Bash configuration
setup_bash() {
    print_header "Setting up Bash configuration..."
    
    # Create .bashrc.d directory for modular bash configuration
    mkdir -p "$HOME/.bashrc.d"
    
    # Create symlink for vim mode bash configuration
    create_symlink "$DOTFILES_DIR/bashrc_vim" "$HOME/.bashrc.d/vim_mode" "Bash vim mode configuration"
    
    # Check if .bashrc sources the .bashrc.d directory
    if ! grep -q "~/.bashrc.d/" "$HOME/.bashrc" 2>/dev/null; then
        print_status "Adding .bashrc.d sourcing to .bashrc..."
        cat >> "$HOME/.bashrc" << 'EOF'

# Source additional bash configurations
if [ -d ~/.bashrc.d ]; then
    for file in ~/.bashrc.d/*; do
        [ -r "$file" ] && source "$file"
    done
fi
EOF
        print_success "Added .bashrc.d sourcing to .bashrc"
    else
        print_status ".bashrc already sources .bashrc.d directory"
    fi
    
    print_success "Bash configuration completed with vim mode enabled"
}

# Function to setup FZF (fuzzy finder)
setup_fzf() {
    print_header "Setting up FZF (fuzzy finder)..."
    
    # Install FZF if not already installed
    install_package "fzf"
    
    # Create FZF configuration for bash
    local fzf_completion="$HOME/.fzf.bash"
    if [[ ! -f "$fzf_completion" ]]; then
        print_status "Creating FZF bash configuration..."
        echo '# FZF configuration for bash' > "$fzf_completion"
        /usr/share/fzf/shell/key-bindings.bash >> "$fzf_completion" 2>/dev/null || true
        /usr/share/fzf/shell/completion.bash >> "$fzf_completion" 2>/dev/null || true
        print_success "FZF bash configuration created"
    else
        print_status "FZF configuration already exists"
    fi
}

# Function to install GNOME Extensions
install_gnome_extensions() {
    print_header "Installing GNOME Extensions..."
    
    # Install gnome-extensions-app if not already installed
    install_package "gnome-extensions-app" || true
    install_package "gnome-shell-extension-manager" || true
    
    # Install hanabi extension for GNOME
    local hanabi_dir="$HOME/.local/share/gnome-shell/extensions/hanabi@jeffshee.github.io"
    if [[ ! -d "$hanabi_dir" ]]; then
        print_status "Installing hanabi GNOME extension..."
        mkdir -p "$HOME/.local/share/gnome-shell/extensions"
        
        # Download and install hanabi extension
        local temp_dir=$(mktemp -d)
        if git clone https://github.com/jeffshee/gnome-ext-hanabi.git "$temp_dir"; then
            cp -r "$temp_dir/hanabi@jeffshee.github.io" "$HOME/.local/share/gnome-shell/extensions/"
            print_success "Hanabi extension installed"
            print_status "Enable it with: gnome-extensions enable hanabi@jeffshee.github.io"
            rm -rf "$temp_dir"
        else
            print_warning "Could not install hanabi extension"
            rm -rf "$temp_dir"
        fi
    else
        print_status "Hanabi extension is already installed"
    fi
}

# Main installation function
main() {
    print_header "=== Fedora Workstation Dotfiles Installation ==="
    print_status "Starting installation from: $DOTFILES_DIR"
    echo
    
    # Update system packages first
    print_header "Updating system packages..."
    sudo dnf update -y
    
    # Install essential packages
    print_header "Installing essential packages..."
    local essential_packages=(
        "vim"
        "git"
        "curl"
        "wget"
        "htop"
        "tree"
        "unzip"
        "tar"
        "alacritty"
    )
    
    for package in "${essential_packages[@]}"; do
        install_package "$package"
    done
    
    # Setup font rendering first for better appearance
    setup_font_rendering
    
    # Install fonts
    install_fonts
    
    # Setup Vim with pathogen and plugins
    install_vim_plugins
    
    # Create symlinks for configuration files
    print_header "Creating symlinks for dotfiles..."
    create_symlink "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc" "Vim configuration"
    
    # Setup Alacritty terminal
    setup_alacritty
    
    # Setup Git configuration  
    setup_git
    
    # Setup Bash configuration
    setup_bash
    
    # Setup FZF
    setup_fzf
    
    # Install GNOME extensions
    install_gnome_extensions
    
    # Final success message
    print_header "=== Installation Complete! ==="
    echo
    print_success "Your Fedora dotfiles have been installed successfully!"
    echo
    print_header "What was installed:"
    echo "  • Vim configuration with pathogen plugin manager and essential plugins"
    echo "  • Alacritty configuration with 80% transparency and vim mode (bash default)"
    echo "  • Git configuration with GPG commit signing"
    echo "  • Font rendering optimizations (fontconfig, freetype, cairo, pango)"
    echo "  • Multiple programming fonts (Fira Code, JetBrains Mono, Cascadia Code)"
    echo "  • Bash configuration with vim mode enabled"
    echo "  • FZF fuzzy finder with bash integration"
    echo "  • GNOME hanabi extension for dynamic wallpapers"
    echo
    print_header "Next steps:"
    echo
    print_status "1. Restart your terminal to use the new bash configuration"
    print_status "2. Enable GNOME extensions: gnome-extensions enable hanabi@jeffshee.github.io"
    print_status "3. If you have font rendering issues, run: ./fix-fonts.sh"
    echo
    print_header "Bash Features & Key Bindings:"
    echo "• Vim mode in command line (ESC to enter vi-command mode)"
    echo "• Enhanced aliases for git, system monitoring, and file operations"
    echo "• FZF integration for fuzzy file/history search (Ctrl+R, Ctrl+T)"
    echo "• Useful functions: mkcd, weather, backup, extract"
    echo
    print_success "Enjoy your new developer environment!"
    print_warning "If you backed up files, they are in: $BACKUP_DIR"
}

# Run main installation
main "$@" 