inoremap jk <ESC>
let mapleader = " "

" Bash
" autocmd Filetype sh setlocal softtabstop=2 shiftwidth=2 expandtab
autocmd Filetype sh setlocal softtabstop=4 shiftwidth=4 expandtab

" Scripting
autocmd Filetype groovy setlocal softtabstop=2 shiftwidth=2 expandtab

" Java
autocmd Filetype java setlocal softtabstop=4 shiftwidth=4 expandtab

" HTML
autocmd Filetype html setlocal softtabstop=4 shiftwidth=4 expandtab

" xml
autocmd Filetype xml setlocal softtabstop=4 shiftwidth=4 expandtab

" NodeJS
autocmd Filetype javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

autocmd Filetype yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

set autoindent
set number
syntax enable
set belloff=all

" Quickly insert an empty new line without entering insert mode
" nnoremap o o<Esc>
" nnoremap O O<Esc>

" Visible whitespace
"  Mapping between character and visual replacement
"  In Vim session, activate with ':set list'
"   Stackoverflow source:
"  https://stackoverflow.com/questions/1675688/make-vim-show-all-white-spaces-as-a-character/29787362#29787362
" set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
" set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<
" set listchars=tab:>·,trail:~,extends:>,precedes:<
" set list

" Color schemes from https://github.com/rafi/awesome-vim-colorschemes (colors/*.vim) and installed in ~/.vim/colors/
" colorscheme solarized8

