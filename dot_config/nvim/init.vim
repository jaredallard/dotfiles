set encoding=utf-8
let g:is_posix = 1                                " use proper syntax highlighting for shell scripts
set virtualedit=onemore                           " navigate to the true end of the line
set autochdir                                     " synchronize vim's cwd with the cwd of the current
set timeout timeoutlen=300 ttimeoutlen=300        " timeout for binding sequences
set nu                                            " line numbers
set laststatus=2                                  " always show status line
set backspace=2                                   " backspace legit
set mouse-=a                                      " disable mouse usage
set linebreak                                     " word wrapping
set nolist                                        " list disables linebreak
set title                                         " display filename in the title
set undolevels=64                                 " levels of undo ;)
set noerrorbells                                  " fthatsh
set noswapfile                                    " save often don't worry about messy garbage
set nobackup                                      " ditto
set nowrap                                        " don't word wrap
let loaded_matchparen = 1                         " don't highlight matched parens
let g:tmuxline_preset = 'nightly_fox'             " tmuxline status

let mapleader = ","
let maplocalleader = "\\"
inoremap <leader>w <c-o>:w<cr>
nnoremap <leader>w :w<cr>
inoremap <leader>q <c-o>:q<cr>
nnoremap <leader>q :q<cr>
inoremap <leader>e <c-o>:e!<cr>
nnoremap <leader>e :e!<cr>
inoremap <leader>wq <c-o>:wq<cr>
nnoremap <leader>wq :wq<cr>

" Enter normal mode
inoremap jk <esc>l
inoremap kj <esc>l

set modeline
set tabstop=2 softtabstop=2 expandtab shiftwidth=2

nnoremap H ^
nnoremap L $
vnoremap H ^
vnoremap L $

function! EatChar(pat)
    let c = nr2char(getchar(0))
    return (c =~ a:pat) ? '' : c
endfunction

function! MakeSpacelessIabbrev(from, to)
    execute "iabbrev <silent> ".a:from." ".a:to."<C-R>=EatChar('\\s')<CR>"
endfunction

function! MakeSpacelessBufferIabbrev(from, to)
    execute "iabbrev <silent> <buffer> ".a:from." ".a:to."<C-R>=EatChar('\\s')<CR>"
endfunction
au FileType javascript call MakeSpacelessBufferIabbrev('clog', 'console.log();<left><left>')
au FileType javascript call MakeSpacelessBufferIabbrev('cl', 'console.log("Æ:", Æ);<esc>8h:/Æ<enter>gi<esc>8hcgn')

au FileType javascript call MakeSpacelessBufferIabbrev('jstr', 'console.log(JSON.stringify(, null, 2));<c-o>12h')

" Theme
let g:airline_theme='atomic'

" fzf Fuzzy Searching
noremap <c-p> :GitFiles<CR>

" fzf string searching
command! -bang -nargs=* FindStandard call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
noremap <c-f> :FindStandard

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>
