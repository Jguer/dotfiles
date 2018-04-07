" vim:fdm=marker foldlevel=0

" Settings {{{

set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
set termguicolors
set clipboard=unnamedplus
set mouse=a
set noswapfile
syntax on "Enable syntax
filetype plugin indent on
set autowriteall ""automatically save any changes made to the buffer before it is hidden.
let mapleader = ","
set hidden " Allow background buffers without saving
set spell spelllang=en_us
set splitright " Split to right by default

set number
set relativenumber "Relative number line
set cursorline
set showcmd "Show command in bottom bar
set showmatch "Highlight matching brackets
set noshowmode " Don't show the current mode (airline.vim takes care of us)

set expandtab    " Use Spaces
set nowrap
set tabstop=4 softtabstop=4 shiftwidth=4

set ignorecase   " Ignore case when searching...
set smartcase    " ...unless we type a capital
set wildignore+=*.jpg,*.jpeg,*.gif,*.png,*.gif,*.psd,*.o,*.obj,*.min.js
set showtabline=2 " Always show tab bar

"" Text Wrapping
set textwidth=79
set colorcolumn=80
set nowrap

let g:netrw_liststyle = 1 " Detail View
let g:netrw_sizestyle = "H" " Human-readable file sizes
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+' " hide dotfiles
let g:netrw_hide = 1 " hide dotfiles by default
let g:netrw_banner = 0 " Turn off banner
""" Explore in vertical split
let g:netrw_winsize = 30

set foldmethod=indent
set foldlevel=20
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf
" }}}

" Plug Setup {{{
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | so %
endif
" }}}

" Plugins {{{
" Tagbar {{{
augroup tagbar_cfg
  autocmd!
  nmap <silent> <F10> :TagbarToggle<CR>
  noremap <Leader>m :TagbarToggle<CR>
  let g:tagbar_autofocus = 1
augroup END
" }}}

" Ale {{{
augroup ale_cfg
  autocmd!
  nmap <silent> <C-k> <Plug>(ale_previous_wrap)
  nmap <silent> <C-j> <Plug>(ale_next_wrap)
  let g:ale_set_loclist = 1
  let g:ale_set_quickfix = 1
  let g:ale_lint_on_text_changed = "normal"
augroup END
" }}}

" Deoplete {{{
augroup deoplete_cfg
  autocmd!
  let g:deoplete#enable_at_startup = 1
  inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
augroup END
" }}}

" Neosnippet {{{
augroup neosnippet_cfg
  autocmd!
  imap <C-k> <Plug>(neosnippet_expand_or_jump)
  smap <C-k> <Plug>(neosnippet_expand_or_jump)
  xmap <C-k> <Plug>(neosnippet_expand_target)
  imap <expr><TAB>
        \ pumvisible() ? "\<C-n>" :
        \ neosnippet#expandable_or_jumpable() ?
        \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
  smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
        \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

  " .-. Vim Easy Align .-.
  xmap ga <Plug>(EasyAlign)
  nmap ga <Plug>(EasyAlign)
augroup END
" }}}

" NerdTree {{{
augroup nerdtree_cfg
  autocmd!
  nnoremap <silent> <F8> :NERDTreeToggle<CR>
  noremap <Leader>n :NERDTreeToggle<CR>
augroup END
" }}}

" Vim Go {{{
augroup vim_go_cfg
  autocmd!
  let g:go_highlight_functions = 1
  let g:go_highlight_methods = 1
  let g:go_highlight_types = 1
  let g:go_highlight_fields = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_extra_types = 1
augroup END
" }}}

" Better Whitespace {{{
augroup whitespace_cfg
  autocmd!
  let g:better_whitespace_filetypes_blacklist=['markdown', 'diff', 'gitcommit', 'unite', 'qf', 'help']
  autocmd BufEnter * EnableStripWhitespaceOnSave
augroup END
" }}}

" Rainbow Parentheses {{{
augroup rainbow_cfg
  autocmd!
  au VimEnter * RainbowParenthesesToggle
  au Syntax * RainbowParenthesesLoadRound
  au Syntax * RainbowParenthesesLoadSquare
  au Syntax * RainbowParenthesesLoadBraces
augroup END
" }}}

" Airline {{{
augroup airline_cfg
  autocmd!
  let g:airline#extensions#tabline#enabled = 1
  let g:airline_highlighting_cache = 1
  let g:airline_powerline_fonts = 1
  let g:airline_theme='base16_google'
augroup END
" }}}

" NeoFormat {{{
augroup neoformat_cfg
  autocmd!
  let g:neoformat_basic_format_align = 0
  let g:neoformat_basic_format_retab = 1
  let g:neoformat_basic_format_trim = 1
  let g:neoformat_run_all_formatters = 1
  let g:neoformat_only_msg_on_error = 1
augroup END

augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END
" }}}
" }}}

" Keybindings {{{

nnoremap j gj
nnoremap k gk
vnoremap <C-c> "+yi
vnoremap <C-x> "+c
vnoremap <C-v> c<ESC>"+`]p
inoremap <C-v> <ESC>"+pa
nnoremap <c-p> "+p
nnoremap <c-P> "+P
noremap Y y$
nnoremap <C-L> :nohl<CR><C-L>
noremap <C-T> :tabnew<CR>
noremap <Leader>t :tabnew<CR>
nnoremap <Leader>k :<C-U>tabnext<CR>
nnoremap <A-k> :<C-U>tabnext<CR>
nnoremap <Leader>j :<C-U>tabprevious<CR>
nnoremap <A-j> :<C-U>tabprevious<CR>
nnoremap <silent> <S-k> :wincmd k<CR>
nnoremap <silent> <S-j> :wincmd j<CR>
nnoremap <silent> <A-h> :wincmd h<CR>
nnoremap <silent> <A-l> :wincmd l<CR>


cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

nnoremap Q <nop>
" }}}

" Auto Commands {{{
au FocusLost,WinLeave * :silent! noautocmd w
au FocusGained,BufEnter * :silent! !
au BufNewFile,BufRead *.h set filetype=c
au FileType python,c,cpp,lua,go set ts=4|set sw=4|set sts=4
" check for and load file changes
autocmd WinEnter,BufWinEnter,FocusGained * checktime

" convert spaces to tabs when reading file
autocmd! bufreadpost * set noexpandtab | retab! 4

" convert tabs to spaces before writing file
autocmd! bufwritepre * set expandtab | retab! 4

" convert spaces to tabs after writing file (to show guides again)
autocmd! bufwritepost * set noexpandtab | retab! 4i

set autowriteall "Auto save when moving tab
set autochdir
set autoread
" }}}

" Plugin Load {{{
call plug#begin('~/.local/share/nvim/plugged')
" .-. Auto Completion .-.
Plug 'w0rp/ale'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/deoplete-clangx'
Plug 'Shougo/neoinclude.vim'
Plug 'zchee/deoplete-go', { 'do': 'go get -u github.com/nsf/gocode & make', 'for': 'go'}
Plug 'Shougo/neosnippet' | Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/neoinclude.vim'

" .-. Appearance .-.
Plug 'vim-airline/vim-airline'
Plug 'kien/rainbow_parentheses.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'vim-airline/vim-airline-themes'

" .-. Util .-.
Plug 'scrooloose/nerdtree'
Plug 'easymotion/vim-easymotion'
Plug 'dietsche/vim-lastplace'
Plug 'majutsushi/tagbar'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'ntpeters/vim-better-whitespace'
Plug 'sbdchd/neoformat'

" .-. Syntax .-.
Plug 'sheerun/vim-polyglot'
Plug 'fatih/vim-go'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
call plug#end()
" }}}

" Colorscheme {{{
augroup colorscheme_cfg
  autocmd!
  set background=dark
  let g:enable_bold_font=1
  let g:solarized_use16 = 1
  let g:solarized_termtrans= 1
  colorscheme solarized8
augroup END
" }}}
