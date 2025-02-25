## Basics
`:set xxx` 	set the option "xxx".

1. Some options are (either use the long or the short option name):

   ```
   'ic' 'ignorecase'       ignore upper/lower case when searching
   'is' 'incsearch'        show partial matches for a search phrase
   'hls' 'hlsearch'        highlight all matching phrases
   ```

2. Prepend "no" to switch an option off: `:set noic`

## Example

```text
let mapleader=" "

" editor behaviors
syntax on
set number
set relativenumber
set cursorline
set showcmd
set wildmenu

" search and highlight
set ignorecase
set smartcase
set hlsearch
exec "nohlsearch"
set incrsearch

" command completion
set wildmenu
set wildmode=longest:list,full

" Working with long lines
set wrap " wrap text without inserting newlines

" key mapping
" noremap E 5j " noremap means non-recursive
" map s <nop>  " nop: no operation
map <esc> :noh <CR>
map R :source $MYVIMRC<CR>
" map <esc> :noh <CR>
noremap <LEADER><CR> :noh<cr>
noremap n nzz
noremap N Nzz

" tab and space configurations
set shiftwidth=4
set softtabstop=-1
set expandtab

" change cursor style based on mode
let

" scroll behaviors
set scrolloff=5 
```
