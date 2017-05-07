# vim-clang-rename
[![Build Status](https://travis-ci.org/uplus/vim-clang-rename.svg?branch=master)](https://travis-ci.org/uplus/vim-clang-rename)  
Vim plugin for clang-rename, clang-rename is a C++ refactoring tool.

## Requirements
- `clang-rename` command. https://clang.llvm.org/extra/clang-rename.html

### Installation clang-rename

#### Arch

Install `clang-tools-extra` package.


#### Ubuntu

Install `clang-3.5` or later package.


## Usage

Available `:ClangRenameCurrent`, `:ClangRenameQualifiedName` and more.  

[![asciicast](https://asciinema.org/a/119553.png)](https://asciinema.org/a/119553)  


## Configure

```vim
  au FileType c,cpp nmap <buffer><silent>,lr <Plug>(clang_rename-current)
```
