"*****************************************************************************
"" Vim-PLug core
"*****************************************************************************
" True on startup / False on running ---> check for when .vimrc manually sourced
if has('vim_starting')
  set nocompatible
endif

let vimplug_exists=expand('~/.vim/autoload/plug.vim')

let g:vim_bootstrap_langs = "html,javascript,php,ruby"
let g:vim_bootstrap_editor = "vim"        " nvim or vim

if !filereadable(vimplug_exists)
  echo "Installing Vim-Plug..."
  echo ""
  silent !\curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif

" Required:
call plug#begin(expand('~/.vim/plugged'))

"*****************************************************************************
"" Plug install packages
"*****************************************************************************

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Navigation
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Netrw boost (split file explorer ... OPPOSITE OF NERDTREE project drawer)
Plug 'tpope/vim-vinegar'
" Add marker to each mark
Plug 'kshenoy/vim-signature'
" Tmux / Vim navigator
Plug 'christoomey/vim-tmux-navigator'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Code Tagging
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" gutentag: automatically regenerate tags for a file when written (PURE VIM)
Plug 'ludovicchabant/vim-gutentags'
" Overview of tags in current file (for ctags generated tags)
Plug 'majutsushi/tagbar'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Code editing + commenting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commenting
Plug 'tpope/vim-commentary'
" Quoting / paren made simple (tpope)
Plug 'tpope/vim-surround'
" Repeat (.) for tpope plugins (tpope)
Plug 'tpope/vim-repeat'
" Working with variants or a word (capitalization, plural)
Plug 'tpope/vim-abolish'
" Fuzzy search for vim (+ shell FZF install)
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Automatic closing of quotes, etc
Plug 'jiangmiao/auto-pairs'
" Tabular lining up text
Plug 'godlygeek/tabular'
" Multiple cursors (Sublime-style)
Plug 'terryma/vim-multiple-cursors'
" Conversion between single / multi lines (function args, lists)
Plug 'FooSoft/vim-argwrap'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocompletion + Snippets
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocompletion
" [1] (Vim -> Engine -> (Lang client -> Lang Server))
" [2] (Vim -> Engine -> source)
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

"""""""""""
" Python
"""""""""""
" Language Source
Plug 'zchee/deoplete-jedi'
" Function doc show
Plug 'Shougo/echodoc.vim'

" Snippet Engine ---> TODO: comeback with better config
" Plug 'SirVer/ultisnips'
" Actual Snippets collection for Engine usage
" Plug 'honza/vim-snippets'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntax Linting / Highlighting / checking / error checking
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Async (vim 8) Linting Engine (will detect each language system installed linters)
Plug 'w0rp/ale'
" Vim syntax language packs
Plug 'sheerun/vim-polyglot'
" JS + JSX syntax plugins
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
" Highlight trailing whitespace
Plug 'bronson/vim-trailing-whitespace'
" Shows indent level with thin vertical lines
Plug 'Yggdroot/indentLine'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color theme
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'ayu-theme/ayu-vim' " Ayu colorscheme

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" StatusLine
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Util
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Git wrapper
Plug 'tpope/vim-fugitive'
" Git gutter (left-side shows diff style)
Plug 'airblade/vim-gitgutter'
" Colorscheme approx (gvim only colors on terminal)
Plug 'vim-scripts/CSApprox'
"" Color
Plug 'tomasr/molokai'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sessions (persist / restore vim editing sessions)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Extends Vim session command (:mksession)
Plug 'xolox/vim-session'
Plug 'xolox/vim-misc'
" Use (:Obsess) to save session
Plug 'tpope/vim-obsession'
" Fancy start screen for Vim
Plug 'mhinz/vim-startify'

"*****************************************************************************
"" Custom language syntax bundles
"*****************************************************************************

" html
"" HTML Bundle
Plug 'hail2u/vim-css3-syntax'
Plug 'gorodinskiy/vim-coloresque'
Plug 'tpope/vim-haml'
Plug 'mattn/emmet-vim'

" PSQL + set as default
Plug 'lifepillar/pgsql.vim'
let g:sql_type_default = 'pgsql'

"*****************************************************************************
"*****************************************************************************

"" Include user's extra bundle
if filereadable(expand("~/.vimrc.local.bundles"))
  source ~/.vimrc.local.bundles
endif

call plug#end()

" Required:
filetype plugin indent on


"*****************************************************************************
"" Basic Setup
"*****************************************************************************"
"" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
" if set, Vim puts "Byte Order Mark" (BOM) at start of Unicode files
" set bomb
" fast terminal redrawing
set ttyfast

"" Fix backspace indent
set backspace=indent,eol,start

"" Tabs. May be overriten by autocmd rules
set tabstop=2
set softtabstop=0
set shiftwidth=2
set expandtab

"" set pastetoggle mode to F2
set pastetoggle=<F2>

"" Map leader to ,
let mapleader=','

"" Enable hidden buffers
set hidden

"" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

"" Directories for swp files
set nobackup
set noswapfile

set fileformats=unix,dos,mac
set showcmd
set shell=/usr/local/bin/zsh

" session management
let g:session_directory = "~/.vim/session"
let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1

" Set up Omni func completion
augroup omnifuncs
  autocmd!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup end

"*****************************************************************************
"" Visual Settings
"*****************************************************************************
syntax on
set ruler
set number

let no_buffers_menu=1
if !exists('g:not_finish_vimplug')
 colorscheme molokai
endif

set termguicolors     " enable true colors support
" let ayucolor="light"  " for light version of theme
let ayucolor="mirage" " for mirage version of theme
" let ayucolor="dark"   " for dark version of theme
colorscheme ayu

set mousemodel=popup
set t_Co=256
set guioptions=egmrti
set gfn=Monospace\ 10

if has("gui_running")
  if has("gui_mac") || has("gui_macvim")
    set guifont=Menlo:h12
    set transparency=7
  endif
else
  let g:CSApprox_loaded = 1

  " IndentLine
  let g:indentLine_enabled = 1
  let g:indentLine_concealcursor = 0
  let g:indentLine_char = '┆'
  let g:indentLine_faster = 1

  if $COLORTERM == 'gnome-terminal'
    set term=gnome-256color
  else
    if $TERM == 'xterm'
      set term=xterm-256color
    endif
  endif
endif


if &term =~ '256color'
  set t_ut=
endif


"" Disable the blinking cursor.
set gcr=a:blinkon0
set scrolloff=3

"" Status bar
set laststatus=2

"" Use modeline overrides
set modeline
set modelines=10

set title
set titleold="Terminal"
set titlestring=%F

set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\

if exists("*fugitive#statusline")
  set statusline+=%{fugitive#statusline()}
endif

" vim-airline
let g:airline_theme = 'powerlineish'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline_skip_empty_sections = 1

" Netrw setting (highlight)
let g:netrw_special_syntax= 1

"*****************************************************************************
"" Abbreviations
"*****************************************************************************
"" no one is really happy until you have this shortcuts
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

" terminal emulation
if g:vim_bootstrap_editor == 'nvim'
  nnoremap <silent> <leader>sh :terminal<CR>
else
  nnoremap <silent> <leader>sh :VimShellCreate<CR>
endif

"*****************************************************************************
"" Functions
"*****************************************************************************
if !exists('*s:setupWrapping')
  function s:setupWrapping()
    set wrap
    set wm=2
    set textwidth=79
  endfunction
endif

"*****************************************************************************
"" Autocmd Rules
"*****************************************************************************
"" The PC is fast enough, do syntax highlight syncing from start unless 200 lines
augroup vimrc-sync-fromstart
  autocmd!
  autocmd BufEnter * :syntax sync maxlines=200
augroup END

"" Remember cursor position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

"" txt
augroup vimrc-wrapping
  autocmd!
  autocmd BufRead,BufNewFile *.txt call s:setupWrapping()
augroup END

"" make/cmake
augroup vimrc-make-cmake
  autocmd!
  autocmd FileType make setlocal noexpandtab
  autocmd BufNewFile,BufRead CMakeLists.txt setlocal filetype=cmake
augroup END

set autoread

"*****************************************************************************
"" Mappings
"*****************************************************************************

"" Split
noremap <Leader>h :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>

"" Git
noremap <Leader>ga :Gwrite<CR>
noremap <Leader>gc :Gcommit<CR>
noremap <Leader>gsh :Gpush<CR>
noremap <Leader>gll :Gpull<CR>
noremap <Leader>gs :Gstatus<CR>
noremap <Leader>gb :Gblame<CR>
noremap <Leader>gd :Gvdiff<CR>
noremap <Leader>gr :Gremove<CR>

" session management
nnoremap <leader>so :OpenSession<Space>
nnoremap <leader>ss :SaveSession<Space>
nnoremap <leader>sd :DeleteSession<CR>
nnoremap <leader>sc :CloseSession<CR>

"" Tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap <silent> <S-t> :tabnew<CR>

"" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

"" Opens an edit command with the path of the currently edited file filled in
noremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

"" Opens a tab edit command with the path of the currently edited file filled
noremap <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

""" Remap Shift+hjkl for quick navigation
nnoremap H ^
nnoremap L $
nnoremap J <C-d>
nnoremap K <C-u>

""" fzf bindings
nmap ; :Buffers<CR>
nmap <Leader>f :Files<CR>
nmap <Leader>ff :Files $HOME<CR>
nmap <Leader>t :Tags<CR>
nmap <Leader>m :Marks<CR>
nmap <Leader>c :Rg<CR>

""" vim-argwrap bindings
nnoremap <silent> <Leader>a :ArgWrap<CR>

" Swap the word the cursor is on with the next word (which can be on a
" newline, and punctuation is "skipped"):
nmap <Leader>sw "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><C-o>:noh<CR>

" Use Rg for Vim external search
if executable('rg')
  set grepprg=rg\ --nogroup\ --nocolor\ --noignore-vcs
endif

" Auto-Pairs settings (extension specific) "
" Python (add multiline string)
au FileType python let b:AutoPairs = AutoPairsDefine({"'''" : "'''"})

" Emmet setting (remap leader to Ctrl+e)
let g:user_emmet_leader_key = '<c-e>'

""" Auto-completion + Snippet bindings
let g:deoplete#enable_at_startup = 1
" disable autocomplete by default
let b:deoplete_disable_auto_complete=1
let g:deoplete_disable_auto_complete=1
let g:deoplete#auto_complete_delay = 150

let g:deoplete#sources = {}
let g:deoplete#sources#jedi#show_docstring = 1
" Disable the candidates in Comment/String syntaxes.
"call deoplete#custom#source('_',
"      \ 'disabled_syntaxes', ['Comment', 'String'])
"call deoplete#custom#option('sources', {
"      \ 'python': [ 'jedi' ]
"\})

" deoplete <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" Func doc show (otherwise INSERT mode overrides auto-complete function)
let g:echodoc#enable_at_startup = 1
let g:echodoc#enable_force_overwrite = 1
set noshowmode
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

"Tagbar
nmap <silent> <F4> :TagbarToggle<CR>
let g:tagbar_autofocus = 1

" Disable visualbell
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

"" Copy/Paste/Cut
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif

noremap YY "+y<CR>
noremap <leader>p "+gP<CR>
noremap XX "+x<CR>

if has('macunix')
  " pbcopy for OSX copy/paste
  vmap <C-x> :!pbcopy<CR>
  vmap <C-c> :w !pbcopy<CR><CR>
endif

"" Clean search (highlight)
nnoremap <silent> <leader><space> :noh<cr>

"" Switching windows + resizing
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

"" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

"" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

"" Open current line on GitHub
nnoremap <Leader>o :.Gbrowse<CR>

"*****************************************************************************
"" Custom configs
"*****************************************************************************

" html
" for html files, 2 spaces
autocmd Filetype html setlocal ts=2 sw=2 expandtab

" javascript
let g:javascript_enable_domhtmlcss = 1

" vim-javascript
augroup vimrc-javascript
  autocmd!
  autocmd FileType javascript set tabstop=4|set shiftwidth=4|set expandtab softtabstop=4 smartindent
augroup END

" ruby
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1

augroup vimrc-ruby
  autocmd!
  autocmd BufNewFile,BufRead *.rb,*.rbw,*.gemspec setlocal filetype=ruby
  autocmd FileType ruby set tabstop=2|set shiftwidth=2|set expandtab softtabstop=2 smartindent
augroup END

let g:tagbar_type_ruby = {
    \ 'kinds' : [
        \ 'm:modules',
        \ 'c:classes',
        \ 'd:describes',
        \ 'C:contexts',
        \ 'f:methods',
        \ 'F:singleton methods'
    \ ]
\ }

"*****************************************************************************
"*****************************************************************************

"" Include user's local vim config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

"*****************************************************************************
"" Convenience variables
"*****************************************************************************

" vim-airline
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

if !exists('g:airline_powerline_fonts')
  let g:airline#extensions#tabline#left_sep = ' '
  let g:airline#extensions#tabline#left_alt_sep = '|'
  let g:airline_left_sep          = '▶'
  let g:airline_left_alt_sep      = '»'
  let g:airline_right_sep         = '◀'
  let g:airline_right_alt_sep     = '«'
  let g:airline#extensions#branch#prefix     = '⤴' "➔, ➥, ⎇
  let g:airline#extensions#readonly#symbol   = '⊘'
  let g:airline#extensions#linecolumn#prefix = '¶'
  let g:airline#extensions#paste#symbol      = 'ρ'
  let g:airline_symbols.linenr    = '␊'
  let g:airline_symbols.branch    = '⎇'
  let g:airline_symbols.paste     = 'ρ'
  let g:airline_symbols.paste     = 'Þ'
  let g:airline_symbols.paste     = '∥'
  let g:airline_symbols.whitespace = 'Ξ'
else
  let g:airline#extensions#tabline#left_sep = ''
  let g:airline#extensions#tabline#left_alt_sep = ''

  " powerline symbols
  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = ''
  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = ''
  let g:airline_symbols.branch = ''
  let g:airline_symbols.readonly = ''
  let g:airline_symbols.linenr = ''
endif


