# Fedora Dotfiles

A comprehensive dotfiles setup for Fedora workstations with modern terminal configuration, enhanced Vim setup, and productivity-focused shell configuration.

## 🚀 Quick Start

```bash
# Clone the repository
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles

# Run the installation script
./install.sh
```

## 📦 What's Included

### Terminal (Alacritty)
- **80% transparency** with background blur
- **Catppuccin-inspired dark theme**
- **Comprehensive vim mode** with navigation and editing bindings
- **Fira Code font** at 9pt for optimal readability
- **No title bar** with maximized startup
- **Modern key bindings** for copy/paste and navigation

### Vim Configuration
- **Pathogen plugin manager** for easy plugin management
- **Modern dark color scheme** with syntax highlighting
- **Space as leader key** for intuitive shortcuts
- **Enhanced history** and smart indentation
- **Auto-pairs** and productivity features
- **Custom status line** with file information
- **Recommended plugins** list for extended functionality

### Git Configuration
- **GPG commit signing** with key `14E4E96742F22903`
- **Modern aliases** for common workflows
- **Colored output** and smart defaults
- **Enhanced diff and merge tools**

### Bash Configuration
- **Vim mode** for command line editing
- **Enhanced history** with deduplication and search
- **Productivity aliases** and functions
- **Modular configuration** in `~/.bashrc.d/`

## 🔧 Installation Details

The `install.sh` script will:

1. **Install required packages** via DNF:
   - `alacritty` - Modern terminal emulator
   - `vim-enhanced` - Enhanced Vim editor
   - `git` - Version control system
   - `fira-code-fonts` - Programming font with ligatures

2. **Optimize font rendering**:
   - Configure fontconfig for better font display
   - Set up proper font aliases and rendering hints

3. **Create intelligent backups**:
   - Backup existing configurations with timestamps
   - Preserve your current settings before applying new ones

4. **Set up symbolic links**:
   - Link configuration files to proper locations
   - Maintain dotfiles in the repository for easy updates

5. **Configure GNOME extensions** (if applicable):
   - Set up hanabi extension for enhanced desktop experience

## 📁 File Structure

```
~/.dotfiles/
├── alacritty.toml      # Alacritty terminal configuration
├── .vimrc              # Vim editor configuration
├── .gitconfig          # Git configuration with GPG signing
├── bashrc_vim          # Bash configuration with vim mode
├── install.sh          # Main installation script
├── fix-fonts.sh        # Font troubleshooting utility
└── README.md           # This documentation
```

## 🎨 Customization

### Changing Terminal Transparency
Edit `alacritty.toml`:
```toml
[window]
opacity = 0.8  # Change this value (0.0 to 1.0)
```

### Switching Fonts
Use the font troubleshooting script:
```bash
./fix-fonts.sh
```

Or manually edit `alacritty.toml`:
```toml
[font]
normal = { family = "Your Font Name", style = "Regular" }
size = 9.0
```

### Vim Leader Key
The leader key is set to Space. To change it, edit `.vimrc`:
```vim
let mapleader = " "  " Change to your preferred key
```

### Git GPG Key
Update your GPG signing key in `.gitconfig`:
```ini
[user]
    signingkey = YOUR_KEY_ID
```

## 🔍 Troubleshooting

### Font Issues
If fonts look poor or aren't rendering correctly:

1. Run the font fix script:
   ```bash
   ./fix-fonts.sh
   ```

2. Clear font cache:
   ```bash
   fc-cache -fv
   ```

3. Check available fonts:
   ```bash
   fc-list | grep -i "fira\|jetbrains\|source"
   ```

### Alacritty Not Starting
1. Check configuration syntax:
   ```bash
   alacritty --print-events
   ```

2. Validate TOML syntax:
   ```bash
   python3 -c "import tomllib; tomllib.load(open('alacritty.toml', 'rb'))"
   ```

### Vim Plugins Not Working
1. Ensure pathogen is installed:
   ```bash
   ls -la ~/.vim/autoload/pathogen.vim
   ```

2. Install recommended plugins:
   ```bash
   mkdir -p ~/.vim/bundle
   cd ~/.vim/bundle
   # Install your preferred plugins
   ```

### Bash Vim Mode Issues
1. Check if vim mode is enabled:
   ```bash
   set -o | grep vi
   ```

2. Reload bash configuration:
   ```bash
   source ~/.bashrc
   ```

## 🎯 Key Features

### Alacritty Vim Mode Bindings
- `Ctrl+Shift+Space` - Enter vim mode
- `i/a/I/A` - Enter insert mode
- `v/V` - Visual selection
- `y` - Copy selection
- `hjkl` - Navigation
- `w/b/e` - Word navigation
- `0/$` - Line beginning/end

### Bash Vim Mode
- `Esc` - Command mode
- `i/a` - Insert mode
- `hjkl` - Navigate command line
- `w/b` - Word navigation
- `dd` - Delete line
- `0/$` - Line beginning/end

### Git Aliases
- `git st` - Status
- `git co` - Checkout
- `git br` - Branch
- `git ci` - Commit
- `git unstage` - Remove from staging
- `git last` - Show last commit
- `git visual` - Visual diff tool

## 🔐 Security Notes

- **GPG Key**: The included GPG key (`14E4E96742F22903`) is safe for public repositories
- **Backup Safety**: All existing configurations are backed up before modification
- **Permission Handling**: Scripts maintain proper file permissions

## 🌟 Extensions & Enhancements

### Recommended Vim Plugins
Add these to `~/.vim/bundle/` for enhanced functionality:

- **NERDTree** - File explorer
- **vim-airline** - Enhanced status line
- **vim-gitgutter** - Git diff indicators
- **auto-pairs** - Automatic bracket pairing
- **vim-surround** - Surround text objects
- **fzf.vim** - Fuzzy file finder

### GNOME Extensions
The setup includes support for GNOME hanabi extension for enhanced desktop experience.

### Shell Enhancements
The bash configuration includes:
- **Smart history** with deduplication
- **Productivity aliases** (ll, la, grep colors, etc.)
- **Git status** in prompt (if available)
- **Directory navigation** shortcuts

## 🤝 Contributing

Feel free to fork this repository and customize it for your needs. If you have improvements or bug fixes, pull requests are welcome!

## 📄 License

This dotfiles configuration is released under the MIT License. Feel free to use, modify, and distribute as needed.

---

**Happy coding with your new Fedora setup!** 🎉 