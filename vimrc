"Run pathogen
call pathogen#infect()

set rtp+=/usr/local/go/misc/vim
syntax on

" backspace fix
set backspace=2

" New leader
let mapleader=","

" Yank, comment, paste.
nmap <leader>y yy,c<space>p
vmap <leader>y yygv,c<space>p

" Various copy/paste niceties (assumes pbcopy/pbpaste is installed)
vmap <leader>c ! pbcopy<CR>:undo<CR>
nmap <leader>v :set paste<CR>! pbpaste<CR>:set nopaste<CR>

" Markdown preview
nmap <Leader>m ! f=$( mktemp -u -t mkdown ).html; redcarpet --parse-no_intra_emphasis --parse-fenced_code_blocks --parse-tables % > $f; open $f<CR>

"status line
:set laststatus=2
:set statusline=%t\ %y%r%{fugitive#statusline()}\ [%c,%l]

"only explicitly add some gui options
set guioptions=aem

" Colors!
syntax enable
set background=dark
colorscheme solarized
" Solarized background strangeness fix
highlight Normal ctermbg=none

"Set linenumber stuff
set numberwidth=5
"Setting number then relativenumber gives us relative numbering with the
"current line having the absolute line number
set number
set relativenumber
highlight LineNr ctermbg=darkgrey

"Set reasonable colors for pyflakes highlighting
hi SpellBad cterm=underline ctermbg=0

" Enable filetype support for awesome plugin goodness
filetype on
filetype plugin on
filetype plugin indent on

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

" More intuitive motions through wrapped lines
set linebreak
nnoremap gj j
nnoremap gk k


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
let g:tagbar_ctags_bin = '/usr/local/bin/ctags'

" ctype settings for go:
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
let NERDTreeIgnore = ['\.pyc$', '\.sw[op]$']

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

"Fold on preprocessor definitions
autocmd FileType [ch] call FoldPreprocessor()
function! FoldPreprocessor()
    set foldmarker=#if,#endif
    set foldmethod=marker
endfunction

"Make asciidoc easier to work with
autocmd FileType asciidoc :set tw=80

"In normal mode, press Space to toggle the current fold open/closed. However, if
"the cursor is not in a fold, move to the right (the default behavior). In
"addition, with the manual fold method, you can create a fold by visually
"selecting some lines, then pressing Space.
" http://vim.wikia.com/wiki/Folding
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

"Tabline
if exists("+guioptions") 
     set go-=e 
endif 
if exists("+showtabline") 
     function MyTabLine() 
         let s = '' 
         let t = tabpagenr() 
         let i = 1 
         while i <= tabpagenr('$') 
             let buflist = tabpagebuflist(i) 
             let winnr = tabpagewinnr(i) 
             let s .= ' %' . i . 'T' 
             let s .= (i == t ? '%1*[' : '%2*%#TabLineFill#(') 
             let s .= i  

             let modified = 0
             for curbuf in buflist
               let modified += getbufvar(curbuf, "&modified")
             endfor
             if modified > 0
               let s .= '*'
             else
               let s .= '-'
             endif

             let s .= '%*' 
             let s .= (i == t ? '%#TabLineSel#' : '') 
             let file = bufname(buflist[winnr - 1]) 
             let file = fnamemodify(file, ':p:.:t') 
             if file == '' 
                 let file = '[No Name]' 
             endif 
             let s .= file 
             if tabpagewinnr(i,'$') > 1
               let s .= '/' . tabpagewinnr(i,'$')
             endif
             let s .= (i == t ? '%#TabLineFill#]' : ')') 
             let s .= ' '
             let i = i + 1 
         endwhile 
         let s .= '%T%#TabLineFill#%=' 
         let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X') 
         return s 
     endfunction 
     set stal=2 
     set tabline=%!MyTabLine() 
endif
