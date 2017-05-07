if exists('g:loaded_clang_rename')
  finish
endif

command! -nargs=* ClangRename call s:clang_rename(<f-args>)
command! -nargs=? ClangRenameCurrent call s:clang_rename_offset(-1, <q-args>)
command! -nargs=* ClangRenameOffset call s:clang_rename_offset(<f-args>)
command! -nargs=* ClangRenameQualifiedName call s:clang_rename_qualified_name(<f-args>)

function! s:clang_rename(...) abort "{{{
  if a:0 == 0
    ClangRenameCurrent
  elseif a:0 == 1
    exec 'ClangRenameCurrent' a:1
  elseif a:0 == 2
    exec 'ClangRenameQualifiedName' a:1 a:2
  endif
endfunction "}}}

" call clang_rename_offset(offset=-1, new_name='')
function! s:clang_rename_offset(...) abort "{{{
  let offset = get(a:000, 0, -1)
  let new_name = get(a:000, 1, '')
  let result = clang_rename#offset(offset, new_name, [])
  redraw
  echo get(split(result, "\n"), -2, '')
endfunction "}}}

" call clang_rename_qualified_name(old_name='', new_name='')
function! s:clang_rename_qualified_name(...) abort "{{{
  let old_name = get(a:000, 0, '')
  let new_name = get(a:000, 1, '')
  let result = clang_rename#qualified_name(old_name, new_name, [])
  redraw
  echo get(split(result, "\n"), -2, '')
endfunction "}}}

let g:loaded_clang_rename = 1
" vim: et ts=2 sts=2 sw=2 tw=0 ff=unix fdm=marker:
