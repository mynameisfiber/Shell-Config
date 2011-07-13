"wrap
" set textwidth=77
" set wrap

"Allow moving to the end of the line in visual block mode
set virtualedit+=block

"tabs
 set softtabstop=2                                                                                                                                                        
 set shiftwidth=2                                                                                                                                                         
 set tabstop=2                                                                                                                                                            
 set expandtab 
 set smarttab
 set smartindent
 set autoindent

"" Folding {
"set foldenable " Turn on folding
"set foldmethod=syntax " Fold by syntax
""set foldopen=block,hor,mark,percent,quickfix,tag " what movements
"" open folds 
"function SimpleFoldText() " {
"return getline(v:foldstart).' '
"endfunction " }
"set foldtext=SimpleFoldText() " Custom fold text function 
"" (cleaner than default)
"" }

"Search config
set ignorecase
set incsearch

"Omni completion
:filetype on
:filetype plugin on
autocmd FileType python set omnifunc=pythoncomplete#Complete
set ofu=syntaxcomplete#Complete

"http://vim.wikia.com/wiki/VimTip1608
set tags+=~/.vim/tags/alltags
" build tags of your own project with Ctrl-F12
map <C-F12> :!ctags -R --sort=yes --c++-kinds=+lp --fields=+iaS --extra=+q .<CR>
" Opens tagbar with F2
map <F2> :TagbarToggle<CR>
" Open NERDTree with F3
map <F3> :NERDTreeToggle<CR>

" OmniCppComplete
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview
"Done

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
             let s .= (i == t ? ']' : ')') 
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
