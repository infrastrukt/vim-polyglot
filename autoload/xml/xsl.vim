if !exists('g:polyglot_disabled') || index(g:polyglot_disabled, 'vim') == -1
  
" Author: Mikolaj Machowski, Thomas Bartel
" Last change: 2007 May 8
let g:xmldata_xsl = {
	\ 'apply-imports' : [[], {}],
    \ 'apply-templates' : [['sort', 'with-param'], {'select' : [], 'mode' : []}],
    \ 'attribute' : [['apply-imports', 'apply-templates', 'attribute', 'call-template', 'choose', 'comment', 'copy', 'copy-of', 'element', 'fallback', 'for-each', 'if', 'message', 'number', 'processing-instruction', 'text', 'value-of', 'variable'], {'name' : [], 'namespace' : []}],
    \ 'attribute-set' : [['attribute'], {'name' : [], 'use-attribute-sets' : []}],
    \ 'call-template' : [['with-param'], {'name' : []}],
    \ 'choose' : [['when', 'otherwise'], {}],
    \ 'comment' : [[], {}],
    \ 'copy' : [[], {'use-attribute-sets' : []}],
    \ 'copy-of' : [[], {'select' : []}],
    \ 'decimal-format' : [[], {'name' : [], 'decimal-separator' : [], 'grouping-separator' : [], 'infinity' : [], 'minus-sign' : [], 'NaN' : [], 'percent' : [], 'per-mille' : [], 'zero-digit' : [], 'digit' : [], 'pattern-separator' : []}],
    \ 'element' : [['apply-imports', 'apply-templates', 'attribute', 'call-template', 'choose', 'comment', 'copy', 'copy-of', 'element', 'fallback', 'for-each', 'if', 'message', 'number', 'processing-instruction', 'text', 'value-of', 'variable'], {'name' : [], 'namespace' : [], 'use-attribute-sets' : []}],
    \ 'fallback' : [[], {}],
    \ 'for-each' : [['sort'], {'select' : []}],
    \ 'if' : [['apply-imports', 'apply-templates', 'attribute', 'call-template', 'choose', 'comment', 'copy', 'copy-of', 'element', 'fallback', 'for-each', 'if', 'message', 'number', 'processing-instruction', 'text', 'value-of', 'variable'], {'test' : []}],
    \ 'import' : [[], {'href' : []}],
    \ 'include' : [[], {'href' : []}],
    \ 'key' : [[], {'name' : [], 'match' : [], 'use' : []}],
    \ 'message' : [[], {'terminate' : ['yes', 'no']}],
    \ 'namespace-alias' : [[], {'stylesheet-prefix' : ['#default'], 'result-prefix' : ['#default']}],
    \ 'number' : [[], {'level' : ['single', 'multiple', 'any'], 'count' : [], 'from' : [], 'value' : [], 'format' : [], 'lang' : [], 'letter-value' : ['alphabetic', 'traditional'], 'grouping-separator' : [], 'grouping-size' : []}],
    \ 'otherwise' : [[], {}],
    \ 'output' : [[], {'method' : ['xml', 'html', 'text'], 'version' : [], 'encoding' : [], 'omit-xml-declaration' : ['yes', 'no'], 'standalone' : ['yes', 'no'], 'doctype-public' : [], 'doctype-system' : [], 'cdata-section-elements' : [], 'indent' : ['yes', 'no'], 'media-type' : []}],
    \ 'param' : [['apply-imports', 'apply-templates', 'attribute', 'call-template', 'choose', 'comment', 'copy', 'copy-of', 'element', 'fallback', 'for-each', 'if', 'message', 'number', 'processing-instruction', 'text', 'value-of', 'variable'], {'name' : [], 'select' : []}],
    \ 'preserve-space' : [[], {'elements' : []}],
    \ 'processing-instructionruction' : [[], {'name' : []}],
    \ 'sort' : [[], {'select' : [], 'lang' : [], 'data-type' : ['text', 'number'], 'order' : ['ascending', 'descending'], 'case-order' : ['upper-first', 'lower-first']}],
    \ 'strip-space' : [[], {'elements' : []}],
    \ 'stylesheet' : [['import', 'attribute-set', 'decimal-format', 'include', 'key', 'namespace-alias', 'output', 'param', 'preserve-space', 'strip-space', 'template'], {'id' : [], 'extension-element-prefixes' : [], 'version' : []}],
    \ 'template' : [['apply-imports', 'apply-templates', 'attribute', 'call-template', 'choose', 'comment', 'copy', 'copy-of', 'element', 'fallback', 'for-each', 'if', 'message', 'number', 'processing-instruction', 'text', 'value-of', 'variable'], {'match' : [], 'name' : [], 'priority' : [], 'mode' : []}],
    \ 'text' : [[], {'disable-output-escaping' : ['yes', 'no']}],
    \ 'transform' : [['import', 'attribute-set', 'decimal-format', 'include', 'key', 'namespace-alias', 'output', 'param', 'preserve-space', 'strip-space', 'template'], {'id' : [], 'extension-element-prefixes' : [], 'exclude-result-prefixes' : [], 'version' : []}],
    \ 'value-of' : [[], {'select' : [], 'disable-output-escaping' : ['yes', 'no']}],
    \ 'variable' : [['apply-imports', 'apply-templates', 'attribute', 'call-template', 'choose', 'comment', 'copy', 'copy-of', 'element', 'fallback', 'for-each', 'if', 'message', 'number', 'processing-instruction', 'text', 'value-of', 'variable'], {'name' : [], 'select' : []}],
    \ 'when' : [[], {'test' : []}],
    \ 'with-param' : [['apply-imports', 'apply-templates', 'attribute', 'call-template', 'choose', 'comment', 'copy', 'copy-of', 'element', 'fallback', 'for-each', 'if', 'message', 'number', 'processing-instruction', 'text', 'value-of', 'variable'], {'name' : [], 'select' : []}]}

endif
