" This script contains  a list of Vim-Plugged plugins 
source $HOME/.config/nvim/configs/plugins.vim
" This script contains general neovim settings 
source $HOME/.config/nvim/configs/main.vim
" This script contains plugin specific settings
source $HOME/.config/nvim/configs/plugin-settings.vim
" This script contains mappings
source $HOME/.config/nvim/configs/mappings.vim
"
" Figure out the system Python for Neovim.
if exists("$VIRTUAL_ENV")
    let g:python3_host_prog=substitute(system("which -a python3 | head -n2 | tail -n1"), "\n", '', 'g')
else
    let g:python3_host_prog=substitute(system("which python3"), "\n", '', 'g')
endif
