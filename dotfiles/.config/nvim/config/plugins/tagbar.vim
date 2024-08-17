" Opens tagbar with F2
"map <F2> :TagbarToggle<CR>

" map F1 to escape because I keep hitting it with this new keyboard
map <F1> <Esc>
imap <F1> <Esc>

" general ctypes location
let g:tagbar_ctags_bin = '/usr/bin/ctags'

" Typescript definition from:
" https://github.com/preservim/tagbar/wiki#exuberant-ctags-vanilla
let g:tagbar_type_typescript = {
  \ 'ctagstype': 'typescript',
  \ 'kinds': [
    \ 'c:classes',
    \ 'n:modules',
    \ 'f:functions',
    \ 'v:variables',
    \ 'v:varlambdas',
    \ 'm:members',
    \ 'i:interfaces',
    \ 'e:enums',
  \ ]
\ }
