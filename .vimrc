"NeoBundle Scripts-----------------------------
if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif
  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" Add or remove your Bundles here:
"NeoBundle 'Shougo/neocomplcache'
"NeoBundle 'Shougo/neocomplete'
"NeoBundle 'Shougo/neosnippet.vim'      " Use snippet
"NeoBundle 'Shougo/neosnippet-snippets' " Snippets
NeoBundle 'tpope/vim-fugitive'         " Use git command          | Gstatus, Ggrep, Gread
"NeoBundle 'ctrlpvim/ctrlp.vim'        " Search files             | Ctrl+P
NeoBundle 'flazz/vim-colorschemes'     " Color schemes
NeoBundle 'Shougo/unite.vim'          " See opening files        | Ctrl+P = opening files, Ctrl+N = files, Ctrl+N = recently files
NeoBundle 'Shougo/neomru.vim'         " See recently files
NeoBundle 'scrooloose/nerdtree'        " See tree of directory    | :NERDTree
NeoBundle 'tpope/vim-endwise'          " Automatically input 'end'
NeoBundle 'tomtom/tcomment_vim'        " Comment out muliline     | (Shift + V) and (Ctrl + -) x 2
"NeoBundle 'vim-scripts/AnsiEsc.vim'   " Color log file
NeoBundle 'bronson/vim-trailing-whitespace' " Highlight space
"NeoBundle 'tpope/vim-rails'           " for rails                | R = to view/controller, A= to test, Rmodel/Rview/Rcontroller
" :R(T|S|V|D) とかやると開き方を指定できます。左から順番に 新規タブ,水平分割,垂直分割,カレントバッファに読み込む となります。
NeoBundle 'scrooloose/syntastic'       " :SyntasticCheck Required gem i rubocop

" You can specify revision/branch/tag.
NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }

" Required:
call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"End NeoBundle Scripts-------------------------
" Unite.vim
" http://blog.remora.cx/2010/12/vim-ref-with-unite.html
let g:unite_enable_start_insert=1 " 入力モードで開始する
" バッファ一覧
noremap <C-P> :Unite buffer<CR>
" ファイル一覧
noremap <C-N> :Unite -buffer-name=file file<CR>
" 最近使ったファイルの一覧
noremap <C-Z> :Unite file_mru<CR>
" sourcesを「今開いているファイルのディレクトリ」とする
noremap :uff :<C-u>UniteWithBufferDir file -buffer-name=file<CR>
" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>
""""""""""""""""""""""""""""""
" ---------------------------------------------
" Neocomplete
"if neobundle#is_installed('neocomplete')
"  " neocomplete用設定
"  let g:neocomplete#enable_at_startup = 2  " 自動補完を行う入力数を設定。初期値は2
"  let g:neocomplete#enable_ignore_case = 1 " 補完候補検索時に大文字・小文字を無視する
"  let g:neocomplete#enable_smart_case = 1  " 入力に大文字が入力されている場合、大文字小文字の区別をする
"  if !exists('g:neocomplete#keyword_patterns')
"    let g:neocomplete#keyword_patterns = {}
"  endif
"  let g:neocomplete#keyword_patterns._ = '\h\w*'
"elseif neobundle#is_installed('neocomplcache')
"  " neocomplcache用設定
"  let g:neocomplcache_enable_at_startup = 1
"  let g:neocomplcache_enable_ignore_case = 1
"  let g:neocomplcache_enable_smart_case = 1
"  if !exists('g:neocomplcache_keyword_patterns')
"    let g:neocomplcache_keyword_patterns = {}
"  endif
"  let g:neocomplcache_keyword_patterns._ = '\h\w*'
"  let g:neocomplcache_enable_camel_case_completion = 1
"  let g:neocomplcache_enable_underbar_completion = 1
"endif
"inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
" ---------------------------------------------
" NERDTree
autocmd vimenter * if !argc() | NERDTree | endif
nnoremap <silent><C-e> :NERDTreeToggle<CR>
" ---------------------------------------------
" fugitve
" autocmd QuickFixCmdPost *grep* cwindow   " grep検索の実行後にQuickFix Listを表示する
" set statusline+=%{fugitive#statusline()} " ステータス行に現在のgitブランチを表示する
" ---------------------------------------------
" rubocop
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['ruby'] }
let g:syntastic_ruby_checkers = ['rubocop']
" ---------------------------------------------
" 挿入モード時、ステータスラインの色を変更
" https://sites.google.com/site/fudist/Home/vim-nihongo-ban/-vimrc-sample
let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'
if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif

let s:slhlcmd = ''
function! s:StatusLine(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec g:hi_insert
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
  endif
endfunction

function! s:GetHighlight(hi)
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction
" --------------------------------------------
" 最後のカーソル位置を復元する
if has("autocmd")
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
endif
" --------------------------------------------
" 各種オプションの設定
set ruler          " カーソルが何行目の何列目に置かれているかを表示する
set cmdheight=2    " コマンドラインに使われる画面上の行数
set laststatus=2   " エディタウィンドウの末尾から2行目にステータスラインを常時表示させる
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P " ステータス行に表示させる情報の指定(どこからかコピペしたので細かい意味はわかっていない)
set statusline+=%{fugitive#statusline()} " ステータス行に現在のgitブランチを表示する
set title          " ウインドウのタイトルバーにファイルのパス情報等を表示する
set wildmenu       " コマンドラインモードで<Tab>キーによるファイル名補完を有効にする
set showcmd        " 入力中のコマンドを表示する
set smartcase      " 小文字のみで検索したときに大文字小文字を無視する
set hlsearch       " 検索結果をハイライト表示する
set background=dark " 暗い背景色に合わせた配色にする
set expandtab      " タブ入力を複数の空白入力に置き換える
set incsearch      " 検索ワードの最初の文字を入力した時点で検索を開始する
set hidden         " 保存されていないファイルがあるときでも別のファイルを開けるようにする
set list           " 不可視文字を表示する
set listchars=tab:>\ ,extends:< " タブと行の続きを可視化する
set number         " 行番号を表示する
set showmatch      " 対応する括弧やブレースを表示する
set autoindent     " 改行時に前の行のインデントを継続する
set smartindent    " 改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set tabstop=2      " タブ文字の表示幅
set shiftwidth=2   " Vimが挿入するインデントの幅
set smarttab       " 行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけインデントする
set whichwrap=b,s,h,l,<,>,[,] " カーソルを行頭、行末で止まらないようにする
set backspace=indent,eol,start
syntax on          " 構文毎に文字色を変化させる
colorscheme desert " カラースキーマの指定
highlight LineNr ctermfg=darkyellow " 行番号の色
" ----------------------------------------------
