set mouse=a
set clipboard=unnamedplus
"set clipboard=unnamed
syntax on
set number
set ts=4 sw=4
"set wrap
set relativenumber

" Settings tabs to space
:set tabstop=4
:set shiftwidth=4
:set expandtab

" Show hidden files by default in nerdtree
let NERDTreeShowHidden=1
" Mirror tree between tabs

set ttimeoutlen=5

" Disable middle mouse
:map <MiddleMouse> <Nop>
:imap <MiddleMouse> <Nop>

" Causes d to somewhat not copy
"nnoremap d "_d
"vnoremap d "_d

" Specify a directory for plugins
" Install plugins:  :PlugInstall
call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'				 " Staus bar
"Plug 'https://github.com/neoclide/coc.nvim'  " Auto Completion
Plug 'https://github.com/preservim/nerdtree' ", {'on': ['NERDTreeMirror']}  NerdTree
Plug 'elkowar/yuck.vim'                      " Yuck syntax highlighting
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'dylanaraps/wal.vim'

Plug 'AlphaTechnolog/pywal.nvim', { 'as': 'pywal' }

Plug 'JuliaEditorSupport/julia-vim'
"Plug 'petertriho/nvim-scrollbar'
"Plug 'dstein64/nvim-scrollview', { 'branch': 'main' }

"scrol bar
Plug 'Xuyuanp/scrollbar.nvim'



" Initialize plugin system
call plug#end()

colorscheme wal


nnoremap <C-M> :NERDTreeToggle<CR>

" Map autocomplete to tab
" Fix
"inoremap <silent><expr> <tab> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<TAB>"

" Tmux tab names
"autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window " . expand("%"))
"autocmd VimLeave * call system("tmux setw automatic-rename")

" TMux tab names from https://vi.stackexchange.com/questions/3897/how-to-label-tmux-tabs-with-the-name-of-the-file-edited-in-vim
if exists('$TMUX')
  let windowName = system("tmux display-message -p '#W'")
  autocmd BufReadPost,FileReadPost,BufNewFile,BufEnter * call system("tmux rename-window 'vim(" . expand("%:t") . ")'")
  autocmd VimLeave * call system("tmux rename-window " . windowName)
endif


" Scrollbar
augroup ScrollbarInit
  autocmd!
  autocmd WinScrolled,VimResized,QuitPre * silent! lua require('scrollbar').show()
  autocmd WinEnter,FocusGained           * silent! lua require('scrollbar').show()
  autocmd WinLeave,BufLeave,BufWinLeave,FocusLost            * silent! lua require('scrollbar').clear()
augroup end



"Set cursor colors
":set termguicolors 
:hi Cursor guifg=lightgreen guibg=lightgreen
:hi Cursor2 guifg=red guibg=red
:set guicursor=n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor50


nnoremap <silent> <esc><esc> :nohlsearch<CR>
