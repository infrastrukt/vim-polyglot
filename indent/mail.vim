if !exists('g:polyglot_disabled') || index(g:polyglot_disabled, 'vim') == -1
  
" Vim indent file
" Language:	Mail
" Maintainer:	Bram Moolenaar
" Last Change:	2009 Jun 03

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

" What works best is auto-indenting, disable other indenting.
" For formatting see the ftplugin.
setlocal autoindent nosmartindent nocindent indentexpr=

endif
