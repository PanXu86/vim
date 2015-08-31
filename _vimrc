set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
"behave mswin

set diffexpr=MyDiff()
function MyDiff()
    let opt = '-a --binary '
    if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
    let arg1 = v:fname_in
    if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
    let arg2 = v:fname_new
    if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
    let arg3 = v:fname_out
    if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
    let eq = ''
    if $VIMRUNTIME =~ ' '
        if &sh =~ '\<cmd'
            let cmd = '""' . $VIMRUNTIME . '\diff"'
            let eq = '"'
        else
            let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
        endif
    else
        let cmd = $VIMRUNTIME . '\diff'
    endif
    silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

" Share the clipboard with windows
set clipboard=unnamed

" Plugin manager -- pathogen
call pathogen#infect()
":call pathogen#helptags()


" Open the explorer tree
nmap <Leader>n :NERDTreeToggle<CR>
" Ignore pyc files
let NERDTreeIgnore = ['\.pyc$\|\.meta$','\.obj$','\.exe$', '\.lnk']


" Set background as back
" colo ayumi
colo desert
" colo bandit
" colo diablo3

" Close file window.
map <C-W> :close<CR>
imap <C-W> <esc>:close<CR>

" Set no back up swap file
set nobackup

" Set tab as 4 space
set tabstop=4
set shiftwidth=4
set expandtab

" No Auto change line in txt file
set wrap
set linebreak
set nolist  " list disables linebreak
set formatoptions+=l

" not using d as cut
" nnoremap d "_d

autocmd Filetype cs setlocal ts=4 sw=4 sts=0 noexpandtab

" Open as maximum window
au GUIEnter * simalt ~x

" Highlight manage.
nnoremap <esc> <esc>:noh<CR>:<esc>

" CtrlP settings
map <Leader>c :CtrlP<CR>
map <F2> :CtrlP<CR>
map <A-O> :CtrlP<CR>
map <F3> :CtrlPMRUFiles<CR>
imap <F2> <esc><F2>
imap <A-O> <esc>:CtrlP<CR>
imap <F3> <esc><F3>

"map <F3> :CtrlPMRU<CR>
let g:ctrlp_by_filename = 1
let g:ctrlp_match_window_bottom = 1
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn$\|\.Boost$\|\protobuf-2.6.0$',
  \ 'file': '\.exe$\|\.so$\|\.dat$\|\.obj$\|\.lnk$\|tags$\|\.dll$\|\.lib$\|\.png$\|\.uasset\|\.pdb'
  \ }
let g:ctrlp_root_markers = ['tags']
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_prompt_mappings = { 'PrtSelectMove("j")':   ['<c-n>', '<down>'], 'PrtSelectMove("k")':   ['<c-p>', '<up>'], 'PrtHistory(-1)':       ['<c-j>'], 'PrtHistory(1)':        ['<c-k>'], 'PrtClearCache()':      ['<F4>'], } 
" let g:ctrlp_user_command = 'find %s -type f'        " MacOSX/Linux
" let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d'  " Windows
let g:ctrlp_match_window = 'btt,order:btt,min:1,max:10,results:30'
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.idea/*,*/.DS_Store,*/vendor,*/.uasset,*/.uplugin,*/.pdb


" Taglist
" Open tag list selector
"map <S-o> :TlistToggle<CR>
map <S-o> :TagbarToggle<CR>
let g:Tlist_Ctags_Cmd='ctags.exe'
" Just display the current buffer's functions
let Tlist_Show_One_File = 1
" Show tag list on the right side
let Tlist_Use_Right_Window = 1

" Remap scroll up and scroll down
noremap <C-j> <C-e>
noremap <C-k> <C-y>

" Grep for search under specific folder or files
let Grep_Path = 'D:\Program Files\grep-2.5.4-bin\bin\grep.exe'
let Fgrep_Path = 'D:\Program Files\grep-2.5.4-bin\bin\fgrep.exe'
let Egrep_Path = 'D:\Program Files\grep-2.5.4-bin\bin\efgrep.exe'
let Grep_Find_Path = 'D:\Program Files\findutils-4.2.20-2-bin\bin\find.exe'
let Grep_Xargs_Path = 'D:\Program Files\findutils-4.2.20-2-bin\bin\xargs.exe'
let g:EasyGrepHidden = 0
let g:EasyGrepFilesToExclude = "tags,*.bak,*~,cscope.*,*.a,*.o,*.pyc,*.bak,*.swp,*.taghl"

" Remap to toggle qfix
map <C-F8> :QFix<CR>
map <F8> :cn<CR>
map <S-F8> :cp<CR>

nmap <Tab> <C-Tab>
nmap <A-k> :wincmd k<CR>
nmap <A-j> :wincmd j<CR>
nmap <A-h> :wincmd h<CR>
nmap <A-l> :wincmd l<CR>

" set encoding=utf-8

" Display line number
set number

" Set font to couriernew
"set guifont=Bitstream_Vera_Sans_Mno:h20:cANSI
set guifont=Bitstream_Vera_Sans_Mono:h10:cANSI
"set guifont=Lucida_Console:h11
"set guifont=monofur:h20

"Toggle Menu and Toolbar
set guioptions-=m
set guioptions-=T

" Don't need to hit enter
set cmdheight=1 lines=43

map <silent> <F9> :if &guioptions =~# 'T' <Bar>
            \set guioptions-=T <Bar>
            \set guioptions-=m <bar>
            \else <Bar>
            \set guioptions+=T <Bar>
            \set guioptions+=m <Bar>
            \endif<CR>

" Find current buffer in the NERD_Tree
map <Leader>g :NERDTreeFind<CR>

" Switch between cpp and h files
map <A-o> <esc>:A<CR>
imap <A-o> <esc>:A<CR>


if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif

" Generate tags and cscope file, cscope_maps.vim will care about the bind
function GenerateLatestTags()
    silent !ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --exclude=boost
    silent !dir /s/b *.js,*.c,*.cpp,*.h,*.java >> cscope.files
    silent !cscope -Rbk
endfunction
map <C-F12> :call GenerateLatestTags()<CR>

" use ctags -R --python-kinds=-i --fields=+iaS --extra=+q to generate tags file.
let ctags_path="./tags"

" to run python code in vim 
nnoremap <F5> :exec '!python' shellescape(@%, 1)<cr>


set completeopt=longest,menu " Don't display the preview window
let OmniCpp_DisplayMode = 1 " Display class members
let OmniCpp_ShowScopeInAbbr = 1 " Display class name first
let OmniCpp_ShowPrototypeInAbbr = 1 " Display the prototype of a function
let OmniCpp_MayCompleteScope = 1 " Show matchs in scope
let OmniCpp_SelectFirstItem = 0 " Select first item and insert as default
let OmniCpp_LocalSearchDecl = 1 " Use local search
let OmniCpp_NamespaceSearch = 0 " Disable namespace 

" Easy motion short cut key
let g:EasyMotion_leader_key = ";"

" Set alternate search path
let g:alternateSearchPath = 'sfr:./'

" Auto save buff and keep the change history
set autowriteall
" Turn backup off, since most stuff is in SVN, git anyway...
set nobackup
set nowb
set noswapfile

"Persistent undo
set undofile                " Save undo's after file closes
set undodir=$HOME/vim/undo  " where to save undo histories, make sure it's existed, or else create it manually
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo

" Hightlight current line
autocmd BufEnter * setlocal cursorline

set list listchars=tab:>-,trail:.,precedes:<,extends:>
autocmd BufWinLeave * call clearmatches()
"au BufWinEnter * let w:m1=matchadd('Search', '\%<81v.\%>77v', -1)
"au BufWinEnter * let w:m2=matchadd('Underlined', '\%>78v.\+', -1)

autocmd BufWritePre  *.{as,lua,cpp,h,hpp,c,py,js,etc}  call StripTrailingWhite()
autocmd BufWritePre  *.{as,lua,cpp,h,hpp,c,py,js,etc}  call StripTabs()
function! StripTrailingWhite()
    let l:winview = winsaveview()
    silent! %s/\s\+$//
    call winrestview(l:winview)
endfunction
function! StripTabs()
    let l:winview = winsaveview()
    silent! %s/\t/    /g
    call winrestview(l:winview)
endfunction

function ExplorerCurrentBuffer()
    exec ":silent !explorer /select, %:p"
endfunction
" Open the selected buffer in windows explorer
nmap <F10> :!start explorer /select, %:p<CR>

" Show dec or hex of current number-word under cursor
nnoremap gn :call DecAndHex(expand("<cWORD>"))<CR>
function! DecAndHex(number)
    let ns = '[.,;:''"<>()^_lL]'      " number separators
    if a:number =~? '^' . ns. '*[-+]\?\d\+' . ns . '*$'
        let dec = substitute(a:number, '[^0-9+-]*\([+-]\?\d\+\).*','\1','')
        echo dec . printf('  ->  0x%X, -(0x%X)', dec, -dec)
    elseif a:number =~? '^' . ns. '*\%\(h''\|0x\|#\)\?\(\x\+\)' . ns . '*$'
        let hex = substitute(a:number, '.\{-}\%\(h''\|0x\|#\)\?\(\x\+\).*','\1','')
        echon '0x' . hex . printf('  ->  %d', eval('0x'.hex))
        if strpart(hex, 0,1) =~? '[89a-f]' && strlen(hex) =~? '2\|4\|6'
            " for 8/16/24 bits numbers print the equivalent negative number
            echon ' ('. float2nr(eval('0x'. hex) - pow(2,4*strlen(hex))) . ')'
        endif
        echo
    else
        echo "NaN"
    endif
endfunction

" Highlight c operator
autocmd! BufRead,BufNewFile,BufEnter *.{c,cpp,h,javascript,zen} call CSyntaxAfter()
autocmd! BufRead,BufNewFile,BufEnter *.zen setfiletype cpp

" Fold marker
set fdm=marker

" au BufRead,BufNewFile *.jar,*.war,*.ear,*.sar,*.rar set filetype=zip

" Grep under windows
set grepprg=findstr\ /n\ /s

command -nargs=+ FullMatchSearch :call g:FullMatchSearch(<f-args>)
command -nargs=+ PartialMatchSearch :call g:PartialMatchSearch(<f-args>)
command Random :py import vim, random; vim.current.line += hex(random.randint(0,2147483647)).upper()

function! g:FullMatchSearch(pattern, searchDir)
    exec "grep \"\\<" . a:pattern . "\\>\" " . a:searchDir
    cw
endfunction

function! g:PartialMatchSearch(pattern, searchDir)
    exec "grep \"" . a:pattern . "\" " . a:searchDir
    cw
endfunction

nmap <leader>f :FullMatchSearch <c-r>=expand("<cword>")<cr> 
nmap <leader>F :PartialMatchSearch <c-r>=expand("<cword>")<cr> 

" Set tail height
let g:tail#Height = 30

" actionscript language
let tlist_actionscript_settings = 'actionscript;c:class;f:method;p:property;v:variable'

" Treat long line as break lines
map j gj
map k gk

" Make cmdline tab completion similar to bash
set wildmode=list:longest
" Auto complete for command in status bar
set wildmenu
set wildmode=longest:full,full


" For comment useless param
nmap mc i/*<Esc>wea*/<Esc>k

" Use pylint
set makeprg=pylint\ --reports=n\ --rcfile=pylint.conf\ --output-format=parseable\ %:p
set errorformat=%f:%l:\ %m
nmap <leader>m :make<cr> 

" Format json
nmap <leader>j :%!python -m json.tool<cr>

" Ignore case when searching
set ignorecase

"filetype plugin indent on
"set completeopt=longest,menu

" for project
" set tags=C:/Development/Runner/XuPan_XuPanWinPC_5392/tags

" for python Plugin
filetype plugin on
let g:pydiction_location = printf('%s/vimfiles/bundle/pydiction/complete-dict', $VIM)
let g:pydiction_menu_height = 3

" neo-complete
"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()

"format
let g:formatprg_cs = "astyle"
let g:formatprg_hpp  = "astyle"
let g:formatprg_cpp  = "astyle"

let g:formatprg_h = "astyle"
let g:formatprg_args_h = " --style=1tbs "

let g:formatprg_c = "astyle"
let g:formatprg_args_c = " --style=1tbs "

noremap <F4> :Autoformat<CR><CR>

" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplete#enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplete#enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

let g:clighter_autostart = 0
let g:clighter_realtime = 0
let g:clighter_highlight_groups = ['clighterMacroInstantiation', 'clighterStructDecl', 'clighterClassDecl', 'clighterEnumDecl', 'clighterEnumConstantDecl', 'clighterTypeRef', 'clighterDeclRefExprEnum']
let g:clighter_clang_options = ['-IC:\Development\Runner\XuPan_XuPanWinPC_5392\Runner\bgfx\bgfx\examples\common\']
hi link clighterMacroInstantiation Constant
hi link clighterTypeRef Identifier
hi link clighterStructDecl Type
hi link clighterClassDecl Type
hi link clighterEnumDecl Type
hi link clighterEnumConstantDecl Identifier
hi link clighterDeclRefExprEnum Identifier
hi link clighterCursorSymbolRef IncSearch
hi link clighterFunctionDecl None
hi link clighterDeclRefExprCall None
hi link clighterMemberRefExpr None
hi link clighterNamespace None

" Enable heavy omni completion.
"
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

let g:neocomplete#sources#include#patterns = {
  \ 'cpp':  '^\s*#\s*include',
  \ 'c':    '^\s*#\s*include',
  \ 'ruby': '^\s*require',
  \ 'perl': '^\s*use',
  \ }


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" setting for this project
" c++ inlcude file path settings
if has("win32") || has("win64")
  let g:neocomplete#sources#include#paths ={
        \ 'cpp':  '.,C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\include,.\Runner\engine',
        \ 'c':    '.,C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\include,.\Runner\engine',
        \ 'ruby': '.,C:/Ruby200/lib/ruby/2.0.0/',
        \ }
else
  let g:neocomplete#sources#include#paths ={
        \ 'cpp':  '.,/opt/local/include/gcc46/c++,/opt/local/include,/usr/include',
        \ 'c':    '.,/usr/include',
        \ 'ruby': '.,$HOME/.rvm/rubies/**/lib/ruby/1.8/',
        \ }
endif

" command to execute shell command
command Shell !start cmd /K cd %:p:h
