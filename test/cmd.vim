let s:suite = themis#suite('cmd')
let s:assert = themis#helper('assert')

let s:file = tempname() . '.cpp'

if exists('$CLANG_RENAME')
  let g:clang_rename#command = $CLANG_RENAME
endif

function! s:suite.before_each() abort
  exec 'edit!' s:file
  %delete
  put! ='int a=0, b=a;'
  write
  call system(printf('echo %s >>/tmp/out', bufnr('%') . bufname('%') . bufname(s:file)))
endfunction

function! s:suite.clang_rename_executable() abort
  call s:assert.true(executable(g:clang_rename#command))
endfunction

if clang_rename#is_support_qualified_name()
  function! s:suite.qualified_name() abort
    ClangRenameQualifiedName a X
    edit
    call s:assert.equals(getline(1), 'int X=0, b=X;')
  endfunction
endif

function! s:suite.offset() abort
  ClangRenameOffset 4 X
  edit
  call s:assert.equals(getline(1), 'int X=0, b=X;')
endfunction

function! s:suite.cursor_pos() abort
  normal! ^fa
  ClangRenameCurrent X
  edit
  call s:assert.equals(getline(1), 'int X=0, b=X;')
endfunction
