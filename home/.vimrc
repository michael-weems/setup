"" ----------------------------------------------
"" Helpful Links

"" ----------------------------------------------
"" Imports
syntax on
colorscheme "catppuccin_mocha"

"" ----------------------------------------------
"" Set
let mapleader = " "
set number
set relativenumber

" turn off persistent search highlighting
set nohlsearch

" replace tab with spaces and set the tab size to 3
set shiftwidth=3 smarttab
set expandtab

" map - to go up a directory
nnoremap - :Explore %:h<CR>
let g:netrw_banner = 0
let g:netrw_keepdir = 0
let g:netrw_localcopydircmd = 'cp -r'

" all yank operations use the system clipboard
set clipboard=unnamed,unnamedplus

" for find, recursively look for files in dir
set path+=**

" see a list of files found via tab-completion
set wildmenu
set wildmode=list,longest,full

" Map to change cwd to the dir of the current buffer
nnoremap cm :call chdir(expand('%:p:h')) \| pwd<CR>

" Map to change cwd to the repo-root-directory of the current buffer
nnoremap cu :call <SID>Cd_to_repo_root()<CR>
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

" Simple mappings for buffer switching.
nnoremap <Leader>d :b *

" Find/edit files using the quickfix list
nnoremap <Leader>sg :cexpr system('grep -rn "" $(find_workspace_root)')<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
nnoremap <Leader>sf :cexpr system('find_file "" $(find_workspace_root)')<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

" todos
nnoremap <Leader>st :vimgrep /todo\c/ **/*<Cr>
nnoremap <Leader>ft :vimgrep /todo\c/ %<Cr>
nnoremap <Leader>pf :call <SID>Cd_to_repo_root()<CR>:call All_files_to_qflist()<CR>:copen<CR>
nnoremap <Leader>lf :call All_files_to_qflist()<CR>:copen<CR>

function! All_files_to_qflist()
	" Find all .txt files in the current dir and subdirs
	let files = filter(glob('**/*', 0, 1), '!isdirectory(v:val)')

	" map list of filenames to a list of quickfix entries
	let qflist = map(files, '{"filename": v:val, "lnum": 1}')

	" set the quickfix list
	call setqflist(qflist)
endfunction

nnoremap <Leader>sc :cexpr system('list_git_conflicts')<Cr><Leader>q

nnoremap <Leader>q :copen<Cr>
nnoremap <Leader>w :cclose<Cr>
nnoremap <Leader>j :cnext<Cr>
nnoremap <Leader>k :cprevious<Cr>
nnoremap <Leader>G :clast<Cr>
nnoremap <Leader>gg :first<Cr>

" navigate splits with C-hjkl
nnoremap <Leader>wh <C-w>h
nnoremap <Leader>wj <C-w>j
nnoremap <Leader>wk <C-w>k
nnoremap <Leader>wl <C-w>l

" 'fzf' like switcher
nnoremap <C-f> :SwitchProject ~/projects/

function! SourceDynamicFile(filename)
	execute "source" a:filename
endfunction

function! LoadSession(file)
	" Cache off existing session
	let project_name = system("basename $(find_workspace_root)")
	let session_file = trim(fnameescape(project_name))

	" update session for current project
	let base_dir = '~/.vim/sessions'
	let projects_dir = '~/projects/'
	execute 'mksession! ' base_dir . session_file . ".vim"

	let basename = fnamemodify(trim(a:file, '/', 2), ':t')
	let new_session = base_dir . basename . ".vim"

	if filereadable(expand(new_session))
		echo "opening: " . new_session
		:call SourceDynamicFile(new_session)
	else
		echo "cd to: " . projects_dir . basename
		execute 'e ' . projects_dir . basename
	endif

	return 1
endfunction

command! -nargs=1 -complete=file SwitchProject call LoadSession(<q-args>)

" open command mode with running shell command
nnoremap <Leader>e :!

" jump over paragraphs
noremap <silent> <expr> <C-k> (line('.') - search('^\n.\+$', 'Wenb')) . 'kzv^'
noremap <silent> <expr> <C-j> (search('^\n.\+$', 'Wenb') - line('.')) . 'jzv^'

" Create file's directory before saving, if it doesn't exist.
augroup BWCCreateDir
	autocmd!
	autocmd BufWritePre * :call s:MkNonExdir(expand('<afile>'), +expand('<abuf>'))
augroup END
fun! s:MkNonExDir(file, buf)
	if empty(getbufvar(a:buf, '&buftype')) && a:file !~# '\v^\w+\:\/'
		call mkdir(fnamemodify(a:file, ':h'), 'p')
	endif
endfun

" remap <C-^> to always switch to a buffer, even if the previous one doesn't
" exist
nnoremap <silent> <C-n> :<C-u>exe v:count ? v:count . 'b' : 'b' . (bufloaded(0) ? '#' : 'n')<CR>

" Sort lines, selected over motion
" - gsip -> sort inside current paragraph
" - gsiB -> sort inside closest braces
xnoremap <silent> gs :sort i<CR>
nnoremap <silent> gs :set opfunc=SortLines<CR>g@
fun! SortLines(type) abort
    '[,']sort i
endfun

" Reverse lines, selected or over motion.
nnoremap <silent> gr :set opfunc=ReverseLines<CR>g@
vnoremap <silent> gr :<C-u>call ReverseLines('vis')<CR>
fun! ReverseLines(type) abort
    let marks = a:type ==? 'vis' ? '<>' : '[]'
    let [_, l1, c1, _] = getpos("'" . marks[0])
    let [_, l2, c2, _] = getpos("'" . marks[1])
    if l1 == l2
        return
    endif
    for line in getline(l1, l2)
        call setline(l2, line)
        let l2 -= 1
    endfor
endfun

nnoremap <Leader>ma :call Add_to_pins()<CR>
nnoremap <Leader>ms :call Show_pins()<CR>
nnoremap <Leader>1 :call Switch_to_pins(1)<CR>
nnoremap <Leader>2 :call Switch_to_pins(2)<CR>
nnoremap <Leader>3 :call Switch_to_pins(3)<CR>
nnoremap <Leader>4 :call Switch_to_pins(4)<CR>
nnoremap <Leader>5 :call Switch_to_pins(5)<CR>
nnoremap <Leader>6 :call Switch_to_pins(6)<CR>
nnoremap <Leader>7 :call Switch_to_pins(7)<CR>
nnoremap <Leader>8 :call Switch_to_pins(8)<CR>
nnoremap <Leader>9 :call Switch_to_pins(9)<CR>
nnoremap <Leader>0 :call Switch_to_pins(0)<CR>

fun s:Add_to_pins() 
   let file_info = expand('%:p') . line('.')
   call writefile(file_info, "~/.vim/pins", "a")
endfun
fun s:Show_pins()
   execute "find ~/.vim/pins"
endfun
fun s:Switch_to_pin(idx)
   let file_info = system("sed -n '" . a:idx . "p' ~/.vim/pins")  
   execute "find " . file_info
endfun
