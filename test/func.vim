let s:suite = themis#suite('func')
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

" qualified name
if clang_rename#is_support_qualified_name()
  function! s:suite.core_qualified_name() abort
    call clang_rename#core_qualified_name('a', 'X', [s:file])
    edit
    call s:assert.equals(getline(1), 'int X=0, b=X;')
  endfunction

  function! s:suite.qualified_name() abort
    call clang_rename#qualified_name('a', 'X', [])
    edit
    call s:assert.equals(getline(1), 'int X=0, b=X;')
  endfunction
endif


" offset
function! s:suite.core_offset() abort
  call clang_rename#core_offset(5-1, 'X', [s:file])
  edit
  call s:assert.equals(getline(1), 'int X=0, b=X;')
endfunction

function! s:suite.offset() abort
  call clang_rename#offset(5-1, 'X', [])
  edit
  call s:assert.equals(getline(1), 'int X=0, b=X;')
endfunction

function! s:suite.cursor_pos() abort
  normal! ^fa
  call clang_rename#offset(-1, 'X', [])
  edit
  call s:assert.equals(getline(1), 'int X=0, b=X;')
endfunction
