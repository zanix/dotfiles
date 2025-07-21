" Use vim settings, rather then vi settings (much better!)
" This must be first, because it changes other options as a side effect.
set nocompatible

" Allow saving of files as sudo when I forget to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

set showmode                    " always show what mode we're currently editing in
filetype plugin on              " use the file type plugins

set title                       " change the terminal's title
set visualbell                  " don't beep
set noerrorbells                " don't beep
set showcmd                     " show (partial) command in the last line of the screen
                                "    this also shows visual selection info
set nomodeline                  " disable mode lines (security measure)

set wildmenu                    " make tab completion for files/buffers act like bash
set wildmode=list:full          " show a list when pressing tab and complete
                                "    first full match
set wildignore=*.swp,*.bak,*.pyc,*.class

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set history=1000                " keep 100 lines of history
set undolevels=1000             " use many mucho levels of undo

if v:version >= 730
    set undofile                " keep a persistent backup file
    set undodir=~/.vim/.undo
endif

set nobackup                    " do not keep backup files, it's 70's style cluttering
set noswapfile                  " do not write annoying intermediate swap files,
                                "    who did ever restore from swap files anyway?
set directory=~/.vim/.tmp
                                " store swap files in one of these directories
                                "    (in case swapfile is ever turned on)

" Create directories if they don't exist
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

set viminfo='20,\"80            " read/write a .viminfo file, don't store more
                                "    than 80 lines of registers

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Searching and matching
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set ignorecase                  " ignore case when searching
set smartcase                   " if search contains uppercase characters, turn off ignorecase
set hlsearch                    " highlight search terms
set incsearch                   " show search matches as you type
set showmatch                   " show matching parenthesis
set magic                       " use magic characters in search patterns

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editor Layout and colors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Fix background color erase
"http://sunaku.github.io/vim-256color-bce.html
set t_ut=
set tm=500

set t_Co=256                    " sets 256 color mode
syntax on                       " enable syntax highlighting

set background=dark             " shell is usally dark

set number                      " show line numbers
set ruler                       " show the cursor position
set lazyredraw                  " don't update the display while executing macros
set encoding=utf8               " set utf8 as standard encoding
set termencoding=utf-8          " set terminal encoding to utf8
set laststatus=2                " always show a status line in, even if there is only one window
" set cmdheight=1                 " use a status bar that is 1 rows high

set ffs=unix,dos,mac            " use Unix as the standard file type

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab, and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set noexpandtab                 " don't expand tabs to spaces by default
set smarttab                    " insert tabs on the start of a line according to shiftwidth, not tabstop
set shiftround                  " use multiples of shiftwidth when indenting with '<' and '>'

set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set whichwrap+=<,>,[,]          " allow arrowing over line breaks

set tabstop=2                   " 1 tab == 2 spaces
set shiftwidth=2                " number of spaces to use for autoindenting
set softtabstop=2               " when hitting <BS>, pretend like a tab is removed, even if spaces

set lbr                         " Use line breaks instead of hard line breaks
set tw=500                      " Set text width to 500 characters

set autoindent                  " auto indent
set smartindent                 " smart indent
set copyindent                  " copy the previous indentation on autoindenting
" set wrap                        " wrap lines

" white space characters
set nolist
set listchars=eol:$,tab:.\ ,trail:·,extends:>,precedes:<,nbsp:_
highlight SpecialKey term=standout ctermfg=darkgray guifg=darkgray

" display white space characters with F3
nnoremap <F3> :set list! list?<CR>

" Trailing whitespace
" Only shown when not in insert mode so I don't go insane.
augroup trailing
  au!
  au InsertEnter * :set listchars=eol:$,tab:.\ ,extends:>,precedes:<,nbsp:_
  au InsertLeave * :set listchars=eol:$,tab:.\ ,trail:·,extends:>,precedes:<,nbsp:_
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" no indent on paste
set pastetoggle=<F2>
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>

set scrolloff=8                 " 8 lines around the cursor when scrolling
set sidescrolloff=8             " 8 columns around the cursor when scrolling
set sidescroll=1                " scroll by 1 column

" Make sure Vim returns to the same line when you reopen a file.
autocmd BufReadPost *
\ if ! exists("g:leave_my_cursor_position_alone") |
\ if line("'\"") > 0 && line ("'\"") <= line("$") |
\ exe "normal g'\"" |
\ endif |
\ endif
