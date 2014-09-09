" Basic settings and reduce vi compatibility
syntax enable
filetype on
filetype indent on
filetype plugin on
set encoding=utf-8
set modeline
set modelines=1
set nocompatible

" General
let g:netrw_dirhistmax=0  " disable netrw history
set autoindent
set bs=2  " backspace should work across lines
set completeopt=menuone,menu,longest,preview
set hidden
set hlsearch
set incsearch
set linebreak " wrap lines at convenient locations
set list
set listchars=tab:▸\ ,extends:❯,precedes:❮
set magic
set novisualbell
set number
set ruler
set showcmd
set showmatch
set smartindent
set splitbelow
set splitright
set t_Co=256
set title
set ttyfast
set tw=0
set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.pyc,*.class,*.so           " compiled files
set wildignore+=ve/**                            " virtualenv folders
set wildignore+=__pycache__                      " Python 3
set wildignore+=.*.sw[opq]                       " vim swap files
set wildmenu
set wildmode=list:longest

" Indentation
set backspace=indent,eol,start
set expandtab
set smarttab
set softtabstop=2
set sw=2
set tabstop=2

" Setup NeoBundle
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Let NeoBundle check its packages.
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'bling/vim-airline'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'mustache/vim-mustache-handlebars'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'tpope/vim-fugitive'
call neobundle#end()
filetype plugin indent on
NeoBundleCheck

" Following taken from http://items.sjbach.com/319/configuring-vim-right
runtime macros/matchit.vim

" Searching
set ignorecase
set smartcase
nnoremap * *<c-o> " Don't move on *

" Cursor moves through visual lines, not real lines
map <Up> gk
map <Down> gj

" http://vim.wikia.com/wiki/Highlight_unwanted_spaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Clean whitespace
map <leader>W  :%s/\s\+$//<cr>:let @/=''<CR>

" C++11
autocmd BufNewFile,BufRead *.h,*.hpp,*.hh,*.hxx,*.cc*,.cpp,*.cxx set syntax=cpp11
" LESS CSS
autocmd BufNewFile,BufRead *.less set filetype=less
" Ragel
autocmd BufNewFile,BufRead *.rl set syntax=ragel

" Colour scheme
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1
let g:solarized_termcolors=256
let g:solarized_contrast="high"
let g:solarized_visibility="high"
colorscheme solarized

" NERDcommenter
nmap <C-c> <plug>NERDCommenterToggle<CR>
vmap <C-c> <plug>NERDCommenterToggle<CR>

" Syntastic
let g:syntastic_python_flake8_args = ' --ignore=E111,E221,E226,E501 '
let g:syntastic_cpp_include_dirs = ['src/include']
let g:syntastic_cpp_compiler_options = ' -W -Wall -Wextra -pedantic std=c++11 '
let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set statusline+=%{fugitive#statusline()}
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" ctrlp
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn$\|ve$\|ve-\|doc/html',
  \ 'file': '\.o$\|\.so$\|\.dll$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

" airline
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Colourful LISP brackets
let g:lisp_rainbow=1
let g:mode=1

" ctags
set tags=./tags;/

" Switch between .h / _impl.h / .cc / .py / .js / _test.* / with ,h ,i ,c ,p ,j ,u
let pattern = '\(\(_test\)\?\.\(cc\|js\|py\)\|\(_impl\)\?\.h\)$'
nmap ,c :e <C-R>=substitute(expand("%"), pattern, ".cc", "")<CR><CR>
nmap ,h :e <C-R>=substitute(expand("%"), pattern, ".h", "")<CR><CR>
nmap ,i :e <C-R>=substitute(expand("%"), pattern, "_impl.h", "")<CR><CR>
nmap ,u :e <C-R>=substitute(expand("%"), pattern, "_test.", "") . substitute(expand("%:e"), "h", "cc", "")<CR><CR>
nmap ,p :e <C-R>=substitute(expand("%"), pattern, ".py", "")<CR><CR>
nmap ,j :e <C-R>=substitute(expand("%"), pattern, ".js", "")<CR><CR>
