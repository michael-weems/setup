let maplocalleader = "\\"

" go to definition c++
nnoremap <LocalLeader>gd :call Cxx_go_to_file_on_include_path()<CR>

function! Extract_text(line_number)
    " Get the content of the specified line
    let line_content = getline(a:line_number)
    if line_content =~ '"'
      return matchstr(line_content, '"\\zs[^"]\\+\\ze"')
    elseif line_content =~ '<'
      return matchstr(line_content, '<\zs.\{-}\ze>')
    else
      echo "line is not an include line"
    endif
endfunction

function! Cxx_go_to_file_on_include_path()
    let header_file = Extract_text(".")
    let dir = trim(system('find_workspace_root'))
    let cmd = 'find_file "' . trim(header_file) . '" "' . dir . '"'
    let file_info = system(cmd)
    cgetexpr file_info
    cfirst
endfunction
