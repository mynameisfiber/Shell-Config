"Run pathogen
call pathogen#infect()

set rtp+=/usr/share/vim/addons
set rtp+=/usr/local/go/misc/vim
syntax on

" backspace fix
set backspace=2

" New leader
let mapleader=","

" speedup the delay for mappings
"set timeout timeoutlen=100

" Screw Ex-mode
nnoremap Q <nop>

" vim-expand-region remaping
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" Yank, comment, paste.
nmap <leader>Y yy,c<space>p
vmap <leader>Y ygv,c<space>P

" Various copy/paste niceties (assumes vim is compiled with +clipboard)
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" buffer movements
nmap bT :bprevious<cr>
nmap bt :bnext<cr>
nmap <leader>b :ls<cr>:buffer<space>
nmap bv :vert sb<space>

" General remapings
nnoremap <Leader>w :w<CR>
nmap <Leader><Leader> V
map q: :q

" Set vim keyboard so that the system copy buffer syncs with vims
set clipboard^=unnamed,unnamedplus

" Markdown preview
nmap <Leader>m ! f=$( mktemp -u -t mkdown ).html; redcarpet --parse-no_intra_emphasis --parse-fenced_code_blocks --parse-tables % > $f; open $f<CR>

"only explicitly add some gui options
"set guioptions=aem

" Colors!
syntax enable
set background=dark
colorscheme solarized
" Solarized background strangeness fix
highlight Normal ctermbg=None
highlight LineNr ctermfg=grey ctermbg=None

" gitgutter
let g:gitgutter_override_sign_column_highlight = 0
highlight SignColumn ctermbg=None

"Set linenumber stuff
set numberwidth=5
"Setting number then relativenumber gives us relative numbering with the
"current line having the absolute line number
set number
set relativenumber

"Set reasonable colors for spellcheck highlighting
hi SpellBad cterm=underline ctermbg=0

"syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 1
let g:syntastic_enable_highlighting=1
let g:syntastic_aggregate_errors = 1
let g:syntastic_python_checkers=["flake8"]
let g:syntastic_asciidoc_checkers=["proselint"]
let g:syntastic_text_checkers=["proselint"]
let g:syntastic_markdown_checkers=["proselint"]


function! ToggleErrors()
    if empty(filter(tabpagebuflist(), 'getbufvar(v:val, "&buftype") is# "quickfix"'))
         " No location/quickfix list shown, open syntastic error location panel
         Errors
    else
        lclose
    endif
endfunction
nnoremap <silent> <C-e> :<C-u>call ToggleErrors()<CR>

" Enable filetype support for awesome plugin goodness
filetype on
filetype plugin on
filetype plugin indent on

" bash-like file completion
set wildmode=longest,list

"Allow moving to the end of the line in visual block mode
set virtualedit+=block

" q to get out of visual mode
vmap q <Esc>

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

"Finding keeps cursor in the middle of the screen
nnoremap n nzz

"Leave insert mode with `jk` (avoid escape!)
imap jk <Esc>

" unmap arrow keys
nmap <right> <nop>
nmap <left> <nop>
nmap <up> <nop>
nmap <down> <nop>
imap <right> <nop>
imap <left> <nop>
imap <up> <nop>
imap <down> <nop>

" also map ^c-arrow to something useful instead of deleting parts of the text
if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif
nmap <silent> <C-Right> <c-w>l
nmap <silent> <C-Left> <c-w>h
nmap <silent> <C-Up> <c-w>k
nmap <silent> <C-Down> <c-w>j
imap <C-w> <C-o><C-w>
imap <silent> <C-Right> <c-w>l
imap <silent> <C-Left> <c-w>h
imap <silent> <C-Up> <c-w>k
imap <silent> <C-Down> <c-w>j

" More intuitive motions through wrapped lines
" http://vim.wikia.com/wiki/Move_cursor_by_display_lines_when_wrapping
set linebreak
noremap <buffer> <silent> k gk
noremap <buffer> <silent> j gj
noremap <buffer> <silent> 0 g0
noremap <buffer> <silent> $ g$


"http://vim.wikia.com/wiki/VimTip1608
set tags+=~/.vim/tags/alltags
" build tags of your own project with Ctrl-F12
map <C-F12> :!ctags -R --sort=yes --c++-kinds=+lp --fields=+iaS --extra=+q .<CR>

"Reload all buffers with F7
nmap <F7> :bufdo e!<CR>

" Opens tagbar with F2
map <F2> :TagbarToggle<CR>

" map F1 to escape because I keep hitting it with this new keyboard
map <F1> <Esc>
imap <F1> <Esc>

" general ctypes location
let g:tagbar_ctags_bin = '/usr/bin/ctags'

" golint for golang
"set rtp+=$HOME/projects/golang/src/github.com/golang/lint/misc/vim
"autocmd BufWritePost,FileWritePost *.go execute 'Lint' | cwindow

" tagbar settings for markdown using markdown2ctags
let g:tagbar_type_markdown = {
    \ 'ctagstype': 'markdown',
    \ 'ctagsbin' : '~/config/bin/markdown2ctags/markdown2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }

" ctype settings for golang:
" https://github.com/jstemmer/gotags
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

" Open NERDTree with F3
map <F3> :NERDTreeToggle<CR>
" Filter out annoying files in nerdtree
let NERDTreeIgnore = ['\.pyc$', '\.sw[op]$', '__pycache__']

" filter cache files everywhere
set wildignore+=*__pycache__*,*.pyc

" Open GunDo with F5
map <F5> :GundoToggle<CR>

"Window Resizing
map <C-A-l> <C-w>>
map <C-A-k> <C-W>-
map <C-A-j> <C-W>+
map <C-A-h> <C-w><

map <C-l> 5<C-w>>
map <C-k> 5<C-W>-
map <C-j> 5<C-W>+
map <C-h> 5<C-w><

"Tab Movement and creation
:map <C-S-tab> :tabprevious<CR>
:map <C-tab> :tabnext<CR>
:imap <C-S-tab> <Esc>:tabprevious<CR>i
:imap <C-tab> <Esc>:tabnext<CR>i
:nmap <C-S-t> :tabnew<CR>
:imap <C-S-t> <Esc>:tabnew<CR>

noremap fj gt
noremap fJ gT
nmap gt <nop>
nmap gT <nop>

"split creation
" window
nmap <leader>swh  :topleft  vnew<CR>
nmap <leader>swl :botright vnew<CR>
nmap <leader>swk    :topleft  new<CR>
nmap <leader>swj  :botright new<CR>
" buffer
nmap <leader>sh   :leftabove  vnew<CR>
nmap <leader>sl  :rightbelow vnew<CR>
nmap <leader>sk     :leftabove  new<CR>
nmap <leader>sj   :rightbelow new<CR>

"Fold on preprocessor definitions
autocmd FileType [ch] call FoldPreprocessor()
function! FoldPreprocessor()
    set foldmarker=#if,#endif
    set foldmethod=marker
endfunction

"Make asciidoc easier to work with
autocmd FileType asciidoc :set tw=80
autocmd FileType asciidoc :set spell
autocmd FileType asciidoc :set noautoindent
autocmd FileType asciidoc :set nosmartindent
autocmd FileType asciidoc :set nocindent
autocmd FileType asciidoc let g:tagbar_type_asciidoc = {
    \ 'ctagstype' : 'asciidoc',
    \ 'kinds' : [
        \ 'h:table of contents',
        \ 'a:anchors',
        \ 't:titles',
        \ 'n:includes',
        \ 'i:images',
        \ 'I:inline images'
    \ ],
    \ 'sort' : 0
\ }


"Make markdown easier to work with
autocmd FileType markdown :set tw=80
autocmd FileType markdown :set spell

"In normal mode, press Space to toggle the current fold open/closed. However, if
"the cursor is not in a fold, move to the right (the default behavior). In
"addition, with the manual fold method, you can create a fold by visually
"selecting some lines, then pressing Space.
" http://vim.wikia.com/wiki/Folding
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

" change ctrlp to be invoked like command-t
let g:ctrlp_map = '<leader>t'

" ctlrp root path uses git
let g:ctrlp_working_path_mode = 'ra'

" ignore big folders
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.git|__pycache__|data|node_modules)$',
  \ 'file': '\v\.(exe|so|dll|pyc)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

" speed up ctrlp as per:
" https://medium.com/a-tiny-piece-of-vim/making-ctrlp-vim-load-100x-faster-7a722fae7df6#.oh6lf21r6
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" air-line
set laststatus=2 " always open
let g:airline_powerline_fonts = 1
let g:airline_theme = 'dark'

" without this we get info in both bufferline and commandline
let g:bufferline_echo = 0

" Tabline enhancements
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#fnamemod = ':t'

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" Close hidden buffers
function DeleteHiddenBuffers()
    let tpbl=[]
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
        silent execute 'bwipeout' buf
    endfor
endfunction
nmap bd :call DeleteHiddenBuffers()<cr>
