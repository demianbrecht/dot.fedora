" Vim Configuration for Fedora Workstation
" Modern dark theme with pathogen plugin manager

" Disable compatibility with vi which can cause unexpected issues
set nocompatible

" Enable file type detection
filetype on

" Enable plugins and load plugin for the detected file type
filetype plugin on

" Load an indent file for the detected file type
filetype indent on

" Pathogen Plugin Manager
" Execute pathogen#infect() to initialize pathogen
execute pathogen#infect()

" Enable syntax highlighting
syntax on

" Add line numbers
set number

" Set relative line numbers
set relativenumber

" Highlight cursor line underneath the cursor horizontally
set cursorline

" Set shift width to 4 spaces
set shiftwidth=4

" Set tab width to 4 columns
set tabstop=4

" Use space characters instead of tabs
set expandtab

" Do not save backup files
set nobackup

" Do not let cursor scroll below or above N number of lines when scrolling
set scrolloff=10

" Do not wrap lines. Allow long lines to extend as far as the line goes
set nowrap

" While searching though a file incrementally highlight matching characters as you type
set incsearch

" Ignore capital letters during search
set ignorecase

" Override the ignorecase option if searching for capital letters
set smartcase

" Show partial command you type in the last line of the screen
set showcmd

" Show the mode you are on the last line
set showmode

" Show matching words during a search
set showmatch

" Use highlighting when doing a search
set hlsearch

" Set the commands to save in history default number is 20
set history=1000

" Enable auto completion menu after pressing TAB
set wildmenu

" Make wildmenu behave like similar to Bash completion
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim
" Wildmenu will ignore files with these extensions
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" Enable mouse support
set mouse=a

" Enable clipboard support
set clipboard=unnamedplus

" Set encoding
set encoding=utf-8

" Enable hidden buffers
set hidden

" Decrease update time
set updatetime=300

" Don't pass messages to |ins-completion-menu|
set shortmess+=c

" Always show the signcolumn
set signcolumn=yes

" Set leader key
let mapleader = " "

" Color scheme and appearance
set termguicolors
set background=dark

" Try to set a nice colorscheme
try
    colorscheme desert
catch /^Vim\%((\a\+)\)\=:E185/
    " Deal with the case where the colorscheme doesn't exist
    colorscheme default
endtry

" Custom highlighting
highlight Normal ctermbg=NONE guibg=NONE
highlight LineNr ctermfg=8 guifg=#585858
highlight CursorLineNr ctermfg=11 guifg=#ffff00 cterm=bold gui=bold
highlight CursorLine ctermbg=8 guibg=#262626 cterm=NONE gui=NONE
highlight Visual ctermbg=4 guibg=#005f87
highlight Search ctermbg=3 ctermfg=0 guibg=#ffaf00 guifg=#000000
highlight IncSearch ctermbg=1 ctermfg=15 guibg=#ff0000 guifg=#ffffff

" Status line configuration
set laststatus=2
set statusline=
set statusline+=%#DiffAdd#%{(mode()=='n')?'\ \ NORMAL\ ':''}
set statusline+=%#DiffChange#%{(mode()=='i')?'\ \ INSERT\ ':''}
set statusline+=%#DiffDelete#%{(mode()=='r')?'\ \ RPLACE\ ':''}
set statusline+=%#Cursor#%{(mode()=='v')?'\ \ VISUAL\ ':''}
set statusline+=%*
set statusline+=\ %n\           " buffer number
set statusline+=%#Visual#       " colour
set statusline+=%{&paste?'\ PASTE\ ':''}
set statusline+=%{&spell?'\ SPELL\ ':''}
set statusline+=%*              " colour
set statusline+=%R%M            " readonly, modified
set statusline+=\ %t\           " short file name
set statusline+=%=              " right align
set statusline+=\ %y\           " file type
set statusline+=\ %{&ff}\       " file format
set statusline+=\ %{strlen(&fenc)?&fenc:'none'}\  " file encoding
set statusline+=\ %c:%l/%L\     " column:line/total
set statusline+=\ %p%%\         " percent of file

" Key mappings
" Make Y yank until end of line (consistent with C and D)
nnoremap Y y$

" Keep cursor centered when searching
nnoremap n nzzzv
nnoremap N Nzzzv

" Undo break points
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

" Moving text
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
inoremap <C-j> <esc>:m .+1<CR>==
inoremap <C-k> <esc>:m .-2<CR>==
nnoremap <leader>k :m .-2<CR>==
nnoremap <leader>j :m .+1<CR>==

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resize windows with arrows
nnoremap <C-Up> :resize -2<CR>
nnoremap <C-Down> :resize +2<CR>
nnoremap <C-Left> :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

" Navigate buffers
nnoremap <S-l> :bnext<CR>
nnoremap <S-h> :bprevious<CR>

" Clear highlights
nnoremap <leader>h :nohlsearch<CR>

" Better escape
inoremap jk <ESC>
inoremap kj <ESC>

" Quick save and quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>wq :wq<CR>

" Split windows
nnoremap <leader>sv :vsplit<CR>
nnoremap <leader>sh :split<CR>

" Close current buffer
nnoremap <leader>bd :bd<CR>

" Toggle paste mode
nnoremap <leader>p :set paste!<CR>

" Auto pairs (simple implementation)
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap " ""<left>
inoremap ' ''<left>

" Auto-commands
augroup general_settings
    autocmd!
    " Remove trailing whitespace on save
    autocmd BufWritePre * %s/\s\+$//e
    
    " Return to last edit position when opening files
    autocmd BufReadPost *
         \ if line("'\"") > 0 && line("'\"") <= line("$") |
         \   exe "normal! g`\"" |
         \ endif
    
    " Highlight yanked text
    autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=300}
augroup END

" File type specific settings
augroup filetype_settings
    autocmd!
    " Python
    autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab
    autocmd FileType python setlocal textwidth=79
    
    " JavaScript/TypeScript
    autocmd FileType javascript,typescript setlocal tabstop=2 shiftwidth=2 expandtab
    
    " HTML/CSS
    autocmd FileType html,css setlocal tabstop=2 shiftwidth=2 expandtab
    
    " YAML
    autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 expandtab
    
    " Markdown
    autocmd FileType markdown setlocal wrap linebreak nolist
augroup END

" Create pathogen directories if they don't exist
if empty(glob('~/.vim/autoload/pathogen.vim'))
  silent !curl -fLo ~/.vim/autoload/pathogen.vim --create-dirs
    \ https://tpo.pe/pathogen.vim
endif

" Create bundle directory for pathogen plugins
if !isdirectory($HOME.'/.vim/bundle')
    call mkdir($HOME.'/.vim/bundle', 'p')
endif

" Plugin recommendations (install manually with pathogen)
" Run these commands to install some great plugins:
"
" cd ~/.vim/bundle
" git clone https://github.com/tpope/vim-sensible.git
" git clone https://github.com/tpope/vim-surround.git
" git clone https://github.com/tpope/vim-commentary.git
" git clone https://github.com/preservim/nerdtree.git
" git clone https://github.com/vim-airline/vim-airline.git
" git clone https://github.com/vim-airline/vim-airline-themes.git
" git clone https://github.com/morhetz/gruvbox.git
" git clone https://github.com/airblade/vim-gitgutter.git
" git clone https://github.com/ctrlpvim/ctrlp.vim.git

" If you install the gruvbox theme, uncomment the following line:
" colorscheme gruvbox 