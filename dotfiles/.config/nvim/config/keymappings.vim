" New leader
let mapleader=","

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

" Help moving around buffers
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
nnoremap <C-t>     :tabnew<CR>
inoremap <C-t>     <Esc>:tabnew<CR>
noremap fj :tabnext<CR>
noremap fJ :tabprevious<CR>
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

" General remapings
nnoremap <Leader>w :w<CR>
map q: :q

"Reload all buffers with F7
nmap <F7> :bufdo e!<CR>

" Screw Ex-mode
nnoremap Q <nop>

" Leader-Leader to move to last location of insert-mode
nmap <leader><leader> `^

" Yank, comment, paste.
nmap <leader>Y yy,c<space>p
vmap <leader>Y ygv,c<space>P
nnoremap p :pu<CR>
nnoremap P :pu!<CR>

"In normal mode, press Space to toggle the current fold open/closed. However, if
"the cursor is not in a fold, move to the right (the default behavior). In
"addition, with the manual fold method, you can create a fold by visually
"selecting some lines, then pressing Space.
" http://vim.wikia.com/wiki/Folding
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf
