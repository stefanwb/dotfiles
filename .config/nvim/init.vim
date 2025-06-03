"G Path to python3 bin
let g:python3_host_prog = '/usr/bin/python3'

" Plugins - install vim-plug then load them
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent execute '!curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

"Plug 'airblade/vim-gitgutter'
"Plug 'dense-analysis/ale'
"Plug 'easymotion/vim-easymotion'
"Plug 'ekalinin/Dockerfile.vim'
"Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
"Plug 'godlygeek/tabular'
"Plug 'mhinz/vim-startify'
"Plug 'raimondi/delimitmate'
"Plug 'sirver/ultisnips' | Plug 'honza/vim-snippets'
"Plug 'sonph/onehalf', { 'rtp': 'vim' }
"Plug 'tmux-plugins/vim-tmux-focus-events'
"Plug 'tpope/vim-fugitive'
"Plug 'tpope/vim-repeat'
"Plug 'tpope/vim-surround'
"Plug 'wellle/tmux-complete.vim'
"Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'make release'} " TODO find solution
Plug 'hashivim/vim-hashicorp-tools'
Plug 'valloric/youcompleteme'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'github/copilot.vim'
Plug 'neovim/nvim-lspconfig'
"Plug 'CoderCookE/vim-chatgpt'
call plug#end()


" lspconfig
lua << EOF
-- Pyright for jump-to-definition
require('lspconfig').pyright.setup {
  on_attach = function(client, bufnr)
    local opts = { noremap=true, silent=true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
    })
  end,
}

-- Ruff for linting
require('lspconfig').ruff.setup {
  on_attach = function(client, bufnr)
    local opts = { noremap=true, silent=true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  end,
}
EOF


"
" Neovim settings
"

" General
filetype plugin indent on       " Automatically detect file types.
let mapleader = ','             " Override default leader key
set autoread                    " Automatically reload files when changed outside vim
set backspace=indent,eol,start  " Backspace for dummies
"set cursorline                  " Highlight current line
set inccommand=nosplit          " Enable live substitutions
set noshowmode                  " We show the current mode with airline
"set number                      " Show the absolute line number the cursor is on
set showmatch                   " Show matching brackets/parenthesis
set scrolloff=5                 " Show at least 5 lines above or below the cursor
syntax enable                   " Enable syntax highlighting
set cuc                         " Enable vertical column

autocmd FileType json setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab


"" More intuitive arrow mappings for wildmenu
"" https://vi.stackexchange.com/questions/22627/switching-arrow-key-mappings-for-wildmenu-tab-completion
"set wildcharm=<C-Z>
"let open_re = '\(e\%[dit]\|\%[v]new\) '
"cnoremap <expr> <up> getcmdline() =~" open_re && wildmenumode() ? "\<left>" : "\<up>"
"cnoremap <expr> <down> getcmdline() =~" open_re && wildmenumode() ? "\<right>" : "\<down>"
"cnoremap <expr> <left> getcmdline() =~" open_re && wildmenumode() ? "\<up>" : "\<left>"
"cnoremap <expr> <right> getcmdline() =~" open_re && wildmenumode() ? " \<bs>\<C-Z>" : "\<right>"

"" Clipboard
"if has('clipboard')
"    if has('unnamedplus') " When possible use + register for copy-paste
"        set clipboard=unnamed,unnamedplus
"    else " On mac and Windows, use * register for copy-paste
"        set clipboard=unnamed
"    endif
"endif

"if exists('+termguicolors')
"  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
"  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
"  set termguicolors
"endif

" Search
set hlsearch                    " Highlight search terms
set incsearch                   " Find the next match as we type the search
set ignorecase                  " Ignore case when searching...
set smartcase                   " ...unless we type a capital

" Formatting
set nowrap                      " Do not wrap long lines
set autoindent                  " Indent at the same level of the previous line
set shiftwidth=4                " Use indents of 4 spaces
set expandtab                   " Tabs are spaces, not tabs
set tabstop=4                   " An indentation every four columns
set softtabstop=4               " Let backspace delete indent
set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current

"
" Plugin settings
"

"" Airline
"let g:airline_powerline_fonts = 1
"
"" Ale
"let g:ale_set_signs = 1
"let g:ale_sign_column_always = 1
"let g:ale_sign_error = '✖'
"let g:ale_sign_warning = '⚠'
"highlight clear ALEErrorSign
"highlight clear ALEWarningSign
"nmap <silent> <C-k> <Plug>(ale_previous_wrap)
"nmap <silent> <C-j> <Plug>(ale_next_wrap)
"
"" GoLang
"let g:go_fmt_command = "goimports"
"let g:go_highlight_build_constraints = 1
"let g:go_highlight_functions = 1
"let g:go_highlight_methods = 1
"let g:go_highlight_operators = 1
"let g:go_highlight_structs = 1
"au FileType go nmap <Leader>s <Plug>(go-implements)
"au FileType go nmap <Leader>i <Plug>(go-info)
"au FileType go nmap <Leader>e <Plug>(go-rename)
"au FileType go nmap <leader>r <Plug>(go-run)
"au FileType go nmap <leader>b <Plug>(go-build)
"au FileType go nmap <leader>t <Plug>(go-test)
"au FileType go nmap <Leader>gd <Plug>(go-doc)
"au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
"au FileType go nmap <leader>co <Plug>(go-coverage)

" Hashicorp vim plugins
let g:terraform_align=1
let g:terraform_commentstring='//%s'
let g:terraform_fmt_on_save=1

let g:LanguageClient_serverCommands = {
    \ 'terraform': ['terraform-ls', 'serve'],
    \ }

"if has('conceal')
"  set conceallevel=2 concealcursor=niv
"endif
"
"let g:UltiSnipsExpandTrigger = "<C-j>"
"let g:UltiSnipsJumpForwardTrigger = "<tab>"
"let g:UltiSnipsJumpBackwardTrigger = "<S-tab>"

map <F12> <C-w>\|
"map <BS> :echo 'You pressed backspace!'<CR>
"map <Del> :echo 'You pressed Delete!'<CR>
"inoremap <C-Del> x


" OpenAI - Github Copilot
" let g:chat_gpt_key='sk-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
" let g:chat_gpt_max_tokens=2000

colorscheme slate

" Mouse
set mouse=a                     " Automatically enable mouse usage
set mousehide                   " Hide the mouse cursor while typing
