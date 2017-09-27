if !exists('g:polyglot_disabled') || index(g:polyglot_disabled, 'vim') == -1
  
" Vim Compiler File
" Compiler:	xmlwf
" Maintainer:	Robert Rowsome <rowsome@wam.umd.edu>
" Last Change:	2004 Mar 27

if exists("current_compiler")
  finish
endif
let current_compiler = "xmlwf"

let s:cpo_save = &cpo
set cpo&vim

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=xmlwf\ %

CompilerSet errorformat=%f:%l%c:%m

let &cpo = s:cpo_save
unlet s:cpo_save

endif
