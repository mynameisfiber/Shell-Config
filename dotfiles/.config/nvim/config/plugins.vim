let plug_install = 0
let autoload_plug_path = stdpath('config') . '/autoload/plug.vim'
if !filereadable(autoload_plug_path)
    silent exe '!curl -fL --create-dirs -o ' . autoload_plug_path . 
        \ ' https://raw.github.com/junegunn/vim-plug/master/plug.vim'
    execute 'source ' . fnameescape(autoload_plug_path)
    let plug_install = 1
endif
unlet autoload_plug_path

call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'mkitt/tabline.vim'
Plug 'altercation/vim-colors-solarized'

Plug 'roxma/vim-tmux-clipboard'

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'preservim/nerdcommenter'
Plug 'wellle/targets.vim'
Plug 'sjl/gundo.vim'
Plug 'terryma/vim-expand-region'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'preservim/tagbar'
Plug 'liuchengxu/vista.vim'

Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

Plug 'kamykn/spelunker.vim'

Plug 'ekickx/clipboard-image.nvim'

" Themes
Plug 'ellisonleao/gruvbox.nvim'

call plug#end()

if plug_install
    PlugInstall --sync
endif
unlet plug_install

