"Run pathogen
" For some reason this makes your spaces tabs and no amount of
" expandtab can do anything about it!
"call pathogen#infect()

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
nmap <Leader>m ! f=$( mktemp -u -t mkdown ).html; maruku --html -o $f %; open $f<CR>

"status line
:set laststatus=2
:set statusline=%t\ %y%r\ [%l,%c]\ %P

" Get rid of the topbar on gui mode
"set guioptions-=T
set guioptions-=T

" Colors!
syntax enable
set background=dark
"colorscheme solarized
" Solarized background strangeness fix
highlight Normal ctermbg=none

"Set linenumber stuff
"set numberwidth=5
"set relativenumber
"autocmd InsertEnter * :set number
"autocmd InsertLeave * :set relativenumber
"highlight LineNr ctermbg=darkgrey

"Set reasonable colors for pyflakes highlighting
hi SpellBad cterm=underline ctermbg=0

" Enable filetype support for awesome plugin goodness
" DONT ENABLE.  for some reason this makes your spaces tabs and no amount of
" expandtab can do anything about it!
"filetype on
"filetype plugin on
"filetype plugin indent on


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

":nmap - Display normal mode maps
":imap - Display insert mode maps
":vmap - Display visual and select mode maps
":smap - Display select mode maps
":xmap - Display visual mode maps
":cmap - Display command-line mode maps
":omap - Display operator pending mode maps

"Leave insert mode with `jk` (avoid escape!)
imap jk <Esc>

"the original gf
map <leader>gf gf

"vsp the file under the cursor
map gv :vertical wincmd f<CR>

"open file in new tab (similar to gf) with `gf`
map gf <C-w>gf

"map gT (go back a tab) to GT
map GT gT

"map <Space> to add a space to the right of the cursor
nmap <leader><Space> a<Space><Esc>

"map <Space><Space> to add a new line below the cursor
nmap <leader><CR> o<Esc>

"map ,nohl remove highlights
nmap <leader>nohl :nohl<CR>

" unmap arrow keys
"nmap <right> <nop>
"nmap <left> <nop>
"nmap <up> <nop>
"nmap <down> <nop>
"imap <right> <nop>
"imap <left> <nop>
"imap <up> <nop>
"imap <down> <nop>

" More intuitive motions through wrapped lines
set linebreak
nnoremap gj j
nnoremap gk k


"http://vim.wikia.com/wiki/VimTip1608
set tags+=~/.vim/tags/alltags
" build tags of your own project with Ctrl-F12
map <C-F12> :!ctags -R --sort=yes --c++-kinds=+lp --fields=+iaS --extra=+q .<CR>

"Reload all buffers with F4
nmap <F4> :bufdo e!<CR>

" Opens tagbar with F2
map <F2> :TagbarToggle<CR>

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

fun! GrepWord()
    let s:term = expand('<cword>')
    :exe ":!grep --color=always -r " . s:term . " *"
endfun

fun! SearchGit()
    let s:term = expand('<cword>')
    :exe ":!git grep " . s:term . ""
endfun

fun! GrepWordPipeOut()
    let s:term = expand('<cword>')
    :exe ":!grep --color=always -r " . s:term . " * > out"
endfun

fun! GitGrepWordPipeOut()
    let s:term = expand('<cword>')
    :exe ":!git grep -i " . s:term . " > out"
endfun

map sear :call GrepWord()<CR>
map fsear :call GrepWordPipeOut()<CR>
map fgsear :call GitGrepWordPipeOut()<CR>
map sg :call SearchGit()<CR>

" format json
command JSON :%!python -m json.tool

" convert page of 
" [filename]: [line of code]
" to
" [filename]
fun! ListFiles()
    " remove everything after the colon
    :%s/:.*$//g
    " remove duplicates
    :sort u
endfun
command Listfiles :call ListFiles()


" Run a given vim command on the results of fuzzy selecting from a given shell
" command. See usage below.
function! SelectaCommand(choice_command, selecta_args, vim_command)
    try
        let selection = system(a:choice_command . " | selecta " . a:selecta_args)
    catch /Vim:Interrupt/
        " Swallow the ^C so that the redraw below happens; otherwise there will be
        " leftovers from selecta on the screen
        redraw!
        return
    endtry
    redraw!
    exec a:vim_command . " " . selection
endfunction

" Find all files in all non-dot directories starting in the working directory.
" Fuzzy select one of those. Open the selected file with :e.
nnoremap <leader>f :call SelectaCommand("find * -type f", "", ":e")<cr>

if filereadable("/Users/expensisaurus/.vim/php_vimrc.vim")
    so /Users/expensisaurus/.vim/php_vimrc.vim
endif
