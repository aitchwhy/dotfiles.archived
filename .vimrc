"*****************************************************************************
"" Vim-Plug core
"*****************************************************************************
" True on startup / False on running ---> check for when .vimrc manually sourced
if has('vim_starting')
  set nocompatible
endif

let vimplug_exists=expand('~/.vim/autoload/plug.vim')

let g:vim_bootstrap_langs = "html,javascript,php,ruby"
let g:vim_bootstrap_editor = "nvim"        " nvim or vim

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
"" Basics (must be set before plugin installs otherwise mappings don't work)
"*****************************************************************************
"" Map leader to ,
let mapleader=','


"*****************************************************************************
"" Plug install packages
"*****************************************************************************

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Navigation
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Netrw boost (split file explorer ... OPPOSITE OF NERDTREE project drawer)
Plug 'tpope/vim-vinegar'
" Add visual marker to each mark
Plug 'kshenoy/vim-signature'
" Tmux / Vim navigator
Plug 'christoomey/vim-tmux-navigator'
" CamelCase motion script (words respect camelcase - when used with LEADER)
Plug 'bkad/CamelCaseMotion'
" CamelCase motion script (words respect camelcase - when used with LEADER)
Plug 'easymotion/vim-easymotion'

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
Plug 'junegunn/fzf.vim'
" Automatic closing of quotes, etc
Plug 'jiangmiao/auto-pairs'
" Tabular lining up text
Plug 'godlygeek/tabular'
" Multiple cursors (Sublime-style)
Plug 'terryma/vim-multiple-cursors'
" Conversion between single / multi lines (function args, lists)
Plug 'FooSoft/vim-argwrap'
" Conversion between single / multi lines (function args, lists)
Plug 'mbbill/undotree'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color theme
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'arcticicestudio/nord-vim'
Plug 'nanotech/jellybeans.vim'
Plug 'whatyouhide/vim-gotham'
Plug 'ayu-theme/ayu-vim'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" StatusLine
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Util
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Window resizing
Plug 'camspiers/lens.vim'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Util
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Git wrapper
Plug 'tpope/vim-fugitive'
" Git gutter (left-side shows diff style)
Plug 'airblade/vim-gitgutter'
" Colorscheme approx (gvim only colors on terminal)
" Plug 'vim-scripts/CSApprox'



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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocompletion + Snippets (by :CocInstall)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" TODO: Add Snippets plugin
" Snippet Engine ---> TODO: comeback with better config
" Plug 'SirVer/ultisnips'
" Actual Snippets collection for Engine usage
" Plug 'honza/vim-snippets'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntax Linting / Highlighting / checking / error checking
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Highlight trailing whitespace
Plug 'bronson/vim-trailing-whitespace'
" Shows indent level with thin vertical lines
Plug 'Yggdroot/indentLine'

"*****************************************************************************
"" Custom language syntax bundles
"*****************************************************************************

" PSQL + set as default
Plug 'lifepillar/pgsql.vim'
let g:sql_type_default = 'pgsql'

"*****************************************************************************
call plug#end()

" Required:
filetype plugin indent on

"*****************************************************************************
"" Visual Settings
"*****************************************************************************

syntax on
set ruler
set number

let no_buffers_menu=1

" enable true colors support
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set t_Co=256
  " set termguicolors --- sets vim colorscheme to be off (do not set unless with iterm support)
  set termguicolors
endif
" colorscheme nord
" colorscheme jellybeans
" colorscheme gotham
colorscheme ayu
let ayucolor="mirage"

set mousemodel=popup
set t_Co=256
set guioptions=egmrti
set gfn=Monospace\ 10

" cursor shape (empty value means shape won't change by mode)
set guicursor=

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

set autoread

function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, '&signcolumn', 'no')
  let height = &lines - 3
  let width = float2nr(&columns - (&columns * 2 / 10))
  let col = float2nr((&columns - width) / 2)

  let opts = {
        \ 'relative': 'editor',
        \ 'row': 1,
        \ 'col': col,
        \ 'width': width,
        \ 'height': height
        \ }

  call nvim_open_win(buf, v:true, opts)
endfunction

"*****************************************************************************
"" Option setting
"*****************************************************************************

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
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab

"" set pastetoggle mode to F2
set pastetoggle=<F2>

"" Enable hidden buffers
set hidden


"" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

"" Directories for swp files
set nobackup
set nowritebackup
set noswapfile

set fileformats=unix,dos,mac
set showcmd
"" Shell settings for Zsh (specify binary location)
set shell=/opt/homebrew/bin/zsh

""" Enable FZF in vim by adding it to runtimepath (path is for Brew install)
set rtp+=/usr/local/opt/fzf

" Use Rg for Vim external search
if executable('rg')
  set grepprg=rg\ --nogroup\ --nocolor\ --noignore-vcs
endif

" Keymap waiting period length (:help timeoutlen) - happens when multiple keys mapped to same prefix
set timeoutlen=250

" Vim folding
set foldmethod=indent
set foldlevelstart=20

" Vim Jumplist (<C-i> clashes with coc.vim so using <c-p> instead)
nnoremap <C-p> <C-i>

"*****************************************************************************
" coc.vim settings
"*****************************************************************************
" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)


" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

"*****************************************************************************
"" Key Mappings
"*****************************************************************************

""" fzf bindings
nmap ; :Buffers<CR>
nmap <Leader>f :GitFiles<CR>
nmap <Leader>ff :Files<CR>
" Current buffer tags only
nmap <Leader>t :BTags<CR>
" all tags
nmap <Leader>tt :Tags<CR>
nmap <Leader>m :Marks<CR>
nmap <Leader>c :BCommits<CR>
nmap <Leader>cc :Commits<CR>
nmap <Leader>l :BLines<CR>
nmap <Leader>ll :Lines<CR>
nmap <Leader>s :Rg<CR>
nmap <Leader>ss :PRg<CR>

""" Split
noremap <Leader>h :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>

""" Git (Fugitive + gitgutter)
noremap <Leader>ga :Gwrite<CR>
noremap <Leader>gc :Gcommit<CR>
noremap <Leader>gsh :Gpush<CR>
noremap <Leader>gll :Gpull<CR>
noremap <Leader>gs :Gstatus<CR>
noremap <Leader>gbl :Gblame<CR>
noremap <Leader>gd :Gvdiff<CR>
noremap <Leader>gr :Gremove<CR>
noremap <Leader>gg :GitGutterToggle<CR>

""" vim-argwrap bindings
nnoremap <silent> <Leader>a :ArgWrap<CR>

" Swap the word the cursor is on with the next word (which can be on a
" newline, and punctuation is "skipped"):
nmap <Leader>sw "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><C-o>:noh<CR>

""" Switching windows + resizing
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

""" Undotree
noremap <Leader>ut :UndotreeToggle<CR>
noremap <F9> :earlier<CR>
noremap <F10> :later<CR>

""" Tagbar
nmap <silent> <F8> :TagbarToggle<CR>

" session management
" nnoremap <leader>so :OpenSession<Space>
" nnoremap <leader>ss :SaveSession<Space>
" nnoremap <leader>sd :DeleteSession<CR>
" nnoremap <leader>sc :CloseSession<CR>

"" Tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap <silent> <S-t> :tabnew<CR>

"" Set working directory (https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file)
nnoremap <leader>. :lcd %:p:h<CR>

" Tagbar
nmap <F8> :TagbarToggle<CR>

nnoremap <C-w>O :call MaximizeToggle()<CR>
nnoremap <C-w>o :call MaximizeToggle()<CR>
nnoremap <C-w><C-O> :call MaximizeToggle()<CR>

function! MaximizeToggle()
  if exists("s:maximize_session")
    exec "source " . s:maximize_session
    call delete(s:maximize_session)
    unlet s:maximize_session
    let &hidden=s:maximize_hidden_save
    unlet s:maximize_hidden_save
  else
    let s:maximize_hidden_save = &hidden
    let s:maximize_session = tempname()
    set hidden
    exec "mksession! " . s:maximize_session
    only
  endif
endfunction


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


"" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

" Netrw bindings
map <leader>nt :Ntree<cr>

" QuickFix keymaps (inspired from unimpaired.vim)
noremap [q :cprev<cr>
noremap ]q :cnext<cr>

"*****************************************************************************
"" Autocmd Rules
"*****************************************************************************

" Disable indentLine Plugin JSON file quote concealing
autocmd Filetype json let g:indentLine_enabled = 0

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

" Auto-Pairs settings (extension specific) "
" Python (add multiline string)
" au FileType python let b:AutoPairs = AutoPairsDefine({"'''" : "'''"})

" Netrw closing
autocmd FileType netrw setl bufhidden=wipe

" netrw buffer won't close, so workaround to delete when hidden
" Remove 'set hidden'
set nohidden
augroup netrw_buf_hidden_fix
    autocmd!

    " Set all non-netrw buffers to bufhidden=hide
    autocmd BufWinEnter *
                \  if &ft != 'netrw'
                \|     set bufhidden=hide
                \| endif
augroup end


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
"" Convenience variables
"*****************************************************************************
" FZF floating window
let g:fzf_layout = { 'window': 'call FloatingFZF()' }
" FZF Rg search default command override
" Options + include file pattern (2nd line) + exclude file pattern (3rd line)
let g:rg_command = '
  \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
  \ -g "!{.git,node_modules,vendor}/*" '
command! -bang -nargs=* Rg call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, <bang>0)

command! -bang -nargs=* PRg
  \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'dir': system('git rev-parse --show-toplevel 2> /dev/null')[:-2]}, <bang>0)

" Netrw Settings
let g:netrw_liststyle = 3       " default style (tree style)
let g:netrw_winsize = 25        " window size 25%

" session management
let g:session_directory = "~/.vim/session"
let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1

" Tagbar autofocus to bar on open
let g:tagbar_autofocus = 1


let g:camelcasemotion_key = '<leader>'


"*****************************************************************************
"" Airline (statusline)
"*****************************************************************************

" Add status line support for coc, for integration with other plugin, checkout `:h coc-status`
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}


let g:airline#extensions#coc#enabled = 1
" set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\
" set statusline+=%{FugitiveStatusline()}
" if exists("*fugitive#statusline")
  " set statusline+=%{fugitive#statusline()}
" endif

" vim-airline
let g:airline_theme = 'fruit_punch'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline_skip_empty_sections = 1


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
