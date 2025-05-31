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
    
    <!-- Improve JetBrains Mono rendering -->
    <match target="font">
        <test name="family">
            <string>JetBrains Mono</string>
        </test>
        <edit name="antialias" mode="assign">
            <bool>true</bool>
        </edit>
        <edit name="hinting" mode="assign">
            <bool>true</bool>
        </edit>
        <edit name="hintstyle" mode="assign">
            <const>hintslight</const>
        </edit>
    </match>
</fontconfig>
EOF
    
    print_success "Created fontconfig configuration for better rendering"
}

# Function to install multiple font options
install_fonts() {
    print_header "Installing programming fonts..."
    
    local font_dir="$HOME/.local/share/fonts"
    mkdir -p "$font_dir"
    
    # Try to install JetBrains Mono
    if ! fc-list | grep -qi "jetbrains mono"; then
        print_status "Installing JetBrains Mono font..."
        local temp_dir=$(mktemp -d)
        cd "$temp_dir"
        
        if curl -L "https://github.com/JetBrains/JetBrainsMono/releases/latest/download/JetBrainsMono.zip" -o JetBrainsMono.zip; then
            unzip -q JetBrainsMono.zip
            cp fonts/ttf/*.ttf "$font_dir/" 2>/dev/null || true
            print_success "Installed JetBrains Mono font"
        else
            print_warning "Failed to download JetBrains Mono font"
        fi
        
        cd - >/dev/null
        rm -rf "$temp_dir"
    else
        print_status "JetBrains Mono font is already installed"
    fi
    
    # Install Fira Code as backup option
    if ! fc-list | grep -qi "fira code"; then
        print_status "Installing Fira Code font as backup..."
        if sudo dnf install -y fira-code-fonts &>/dev/null; then
            print_success "Installed Fira Code font"
        else
            print_warning "Failed to install Fira Code font via DNF"
            
            # Try manual installation
            local temp_dir=$(mktemp -d)
            cd "$temp_dir"
            
            if curl -L "https://github.com/tonsky/FiraCode/releases/latest/download/Fira_Code_v6.2.zip" -o FiraCode.zip 2>/dev/null; then
                unzip -q FiraCode.zip 2>/dev/null
                cp ttf/*.ttf "$font_dir/" 2>/dev/null || true
                print_success "Manually installed Fira Code font"
            else
                print_warning "Failed to download Fira Code font"
            fi
            
            cd - >/dev/null
            rm -rf "$temp_dir"
        fi
    else
        print_status "Fira Code font is already installed"
    fi
    
    # Install additional monospace fonts available in Fedora repos
    local repo_fonts=(
        "liberation-mono-fonts"
        "dejavu-sans-mono-fonts" 
        "google-noto-mono-fonts"
        "cascadia-code-fonts"
    )
    
    for font_package in "${repo_fonts[@]}"; do
        if ! rpm -q "$font_package" &>/dev/null; then
            print_status "Installing $font_package..."
            sudo dnf install -y "$font_package" &>/dev/null || true
        fi
    done
    
    # Refresh font cache
    print_status "Refreshing font cache..."
    fc-cache -f -v >/dev/null 2>&1
    print_success "Font cache refreshed"
    
    # Check which fonts are actually available
    print_status "Available monospace fonts:"
    fc-list : family | grep -i -E "(mono|code|jetbrains|fira|cascadia|liberation|dejavu|noto)" | sort -u | head -10
}

# Function to setup Alacritty config directory
setup_alacritty() {
    print_header "Setting up Alacritty configuration..."
    
    local alacritty_config_dir="$HOME/.config/alacritty"
    mkdir -p "$alacritty_config_dir"
    
    create_symlink "$DOTFILES_DIR/alacritty.toml" "$alacritty_config_dir/alacritty.toml" "Alacritty config"
    
    # Provide font suggestions if JetBrains Mono isn't available
    if command -v alacritty &>/dev/null; then
        if ! fc-list | grep -qi "jetbrains mono"; then
            print_warning "JetBrains Mono not found!"
            print_status "You can manually edit ~/.config/alacritty/alacritty.toml to use a different font:"
            print_status "  - Change 'JetBrains Mono' to 'Fira Code'"
            print_status "  - Or uncomment the alternative font sections in the config"
            print_status "  - Or run './fix-fonts.sh' for interactive font switching"
        else
            print_success "JetBrains Mono font is available"
        fi
    fi
}

# Function to install and configure Hanabi GNOME extension
install_hanabi_extension() {
    print_header "Setting up Hanabi GNOME Extension (Live Wallpapers)..."
    
    # Check if we're running GNOME
    if [[ "$XDG_CURRENT_DESKTOP" != *"GNOME"* ]] && [[ "$DESKTOP_SESSION" != *"gnome"* ]]; then
        print_warning "Hanabi extension is designed for GNOME Shell. Skipping installation."
        return 0
    fi
    
    # Check GNOME Shell version
    local gnome_version=""
    if command -v gnome-shell &>/dev/null; then
        gnome_version=$(gnome-shell --version | grep -oE '[0-9]+' | head -1)
        print_status "Detected GNOME Shell version: $gnome_version"
        
        if [[ "$gnome_version" -lt 42 ]]; then
            print_warning "Hanabi requires GNOME Shell 42 or later. Current version: $gnome_version. Skipping installation."
            return 0
        fi
    else
        print_warning "GNOME Shell not found. Skipping Hanabi installation."
        return 0
    fi
    
    # Install required packages for Hanabi
    local hanabi_packages=(
        "meson"
        "ninja-build" 
        "npm"
        "clapper"
        "gstreamer1-plugins-base"
        "gstreamer1-plugins-good"
        "gstreamer1-plugins-bad-free"
        "gstreamer1-libav"
    )
    
    print_status "Installing Hanabi dependencies..."
    for package in "${hanabi_packages[@]}"; do
        install_package "$package"
    done
    
    # Check if extension is already installed
    local extensions_dir="$HOME/.local/share/gnome-shell/extensions"
    local hanabi_ext_dir="$extensions_dir/hanabi-extension@jeffshee.github.io"
    
    if [[ -d "$hanabi_ext_dir" ]]; then
        print_status "Hanabi extension is already installed"
    else
        print_status "Installing Hanabi extension..."
        
        # Create temporary directory for installation
        local temp_dir=$(mktemp -d)
        cd "$temp_dir"
        
        # Clone appropriate branch based on GNOME version
        local clone_command="git clone https://github.com/jeffshee/gnome-ext-hanabi.git"
        if [[ "$gnome_version" -ge 48 ]]; then
            clone_command="git clone https://github.com/jeffshee/gnome-ext-hanabi.git -b gnome-48"
            print_status "Using experimental GNOME 48 branch"
        elif [[ "$gnome_version" -le 44 ]]; then
            clone_command="git clone https://github.com/jeffshee/gnome-ext-hanabi.git -b legacy"
            print_status "Using legacy branch for GNOME 44 and earlier"
        fi
        
        if $clone_command; then
            cd gnome-ext-hanabi
            
            # Run installation script
            if ./run.sh install; then
                print_success "Hanabi extension installed successfully"
            else
                print_error "Failed to install Hanabi extension"
                cd - >/dev/null
                rm -rf "$temp_dir"
                return 1
            fi
        else
            print_error "Failed to clone Hanabi repository"
            cd - >/dev/null
            rm -rf "$temp_dir"
            return 1
        fi
        
        cd - >/dev/null
        rm -rf "$temp_dir"
    fi
    
    # Setup live directory and space bedroom wallpaper
    print_status "Setting up live wallpaper directory..."
    local live_dir="$HOME/live"
    mkdir -p "$live_dir"
    
    # Check if space bedroom video exists in the repository
    local repo_space_bedroom="$DOTFILES_DIR/live/space-bedroom.3840x2160.mp4"
    local target_space_bedroom="$live_dir/space-bedroom.3840x2160.mp4"
    
    if [[ -f "$repo_space_bedroom" ]]; then
        print_success "Found space bedroom wallpaper in repository: $repo_space_bedroom"
        
        # Create symlink to the repository file
        if ln -sf "$repo_space_bedroom" "$target_space_bedroom"; then
            print_success "Linked space bedroom wallpaper to $target_space_bedroom"
            space_bedroom_file="$target_space_bedroom"
        else
            print_error "Failed to link space bedroom wallpaper"
            return 1
        fi
    else
        print_warning "Space bedroom wallpaper not found in repository at: $repo_space_bedroom"
        space_bedroom_file=""
    fi
    
    # Also check for other video files in the repo's live directory
    print_status "Available wallpapers in repository:"
    if [[ -d "$DOTFILES_DIR/live" ]]; then
        for video_file in "$DOTFILES_DIR/live"/*.mp4 "$DOTFILES_DIR/live"/*.webm; do
            if [[ -f "$video_file" ]]; then
                local filename=$(basename "$video_file")
                local target_file="$live_dir/$filename"
                
                print_status "  • $filename"
                
                # Link all available wallpapers
                if [[ ! -L "$target_file" ]] && [[ ! -f "$target_file" ]]; then
                    ln -sf "$video_file" "$target_file" 2>/dev/null || true
                fi
            fi
        done
    fi
    
    if [[ -n "$space_bedroom_file" ]]; then
        print_success "Space bedroom wallpaper ready: $space_bedroom_file"
        
        # Create a helper script for configuring Hanabi
        mkdir -p "$HOME/.local/bin"
        cat > "$HOME/.local/bin/configure-hanabi" << EOF
#!/bin/bash
# Helper script to configure Hanabi with space bedroom wallpaper

SPACE_BEDROOM_FILE="$space_bedroom_file"

if command -v gsettings &>/dev/null; then
    # Set the wallpaper file (this may vary depending on Hanabi's schema)
    # Note: This is a placeholder - actual gsettings key may differ
    echo "Configuring Hanabi to use: \$SPACE_BEDROOM_FILE"
    echo "Please manually configure in Hanabi extension preferences:"
    echo "1. Open GNOME Extensions app"
    echo "2. Find Hanabi extension and click settings/preferences"
    echo "3. Set video file to: \$SPACE_BEDROOM_FILE"
else
    echo "gsettings not available. Please configure Hanabi manually."
fi
EOF
        chmod +x "$HOME/.local/bin/configure-hanabi"
    else
        print_warning "Space bedroom wallpaper not available"
        print_status "Available wallpapers will be linked to $live_dir"
    fi
    
    # Enable extension if possible
    if command -v gnome-extensions &>/dev/null; then
        print_status "Attempting to enable Hanabi extension..."
        if gnome-extensions enable hanabi-extension@jeffshee.github.io 2>/dev/null; then
            print_success "Hanabi extension enabled"
        else
            print_warning "Could not auto-enable Hanabi extension"
            print_status "Please enable it manually using GNOME Extensions app"
        fi
    fi
    
    echo ""
    print_status "Hanabi extension setup complete!"
    print_status "To configure:"
    print_status "1. Restart GNOME Shell (logout/login or Alt+F2 → 'r' on X11)"
    print_status "2. Enable Hanabi extension in GNOME Extensions app"
    print_status "3. Open Hanabi preferences and select your video file"
    if [[ -n "$space_bedroom_file" ]]; then
        print_status "4. Use: $space_bedroom_file"
    fi
    echo ""
}

# Main installation function
main() {
    print_header "=== Fedora Workstation Dotfiles Installation ==="
    echo ""
    
    print_status "Starting installation from: $DOTFILES_DIR"
    print_status "Target directory: $HOME"
    echo ""
    
    # Check if required commands exist
    local required_commands=("git" "curl" "unzip")
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" &>/dev/null; then
            print_error "$cmd is required but not installed"
            exit 1
        fi
    done
    
    # Install required packages
    print_header "Checking and installing required packages..."
    install_package "alacritty"
    install_package "vim"
    install_package "git"
    install_package "curl"
    install_package "unzip"
    install_package "fontconfig"
    echo ""
    
    # Setup font rendering
    setup_font_rendering
    echo ""
    
    # Install fonts
    install_fonts
    echo ""
    
    # Setup Alacritty
    setup_alacritty
    echo ""
    
    # Setup Vim configuration
    print_header "Setting up Vim configuration..."
    create_symlink "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc" "Vim config"
    echo ""
    
    # Setup Git configuration
    print_header "Setting up Git configuration..."
    
    # Install GPG for signing commits
    install_package "gnupg2"
    
    create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig" "Git config"
    
    print_warning "Please update ~/.gitconfig with your actual name and email:"
    print_status "git config --global user.name \"Your Full Name\""
    print_status "git config --global user.email \"your.email@example.com\""
    echo ""
    print_status "Your GPG signing key is already configured: 14E4E96742F22903"
    print_status "Verify your GPG key is available: gpg --list-secret-keys"
    echo ""
    
    # Setup Bash configuration
    print_header "Setting up Bash configuration..."
    
    # Create bashrc.d directory
    mkdir -p "$HOME/.bashrc.d"
    
    create_symlink "$DOTFILES_DIR/bashrc_vim" "$HOME/.bashrc.d/vim_mode" "Bash vim mode config"
    
    # Check if bashrc sources from bashrc.d
    if ! grep -q 'bashrc\.d' "$HOME/.bashrc" 2>/dev/null; then
        print_status "Adding ~/.bashrc.d/ sourcing to ~/.bashrc..."
        
        # Backup original bashrc
        if [[ -f "$HOME/.bashrc" ]]; then
            backup_file "$HOME/.bashrc"
        fi
        
        # Add sourcing of bashrc.d files
        cat >> "$HOME/.bashrc" << 'EOF'

# Source additional bash configurations from ~/.bashrc.d/
if [ -d ~/.bashrc.d ]; then
    for file in ~/.bashrc.d/*; do
        [[ -r "$file" ]] && source "$file"
    done
fi
EOF
        print_success "Added ~/.bashrc.d/ sourcing to ~/.bashrc"
    else
        print_status "~/.bashrc already sources from ~/.bashrc.d/"
    fi
    
    print_status "Bash vim mode and productivity enhancements installed"
    print_status "Start a new shell session or run 'source ~/.bashrc' to apply changes"
    echo ""
    
    # Install Vim plugins
    install_vim_plugins
    echo ""
    
    # Install Hanabi GNOME extension
    install_hanabi_extension
    echo ""
    
    print_header "=== Installation Complete! ==="
    echo ""
    print_success "All dotfiles have been installed successfully!"
    echo ""
    print_status "What's been installed:"
    echo "  • Alacritty configuration with 80% transparency and vim mode"
    echo "  • Vim configuration with pathogen and dark theme"
    echo "  • Vim plugins for enhanced productivity"
    echo "  • Git configuration with GPG commit signing"
    echo "  • Bash configuration with vim mode and aliases"
    echo "  • Multiple programming fonts with improved rendering"
    echo "  • Font rendering optimizations"
    echo "  • Hanabi GNOME extension for live wallpapers"
    echo ""
    
    if [[ -d "$BACKUP_DIR" ]]; then
        print_warning "Your original dotfiles have been backed up to: $BACKUP_DIR"
    fi
    
    echo ""
    print_header "Font Troubleshooting:"
    echo "If JetBrains Mono still looks bad, try these alternatives:"
    echo "1. Edit ~/.config/alacritty/alacritty.toml and uncomment the Fira Code section"
    echo "2. Or use the system monospace font section"
    echo "3. Run 'fc-list : family | grep -i mono' to see available fonts"
    echo ""
    print_status "To apply changes:"
    echo "  • Restart Alacritty or open a new terminal window"
    echo "  • Open Vim to see the new configuration"
    echo ""
    print_status "Useful Vim commands with this configuration:"
    echo "  • Space + w : Save file"
    echo "  • Space + q : Quit"
    echo "  • Space + h : Clear search highlights"
    echo "  • Ctrl + Shift + Space : Toggle Vi mode in Alacritty"
    echo "  • jk or kj : Alternative to Escape in Vim insert mode"
    echo ""
}

# Check if script is being run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi 