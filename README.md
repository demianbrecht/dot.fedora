# Fedora Workstation Dotfiles

A curated collection of configuration files (dotfiles) for a modern, productive development environment on Fedora Workstation.

## Features

### 🖥️ Alacritty Terminal
- **80% window transparency** with background blur
- **Vim mode** enabled with full key bindings
- **Catppuccin-inspired dark theme** with modern aesthetics
- Multiple font options with optimized rendering
- Optimized for productivity with custom key bindings
- URL hint support for easy link opening

### 📝 Vim Configuration
- **Pathogen plugin manager** for easy plugin management
- **Modern dark theme** with custom highlighting
- **Comprehensive key mappings** for enhanced productivity
- Automatic plugin installation
- Smart indentation and file type detection
- Custom status line with mode indicators
- Auto-pairs, search enhancements, and more

### 🔐 Git Configuration
- **GPG commit signing** automatically enabled
- **Modern Git aliases** for enhanced productivity
- **Optimized settings** for better performance and workflow
- **Colored output** for better readability
- **Smart defaults** for pulling, pushing, and branching

### 🔧 Automated Installation
- **Intelligent backup system** - saves your existing configs
- **Package installation** - installs required dependencies
- **Font management** - downloads and installs multiple programming fonts
- **Font rendering optimization** - configures fontconfig for better display
- **Plugin setup** - automatically installs recommended Vim plugins
- **Colored output** - beautiful installation process

## Quick Start

1. **Clone this repository:**
   ```bash
   git clone https://github.com/yourusername/dot.fedora.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Run the installation script:**
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. **If fonts look bad, run the font fix script:**
   ```bash
   chmod +x fix-fonts.sh
   ./fix-fonts.sh
   ```

4. **Restart your terminal** and open Vim to see the changes!

## What Gets Installed

### Packages (via DNF)
- `alacritty` - Modern terminal emulator
- `vim` - Text editor
- `git` - Version control
- `gnupg2` - GPG for commit signing
- `curl` - Command line tool for transfers
- `unzip` - Archive extraction
- `fontconfig` - Font configuration
- Font rendering libraries (`freetype`, `cairo`, `pango`)

### Fonts
- **JetBrains Mono** - Primary programming font with ligatures
- **Fira Code** - Backup programming font with ligatures
- **Cascadia Code** - Microsoft's programming font
- **Liberation Mono**, **DejaVu Sans Mono**, **Noto Mono** - System fallbacks

### Vim Plugins (via Pathogen)
- `vim-sensible` - Sensible defaults for Vim
- `vim-surround` - Quoting/parenthesizing made simple
- `vim-commentary` - Comment stuff out
- `nerdtree` - File system explorer
- `vim-airline` - Lean & mean status/tabline
- `vim-airline-themes` - Themes for airline
- `gruvbox` - Beautiful dark theme
- `vim-gitgutter` - Git diff in the gutter
- `ctrlp.vim` - Fuzzy file finder

## File Structure

```
~/.dotfiles/
├── alacritty.toml    # Alacritty configuration
├── .vimrc            # Vim configuration
├── .gitconfig        # Git configuration with GPG signing
├── install.sh        # Installation script
├── fix-fonts.sh      # Font troubleshooting script
└── README.md         # This file
```

## Font Issues and Solutions

### Common Problems
- **Blurry or pixelated fonts** - Usually due to poor font rendering settings
- **Fonts too small/large** - HiDPI display scaling issues
- **Missing ligatures** - Font not properly installed or recognized
- **Ugly appearance** - Incorrect hinting or anti-aliasing

### Quick Fixes

1. **Run the font troubleshooting script:**
   ```bash
   ./fix-fonts.sh
   ```

2. **Try different fonts:**
   - Edit `~/.config/alacritty/alacritty.toml`
   - Change `family = "JetBrains Mono"` to:
     - `family = "Fira Code"` (excellent alternative)
     - `family = "Cascadia Code"` (Microsoft's font)
     - `family = "monospace"` (system default)

3. **Adjust font size:**
   - Edit `~/.config/alacritty/alacritty.toml`
   - Change `size = 13.0` to `14.0`, `15.0`, or `16.0`

4. **For HiDPI displays:**
   - Use larger font sizes (16-18pt)
   - Check GNOME Settings > Displays for proper scaling

### Manual Font Configuration

If automatic font installation fails:

```bash
# Install fonts via DNF
sudo dnf install fira-code-fonts cascadia-code-fonts

# Or manually install JetBrains Mono
mkdir -p ~/.local/share/fonts
cd /tmp
curl -L "https://github.com/JetBrains/JetBrainsMono/releases/latest/download/JetBrainsMono.zip" -o JetBrainsMono.zip
unzip JetBrainsMono.zip
cp fonts/ttf/*.ttf ~/.local/share/fonts/
fc-cache -f -v
```

## Key Bindings

### Alacritty (Vi Mode)
- `Ctrl + Shift + Space` - Toggle Vi mode
- `hjkl` - Navigation in Vi mode
- `v` - Visual selection
- `y` - Copy selection
- `/` - Search forward
- `n/N` - Next/previous search result

### Vim
- `Space` - Leader key
- `Space + w` - Save file
- `Space + q` - Quit
- `Space + h` - Clear search highlights
- `Space + sv` - Split vertically
- `Space + sh` - Split horizontally
- `jk` or `kj` - Alternative to Escape
- `Ctrl + h/j/k/l` - Navigate between windows

## Git Configuration

The included `.gitconfig` provides a comprehensive Git setup with GPG signing enabled.

### Key Features
- **Automatic GPG signing** for all commits and tags
- **GPG Key**: `14E4E96742F22903` (pre-configured)
- **Modern workflow defaults** (rebase on pull, auto-setup remotes)
- **Helpful aliases** for common operations
- **Better diff and log formatting**
- **Colored output** for improved readability

### Setup Required
After installation, update your Git identity:
```bash
git config --global user.name "Your Full Name"
git config --global user.email "your.email@example.com"
```

### Verify GPG Setup
Make sure your GPG key is available:
```bash
# List your GPG keys
gpg --list-secret-keys

# If you need to import your key
gpg --import /path/to/your/private-key.asc

# Test GPG signing
echo "test" | gpg --clearsign
```

### Useful Git Aliases
The configuration includes many helpful aliases:
- `git lg` - Beautiful colored log with graph
- `git st` - Short status
- `git cm "message"` - Quick commit
- `git ac "message"` - Add all and commit
- `git amend` - Amend last commit
- `git undo` - Undo last commit (keep changes)
- `git cleanup` - Remove merged branches
- `git verify` - Show commit signature verification

## Customization

### Alacritty
The Alacritty configuration uses a Catppuccin-inspired color scheme. You can modify colors, opacity, and other settings in `alacritty.toml`.

### Vim
The Vim configuration includes extensive customization. Key areas:
- **Theme**: Currently uses desert with custom highlighting. Uncomment the gruvbox line at the end of `.vimrc` to use gruvbox theme.
- **Leader key**: Set to Space for easy access
- **Plugins**: Add more plugins by cloning them to `~/.vim/bundle/`

## Manual Installation

If you prefer to install components manually:

### Alacritty Configuration
```bash
mkdir -p ~/.config/alacritty
ln -sf ~/.dotfiles/alacritty.toml ~/.config/alacritty/alacritty.toml
```

### Vim Configuration
```bash
ln -sf ~/.dotfiles/.vimrc ~/.vimrc
```

### Install Vim Plugins
```bash
mkdir -p ~/.vim/{autoload,bundle}
curl -fLo ~/.vim/autoload/pathogen.vim --create-dirs \
    https://tpo.pe/pathogen.vim

cd ~/.vim/bundle
git clone https://github.com/tpope/vim-sensible.git
git clone https://github.com/morhetz/gruvbox.git
# ... add other plugins as needed
```

## Backup and Restoration

The installation script automatically creates backups of your existing configuration files in `~/.dotfiles_backup_YYYYMMDD_HHMMSS/`. 

To restore your original configurations:
```bash
# Find your backup directory
ls -la ~/.dotfiles_backup_*

# Restore specific files
cp ~/.dotfiles_backup_*/vimrc ~/.vimrc
cp ~/.dotfiles_backup_*/alacritty.toml ~/.config/alacritty/
```

## Troubleshooting

### Alacritty doesn't start
- Ensure Alacritty is installed: `sudo dnf install alacritty`
- Check for syntax errors in config: `alacritty --config-file ~/.config/alacritty/alacritty.toml`

### Vim plugins not working
- Ensure pathogen is installed: Check `~/.vim/autoload/pathogen.vim` exists
- Verify plugins are in bundle directory: `ls ~/.vim/bundle/`
- Restart Vim and run `:Helptags` to generate help documentation

### Font issues
- **Run the font fix script first:** `./fix-fonts.sh`
- Refresh font cache: `fc-cache -f -v`
- Verify fonts are installed: `fc-list | grep -i jetbrains`
- Check available monospace fonts: `fc-list : family | grep -i mono`
- Try different fonts in the Alacritty config

### Display Issues
- For blurry text, check your display scaling in GNOME Settings
- For HiDPI displays, increase font size to 16-18pt
- Ensure proper RGB sub-pixel ordering is set

## Contributing

Feel free to submit issues and pull requests to improve these dotfiles!

## License

This project is open source and available under the [MIT License](LICENSE).

---

**Enjoy your new development environment! 🚀** 