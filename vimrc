set nocompatible              " be iMproved, required
filetype off                  " required

"vundle plugins set via .vimrc.bundles
set nocompatible

" Leader
let mapleader = " "

set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

" Press F4 to toggle highlighting on/off, and show current value.
:noremap <F4> :set hlsearch! hlsearch?<CR>

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

filetype plugin indent on

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" zoom a vim pane, <C-w>= to re-balance
" nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
" nnoremap <leader>= :wincmd =<cr>=<cr>
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>:wincmd =<cr>

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Cucumber navigation commands
  " TODO broken
  " autocmd User Rails Rnavcommand step features/step_definitions -glob=**/* -suffix=_steps.rb
  " autocmd User Rails Rnavcommand config config -glob=**/* -suffix=.rb -default=routes

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell spelllang=en_us

  " Automatically wrap at 80 characters for Markdown
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-
augroup END

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·

let g:ackprg = 'ag --vimgrep --smart-case'
cnoreabbrev ag Ack
cnoreabbrev aG Ack
cnoreabbrev Ag Ack
cnoreabbrev AG Ack

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Color scheme
" colorscheme github
" highlight NonText guibg=#060606
" highlight Folded  guibg=#0A0A0A guifg=#9090D0

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" FORMAT commands
" x12: Replace tildes with new lines to view
map <leader>X    :%s/\~/\~\r/g<CR>

" json: Replace tildes with new lines to view
function! FormatJSON()
:%!python -m json.tool
endfunction

" Numbers
set number
set numberwidth=5

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

" Exclude Javascript files in :Rtags via rails.vim due to warnings when parsing
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

" Index ctags from any project, including those outside Rails
map <Leader>ct :!ctags -R .<CR>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" vim-rspec mappings
nnoremap <Leader>t :call RunCurrentSpecFile()<CR>
nnoremap <Leader>s :call RunNearestSpec()<CR>
nnoremap <Leader>l :call RunLastSpec()<CR>
nnoremap <Leader>a :call RunAllSpecs()<CR>

" Plugin Vim Tmux Runner
let g:rspec_command = "call VtrSendCommand('bundle exec rspec {spec}')"

"NERDTree
map \| :NERDTreeFind<CR>
let g:NERDTreeWinSize=50

"-OPEN RUNNER-
"new runner H
nnoremap <leader>osrv :VtrOpenRunner {'orientation': 'h', 'percentage': 30, 'cmd': ''}<cr>
"new runner V
nnoremap <leader>osrs :VtrOpenRunner {'orientation': 'v', 'percentage': 30, 'cmd': ''}<cr>
" reattach runner
nnoremap <leader>osrr :VtrReattachRunner<cr>

" send highlighted lines to runner
vnoremap <leader>t :VtrSendLinesToRunner<cr>

"irb
nnoremap <leader>irb :VtrOpenRunner {'orientation': 'h', 'percentage': 50, 'cmd': 'irb'}<cr>
"--

" Run commands that require an interactive shell
nnoremap <Leader>r :RunInInteractiveShell<space>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" configure syntastic syntax checking to check on open as well as save
let g:syntastic_check_on_open=1
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]

"----- Python -----
let python_highlight_all = 1

"END python

" enable rspec highlighing in ruby specs as in rails projects
" this is weird not working?? throws error
" autocmd BufRead *_spec.rb syn keyword rubyRspec describe context it specify it_should_behave_like before after setup subject its shared_examples_for shared_context let
" highlight def link rubyRspec Function

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add
setlocal spell spelllang=en_us
set spell

" Always use vertical diffs
set diffopt+=vertical

"execute pathogen#infect()
"
set t_Co=16

filetype plugin indent on

set background=light
" let g:solarized_termcolors = 256
let g:solarized_contrast = "high"
colorscheme solarized

" CURSOR info
" redraw
inoremap <special> <Esc> <Esc>hl

" javascript/React
let g:jsx_ext_required = 0

" arrow keys not working correctly with tap completion
imap <ESC>oA <ESC>ki
imap <ESC>oB <ESC>ji
imap <ESC>oC <ESC>li
imap <ESC>oD <ESC>hi

"no blink
set guicursor+=i:blinkwait0
" set guicursor+=n-v-c:blinkon0


"------ Changing cursor shape per mode MAC_OS
" 1 or 0 -> blinking block
" 2 -> solid block
" 3 -> blinking underscore
" 4 -> solid underscore
if exists('$TMUX')
    let &t_SI = "\e[6 q"
    let &t_EI = "\e[2 q"
else
    let &t_SI .= "\<Esc>[5 q"
    let &t_EI .= "\<Esc>[2 q"
    autocmd VimLeave * silent !echo -ne "\033[0 q"
endif

" Replace tildes with new lines to view X12
map <leader>X    :%s/\~/\~\r/g<CR>

" debugging
" insert puts statements and line number https://twitter.com/Benoit_Tgt/status/1037988875476586496
nnoremap <Leader>pt oputs "#" * 60<C-M>puts "<C-R>=expand("%") . ':' . line(".")<CR>"<C-M>puts "*" * 60<esc>

" EasyAlign
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Linix
" change cursor depending on mode
" if exists('$TMUX')
"   au InsertEnter * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
"   au InsertLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
"   au VimLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
" else
"   au VimLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
" endif
"
"
"----- inserts [#SID] into your commit message,
" assuming your branches follow the naming scheme: SID_description
function! InsertStoryId()
  let sid_command = "mi"                           " mark current position

  let sid_command = sid_command."\/On branch\<CR>" " move to line with branch name
  let sid_command = sid_command."ww"               " move to first char of story #
  let sid_command = sid_command."yt_"              " yank the story #
  let sid_command = sid_command."\/^#\<CR>gg"      " move to first #... line
  let sid_command = sid_command."O"                " add blank line in insert mode
  let sid_command = sid_command."[#\<esc>pA] "     " insert [#SID]
  let sid_command = sid_command."\<esc>"           " switch to normal mode

  exec "normal! ".sid_command
endfunction
autocmd FileType gitcommit nnoremap <leader>i :Sid<CR>

command! Sid :call InsertStoryId()

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
