" general settings
set number
set smartindent
set expandtab

set shiftwidth=2
set softtabstop=2
set tabstop=2

set ignorecase
set smartcase

set virtualedit=onemore

set undofile
set undolevels=1000
set undoreload=10000
set undodir=$HOME/.config/nvim/undo

set wildmode=longest,list:longest
set inccommand=nosplit

set lazyredraw
set noshowmode
set cursorline

set noerrorbells visualbell t_vb=

" disable automatic commenting
autocmd FileType * setlocal formatoptions-=cro
set formatoptions-=cro

set mouse=a

" plugins
call plug#begin($HOME . '/.config/nvim/plugged')

" junegunn
Plug 'junegunn/fzf', {
  \ 'dir': '~/.fzf',
  \ 'do': './install --all',
  \ }
Plug 'junegunn/fzf.vim'

" tpope
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'

" languages
Plug 'rust-lang/rust.vim'
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'hashivim/vim-terraform'
Plug 'ekalinin/Dockerfile.vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'elixir-editors/vim-elixir'
Plug 'ElmCast/elm-vim'

Plug 'jelera/vim-javascript-syntax'
Plug 'fatih/vim-go', {
  \ 'do': ':GoInstallBinaries'
  \ }

" language server
Plug 'autozimu/LanguageClient-neovim', {
  \ 'branch': 'next',
  \ 'do': 'bash install.sh',
  \ }

" auto complete
Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-go'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'roxma/nvim-yarp'

" linting
Plug 'w0rp/ale'

" lightline
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'

" utilities
Plug 'jremmen/vim-ripgrep'
Plug 'sgur/vim-editorconfig'
Plug 'ludovicchabant/vim-gutentags'
Plug 'mhinz/vim-signify'
Plug 'christoomey/vim-tmux-navigator'

" themes
Plug 'drewtempelmeyer/palenight.vim'

call plug#end()

" colorscheme
set background=dark
colorscheme palenight

if (has("termguicolors"))
  set termguicolors
endif

let g:palenight_terminal_italics = 1

" python remote plugin
let g:python_host_prog='/usr/local/bin/python2'
let g:python3_host_prog='/usr/local/miniconda3/bin/python'

" auto complete
set completeopt=noinsert,menuone,noselect
set shortmess+=c

inoremap <c-c> <ESC>
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

autocmd BufEnter * call ncm2#enable_for_buffer()

" language server
let g:LanguageClient_diagnosticsEnable = 0
let g:LanguageClient_serverCommands = {
  \ 'python': ['pyls'],
  \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
  \ 'ruby': ['solargraph', 'stdio'],
  \ }

nnoremap <silent> gd :call LanguageClient#textDocument_definition()<cr>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<cr>

" ale
let g:ale_sign_column_always = 1
let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 1
let g:ale_set_highlights = 0

let g:ale_sign_warning = ''
let g:ale_sign_error = ''

let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')

let g:ale_linters = {
  \ 'python': ['flake8'],
  \ 'go': ['gometalinter'],
  \ 'javascript': ['eslint'],
  \ 'rust': ['cargo'],
  \ 'ruby': ['rubocop'],
  \ }

let g:ale_fixers = {
  \ '*': ['remove_trailing_lines', 'trim_whitespace'],
  \ 'python': ['isort', 'black'],
  \ 'go': ['gofmt', 'goimports'],
  \ 'rust': ['rustfmt'],
  \ 'ruby': ['rubocop', 'rufo'],
  \ 'css': ['prettier'],
  \ 'html': ['prettier'],
  \ 'javascript': ['prettier'],
  \ 'json': ['prettier'],
  \ 'markdown': ['prettier'],
  \ 'scss': ['prettier'],
  \ 'typescript': ['prettier'],
  \ 'yaml': ['prettier'],
  \ }

" gutentags
let g:gutentags_exclude_filetypes = ['gitcommit', 'vim']

" signify
let g:signify_vcs_list = ['git']

" lightline
let g:lightline = {
  \ 'colorscheme': 'palenight',
  \ 'active': {
  \   'left': [['mode', 'paste'],
  \            ['fugitive', 'filename', 'filetype']],
  \   'right': [['lineinfo'], ['percent'],
  \             ['linter_errors', 'linter_warnings']],
  \ },
  \ 'component_function': {
  \   'mode': 'LightLineMode',
  \   'filename': 'LightLineFilename',
  \   'fugitive': 'LightLineFugitive',
  \   'fileformat': 'LightLineFileformat',
  \   'filetype': 'LightLineFiletype',
  \ },
  \ 'component_expand': {
  \   'linter_warnings': 'lightline#ale#warnings',
  \   'linter_errors': 'lightline#ale#errors',
  \ },
  \ 'component_type': {
  \   'linter_warnings': 'warning',
  \   'linter_errors': 'error',
  \ },
  \ 'separator': { 'left': '', 'right': '' },
	\ 'subseparator': { 'left': '', 'right': '' },
  \ }

let g:lightline#ale#indicator_warnings = ' '
let g:lightline#ale#indicator_errors = ' '

function! LightLineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! LightLineFilename()
  let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
  let modified = &modified ? ' +' : ''
  return filename . modified
endfunction

function! LightLineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightLineFugitive()
  let _ = fugitive#head()
  return strlen(_) ? ' '._ : ''
endfunction

" standard keybindings
let mapleader = "\<Space>"

nnoremap <silent> <leader>ea :edit $HOME/.config/alacritty/alacritty.yml<cr>
nnoremap <silent> <leader>et :edit $HOME/.tmux.conf<cr>
nnoremap <silent> <leader>ez :edit $HOME/.zshrc<cr>
nnoremap <silent> <leader>ev :edit $MYVIMRC<cr>
nnoremap <silent> <leader>sv :source $MYVIMRC<cr>

nnoremap <silent> <leader>l :redraw!<cr>:nohl<cr><esc>
nnoremap <silent> <leader>v :vsplit<cr><c-w>l
nnoremap <silent> <leader>h :split<cr><c-w>j
nnoremap <silent> <leader>w :write<cr>
nnoremap <silent> <leader>q :quit<cr>

nnoremap <silent> <c-h> <c-w>h
nnoremap <silent> <c-j> <c-w>j
nnoremap <silent> <c-k> <c-w>k
nnoremap <silent> <c-l> <c-w>l

nnoremap <silent> Y y$

nnoremap <silent> j gj
nnoremap <silent> k gk

nnoremap <silent> n nzz
nnoremap <silent> N Nzz

nnoremap <silent> <c-d> <c-d>zz
nnoremap <silent> <c-u> <c-u>zz

noremap <silent> <leader>sy "*y

cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-f> <right>
cnoremap <c-b> <left>

" fzf
nnoremap <silent> <leader>p :call fzf#run({ 'source': 'rg --files', 'sink': 'e', 'window': 'enew' })<cr>

" rg
nnoremap <leader>a :Rg<space>

" format json
nnoremap <leader>j :%!python -m json.tool<cr>
