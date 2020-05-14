" air-line

set cmdheight=1
set laststatus=2 " always open

let g:airline_powerline_fonts = 1
let g:airline_theme = 'solarized_flood'

" without this we get info in both bufferline and commandline
let g:bufferline_echo = 0

" Tabline enhancements
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#fnamemod = ':t'
