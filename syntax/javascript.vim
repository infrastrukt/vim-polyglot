if !exists('g:polyglot_disabled') || index(g:polyglot_disabled, 'vim') == -1
  
" Vim syntax file
" Language:	JavaScript
" Maintainer:	Claudio Fleiner <claudio@fleiner.com>
" Updaters:	Scott Shattuck (ss) <ss@technicalpursuit.com>
" URL:		http://www.fleiner.com/vim/syntax/javascript.vim
" Changes:	(ss) added keywords, reserved words, and other identifiers
"		(ss) repaired several quoting and grouping glitches
"		(ss) fixed regex parsing issue with multiple qualifiers [gi]
"		(ss) additional factoring of keywords, globals, and members
" Last Change:	2012 Oct 05
" 		2013 Jun 12: adjusted javaScriptRegexpString (Kevin Locke)

" tuning parameters:
" unlet javaScript_fold

if !exists("main_syntax")
  " quit when a syntax file was already loaded
  if exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'javascript'
elseif exists("b:current_syntax") && b:current_syntax == "javascript"
  finish
endif

let s:cpo_save = &cpo
set cpo&vim


syn keyword javaScriptCommentTodo      TODO FIXME XXX TBD contained
syn match   javaScriptLineComment      "\/\/.*" contains=@Spell,javaScriptCommentTodo
syn match   javaScriptCommentSkip      "^[ \t]*\*\($\|[ \t]\+\)"
syn region  javaScriptComment	       start="/\*"  end="\*/" contains=@Spell,javaScriptCommentTodo
syn match   javaScriptSpecial	       "\\\d\d\d\|\\."
syn region  javaScriptStringD	       start=+"+  skip=+\\\\\|\\"+  end=+"\|$+	contains=javaScriptSpecial,@htmlPreproc
syn region  javaScriptStringS	       start=+'+  skip=+\\\\\|\\'+  end=+'\|$+	contains=javaScriptSpecial,@htmlPreproc

syn match   javaScriptSpecialCharacter "'\\.'"
syn match   javaScriptNumber	       "-\=\<\d\+L\=\>\|0[xX][0-9a-fA-F]\+\>"
syn region  javaScriptRegexpString     start=+/[^/*]+me=e-1 skip=+\\\\\|\\/+ end=+/[gim]\{0,2\}\s*$+ end=+/[gim]\{0,2\}\s*[;.,)\]}]+me=e-1 contains=@htmlPreproc oneline

syn keyword javaScriptConditional	if else switch
syn keyword javaScriptRepeat		while for do in
syn keyword javaScriptBranch		break continue
syn keyword javaScriptOperator		new delete instanceof typeof
syn keyword javaScriptType		Array Boolean Date Function Number Object String RegExp
syn keyword javaScriptStatement		return with
syn keyword javaScriptBoolean		true false
syn keyword javaScriptNull		null undefined
syn keyword javaScriptIdentifier	arguments this var let
syn keyword javaScriptLabel		case default
syn keyword javaScriptException		try catch finally throw
syn keyword javaScriptMessage		alert confirm prompt status
syn keyword javaScriptGlobal		self window top parent
syn keyword javaScriptMember		document event location 
syn keyword javaScriptDeprecated	escape unescape
syn keyword javaScriptReserved		abstract boolean byte char class const debugger double enum export extends final float goto implements import int interface long native package private protected public short static super synchronized throws transient volatile 

if exists("javaScript_fold")
    syn match	javaScriptFunction	"\<function\>"
    syn region	javaScriptFunctionFold	start="\<function\>.*[^};]$" end="^\z1}.*$" transparent fold keepend

    syn sync match javaScriptSync	grouphere javaScriptFunctionFold "\<function\>"
    syn sync match javaScriptSync	grouphere NONE "^}"

    setlocal foldmethod=syntax
    setlocal foldtext=getline(v:foldstart)
else
    syn keyword javaScriptFunction	function
    syn match	javaScriptBraces	   "[{}\[\]]"
    syn match	javaScriptParens	   "[()]"
endif

syn sync fromstart
syn sync maxlines=100

if main_syntax == "javascript"
  syn sync ccomment javaScriptComment
endif

" Define the default highlighting.
" Only when an item doesn't have highlighting yet
hi def link javaScriptComment		Comment
hi def link javaScriptLineComment		Comment
hi def link javaScriptCommentTodo		Todo
hi def link javaScriptSpecial		Special
hi def link javaScriptStringS		String
hi def link javaScriptStringD		String
hi def link javaScriptCharacter		Character
hi def link javaScriptSpecialCharacter	javaScriptSpecial
hi def link javaScriptNumber		javaScriptValue
hi def link javaScriptConditional		Conditional
hi def link javaScriptRepeat		Repeat
hi def link javaScriptBranch		Conditional
hi def link javaScriptOperator		Operator
hi def link javaScriptType			Type
hi def link javaScriptStatement		Statement
hi def link javaScriptFunction		Function
hi def link javaScriptBraces		Function
hi def link javaScriptError		Error
hi def link javaScrParenError		javaScriptError
hi def link javaScriptNull			Keyword
hi def link javaScriptBoolean		Boolean
hi def link javaScriptRegexpString		String

hi def link javaScriptIdentifier		Identifier
hi def link javaScriptLabel		Label
hi def link javaScriptException		Exception
hi def link javaScriptMessage		Keyword
hi def link javaScriptGlobal		Keyword
hi def link javaScriptMember		Keyword
hi def link javaScriptDeprecated		Exception 
hi def link javaScriptReserved		Keyword
hi def link javaScriptDebug		Debug
hi def link javaScriptConstant		Label


let b:current_syntax = "javascript"
if main_syntax == 'javascript'
  unlet main_syntax
endif
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: ts=8

endif
if !exists('g:polyglot_disabled') || index(g:polyglot_disabled, 'javascript') == -1
  
" Vim syntax file
" Language:     JavaScript
" Maintainer:   vim-javascript community
" URL:          https://github.com/pangloss/vim-javascript

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'javascript'
endif

" Dollar sign is permitted anywhere in an identifier
if v:version > 704 || v:version == 704 && has('patch1142')
  syntax iskeyword @,48-57,_,192-255,$
else
  setlocal iskeyword+=$
endif

syntax sync fromstart
" TODO: Figure out what type of casing I need
" syntax case ignore
syntax case match

syntax match   jsNoise          /[:,\;]\{1}/
syntax match   jsNoise          /[\.]\{1}/ skipwhite skipempty nextgroup=jsObjectProp,jsFuncCall,jsPrototype,jsTaggedTemplate
syntax match   jsObjectProp     contained /\<[a-zA-Z_$][0-9a-zA-Z_$]*\>/
syntax match   jsFuncCall       /\k\+\%(\s*(\)\@=/
syntax match   jsParensError    /[)}\]]/

" Program Keywords
syntax keyword jsStorageClass   const var let skipwhite skipempty nextgroup=jsDestructuringBlock,jsDestructuringArray,jsVariableDef
syntax match   jsVariableDef    contained /\k\+/ skipwhite skipempty nextgroup=jsFlowDefinition
syntax keyword jsOperator       delete instanceof typeof void new in of skipwhite skipempty nextgroup=@jsExpression
syntax match   jsOperator       /[\!\|\&\+\-\<\>\=\%\/\*\~\^]\{1}/ skipwhite skipempty nextgroup=@jsExpression
syntax match   jsOperator       /::/ skipwhite skipempty nextgroup=@jsExpression
syntax keyword jsBooleanTrue    true
syntax keyword jsBooleanFalse   false

" Modules
syntax keyword jsImport                       import skipwhite skipempty nextgroup=jsModuleAsterisk,jsModuleKeyword,jsModuleGroup,jsFlowImportType
syntax keyword jsExport                       export skipwhite skipempty nextgroup=@jsAll,jsModuleGroup,jsExportDefault,jsModuleAsterisk,jsModuleKeyword,jsFlowTypeStatement
syntax match   jsModuleKeyword      contained /\k\+/ skipwhite skipempty nextgroup=jsModuleAs,jsFrom,jsModuleComma
syntax keyword jsExportDefault      contained default skipwhite skipempty nextgroup=@jsExpression
syntax keyword jsExportDefaultGroup contained default skipwhite skipempty nextgroup=jsModuleAs,jsFrom,jsModuleComma
syntax match   jsModuleAsterisk     contained /\*/ skipwhite skipempty nextgroup=jsModuleKeyword,jsModuleAs,jsFrom
syntax keyword jsModuleAs           contained as skipwhite skipempty nextgroup=jsModuleKeyword,jsExportDefaultGroup
syntax keyword jsFrom               contained from skipwhite skipempty nextgroup=jsString
syntax match   jsModuleComma        contained /,/ skipwhite skipempty nextgroup=jsModuleKeyword,jsModuleAsterisk,jsModuleGroup,jsFlowTypeKeyword

" Strings, Templates, Numbers
syntax region  jsString           start=+"+  skip=+\\\("\|$\)+  end=+"\|$+  contains=jsSpecial,@Spell extend
syntax region  jsString           start=+'+  skip=+\\\('\|$\)+  end=+'\|$+  contains=jsSpecial,@Spell extend
syntax region  jsTemplateString   start=+`+  skip=+\\\(`\|$\)+  end=+`+     contains=jsTemplateExpression,jsSpecial,@Spell extend
syntax match   jsTaggedTemplate   /\k\+\%(`\)\@=/ nextgroup=jsTemplateString
syntax match   jsNumber           /\<\d\+\%([eE][+-]\=\d\+\)\=\>\|\<0[bB][01]\+\>\|\<0[oO]\o\+\>\|\<0[xX]\x\+\>/
syntax keyword jsNumber           Infinity
syntax match   jsFloat            /\<\%(\d\+\.\d\+\|\d\+\.\|\.\d\+\)\%([eE][+-]\=\d\+\)\=\>/

" Regular Expressions
syntax match   jsSpecial            contained "\v\\%(0|\\x\x\{2\}\|\\u\x\{4\}\|\c[A-Z]|.)"
syntax region  jsTemplateExpression contained matchgroup=jsTemplateBraces start=+${+ end=+}+ contains=@jsExpression keepend
syntax region  jsRegexpCharClass    contained start=+\[+ skip=+\\.+ end=+\]+
syntax match   jsRegexpBoundary     contained "\v%(\<@![\^$]|\\[bB])"
syntax match   jsRegexpBackRef      contained "\v\\[1-9][0-9]*"
syntax match   jsRegexpQuantifier   contained "\v\\@<!%([?*+]|\{\d+%(,|,\d+)?})\??"
syntax match   jsRegexpOr           contained "\v\<@!\|"
syntax match   jsRegexpMod          contained "\v\(@<=\?[:=!>]"
syntax region  jsRegexpGroup        contained start="\\\@<!(" skip="\\.\|\[\(\\.\|[^]]\)*\]" end="\\\@<!)" contains=jsRegexpCharClass,@jsRegexpSpecial keepend
if v:version > 703 || v:version == 603 && has("patch1088")
  syntax region  jsRegexpString   start=+\%(\%(\%(return\|case\)\s\+\)\@50<=\|\%(\%([)\]"']\|\d\|\w\)\s*\)\@50<!\)/\(\*\|/\)\@!+ skip=+\\.\|\[\%(\\.\|[^]]\)*\]+ end=+/[gimyu]\{,5}+ contains=jsRegexpCharClass,jsRegexpGroup,@jsRegexpSpecial oneline keepend extend
else
  syntax region  jsRegexpString   start=+\%(\%(\%(return\|case\)\s\+\)\@<=\|\%(\%([)\]"']\|\d\|\w\)\s*\)\@<!\)/\(\*\|/\)\@!+ skip=+\\.\|\[\%(\\.\|[^]]\)*\]+ end=+/[gimyu]\{,5}+ contains=jsRegexpCharClass,jsRegexpGroup,@jsRegexpSpecial oneline keepend extend
endif
syntax cluster jsRegexpSpecial    contains=jsSpecial,jsRegexpBoundary,jsRegexpBackRef,jsRegexpQuantifier,jsRegexpOr,jsRegexpMod

" Objects
syntax match   jsObjectKey         contained /\<[0-9a-zA-Z_$]*\>\(\s*:\)\@=/ contains=jsFunctionKey skipwhite skipempty nextgroup=jsObjectValue
syntax match   jsObjectColon       contained /:/ skipwhite skipempty
syntax region  jsObjectKeyString   contained start=+"+  skip=+\\\("\|$\)+  end=+"\|$+  contains=jsSpecial,@Spell skipwhite skipempty nextgroup=jsObjectValue
syntax region  jsObjectKeyString   contained start=+'+  skip=+\\\('\|$\)+  end=+'\|$+  contains=jsSpecial,@Spell skipwhite skipempty nextgroup=jsObjectValue
syntax region  jsObjectKeyComputed contained matchgroup=jsBrackets start=/\[/ end=/]/ contains=@jsExpression skipwhite skipempty nextgroup=jsObjectValue,jsFuncArgs extend
syntax match   jsObjectSeparator   contained /,/
syntax region  jsObjectValue       contained matchgroup=jsNoise start=/:/ end=/\%(,\|}\)\@=/ contains=@jsExpression extend
syntax match   jsObjectFuncName    contained /\<[a-zA-Z_$][0-9a-zA-Z_$]*\>[\r\n\t ]*(\@=/ skipwhite skipempty nextgroup=jsFuncArgs
syntax match   jsFunctionKey       contained /\<[a-zA-Z_$][0-9a-zA-Z_$]*\>\(\s*:\s*function\s*\)\@=/
syntax match   jsObjectMethodType  contained /\%(get\|set\)\%( \k\+\)\@=/ skipwhite skipempty nextgroup=jsObjectFuncName
syntax region  jsObjectStringKey   contained start=+"+  skip=+\\\("\|$\)+  end=+"\|$+  contains=jsSpecial,@Spell extend skipwhite skipempty nextgroup=jsFuncArgs,jsObjectValue
syntax region  jsObjectStringKey   contained start=+'+  skip=+\\\('\|$\)+  end=+'\|$+  contains=jsSpecial,@Spell extend skipwhite skipempty nextgroup=jsFuncArgs,jsObjectValue

exe 'syntax keyword jsNull      null             '.(exists('g:javascript_conceal_null')      ? 'conceal cchar='.g:javascript_conceal_null       : '')
exe 'syntax keyword jsReturn    return contained '.(exists('g:javascript_conceal_return')    ? 'conceal cchar='.g:javascript_conceal_return     : '').' skipwhite skipempty nextgroup=@jsExpression'
exe 'syntax keyword jsUndefined undefined        '.(exists('g:javascript_conceal_undefined') ? 'conceal cchar='.g:javascript_conceal_undefined  : '')
exe 'syntax keyword jsNan       NaN              '.(exists('g:javascript_conceal_NaN')       ? 'conceal cchar='.g:javascript_conceal_NaN        : '')
exe 'syntax keyword jsPrototype prototype        '.(exists('g:javascript_conceal_prototype') ? 'conceal cchar='.g:javascript_conceal_prototype  : '')
exe 'syntax keyword jsThis      this             '.(exists('g:javascript_conceal_this')      ? 'conceal cchar='.g:javascript_conceal_this       : '')
exe 'syntax keyword jsSuper     super  contained '.(exists('g:javascript_conceal_super')     ? 'conceal cchar='.g:javascript_conceal_super      : '')

" Statement Keywords
syntax match   jsBlockLabel              /\<[a-zA-Z_$][0-9a-zA-Z_$]*\>\s*::\@!/    contains=jsNoise skipwhite skipempty nextgroup=jsBlock
syntax match   jsBlockLabelKey contained /\<[a-zA-Z_$][0-9a-zA-Z_$]*\>\%(\s*\%(;\|\n\)\)\@=/
syntax keyword jsStatement     contained with yield debugger
syntax keyword jsStatement     contained break continue skipwhite skipempty nextgroup=jsBlockLabelKey
syntax keyword jsConditional            if              skipwhite skipempty nextgroup=jsParenIfElse
syntax keyword jsConditional            else            skipwhite skipempty nextgroup=jsCommentIfElse,jsIfElseBlock
syntax keyword jsConditional            switch          skipwhite skipempty nextgroup=jsParenSwitch
syntax keyword jsRepeat                 while for       skipwhite skipempty nextgroup=jsParenRepeat,jsForAwait
syntax keyword jsDo                     do              skipwhite skipempty nextgroup=jsRepeatBlock
syntax region  jsSwitchCase   contained matchgroup=jsLabel start=/\<\%(case\|default\)\>/ end=/:\@=/ contains=@jsExpression,jsLabel skipwhite skipempty nextgroup=jsSwitchColon keepend
syntax keyword jsTry                    try             skipwhite skipempty nextgroup=jsTryCatchBlock
syntax keyword jsFinally      contained finally         skipwhite skipempty nextgroup=jsFinallyBlock
syntax keyword jsCatch        contained catch           skipwhite skipempty nextgroup=jsParenCatch
syntax keyword jsException              throw
syntax keyword jsAsyncKeyword           async await
syntax match   jsSwitchColon   contained /::\@!/        skipwhite skipempty nextgroup=jsSwitchBlock

" Keywords
syntax keyword jsGlobalObjects      Array Boolean Date Function Iterator Number Object Symbol Map WeakMap Set RegExp String Proxy Promise Buffer ParallelArray ArrayBuffer DataView Float32Array Float64Array Int16Array Int32Array Int8Array Uint16Array Uint32Array Uint8Array Uint8ClampedArray JSON Math console document window Intl Collator DateTimeFormat NumberFormat fetch
syntax keyword jsGlobalNodeObjects  module exports global process __dirname __filename
syntax match   jsGlobalNodeObjects  /\<require\>/ containedin=jsFuncCall
syntax keyword jsExceptions         Error EvalError InternalError RangeError ReferenceError StopIteration SyntaxError TypeError URIError
syntax keyword jsBuiltins           decodeURI decodeURIComponent encodeURI encodeURIComponent eval isFinite isNaN parseFloat parseInt uneval
" DISCUSS: How imporant is this, really? Perhaps it should be linked to an error because I assume the keywords are reserved?
syntax keyword jsFutureKeys         abstract enum int short boolean interface byte long char final native synchronized float package throws goto private transient implements protected volatile double public

" DISCUSS: Should we really be matching stuff like this?
" DOM2 Objects
syntax keyword jsGlobalObjects  DOMImplementation DocumentFragment Document Node NodeList NamedNodeMap CharacterData Attr Element Text Comment CDATASection DocumentType Notation Entity EntityReference ProcessingInstruction
syntax keyword jsExceptions     DOMException

" DISCUSS: Should we really be matching stuff like this?
" DOM2 CONSTANT
syntax keyword jsDomErrNo       INDEX_SIZE_ERR DOMSTRING_SIZE_ERR HIERARCHY_REQUEST_ERR WRONG_DOCUMENT_ERR INVALID_CHARACTER_ERR NO_DATA_ALLOWED_ERR NO_MODIFICATION_ALLOWED_ERR NOT_FOUND_ERR NOT_SUPPORTED_ERR INUSE_ATTRIBUTE_ERR INVALID_STATE_ERR SYNTAX_ERR INVALID_MODIFICATION_ERR NAMESPACE_ERR INVALID_ACCESS_ERR
syntax keyword jsDomNodeConsts  ELEMENT_NODE ATTRIBUTE_NODE TEXT_NODE CDATA_SECTION_NODE ENTITY_REFERENCE_NODE ENTITY_NODE PROCESSING_INSTRUCTION_NODE COMMENT_NODE DOCUMENT_NODE DOCUMENT_TYPE_NODE DOCUMENT_FRAGMENT_NODE NOTATION_NODE

" DISCUSS: Should we really be special matching on these props?
" HTML events and internal variables
syntax keyword jsHtmlEvents     onblur onclick oncontextmenu ondblclick onfocus onkeydown onkeypress onkeyup onmousedown onmousemove onmouseout onmouseover onmouseup onresize

" Code blocks
syntax region  jsBracket                      matchgroup=jsBrackets            start=/\[/ end=/\]/ contains=@jsExpression,jsSpreadExpression extend fold
syntax region  jsParen                        matchgroup=jsParens              start=/(/  end=/)/  contains=@jsExpression extend fold nextgroup=jsFlowDefinition
syntax region  jsParenDecorator     contained matchgroup=jsParensDecorator     start=/(/  end=/)/  contains=@jsAll extend fold
syntax region  jsParenIfElse        contained matchgroup=jsParensIfElse        start=/(/  end=/)/  contains=@jsAll skipwhite skipempty nextgroup=jsCommentIfElse,jsIfElseBlock extend fold
syntax region  jsParenRepeat        contained matchgroup=jsParensRepeat        start=/(/  end=/)/  contains=@jsAll skipwhite skipempty nextgroup=jsCommentRepeat,jsRepeatBlock extend fold
syntax region  jsParenSwitch        contained matchgroup=jsParensSwitch        start=/(/  end=/)/  contains=@jsAll skipwhite skipempty nextgroup=jsSwitchBlock extend fold
syntax region  jsParenCatch         contained matchgroup=jsParensCatch         start=/(/  end=/)/  skipwhite skipempty nextgroup=jsTryCatchBlock extend fold
syntax region  jsFuncArgs           contained matchgroup=jsFuncParens          start=/(/  end=/)/  contains=jsFuncArgCommas,jsComment,jsFuncArgExpression,jsDestructuringBlock,jsDestructuringArray,jsRestExpression,jsFlowArgumentDef skipwhite skipempty nextgroup=jsCommentFunction,jsFuncBlock,jsFlowReturn extend fold
syntax region  jsClassBlock         contained matchgroup=jsClassBraces         start=/{/  end=/}/  contains=jsClassFuncName,jsClassMethodType,jsArrowFunction,jsArrowFuncArgs,jsComment,jsGenerator,jsDecorator,jsClassProperty,jsClassPropertyComputed,jsClassStringKey,jsAsyncKeyword,jsNoise extend fold
syntax region  jsFuncBlock          contained matchgroup=jsFuncBraces          start=/{/  end=/}/  contains=@jsAll,jsBlock extend fold
syntax region  jsIfElseBlock        contained matchgroup=jsIfElseBraces        start=/{/  end=/}/  contains=@jsAll,jsBlock extend fold
syntax region  jsTryCatchBlock      contained matchgroup=jsTryCatchBraces      start=/{/  end=/}/  contains=@jsAll,jsBlock skipwhite skipempty nextgroup=jsCatch,jsFinally extend fold
syntax region  jsFinallyBlock       contained matchgroup=jsFinallyBraces       start=/{/  end=/}/  contains=@jsAll,jsBlock extend fold
syntax region  jsSwitchBlock        contained matchgroup=jsSwitchBraces        start=/{/  end=/}/  contains=@jsAll,jsBlock,jsSwitchCase extend fold
syntax region  jsRepeatBlock        contained matchgroup=jsRepeatBraces        start=/{/  end=/}/  contains=@jsAll,jsBlock extend fold
syntax region  jsDestructuringBlock contained matchgroup=jsDestructuringBraces start=/{/  end=/}/  contains=jsDestructuringProperty,jsDestructuringAssignment,jsDestructuringNoise,jsDestructuringPropertyComputed,jsSpreadExpression,jsComment extend fold
syntax region  jsDestructuringArray contained matchgroup=jsDestructuringBraces start=/\[/ end=/\]/ contains=jsDestructuringPropertyValue,jsNoise,jsDestructuringProperty,jsSpreadExpression,jsComment extend fold
syntax region  jsObject             contained matchgroup=jsObjectBraces        start=/{/  end=/}/  contains=jsObjectKey,jsObjectKeyString,jsObjectKeyComputed,jsObjectSeparator,jsObjectFuncName,jsObjectMethodType,jsGenerator,jsComment,jsObjectStringKey,jsSpreadExpression,jsDecorator,jsAsyncKeyword extend fold
syntax region  jsBlock                        matchgroup=jsBraces              start=/{/  end=/}/  contains=@jsAll,jsSpreadExpression extend fold
syntax region  jsModuleGroup        contained matchgroup=jsModuleBraces        start=/{/ end=/}/   contains=jsModuleKeyword,jsModuleComma,jsModuleAs,jsComment,jsFlowTypeKeyword skipwhite skipempty nextgroup=jsFrom fold
syntax region  jsSpreadExpression   contained matchgroup=jsSpreadOperator      start=/\.\.\./ end=/[,}\]]\@=/ contains=@jsExpression
syntax region  jsRestExpression     contained matchgroup=jsRestOperator        start=/\.\.\./ end=/[,)]\@=/
syntax region  jsTernaryIf                    matchgroup=jsTernaryIfOperator   start=/?/  end=/\%(:\|[\}]\@=\)/  contains=@jsExpression extend skipwhite skipempty nextgroup=@jsExpression

syntax match   jsGenerator            contained /\*/ skipwhite skipempty nextgroup=jsFuncName,jsFuncArgs,jsFlowFunctionGroup
syntax match   jsFuncName             contained /\<[a-zA-Z_$][0-9a-zA-Z_$]*\>/ skipwhite skipempty nextgroup=jsFuncArgs,jsFlowFunctionGroup
syntax region  jsFuncArgExpression    contained matchgroup=jsFuncArgOperator start=/=/ end=/[,)]\@=/ contains=@jsExpression extend
syntax match   jsFuncArgCommas        contained ','
syntax keyword jsArguments            contained arguments
syntax keyword jsForAwait             contained await skipwhite skipempty nextgroup=jsParenRepeat

" Matches a single keyword argument with no parens
syntax match   jsArrowFuncArgs  /\k\+\s*\%(=>\)\@=/ skipwhite contains=jsFuncArgs skipwhite skipempty nextgroup=jsArrowFunction extend
" Matches a series of arguments surrounded in parens
syntax match   jsArrowFuncArgs  /([^()]*)\s*\(=>\)\@=/ contains=jsFuncArgs skipempty skipwhite nextgroup=jsArrowFunction extend

exe 'syntax match jsFunction /\<function\>/ skipwhite skipempty nextgroup=jsGenerator,jsFuncName,jsFuncArgs,jsFlowFunctionGroup skipwhite '.(exists('g:javascript_conceal_function')       ? 'conceal cchar='.g:javascript_conceal_function : '')
exe 'syntax match jsArrowFunction /=>/      skipwhite skipempty nextgroup=jsFuncBlock,jsCommentFunction                                   '.(exists('g:javascript_conceal_arrow_function') ? 'conceal cchar='.g:javascript_conceal_arrow_function : '')
exe 'syntax match jsArrowFunction /()\s*\(=>\)\@=/   skipwhite skipempty nextgroup=jsArrowFunction                                        '.(exists('g:javascript_conceal_noarg_arrow_function') ? 'conceal cchar='.g:javascript_conceal_noarg_arrow_function : '').(' contains=jsArrowFuncArgs')
exe 'syntax match jsArrowFunction /_\s*\(=>\)\@=/    skipwhite skipempty nextgroup=jsArrowFunction                                        '.(exists('g:javascript_conceal_underscore_arrow_function') ? 'conceal cchar='.g:javascript_conceal_underscore_arrow_function : '')

" Classes
syntax keyword jsClassKeyword           contained class
syntax keyword jsExtendsKeyword         contained extends skipwhite skipempty nextgroup=@jsExpression
syntax match   jsClassNoise             contained /\./
syntax match   jsClassMethodType        contained /\%(get\|set\|static\)\%( \k\+\)\@=/ skipwhite skipempty nextgroup=jsAsyncKeyword,jsFuncName,jsClassProperty
syntax region  jsClassDefinition                  start=/\<class\>/ end=/\(\<extends\>\s\+\)\@<!{\@=/ contains=jsClassKeyword,jsExtendsKeyword,jsClassNoise,@jsExpression,jsFlowClassGroup skipwhite skipempty nextgroup=jsCommentClass,jsClassBlock,jsFlowClassGroup
syntax match   jsClassProperty          contained /\<[0-9a-zA-Z_$]*\>\(\s*[=:]\)\@=/ skipwhite skipempty nextgroup=jsClassValue,jsFlowClassDef
syntax region  jsClassValue             contained start=/=/ end=/\%(;\|}\|\n\)\@=/ contains=@jsExpression
syntax region  jsClassPropertyComputed  contained matchgroup=jsBrackets start=/\[/ end=/]/ contains=@jsExpression skipwhite skipempty nextgroup=jsFuncArgs,jsClassValue extend
syntax match   jsClassFuncName          contained /\<[a-zA-Z_$][0-9a-zA-Z_$]*\>\%(\s*(\)\@=/ skipwhite skipempty nextgroup=jsFuncArgs
syntax region  jsClassStringKey         contained start=+"+  skip=+\\\("\|$\)+  end=+"\|$+  contains=jsSpecial,@Spell extend skipwhite skipempty nextgroup=jsFuncArgs
syntax region  jsClassStringKey         contained start=+'+  skip=+\\\('\|$\)+  end=+'\|$+  contains=jsSpecial,@Spell extend skipwhite skipempty nextgroup=jsFuncArgs

" Destructuring
syntax match   jsDestructuringPropertyValue     contained /\<[0-9a-zA-Z_$]*\>/
syntax match   jsDestructuringProperty          contained /\<[0-9a-zA-Z_$]*\>\(\s*=\)\@=/ skipwhite skipempty nextgroup=jsDestructuringValue
syntax match   jsDestructuringAssignment        contained /\<[0-9a-zA-Z_$]*\>\(\s*:\)\@=/ skipwhite skipempty nextgroup=jsDestructuringValueAssignment
syntax region  jsDestructuringValue             contained start=/=/ end=/[,}\]]\@=/ contains=@jsExpression extend
syntax region  jsDestructuringValueAssignment   contained start=/:/ end=/[,}=]\@=/ contains=jsDestructuringPropertyValue,jsDestructuringBlock,jsNoise,jsDestructuringNoise skipwhite skipempty nextgroup=jsDestructuringValue extend
syntax match   jsDestructuringNoise             contained /[,\[\]]/
syntax region  jsDestructuringPropertyComputed  contained matchgroup=jsBrackets start=/\[/ end=/]/ contains=@jsExpression skipwhite skipempty nextgroup=jsDestructuringValue,jsDestructuringNoise extend fold

" Comments
syntax keyword jsCommentTodo    contained TODO FIXME XXX TBD
syntax region  jsComment        start=/\/\// end=/$/ contains=jsCommentTodo,@Spell extend keepend
syntax region  jsComment        start=/\/\*/  end=/\*\// contains=jsCommentTodo,@Spell fold extend keepend
syntax region  jsEnvComment     start=/\%^#!/ end=/$/ display

" Specialized Comments - These are special comment regexes that are used in
" odd places that maintain the proper nextgroup functionality. It sucks we
" can't make jsComment a skippable type of group for nextgroup
syntax region  jsCommentFunction    contained start=/\/\// end=/$/    contains=jsCommentTodo,@Spell skipwhite skipempty nextgroup=jsFuncBlock,jsFlowReturn extend keepend
syntax region  jsCommentFunction    contained start=/\/\*/ end=/\*\// contains=jsCommentTodo,@Spell skipwhite skipempty nextgroup=jsFuncBlock,jsFlowReturn fold extend keepend
syntax region  jsCommentClass       contained start=/\/\// end=/$/    contains=jsCommentTodo,@Spell skipwhite skipempty nextgroup=jsClassBlock,jsFlowClassGroup extend keepend
syntax region  jsCommentClass       contained start=/\/\*/ end=/\*\// contains=jsCommentTodo,@Spell skipwhite skipempty nextgroup=jsClassBlock,jsFlowClassGroup fold extend keepend
syntax region  jsCommentIfElse      contained start=/\/\// end=/$/    contains=jsCommentTodo,@Spell skipwhite skipempty nextgroup=jsIfElseBlock extend keepend
syntax region  jsCommentIfElse      contained start=/\/\*/ end=/\*\// contains=jsCommentTodo,@Spell skipwhite skipempty nextgroup=jsIfElseBlock fold extend keepend
syntax region  jsCommentRepeat      contained start=/\/\// end=/$/    contains=jsCommentTodo,@Spell skipwhite skipempty nextgroup=jsRepeatBlock extend keepend
syntax region  jsCommentRepeat      contained start=/\/\*/ end=/\*\// contains=jsCommentTodo,@Spell skipwhite skipempty nextgroup=jsRepeatBlock fold extend keepend

" Decorators
syntax match   jsDecorator                    /^\s*@/ nextgroup=jsDecoratorFunction
syntax match   jsDecoratorFunction  contained /[a-zA-Z_][a-zA-Z0-9_.]*/ nextgroup=jsParenDecorator

if exists("javascript_plugin_jsdoc")
  runtime extras/jsdoc.vim
  " NGDoc requires JSDoc
  if exists("javascript_plugin_ngdoc")
    runtime extras/ngdoc.vim
  endif
endif

if exists("javascript_plugin_flow")
  runtime extras/flow.vim
endif

syntax cluster jsExpression  contains=jsBracket,jsParen,jsObject,jsTernaryIf,jsTaggedTemplate,jsTemplateString,jsString,jsRegexpString,jsNumber,jsFloat,jsOperator,jsBooleanTrue,jsBooleanFalse,jsNull,jsFunction,jsArrowFunction,jsGlobalObjects,jsExceptions,jsFutureKeys,jsDomErrNo,jsDomNodeConsts,jsHtmlEvents,jsFuncCall,jsUndefined,jsNan,jsPrototype,jsBuiltins,jsNoise,jsClassDefinition,jsArrowFunction,jsArrowFuncArgs,jsParensError,jsComment,jsArguments,jsThis,jsSuper,jsDo,jsForAwait,jsAsyncKeyword,jsStatement
syntax cluster jsAll         contains=@jsExpression,jsStorageClass,jsConditional,jsRepeat,jsReturn,jsException,jsTry,jsNoise,jsBlockLabel

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_javascript_syn_inits")
  if version < 508
    let did_javascript_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink jsComment              Comment
  HiLink jsEnvComment           PreProc
  HiLink jsParensIfElse         jsParens
  HiLink jsParensRepeat         jsParens
  HiLink jsParensSwitch         jsParens
  HiLink jsParensCatch          jsParens
  HiLink jsCommentTodo          Todo
  HiLink jsString               String
  HiLink jsObjectKeyString      String
  HiLink jsTemplateString       String
  HiLink jsObjectStringKey      String
  HiLink jsClassStringKey       String
  HiLink jsTaggedTemplate       StorageClass
  HiLink jsTernaryIfOperator    Operator
  HiLink jsRegexpString         String
  HiLink jsRegexpBoundary       SpecialChar
  HiLink jsRegexpQuantifier     SpecialChar
  HiLink jsRegexpOr             Conditional
  HiLink jsRegexpMod            SpecialChar
  HiLink jsRegexpBackRef        SpecialChar
  HiLink jsRegexpGroup          jsRegexpString
  HiLink jsRegexpCharClass      Character
  HiLink jsCharacter            Character
  HiLink jsPrototype            Special
  HiLink jsConditional          Conditional
  HiLink jsBranch               Conditional
  HiLink jsLabel                Label
  HiLink jsReturn               Statement
  HiLink jsRepeat               Repeat
  HiLink jsDo                   Repeat
  HiLink jsStatement            Statement
  HiLink jsException            Exception
  HiLink jsTry                  Exception
  HiLink jsFinally              Exception
  HiLink jsCatch                Exception
  HiLink jsAsyncKeyword         Keyword
  HiLink jsForAwait             Keyword
  HiLink jsArrowFunction        Type
  HiLink jsFunction             Type
  HiLink jsGenerator            jsFunction
  HiLink jsArrowFuncArgs        jsFuncArgs
  HiLink jsFuncName             Function
  HiLink jsClassFuncName        jsFuncName
  HiLink jsObjectFuncName       Function
  HiLink jsArguments            Special
  HiLink jsError                Error
  HiLink jsParensError          Error
  HiLink jsOperator             Operator
  HiLink jsOf                   Operator
  HiLink jsStorageClass         StorageClass
  HiLink jsClassKeyword         Keyword
  HiLink jsExtendsKeyword       Keyword
  HiLink jsThis                 Special
  HiLink jsSuper                Constant
  HiLink jsNan                  Number
  HiLink jsNull                 Type
  HiLink jsUndefined            Type
  HiLink jsNumber               Number
  HiLink jsFloat                Float
  HiLink jsBooleanTrue          Boolean
  HiLink jsBooleanFalse         Boolean
  HiLink jsObjectColon          jsNoise
  HiLink jsNoise                Noise
  HiLink jsBrackets             Noise
  HiLink jsParens               Noise
  HiLink jsBraces               Noise
  HiLink jsFuncBraces           Noise
  HiLink jsFuncParens           Noise
  HiLink jsClassBraces          Noise
  HiLink jsClassNoise           Noise
  HiLink jsIfElseBraces         Noise
  HiLink jsTryCatchBraces       Noise
  HiLink jsModuleBraces         Noise
  HiLink jsObjectBraces         Noise
  HiLink jsObjectSeparator      Noise
  HiLink jsFinallyBraces        Noise
  HiLink jsRepeatBraces         Noise
  HiLink jsSwitchBraces         Noise
  HiLink jsSpecial              Special
  HiLink jsTemplateBraces       Noise
  HiLink jsGlobalObjects        Constant
  HiLink jsGlobalNodeObjects    Constant
  HiLink jsExceptions           Constant
  HiLink jsBuiltins             Constant
  HiLink jsImport               Include
  HiLink jsExport               Include
  HiLink jsExportDefault        StorageClass
  HiLink jsExportDefaultGroup   jsExportDefault
  HiLink jsModuleAs             Include
  HiLink jsModuleComma          jsNoise
  HiLink jsModuleAsterisk       Noise
  HiLink jsFrom                 Include
  HiLink jsDecorator            Special
  HiLink jsDecoratorFunction    Function
  HiLink jsParensDecorator      jsParens
  HiLink jsFuncArgOperator      jsFuncArgs
  HiLink jsClassProperty        jsObjectKey
  HiLink jsSpreadOperator       Operator
  HiLink jsRestOperator         Operator
  HiLink jsRestExpression       jsFuncArgs
  HiLink jsSwitchColon          Noise
  HiLink jsClassMethodType      Type
  HiLink jsObjectMethodType     Type
  HiLink jsClassDefinition      jsFuncName
  HiLink jsBlockLabel           Identifier
  HiLink jsBlockLabelKey        jsBlockLabel

  HiLink jsDestructuringBraces     Noise
  HiLink jsDestructuringProperty   jsFuncArgs
  HiLink jsDestructuringAssignment jsObjectKey
  HiLink jsDestructuringNoise      Noise

  HiLink jsCommentFunction      jsComment
  HiLink jsCommentClass         jsComment
  HiLink jsCommentIfElse        jsComment
  HiLink jsCommentRepeat        jsComment

  HiLink jsDomErrNo             Constant
  HiLink jsDomNodeConsts        Constant
  HiLink jsDomElemAttrs         Label
  HiLink jsDomElemFuncs         PreProc

  HiLink jsHtmlEvents           Special
  HiLink jsHtmlElemAttrs        Label
  HiLink jsHtmlElemFuncs        PreProc

  HiLink jsCssStyles            Label

  delcommand HiLink
endif

" Define the htmlJavaScript for HTML syntax html.vim
syntax cluster  htmlJavaScript       contains=@jsAll,jsImport,jsExport
syntax cluster  javaScriptExpression contains=@jsAll

" Vim's default html.vim highlights all javascript as 'Special'
hi! def link javaScript              NONE

let b:current_syntax = "javascript"
if main_syntax == 'javascript'
  unlet main_syntax
endif

endif
