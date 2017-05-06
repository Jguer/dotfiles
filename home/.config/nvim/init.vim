" vim:fdm=marker foldlevel=0
" System {{{
:set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
set termguicolors
set clipboard+=unnamedplus
set mouse=a
let mapleader = ","
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
  let g:neomake_open_list = 2
  let g:neomake_c_gcc_maker = {
        \ 'exe': 'gcc',
        \ 'args': ['-Wall', '-Iinclude', '-Wextra', '-pedantic'],
        \ }

  autocmd! BufWritePost * Neomake
  nmap <Leader>j :lnext<CR>
  nmap <Leader>k :lprev<CR>
augroup END
" }}}

" Neomake {{{
augroup neomake_cfg
  autocmd!
  nmap <silent> <F10> :TagbarToggle<CR>
  noremap <Leader>m :TagbarToggle<CR>
  let g:tagbar_autofocus = 1
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

" Vim Go {{{
augroup vim_go_cfg
  autocmd!
  let g:go_fmt_command = "goimports"
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

" lightline {{{
augroup lightline_cfg
  autocmd!
  let g:lightline={}
  let g:lightline.tab_component_function = { 'filename': 'MyTabFilename',}

  function! MyTabFilename(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let bufnum = buflist[winnr - 1]
    let bufname = expand('#'.bufnum.':t')
    let buffullname = expand('#'.bufnum.':p')
    let buffullnames = []
    let bufnames = []
    for i in range(1, tabpagenr('$'))
      if i != a:n
        let num = tabpagebuflist(i)[tabpagewinnr(i) - 1]
        call add(buffullnames, expand('#' . num . ':p'))
        call add(bufnames, expand('#' . num . ':t'))
      endif
    endfor
    let i = index(bufnames, bufname)
    if strlen(bufname) && i >= 0 && buffullnames[i] != buffullname
      return substitute(buffullname, '.*/\([^/]\+/\)', '\1', '')
    else
      return strlen(bufname) ? bufname : '[No Name]'
    endif
  endfunction

  silent! let g:lightline.colorscheme = 'molokai'
augroup END
" }}}

" }}}

" Settings {{{
set background=dark
let g:enable_bold_font=1

set number
set relativenumber "Relative number line
set cursorline
set showcmd "Show command in bottom bar
set showmatch "Highlight matching brackets
set noshowmode " Don't show the current mode (airline.vim takes care of us)

set expandtab    " Use Spaces
set nowrap
set shiftwidth=2 " Tab Size
set tabstop=2    " Tab Size
set ignorecase   " Ignore case when searching...
set smartcase    " ...unless we type a capital
set wildignore+=*.jpg,*.jpeg,*.gif,*.png,*.gif,*.psd,*.o,*.obj,*.min.js
set showtabline=2 " Always show tab bar

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_winsize = 30

augroup vimrc
  au BufReadPre * setlocal foldmethod=indent
  au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
augroup END
set foldcolumn=0
set foldlevelstart=200
set foldlevel=200  " disable auto folding
nnoremap <silent> <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
vnoremap <silent> <space> zf

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
nnoremap <silent> <S-h> :wincmd h<CR>
nnoremap <silent> <S-l> :wincmd l<CR>

nnoremap <silent> <F8> :Lexplore<CR>
noremap <Leader>n :Lexplore<CR>

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
autocmd FileType python,c,cpp,lua,go set tabstop=4|set shiftwidth=4|set expandtab

set autowriteall "Auto save when moving tab
set autochdir
" }}}

" Plugin Load {{{
call plug#begin('~/.local/share/nvim/plugged')
" .-. Auto Completion .-.
Plug 'neomake/neomake', { 'on': 'Neomake' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-go', { 'do': 'go get -u github.com/nsf/gocode & make', 'for': 'go'}
Plug 'Shougo/neosnippet' | Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/neoinclude.vim'

" .-. Appearance .-.
Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'

" .-. Util .-.
Plug 'easymotion/vim-easymotion'
Plug 'dietsche/vim-lastplace'
Plug 'majutsushi/tagbar'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'ntpeters/vim-better-whitespace'

" .-. Syntax .-.
Plug 'sheerun/vim-polyglot'
Plug 'fatih/vim-go'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
call plug#end()

" Gruvbox {{{
augroup gruvbox_cfg
  autocmd!
  let g:gruvbox_contrast_dark='hard'
  silent! colorscheme gruvbox
augroup END
" }}}

" }}}
