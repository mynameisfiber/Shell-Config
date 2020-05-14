" change ctrlp to be invoked like command-t
let g:ctrlp_map = '<leader>t'

" ignore big folders
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.git|__pycache__|data|node_modules)$',
  \ 'file': '\v\.(exe|so|dll|pyc)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

" speed up ctrlp as per:
" https://medium.com/a-tiny-piece-of-vim/making-ctrlp-vim-load-100x-faster-7a722fae7df6#.oh6lf21r6
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" ctlrp root path uses git
let g:ctrlp_working_path_mode = 'ra'

