let s:save_cpo = &cpo
set cpo&vim

" #variables {{{
let g:clang_rename#command = get(g:, 'clang_rename#command', 'clang-rename')
if !executable(g:clang_rename#command)
  echohl ErrorMsg
  echomsg printf("Error: '%s' not found", g:clang_rename#command)
  echohl None
  finish
endif

let g:clang_rename#default_compile_flags = {
  \ 'c': ['-std=gnu11'],
  \ 'cpp': ['-std=c++11'],
  \ }
let g:clang_rename#compile_flags = get(g:, 'clang_rename#compile_flags', {})
call extend(g:clang_rename#compile_flags, g:clang_rename#default_compile_flags, 'keep')

let g:clang_rename#flags = get(g:, 'clang_rename#flags', [])
"}}}

" #core functions {{{
function! clang_rename#core(opts, new_name, files) abort "{{{
  let flags = get(b: , 'clang_rename_flags', g:clang_rename#flags)
  let compile_flags = get(b:, 'clang_rename_compile_flags', get(g:clang_rename#compile_flags, &ft, []))
  let cmd_list = [g:clang_rename#command, '-i', '-new-name=' . a:new_name]
    \ + a:opts
    \ + flags
    \ + a:files
    \ + ['--'] + compile_flags + ['...']
  let cmd_str = join(map(cmd_list, 'shellescape(v:val)'), ' ')

  let result = system(cmd_str)
  for f in a:files
    let bufname = bufname(f)
    if bufname !=# ''
      silent exec 'checktime' f
    endif
  endfor
  return result
endfunction "}}}

function! clang_rename#core_offset(offset, new_name, files) abort "{{{
  let opts = ['-offset=' . a:offset]
  return clang_rename#rename(opts, a:new_name, a:files)
endfunction "}}}

function! clang_rename#core_qualified_name(qualified_name, new_name, files) abort "{{{
  let opts = ['-qualified-name=' . a:qualified_name]
  return clang_rename#rename(opts, a:new_name, a:files)
endfunction "}}}
"}}}

" #interfaces {{{
function! clang_rename#rename(opts, new_name, files) abort "{{{
  let new_name = a:new_name !=# '' ? a:new_name : input('New name> ')
  if new_name ==# ''
    return
  endif
  let files = a:files != [] ? a:files : [bufname('%')]
  return clang_rename#core(a:opts, new_name, files)
endfunction "}}}

function! clang_rename#offset(offset, new_name, files) abort "{{{
  let offset = a:offset
  if offset < 0
    let offset = clang_rename#get_cursor_offset()
  endif
  return clang_rename#core_offset(offset, a:new_name, a:files)
endfunction "}}}

function! clang_rename#qualified_name(qualified_name, new_name, files) abort "{{{
  let qualified_name = a:qualified_name
  if qualified_name ==# ''
    let qualified_name = input('Qualified Name> ')
  endif
  return clang_rename#core_qualified_name(qualified_name, a:new_name, a:files)
endfunction "}}}
"}}}

" #misc
function! clang_rename#get_cursor_offset() abort "{{{
  return line2byte('.') + col('.') - 2
endfunction "}}}

function! clang_rename#is_support_qualified_name() abort "{{{
  return '' !=# system(printf("%s --help | grep 'qualified-name'", g:clang_rename#command))
endfunction "}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: et ts=2 sts=2 sw=2 tw=0 ff=unix fdm=marker:
