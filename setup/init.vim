" File: ~/.init.vim
" Discription: NEOVIM Configuration
" Author: Yi Zhang 
" Time: 2019/09/21
"
"
"
" --- if want to use the VIM configuration ---
" set runtimepath+=~/.vim,~/.vim/after
" set packpath+=~/.vim
" source ~/.vimrc
" --- if want to use the VIM configuration ---
set colorcolumn=80
set ic

source /usr/share/vim/google/core.vim
Glug codefmt gofmt_executable="goimports"
Glug codefmt-google

call plug#begin('~/.local/share/nvim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
Plug 'altercation/vim-colors-solarized'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'ryanoasis/vim-devicons'
Plug 'schickling/vim-bufonly'
"""""""""""""""
" Async Plugs "
"""""""""""""""
" CoC
" Use release branch
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'fatih/vim-go'
" Or latest tag
" Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}
" CoC

" Plug 'liuchengxu/vista.vim'

call plug#end()

"""""""""""""""
" setting for golang
"""""""""""""""
autocmd FileType go AutoFormatBuffer gofmt
" for gopls 
" add missing import on save for golang
"autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')
"autocmd BufRead /usr/local/google/home/cathyzhyi/work/go/src/knative.dev/*
          "\ :GoGuruScope /usr/local/google/home/cathyzhyi/work/go/src/knative.dev 

"""""""""""""""""""
" git
"""""""""""""""""""
nnoremap gb :Gblame<return>

"""""""""""""""""""
" common settings "
"""""""""""""""""""
" ABOUT FILE
set autoread        " auto read-in after modification from outside
set fileformats=unix
set fileencodings=utf-8
set nofixendofline

" ABOUT ENCODING
set encoding=UTF-8
set fileencodings=utf-8

" ABOUT INPUT
set ai              " auto indent
set si              " smart indent
set bs=2            " set backspace action
set showmatch       " show matching parentheses
set vb              " visual beep rather than real beep

set expandtab           " replace tab with spaces
set tabstop=2           " show tab as 2 spaces
set softtabstop=2       " input 2 spaces insdead of a tab
set shiftwidth=2        " spaces for an indent

" ABOUT DISPLAY
syntax enable           " switch on syntax highlighting.
set background=dark
colorscheme solarized   " set color scheme
set laststatus=2        " always display status bar
set cursorline          " high light the current line
set cursorcolumn        " high light the current column
set number              " display the lineno
set relativenumber      " display relativenumber
let c_comment_strings=1 " highlight strings inside C comments
set mousehide           " hide the mouse while typing
" set list                " display chart-symbols
" set listchars=tab:>-,trail:-
" set listchars=tab:>-,trail:-,eol:$
" set ch=2                " make command line two lines high
set t_Co=256

" ABOUT SEARCHING
" set ignorecase          " the opposite is set noignorecase
set nowrapscan          " no wraparound while searching, the opposite is 'wrapscan'
set hlsearch            " highlight search result
set incsearch           " incremental search
" cancel highlighting after search
nnoremap <F7> :noh<return><esc>
"search selected txt
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" COMMON SETTINGS DONE
" enable filetype plugin & filetype indentation
filetype plugin indent on
" enable new-omni-completion
set completeopt=menu,menuone,longest,preview
set ofu=syntaxcomplete#Complete

"""""""""""
" folding "
"""""""""""
set foldmethod=syntax
set foldlevel=100       " Don't fold anything at start-up
" set foldopen-=search    " Don't unfold when search
" set foldopen-=undo      " Don't unfold when undo

"""""""""""""""""""""
" buffer operations "
"""""""""""""""""""""
"map <silent> <leader>[ :<C-u>bp<cr>
"map <silent> <leader>] :<C-u>bn<cr>
"map <silent> <leader>s :<C-u>b#<cr>
"nnoremap <leader>b :ls<CR>:b<Space>
"nnoremap <leader>be :<C-u>CocList extensions<cr>
"nnoremap <leader>br :<C-u>CocList mru<cr>

""""""""""""""""""
" tab operations "
""""""""""""""""""
map <silent> <leader>c         :tabnew<cr>
map <silent> <leader>]         :tabn<cr>
map <silent> <leader>[         :tabp<cr>
map <silent> <leader><up>      :tabr<cr>
map <silent> <leader><down>    :tabl<cr>
map <silent> <leader><left>    :tabp<cr>
map <silent> <leader><right>   :tabn<cr>
" jump to a specific tab
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt

""""""""""""""""""
" cscope setting "
""""""""""""""""""
if has("cscope")
set csprg=/usr/bin/cscope
set csto=0
set cst

set nocsverb
" add any database in current directory
if filereadable("cscope.out")
      cs add cscope.out
endif
set csverb

set cscopequickfix=s-,c-,d-,i-,t-,e-
endif

nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-_>i :cs find i <C-R>=expand("<cfile>")<CR><CR>
nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>r :!find . -iname '*.c' -o -iname '*.cc' -o -iname '*.cpp' -o -iname '*.c++' -o -iname '*.cxx' -o -iname '*.inc' -o -iname '*.h' -o -iname '*.hh' -o -iname '*.hpp' -o -iname '*.h++' -o -iname '*.hxx' -o -iname '*.py' > cscope.files<CR>:!cscope -b -q -i cscope.files -f cscope.out<CR>:cs reset<CR><CR>

""""""""""""
" QuickFix "
""""""""""""
nmap <F9> : cn <cr>
nmap <F10> : cp <cr>

"""""""""""
" TagList "
"""""""""""
" noremap <F12> :Tlist<CR>
" " noremap <S-F12> :TlistUpdate<CR>

" let Tlist_Show_One_File = 1
" let Tlist_Exit_OnlyWindow = 1
" let Tlist_GainFocus_On_ToggleOpen = 1
" " let tlist_Sort_Type = "name"
" " let Tlist_Use_Right_Window = 1
" " let Tlist_Ctags_Cmd = '/usr/bin/ctags'

""""""""""""
" NERDTree "
""""""""""""
map <F11> :NERDTree <CR>

""""""""""
" tagbar "
""""""""""
nmap <F12> :TagbarToggle<CR>

"""""""
" fzf "
"""""""
let g:fzf_nvim_statusline = 0 " disable statusline overwriting

nnoremap <silent> <leader><space> :Files<CR>
nnoremap <silent> <leader>a :Buffers<CR>
nnoremap <silent> <leader>A :Windows<CR>
nnoremap <silent> <leader>; :BLines<CR>
nnoremap <silent> <leader>o :BTags<CR>
nnoremap <silent> <leader>O :Tags<CR>
nnoremap <silent> <leader>? :History<CR>
nnoremap <silent> <leader>t :execute 'Ag ' . input('Ag/')<CR>
nnoremap <silent> <leader>. :AgIn

 nnoremap <silent> <leader>s :call SearchWordWithAg()<CR>
" vnoremap <silent> K :call SearchVisualSelectionWithAg()<CR>
nnoremap <silent> <leader>gl :Commits<CR>
nnoremap <silent> <leader>ga :BCommits<CR>
nnoremap <silent> <leader>ft :Filetypes<CR>

imap <C-x><C-f> <plug>(fzf-complete-file-ag)
imap <C-x><C-l> <plug>(fzf-complete-line)

function! SearchWordWithAg()
  execute 'Ag' expand('<cword>')
endfunction

function! SearchVisualSelectionWithAg() range
  let old_reg = getreg('"')
  let old_regtype = getregtype('"')
  let old_clipboard = &clipboard
  set clipboard&
  normal! ""gvy
  let selection = getreg('"')
  call setreg('"', old_reg, old_regtype)
  let &clipboard = old_clipboard
  execute 'Ag' selection
endfunction

function! SearchWithAgInDirectory(...)
  call fzf#vim#ag(join(a:000[1:], ' '), extend({'dir': a:1}, g:fzf#vim#default_layout))
endfunction
command! -nargs=+ -complete=dir AgIn call SearchWithAgInDirectory(<f-args>)

"""""""""""
" airline "
"""""""""""
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'

" " unicode symbols
" let g:airline_left_sep = '»'
" let g:airline_left_sep = '▶'
" let g:airline_right_sep = '«'
" let g:airline_right_sep = '◀'
" let g:airline_symbols.crypt = '🔒'
" let g:airline_symbols.linenr = '☰'
" let g:airline_symbols.linenr = '␊'
" let g:airline_symbols.linenr = '␤'
" let g:airline_symbols.linenr = '¶'
" let g:airline_symbols.maxlinenr = ''
" let g:airline_symbols.maxlinenr = '㏑'
" let g:airline_symbols.branch = '⎇'
" let g:airline_symbols.paste = 'ρ'
" let g:airline_symbols.paste = 'Þ'
" let g:airline_symbols.paste = '∥'
" let g:airline_symbols.spell = 'Ꞩ'
" let g:airline_symbols.notexists = 'Ɇ'
" let g:airline_symbols.whitespace = 'Ξ'

" " powerline symbols
" let g:airline_left_sep = ''
" let g:airline_left_alt_sep = ''
" let g:airline_right_sep = ''
" let g:airline_right_alt_sep = ''
" let g:airline_symbols.branch = ''
" let g:airline_symbols.readonly = ''
" let g:airline_symbols.linenr = '☰'
" let g:airline_symbols.maxlinenr = ''
" let g:airline_symbols.dirty=⚡

" " old vim-powerline symbols
" let g:airline_left_sep = '⮀'
" let g:airline_left_alt_sep = '⮁'
" let g:airline_right_sep = '⮂'
" let g:airline_right_alt_sep = '⮃'
" let g:airline_symbols.branch = '⭠'
" let g:airline_symbols.readonly = '⭤'
" let g:airline_symbols.linenr = '⭡'

"""""""
" CoC "
"""""""
" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.

xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search symbol in workspace for word under the cursor 
nnoremap <silent> <space>s  :exe 'CocList -I --normal --input='.expand('<cword>').' symbols'<CR>
" Search workspace symbols
nnoremap <silent> <space>t  :<C-u>CocList -I symbols<cr>
" nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" Show all buffers
nnoremap <silent> <space>e  :<C-u>CocList buffers<cr>
" Show mru files
nnoremap <silent> <space>r  :<C-u>CocList mru<cr>
" Show bookmarks
nnoremap <silent> <space>m  :<C-u>CocList marks<cr>


" """""""""
" " ctrlp "
" """""""""
" let g:ctrlp_map = '<c-p>'
" let g:ctrlp_cmd = 'CtrlP'
"
" let g:ctrlp_working_path_mode = 'ra'
"
" set wildignore+=*/tmp/*,*.so,*.swp,*.zip        " MacOSX/Linux
" " set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe   " Windows
"
" let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
"
" let g:ctrlp_user_command = 'find %s -type f'        " MacOSX/Linux
" " let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d'  " Windows

" """"""""
" " grep "
" """"""""
" nnoremap <silent><F3> :Grep<CR>

"""""""""
" vista "
"""""""""
" let g:vista_default_executive = 'coc'
" nnoremap <leader>v :<C-u>Vista!!<CR>
" 
" let g:vista#renderer#enable_icon = 1
" let g:vista#renderer#icons = {
"             \   "function": "\uf794",
"             \   "variable": "\uf71b",
"             \  }
"""""""""""""""""""
" show tab number in vim
"""""""""""""""""""
:set tabline=%!MyTabLine()
if exists("+showtabline")
     function MyTabLine()
         let s = ''
         let t = tabpagenr()
         let i = 1
         while i <= tabpagenr('$')
             let buflist = tabpagebuflist(i)
             let winnr = tabpagewinnr(i)
             let s .= '%' . i . 'T'
             let s .= (i == t ? '%1*' : '%2*')
             let s .= ' '
             let s .= i . ')'
             let s .= ' %*'
             let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
             let file = bufname(buflist[winnr - 1])
             let file = fnamemodify(file, ':p:t')
             if file == ''
                 let file = '[No Name]'
             endif
             let s .= file
             let i = i + 1
         endwhile
         let s .= '%T%#TabLineFill#%='
         let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
         return s
     endfunction
     set stal=2
     set tabline=%!MyTabLine()
endif

function MyTabLabel(n)
	  let buflist = tabpagebuflist(a:n)
	  let winnr = tabpagewinnr(a:n)
	  return buflist[winnr - 1] . ') ' . bufname(buflist[winnr - 1])
endfunction

""""""""""""""""""""""""""""""""""""
" focus left tab after closing a tab
""""""""""""""""""""""""""""""""""""
let s:prevtabnum=tabpagenr('$')
augroup TabClosed
    autocmd! TabEnter * :if tabpagenr('$')<s:prevtabnum && tabpagenr()>1
                \       |   tabprevious
                \       |endif
                \       |let s:prevtabnum=tabpagenr('$')
augroup END

""""""""""
" others "
""""""""""
func MyTitle()
    let l:author = 'Garf'
    if &filetype == 'sh'
        call append(0, "\#!/bin/bash")
        call append(1, "\# File Name:     ".expand("%"))
        call append(2, "\# Author:        ".l:author)
        call append(3, "\# Created Time:  ".strftime("%c"))
        call append(4, "\# Description:   ")
        call append(4, "\# ")
        call append(5, "\# History:       ")
        call append(5, "\# ")
        call append(6, "\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#")
        call append(7, "")
    elseif &filetype == 'cpp'
        call append(0, "\/*********************************")
        call append(1, " * File Name:     ".expand("%"))
        call append(2, " * Author:        ".l:author)
        call append(3, " * Created Time:  ".strftime("%c"))
        call append(4, " * Description:   ")
        call append(5, " * ")
        call append(6, " * History:       ")
        call append(7, " * ")
        call append(8, " *********************************\/")
        call append(9, "")
    elseif &filetype == 'c'
        call append(0, "\/*********************************")
        call append(1, " * File Name:     ".expand("%"))
        call append(2, " * Author:        ".l:author)
        call append(3, " * Created Time:  ".strftime("%c"))
        call append(4, " * Description:   ")
        call append(5, " * ")
        call append(6, " * History:       ")
        call append(7, " * ")
        call append(8, " *********************************\/")
        call append(9, "")
    elseif &filetype == 'verilog'
        call append(0, "\/*********************************")
        call append(1, " * File Name:     ".expand("%"))
        call append(2, " * Author:        ".l:author)
        call append(3, " * Created Time:  ".strftime("%c"))
        call append(4, " * Description:   ")
        call append(5, " * ")
        call append(6, " * History:       ")
        call append(7, " * ")
        call append(8, " *********************************\/")
        call append(9, "")
    elseif &filetype == 'python'
        call setline(1,"\#!/usr/bin/env python")
        call append(1, "\# File Name:     ".expand("%"))
        call append(2, "\# Author:        ".l:author)
        call append(3, "\# Created Time:  ".strftime("%c"))
        call append(4, "\# Description:   ")
        call append(4, "\# ")
        call append(5, "\# History:       ")
        call append(5, "\# ")
        call append(6, "\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#")
        call append(7, "")
    else
        call append(0, "\/*********************************")
        call append(1, " * File Name:     ".expand("%"))
        call append(2, " * Author:        ".l:author)
        call append(3, " * Created Time:  ".strftime("%c"))
        call append(4, " * Description:   ")
        call append(5, " * ")
        call append(6, " * History:       ")
        call append(7, " * ")
        call append(8, " *********************************\/")
        call append(9, "")
    endif
endfunc





