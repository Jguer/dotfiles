"*****************************************************************************
" :.: Plug Setup :.:
"*****************************************************************************

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

"*****************************************************************************
" :.: Plug Init :.:
"*****************************************************************************

call plug#begin('~/.config/nvim/plugged/')

" .-. Auto Completion .-.
Plug 'neomake/neomake', { 'on': 'Neomake' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-go', { 'do': 'make'}

" .-. Appearance .-.
Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'

" .-. Util .-.
Plug 'dietsche/vim-lastplace'
Plug 'majutsushi/tagbar'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary' " gcc or gc visual

" .-. Syntax .-.
Plug 'sheerun/vim-polyglot'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries'}
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }

" .-. Snippets .-.
Plug 'Shougo/neosnippet' | Plug 'Shougo/neosnippet-snippets'

call plug#end()

"*****************************************************************************
" :.: Appearance :.:
"*****************************************************************************

let $GOPATH = "/home/jguer/Go"
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
set termguicolors
set background=dark
try
  colorscheme gruvbox
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme ron
endtry

set number "Absolute number line
set relativenumber "Relative number line
set ruler " line and column number of the cursor position
set cursorline "Highlight current line
set showcmd "Show command in bottom bar
set showmatch "Highlight matching brackets

set expandtab "Use Spaces
set nowrap
set shiftwidth=2 "Tab Size
set tabstop=2 "Tab Size

set splitbelow  " Horizontal split below current.
set splitright  " Vertical split to right of current.

set clipboard+=unnamedplus

"*****************************************************************************
" :.: General Settings :.:
"*****************************************************************************

set noswapfile
set nobackup
set nowb

set wildignore=.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif

" .-. Searching .-.
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital

" .-. Folding .-.
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " fold based on indent level
let g:sh_fold_enabled=1

" .-. File Explorer .-.
let g:netrw_banner = 0
let g:netrw_liststyle=3
let g:netrw_winsize = 30

"*****************************************************************************
" :.: General keybindings :.:
"*****************************************************************************

let mapleader = ","

" Space open/closes folds
nnoremap <space> za
vnoremap <space> zf

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" Copy Paste improvements
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+`]p
imap <C-v> <ESC>"+pa
nnoremap <c-p> "+p
nnoremap <c-P> "+P

" Copy until EOL
map Y y$
nnoremap <C-L> :nohl<CR><C-L>

" New tab
map <C-T> :tabnew<CR>

" Shift k is next tab
noremap <A-k> :<C-U>tabnext<CR>
cnoremap <A-k> <C-C>:tabnext<CR>
" Shift j is previous tab
noremap <A-j> :<C-U>tabprevious<CR>
cnoremap <A-j> <C-C>:tabprevious<CR>

"Alt-Arrow Navigation
nmap <silent> <S-k> :wincmd k<CR>
nmap <silent> <S-j> :wincmd j<CR>
nmap <silent> <S-h> :wincmd h<CR>
nmap <silent> <S-l> :wincmd l<CR>

"Lexplore
nmap <silent> <F8> :Lexplore<CR>
map <Leader>n :Lexplore<CR>

"*****************************************************************************
"" Abbreviations
"*****************************************************************************

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

"*****************************************************************************
" :.: Plugin Config and Keybindings :.:
"*****************************************************************************

let g:polyglot_disabled = ['markdown']

" .-. Airline .-.
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'component': {
      \   'readonly': '%{&readonly?"x":""}',
      \ },
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
      \ }

" .-. Tagbar .-.
nmap <silent> <F10> :TagbarToggle<CR>
map <Leader>m :TagbarToggle<CR>
let g:tagbar_autofocus = 1

" .-. Neomake .-.
let g:neomake_open_list = 2
let g:neomake_go_enabled_makers = ['go', 'golint', 'govet']
let g:neomake_sh_enabled_makers = ['sh', 'shellcheck']
autocmd! BufWritePost * Neomake
nmap <Leader>j :lnext<CR>
nmap <Leader>k :lprev<CR>

" .-. Vim-go .-.
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"
let g:go_metalinter_autosave = 1

" .-. Deoplete .-.
let g:deoplete#enable_at_startup = 1
" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" .-. Neosnippet .-.
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

imap <expr><TAB>
 \ pumvisible() ? "\<C-n>" :
 \ neosnippet#expandable_or_jumpable() ?
 \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" .-. Vim Easy Align .-.
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" .-. Vim-Go .-.
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
au FileType go nmap <Leader>rs <Plug>(go-run-split)

"*****************************************************************************
" :.: Auto Commands :.:
"*****************************************************************************

autocmd BufWritePre * :call StripTrailingWhitespace()
function! StripTrailingWhitespace()
  if !&binary && &filetype != 'diff' && &filetype != 'markdown'
    normal mz
    normal Hmy
    if &filetype == 'mail'
" Preserve space after e-mail signature separator
      %s/\(^--\)\@<!\s\+$//e
    else
      %s/\s\+$//e
    endif
    normal 'yz<Enter>
    normal `z
  endif
endfunction

au BufNewFile,BufRead *.h set filetype=c
autocmd FileType python set tabstop=4|set shiftwidth=4|set expandtab
autocmd FileType c set tabstop=4|set shiftwidth=4|set expandtab
autocmd FileType cpp set tabstop=4|set shiftwidth=4|set expandtab
autocmd FileType lua set tabstop=4|set shiftwidth=4|set expandtab
autocmd FileType go set tabstop=4|set shiftwidth=4|set expandtab
au FocusLost * silent! wa

set autowriteall "Auto save when moving tab
set autochdir
