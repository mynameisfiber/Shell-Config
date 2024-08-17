" Enable filetype support for awesome plugin goodness
filetype on
filetype plugin on
filetype plugin indent on

" utf8
set encoding=utf-8
" right click extends current selection
set mousemodel=extend
" Set vim keyboard so that the system copy buffer syncs with vims
set clipboard^=unnamed,unnamedplus

" Spellcheck language and auto-turn-on for markdown
set spelllang=fr,en
autocmd FileType markdown setlocal spell
autocmd FileType gitcommit setlocal spell
autocmd FileType markdown setlocal complete+=kspell
autocmd FileType gitcommit setlocal complete+=kspell

" gitgutter
let g:gitgutter_override_sign_column_highlight = 0
highlight SignColumn ctermbg=None
"
"Set linenumber stuff
set numberwidth=5
"Setting number then relativenumber gives us relative numbering with the
"current line having the absolute line number
set number
set relativenumber

" bash-like file completion
set wildmode=longest,list

"Allow moving to the end of the line in visual block mode
set virtualedit+=block

"Highlight search results
set hlsearch

"tabs
set softtabstop=4
set shiftwidth=4
set expandtab
set tabstop=4
set smarttab
set smartindent
set autoindent

"Search config
set ignorecase
set smartcase
set incsearch

" filter cache files everywhere
set wildignore+=*__pycache__*,*.pyc
