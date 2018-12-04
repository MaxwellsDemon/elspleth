" Bash (at least I like tabs when not collaborating)
autocmd Filetype sh setlocal tabstop=2 shiftwidth=2

" Java
autocmd Filetype java setlocal softtabstop=4 shiftwidth=4 expandtab
autocmd Filetype groovy setlocal softtabstop=4 shiftwidth=4 expandtab

" NodeJS
autocmd Filetype javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

autocmd Filetype yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

set smartindent
set number
syntax enable
set belloff=all

" Visible whitespace
"	Mapping between character and visual replacement
"	In Vim session, activate with ':set list'
" 	Stackoverflow source:
"	https://stackoverflow.com/questions/1675688/make-vim-show-all-white-spaces-as-a-character/29787362#29787362
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

" Color schemes from https://github.com/rafi/awesome-vim-colorschemes (colors/*.vim) and installed in ~/.vim/colors/
colorscheme solarized8

