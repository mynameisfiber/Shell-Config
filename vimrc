"Run pathogen
call pathogen#infect()
syntax on

syntax enable
set background=dark
colorscheme solarized
" Solarized background strangeness fix
highlight Normal ctermbg=none

"Set linenumber stuff
set numberwidth=3
set relativenumber
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber
highlight LineNr ctermbg=darkgrey

"Set reasonable colors for pyflakes highlighting
hi SpellBad cterm=underline ctermbg=0

filetype on
filetype plugin on
filetype plugin indent on

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
set incsearch

"Omni completion
:filetype on
:filetype plugin on
set nocp

if has("autocmd")
  autocmd Filetype java setlocal omnifunc=javacomplete#Complete
  autocmd Filetype java setlocal completefunc=javacomplete#CompleteParamsInfo
endif
:inoremap <buffer> <C-X><C-U> <C-X><C-U><C-P>
:inoremap <buffer> <C-S-Space> <C-X><C-O>

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

"http://vim.wikia.com/wiki/VimTip1608
set tags+=~/.vim/tags/alltags
" build tags of your own project with Ctrl-F12
map <C-F12> :!ctags -R --sort=yes --c++-kinds=+lp --fields=+iaS --extra=+q .<CR>

"Reload all buffers with F4
nmap <F4> :bufdo e!<CR>

" Opens tagbar with F2
let g:tagbar_ctags_bin = '/usr/local/bin/ctags'
map <F2> :TagbarToggle<CR>

" Open NERDTree with F3
map <F3> :NERDTreeToggle<CR>

" Open GunDo with F5
map <F5> :GundoToggle<CR>

"Window Resizing
map <C-h> <C-w><
map <C-j> <C-W>-
map <C-k> <C-W>+
map <C-l> <C-w>>

"Tab Movement and creation
:map <C-S-tab> :tabprevious<CR>
:map <C-tab> :tabnext<CR>
:imap <C-S-tab> <Esc>:tabprevious<CR>i
:imap <C-tab> <Esc>:tabnext<CR>i
:nmap <C-S-t> :tabnew<CR>
:imap <C-S-t> <Esc>:tabnew<CR>

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
