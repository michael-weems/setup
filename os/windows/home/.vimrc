"" ----------------------------------------------
"" global variables

let g:PROJECTS_DIR="~/projects/"

"" ----------------------------------------------
"" Imports
source ~/.vim/colors/catppuccin_mocha.vim

"" ----------------------------------------------
"" Set
let mapleader = " "

" line numbers
set number
set relativenumber
" split defaults
set splitright
set splitbelow
" scroll
set scroll=8
set scrolloff=8
" turn off persistent search highlighting
set nohlsearch
 
set noswapfile

" replace tab with spaces and set the tab size to 3
set shiftwidth=3 smarttab
set expandtab
" map - to go up a directory
"" first, make sure we're in the directory of the buffer - without this it sometimes gets out of sync!
let g:netrw_banner = 0
let g:netrw_keepdir = 0
let g:netrw_localcopydircmd = 'cp -r'
" all yank/delete operations use the system clipboard
set clipboard=unnamed,unnamedplus
" for find, recursively look for files in dir
set path+=**
" see a list of files found via tab-completion
set wildmenu
set wildmode=list,longest,full
let g:markers = split('.git')
fun s:Cd_to_repo_root() abort
	for marker in g:markers
		let root = finddir(marker, expand('%:p:h') . ';')
		if !empty(root)
			let root = fnamemodify(root, ':h')
			call chdir(root)
			echo 'cd ' . root . ' (found ' . marker . ')'
			return
		endif
	endfor
	echoerr 'No repo root found.'
endfun

" Find/edit files using the quickfix list

" quit
nnoremap <Leader>q :q<Cr>
nnoremap <Leader>w :w<Cr>

" jump over paragraphs
noremap <silent> <expr> <C-k> (line('.') - search('^\n.\+$', 'Wenb')) . 'kzv^'
noremap <silent> <expr> <C-j> (search('^\n.\+$', 'Wenb') - line('.')) . 'jzv^'

"" ----------------------------------------------
"" Automations
" on enter buffer, cd into that file's directory
autocmd BufEnter * silent! lcd %:h

" TODO this isn't working for some reason...
" Create file's directory before saving, if it doesn't exist.
"augroup BWCCreateDir
"	autocmd!
"	autocmd BufWritePre * :call s:MkNonExdir(expand('<afile>'), +expand('<abuf>'))
"augroup END
"fun! s:MkNonExDir(file, buf)
"	if empty(getbufvar(a:buf, '&buftype')) && a:file !~# '\v^\w+\:\/'
"		call mkdir(fnamemodify(a:file, ':h'), 'p')
"	endif
"endfun

" Automatically re-source the vimrc file after loading a session
autocmd SessionLoadPost * source ~/.vimrc

"" ----------------------------------------------
"" Color Scheme
set termguicolors
syntax on
