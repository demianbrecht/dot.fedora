# Fedora Workstation Dotfiles

A comprehensive collection of dotfiles specifically designed for Fedora Workstation, providing a developer-friendly environment with transparency, productivity features, and vim-centric workflows.

## 🌟 What's Included

### Core Configuration Files
- **Alacritty Terminal** (`alacritty.toml`) - Modern terminal with 80% transparency, maximized window, vim scrollback mode
- **Vim Configuration** (`.vimrc`) - Comprehensive vim setup with pathogen plugin manager and essential plugins
- **Git Configuration** (`.gitconfig`) - GPG commit signing, aliases, and modern Git workflow optimizations
- **Bash Configuration** (`bashrc_vim`) - Enhanced bash with vim mode, productivity aliases, and developer tools

### Key Features
- **🎨 Modern Terminal**: Alacritty with transparency, no title bar, maximized startup
- **⌨️ Vim Mode Everywhere**: Command line vim mode in bash for consistent editing experience
- **🔐 GPG Commit Signing**: Automatic commit signing with your GPG key
- **🎯 Font Optimization**: Multiple font options with rendering improvements
- **🔍 Fuzzy Finding**: FZF integration for file and history search
- **🌈 GNOME Integration**: GNOME wallpaper engine extension for live wallpapers
- **📦 Plugin Management**: Pathogen for vim plugin management

## 🚀 Quick Start

```bash
git clone https://github.com/yourusername/dot.fedora.git ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh
./install.sh
```

## 📁 File Overview

### Alacritty (`alacritty.toml`)
- **80% transparency** with background blur
- **Maximized window** with no decorations for clean look
- **Fira Code font** at 11pt with fallbacks (JetBrains Mono, Cascadia Code)
- **Vim scrollback mode** for keyboard-driven terminal navigation
- **Custom key bindings** for productivity

### Vim (`.vimrc`)
- **Pathogen plugin manager** for easy plugin installation
- **Gruvbox dark theme** for comfortable coding
- **Essential plugins**: NERDTree, airline, ctrlp, surround, commentary, gitgutter
- **Custom key mappings** with Space as leader key
- **Auto-completion** and **syntax highlighting**
- **File type specific** configurations

### Git (`.gitconfig`)
- **GPG commit signing** enabled by default (key: 14E4E96742F22903)
- **Useful aliases**: co, br, ci, st, unstage, last, visual
- **Modern defaults**: push.default = simple, pull.rebase = false
- **Better diffs** and **merge conflict resolution**

### Bash (`bashrc_vim`)
- **Vim mode enabled** for command line editing
- **Productivity aliases**: git shortcuts, enhanced ls, system monitoring
- **Useful functions**: mkcd, weather, backup, extract, genpass
- **Enhanced history** with better search and navigation
- **FZF integration** for fuzzy finding

## 🎯 Key Features in Detail

### Terminal Experience
The Alacritty configuration provides a modern, transparent terminal that integrates seamlessly with GNOME:

- **Background transparency** (80%) with blur effects
- **Maximized startup** with no window decorations
- **Vim-like scrollback navigation** (Ctrl+Shift+Space to toggle)
- **Font rendering optimizations** for crisp text display

### Vim Mode in Bash
The bash configuration enables vim mode for command line editing:

- Press `Esc` to enter vi-command mode
- Use `hjkl` for navigation, `w/b` for word movement
- `i/a` to enter insert mode, `A/I` for line start/end insert
- Search command history with `/` and navigate with `n/N`

### Productivity Aliases
Common commands are shortened for faster development:

```bash
# Git shortcuts
g       # git
ga      # git add
gc      # git commit
gp      # git push
gl      # git pull
gs      # git status

# System aliases
ll      # detailed file listing
la      # list all files including hidden
..      # cd ..
...     # cd ../..

# Development
py      # python3
serve   # start HTTP server in current directory
```

### Plugin-Powered Vim
The vim configuration includes essential plugins for modern development:

- **NERDTree**: File explorer (`,n` to toggle)
- **CtrlP**: Fuzzy file finding (`Ctrl+P`)
- **Airline**: Enhanced status bar
- **GitGutter**: Git diff indicators in the gutter
- **Surround**: Easy text surrounding operations
- **Commentary**: Comment/uncomment code (`,/`)

## 🛠 Installation Details

The install script automatically:

1. **Updates system packages** and installs essential tools
2. **Installs fonts** (Fira Code, JetBrains Mono, Cascadia Code)
3. **Optimizes font rendering** with fontconfig improvements
4. **Sets up vim plugins** via pathogen
5. **Creates symlinks** for all configuration files
6. **Configures bash** with vim mode and productivity features
7. **Installs FZF** for fuzzy finding
8. **Sets up GNOME extensions** including gnome-wallpaper-engine for live wallpapers

## 🔧 Customization

### Switching Fonts
If you prefer different fonts, run the font troubleshooting script:

```bash
./fix-fonts.sh
```

This provides an interactive menu to switch between:
- Fira Code (default)
- JetBrains Mono
- Cascadia Code
- System Liberation Mono

### Vim Plugins
To install additional vim plugins with pathogen:

```bash
cd ~/.vim/bundle
git clone https://github.com/plugin-author/plugin-name.git
```

### Bash Customization
The bash configuration is modular. Add custom aliases or functions to:

```bash
~/.bashrc.d/custom
```

## 🔑 Key Bindings Reference

### Alacritty Terminal
- `Ctrl+Shift+Space` - Toggle vim scrollback mode
- `Ctrl+Shift+C` - Copy selection
- `Ctrl+Shift+V` - Paste
- `Ctrl+Plus/Minus` - Increase/decrease font size

### Bash Vim Mode
- `Esc` - Enter vi-command mode
- `i` - Insert mode at cursor
- `a` - Insert mode after cursor
- `A` - Insert mode at end of line
- `^` - Beginning of line
- `$` - End of line
- `/pattern` - Search command history

### Vim Editor
- `Space+w` - Save file
- `Space+q` - Quit
- `Space+h` - Clear search highlights
- `,n` - Toggle NERDTree
- `,/` - Toggle comment
- `Ctrl+P` - Fuzzy file finder
- `jk` or `kj` - Alternative to Escape in insert mode

### FZF Integration
- `Ctrl+R` - Fuzzy search command history
- `Ctrl+T` - Fuzzy search files in current directory
- `Alt+C` - Fuzzy search directories and cd into them

## 🐛 Troubleshooting

### Font Rendering Issues
If fonts don't display correctly:

1. Run `./fix-fonts.sh` for interactive font switching
2. Check available fonts: `fc-list : family | grep -i mono`
3. Manually edit `~/.config/alacritty/alacritty.toml` to change font family

### Vim Plugins Not Working
If vim plugins aren't loading:

1. Verify pathogen installation: `ls ~/.vim/autoload/pathogen.vim`
2. Check plugin directory: `ls ~/.vim/bundle/`
3. Restart vim and run `:Helptags`

### Bash Vim Mode Not Active
If vim mode isn't working in bash:

1. Check if configuration is loaded: `set -o | grep vi`
2. Source the configuration: `source ~/.bashrc`
3. Verify the symlink: `ls -la ~/.bashrc.d/vim_mode`

### GNOME Extensions
To enable the gnome-wallpaper-engine extension:

1. Install GNOME Extensions app: `sudo dnf install gnome-extensions-app`
2. Enable it: `gnome-extensions enable gnome-wallpaper-engine@gjs.com` (log out and back in first if it is not listed)
3. Configure via Extensions app preferences

## 📝 Notes

- **GPG Signing**: The git configuration includes GPG signing with key `14E4E96742F22903`. Update this in `.gitconfig` if you use a different key.
- **Font Dependencies**: The configuration assumes Fira Code is available. Install additional fonts if needed.
- **Shell Integration**: The bash configuration integrates with FZF for enhanced file and history searching.
- **GNOME Compatibility**: Designed specifically for GNOME on Fedora with appropriate extension support.

## 🤝 Contributing

Feel free to submit issues, fork the repository, and create pull requests for any improvements.

## 📄 License

MIT License - see LICENSE file for details. 