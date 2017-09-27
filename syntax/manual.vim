if !exists('g:polyglot_disabled') || index(g:polyglot_disabled, 'vim') == -1
  
" Vim syntax support file
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last Change:	2016 Feb 01

" This file is used for ":syntax manual".
" It installs the Syntax autocommands, but no the FileType autocommands.

if !has("syntax")
  finish
endif

" Load the Syntax autocommands and set the default methods for highlighting.
if !exists("syntax_on")
  so <sfile>:p:h/synload.vim
endif

let syntax_manual = 1

" Overrule the connection between FileType and Syntax autocommands.  This sets
" the syntax when the file type is detected, without changing the value.
augroup syntaxset
  au! FileType *	exe "set syntax=" . &syntax
augroup END

" If the GUI is already running, may still need to install the FileType menu.
" Don't do it when the 'M' flag is included in 'guioptions'.
if has("menu") && has("gui_running") && !exists("did_install_syntax_menu") && &guioptions !~# 'M'
  source $VIMRUNTIME/menu.vim
endif

endif
