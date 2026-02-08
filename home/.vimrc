"" ----------------------------------------------
"" Helpful Links

"" ----------------------------------------------
"" Imports
source ~/.vim/colors/catppuccin_mocha.vim
source ~/.vim/utils.vim

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
" replace tab with spaces and set the tab size to 3
set shiftwidth=3 smarttab
set expandtab
" map - to go up a directory
"" first, make sure we're in the directory of the buffer - without this it sometimes gets out of sync!
nnoremap - :call chdir(expand('%:p:h'))<CR>:Explore %:h<CR>
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
" Map to change cwd to the dir of the current buffer
nnoremap cm :call chdir(expand('%:p:h')) <bar> pwd<CR>
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
" TODO: get sk --> "keymaps in scratch buffer" working
nnoremap <Leader>sk :vnew <bar> :normal! :map <bar> :setlocal buftype=nofile bufhidden=wipe noswapfile<CR>
" go to definition c++
nnoremap <Leader>gd :call Cxx_go_to_file_on_include_path()<CR>
" git
nnoremap <Leader>gc :cexpr system('list_git_conflicts')<Cr>:copen<CR>
" todos
nnoremap <Leader>st :vimgrep /todo\c/ **/*<Cr>
nnoremap <Leader>bt :vimgrep /todo\c/ %<Cr>
" list files
nnoremap <Leader>lpf :call <SID>Cd_to_repo_root()<CR>:call All_files_to_qflist()<CR>:copen<CR>
nnoremap <Leader>ldf :call All_files_to_qflist()<CR>:copen<CR>
function! All_files_to_qflist()
	" Find all .txt files in the current dir and subdirs
	let files = filter(glob('**/*', 0, 1), '!isdirectory(v:val)')

	" map list of filenames to a list of quickfix entries
	let qflist = map(files, '{"filename": v:val, "lnum": 1}')

	" set the quickfix list
	call setqflist(qflist)
endfunction
" quit
nnoremap <Leader>q :q<Cr>
nnoremap <Leader>w :w<Cr>
" Quick Fix List
nnoremap <Leader>co :copen<Cr>
nnoremap <Leader>cc :cclose<Cr>
nnoremap <Leader>cj :cnext<Cr>
nnoremap <Leader>ck :cprevious<Cr>
nnoremap <Leader>cG :clast<Cr>
nnoremap <Leader>cgg :first<Cr>
" 'fzf' like switcher
nnoremap <C-f> :SwitchProject ~/projects/
" TODO: function and mapping to clean sessions (delete all existing session files)
function! SourceDynamicFile(filename)
	execute "source" a:filename
endfunction
function! LoadSession(file)
	" Cache off existing session
        let fwr = system("find_workspace_root")
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
" global todos
nnoremap <C-g> :find ~/notes/todo.md<CR>
" project todos
nnoremap <Leader>pt :call EditFile(trim(system('find_workspace_root')) . "/todo.md")<CR>
function! EditFile(file)
   if filereadable(expand(a:file))
      execute 'find ' . a:file
   else
      execute 'e ' . a:file
   endif
endfunction
" open command mode with running shell command
nnoremap <Leader>e :!
" terminal
nnoremap <Leader>to :terminal<CR>
nnoremap <Leader>tp :call Cd_to_repo_root()<CR>:terminal<CR>
" jump over paragraphs
noremap <silent> <expr> <C-k> (line('.') - search('^\n.\+$', 'Wenb')) . 'kzv^'
noremap <silent> <expr> <C-j> (search('^\n.\+$', 'Wenb') - line('.')) . 'jzv^'
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
" File switching
nnoremap <Leader>ma :call Add_to_pins()<CR>
nnoremap <Leader>ms :call Show_pins()<CR>
nnoremap <Leader>mo :call Open_file_under_cursor()<CR>
nnoremap <Leader>1 :call Switch_to_pin(1)<CR>
nnoremap <Leader>2 :call Switch_to_pin(2)<CR>
nnoremap <Leader>3 :call Switch_to_pin(3)<CR>
nnoremap <Leader>4 :call Switch_to_pin(4)<CR>
nnoremap <Leader>5 :call Switch_to_pin(5)<CR>
nnoremap <Leader>6 :call Switch_to_pin(6)<CR>
nnoremap <Leader>7 :call Switch_to_pin(7)<CR>
nnoremap <Leader>8 :call Switch_to_pin(8)<CR>
nnoremap <Leader>9 :call Switch_to_pin(9)<CR>
nnoremap <Leader>0 :call Switch_to_pin(10)<CR>
fun Add_to_pins() 
   let file_info = expand('%:p') . " | " .  line('.')
   let l:cmd = "append_to_first_open_line --file home/dang/.vim/pins --text " . file_info 
   echo l:cmd
   system(l:cmd)  
endfun
fun Show_pins()
   exe "find /home/dang/.vim/pins"
endfun
fun Open_file_under_cursor() 
   let current_line = getline('.')
   execute "find " . current_line
endfun
fun Switch_to_pin(idx)
   let file_info = system("sed -n '" . a:idx . "p' /home/dang/.vim/pins")  
   execute "find " . file_info
endfun
autocmd BufRead,BufNewFile /home/dang/.vim/pins map <buffer> <CR> :call Open_file_under_cursor()<CR>

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

"" ----------------------------------------------
"" Color Scheme
set termguicolors
syntax on
