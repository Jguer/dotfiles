" vim:fdm=marker foldlevel=0

" Settings {{{

syntax on "Enable syntax
filetype plugin indent on
" set termguicolors
set clipboard=unnamedplus
set mouse=a
set noswapfile
set autowriteall ""automatically save any changes made to the buffer before it is hidden.
let mapleader = ","
set hidden " Allow background buffers without saving
" set spell spelllang=en_us

set number
set relativenumber "Relative number line
set cursorline
set showcmd "Show command in bottom bar
set showmatch "Highlight matching brackets
set noshowmode " Don't show the current mode (airline.vim takes care of us)

set expandtab    " Use Spaces
set tabstop=2 softtabstop=2 shiftwidth=2

set ignorecase   " Ignore case when searching...
set smartcase    " ...unless we type a capital
set wildignore+=*.jpg,*.jpeg,*.gif,*.png,*.gif,*.psd,*.o,*.obj,*.min.js
set showtabline=2 " Always show tab bar

" Text Wrapping {{{
set textwidth=79
set colorcolumn=80
set nowrap
"}}}

" Folding {{{
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf
" }}}
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
  let g:ale_set_loclist=1
  let g:ale_sign_error=' ●'
  let g:ale_sign_warning=' ●'
  let g:ale_lint_on_text_changed = "normal"
  let g:ale_lint_on_enter=1
  let g:ale_lint_on_save=1
  let g:ale_lint_on_filetype_changed=1
  let g:ale_set_highlights=1
  let g:ale_set_signs=1
  let g:ale_c_clang_options = '-std=gnu11 -Wall -Wextra'
  let g:ale_c_gcc_options = '-std=gnu11 -Wall -Wextra'
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

" LightLine {{{
augroup lightline_cfg
  autocmd!
  let g:lightline = {
        \ 'colorscheme': 'snazzy',
        \ }
augroup END
" }}}

" GitGutter {{{
augroup gitgutter_cfg
  autocmd!
  let g:gitgutter_sign_added='┃'
  let g:gitgutter_sign_modified='┃'
  let g:gitgutter_sign_removed='◢'
  let g:gitgutter_sign_removed_first_line='◥'
  let g:gitgutter_sign_modified_removed='◢'
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
au FileType python,c,cpp,go set ts=4|set sw=4|set sts=4
" check for and load file changes
autocmd WinEnter,BufWinEnter,FocusGained * checktime

set autowriteall "Auto save when moving tab
set autochdir
set autoread
" }}}

" Plugin Load {{{
call plug#begin('~/.local/share/nvim/plugged')
" .-. Auto Completion .-.
Plug 'w0rp/ale'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/deoplete-clangx', { 'for': 'C' }
Plug 'Shougo/neoinclude.vim'
Plug 'zchee/deoplete-go', { 'do': 'go get -u github.com/nsf/gocode & make', 'for': 'go'}
Plug 'Shougo/neosnippet' | Plug 'Shougo/neosnippet-snippets'

" .-. Appearance .-.
Plug 'itchyny/lightline.vim'
Plug 'kien/rainbow_parentheses.vim'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0ng/vim-hybrid'
Plug 'connorholyday/vim-snazzy'
Plug 'sonph/onehalf', {'rtp': 'vim/'}

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
Plug 'vim-scripts/DoxygenToolkit.vim', { 'for': 'C' }

" .-. Syntax .-.
Plug 'sheerun/vim-polyglot'
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
call plug#end()
" }}}

" Colorscheme {{{
augroup colorscheme_cfg
  autocmd!
  colorscheme snazzy
augroup END
" }}}
