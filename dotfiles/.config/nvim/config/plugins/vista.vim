"let g:vista_default_executive = "coc"

" Opens tagbar with F2
map <F2> :Vista!!<CR>

" map F1 to escape because I keep hitting it with this new keyboard
map <F1> <Esc>
imap <F1> <Esc>

function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

set statusline+=%{NearestMethodOrFunction()}

" By default vista.vim never run if you don't call it explicitly.
"
" If you want to show the nearest function in your statusline automatically,
" you can add the following line to your vimrc
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()
