" Vim syntax file
" Language:	Markdown
" Maintainer:	Ben Williams <benw@plasticboy.com>
" URL:		http://plasticboy.com/markdown-vim-mode/
" Remark:	Uses HTML syntax file
" TODO: 	Handle stuff contained within stuff (e.g. headings within blockquotes)
" Modified by:	Bekaboo Zeng <18127878294@qq.com>

if exists('b:current_syntax')
  unlet b:current_syntax
endif

" Markdown math
syn include @tex syntax/tex.vim
syn region mkdMath start="\\\@<!\$" end="\$" skip="\\\$" contains=@tex keepend
syn region mkdMath start="\\\@<!\$\$" end="\$\$" skip="\\\$" contains=@tex keepend

runtime! syntax/html.vim
command! -nargs=+ HtmlHiLink hi def link <args>

syn spell toplevel
syn case ignore
syn sync linebreaks=1

let s:conceal = ''
let s:concealends = ''
let s:concealcode = ''
let s:conceal = ' conceal'
let s:concealends = ' concealends'
let s:concealcode = ' concealends'
let s:oneline = ''

syn region mkdItalic matchgroup=mkdItalic start="\%(\*\|_\)"    end="\%(\*\|_\)"
syn region mkdBold matchgroup=mkdBold start="\%(\*\*\|__\)"    end="\%(\*\*\|__\)"
syn region mkdBoldItalic matchgroup=mkdBoldItalic start="\%(\*\*\*\|___\)"    end="\%(\*\*\*\|___\)"
execute 'syn region htmlItalic matchgroup=mkdItalic start="\%(^\|\s\)\zs\*\ze[^\\\*\t ]\%(\%([^*]\|\\\*\|\n\)*[^\\\*\t ]\)\?\*\_W" end="[^\\\*\t ]\zs\*\ze\_W" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlItalic matchgroup=mkdItalic start="\%(^\|\s\)\zs_\ze[^\\_\t ]" end="[^\\_\t ]\zs_\ze\_W" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlBold matchgroup=mkdBold start="\%(^\|\s\)\zs\*\*\ze\S" end="\S\zs\*\*" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlBold matchgroup=mkdBold start="\%(^\|\s\)\zs__\ze\S" end="\S\zs__" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlBoldItalic matchgroup=mkdBoldItalic start="\%(^\|\s\)\zs\*\*\*\ze\S" end="\S\zs\*\*\*" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlBoldItalic matchgroup=mkdBoldItalic start="\%(^\|\s\)\zs___\ze\S" end="\S\zs___" keepend contains=@Spell' . s:oneline . s:concealends

" [link](URL) | [link][id] | [link][] | ![image](URL)
syn region mkdFootnotes matchgroup=mkdDelimiter start="\[^"    end="\]"
execute 'syn region mkdID matchgroup=mkdDelimiter    start="\["    end="\]" contained oneline' . s:conceal
execute 'syn region mkdURL matchgroup=mkdDelimiter   start="("     end=")"  contained oneline' . s:conceal
execute 'syn region mkdLink matchgroup=mkdDelimiter  start="\\\@<!!\?\[\ze[^]\n]*\n\?[^]\n]*\][[(]" end="\]" contains=@mkdNonListItem,@Spell nextgroup=mkdURL,mkdID skipwhite' . s:concealends

" Autolink without angle brackets.
" mkd  inline links:      protocol     optional  user:pass@  sub/domain                    .com, .co.uk, etc         optional port   path/querystring/hash fragment
"                         ------------ _____________________ ----------------------------- _________________________ ----------------- __
syn match   mkdInlineURL /https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z0-9][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?[^] \t]*/

" Autolink with parenthesis.
syn region  mkdInlineURL matchgroup=mkdDelimiter start="(\(https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z0-9][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?[^] \t]*)\)\@=" end=")"

" Autolink with angle brackets.
syn region mkdInlineURL matchgroup=mkdDelimiter start="\\\@<!<\ze[a-z][a-z0-9,.-]\{1,22}:\/\/[^> ]*>" end=">"

" Link definitions: [id]: URL (Optional Title)
syn region mkdLinkDef matchgroup=mkdDelimiter   start="^ \{,3}\zs\[\^\@!" end="]:" oneline nextgroup=mkdLinkDefTarget skipwhite
syn region mkdLinkDefTarget start="<\?\zs\S" excludenl end="\ze[>[:space:]\n]"   contained nextgroup=mkdLinkTitle,mkdLinkDef skipwhite skipnl oneline
syn region mkdLinkTitle matchgroup=mkdDelimiter start=+"+     end=+"+  contained
syn region mkdLinkTitle matchgroup=mkdDelimiter start=+'+     end=+'+  contained
syn region mkdLinkTitle matchgroup=mkdDelimiter start=+(+     end=+)+  contained

"HTML headings
syn region htmlH1       matchgroup=mkdHeading     start="^\s*#"                   end="$" contains=mkdLink,mkdInlineURL,@Spell
syn region htmlH2       matchgroup=mkdHeading     start="^\s*##"                  end="$" contains=mkdLink,mkdInlineURL,@Spell
syn region htmlH3       matchgroup=mkdHeading     start="^\s*###"                 end="$" contains=mkdLink,mkdInlineURL,@Spell
syn region htmlH4       matchgroup=mkdHeading     start="^\s*####"                end="$" contains=mkdLink,mkdInlineURL,@Spell
syn region htmlH5       matchgroup=mkdHeading     start="^\s*#####"               end="$" contains=mkdLink,mkdInlineURL,@Spell
syn region htmlH6       matchgroup=mkdHeading     start="^\s*######"              end="$" contains=mkdLink,mkdInlineURL,@Spell
syn match  htmlH1       /^.\+\n=\+$/ contains=mkdLink,mkdInlineURL,@Spell
syn match  htmlH2       /^.\+\n-\+$/ contains=mkdLink,mkdInlineURL,@Spell

"define Markdown groups
syn match  mkdLineBreak    /  \+$/
syn region mkdBlockquote   start=/^\s*>/                   end=/$/ contains=mkdLink,mkdInlineURL,mkdLineBreak,@Spell
execute 'syn region mkdCode      matchgroup=mkdCodeDelimiter start=/\(\([^\\]\|^\)\\\)\@<!`/                     end=/`/'  . s:concealcode
execute 'syn region mkdCodeBlock matchgroup=mkdCodeDelimiter start=/\(\([^\\]\|^\)\\\)\@<!``/ skip=/[^`]`[^`]/   end=/``/' . s:concealcode
execute 'syn region mkdCodeBlock matchgroup=mkdCodeDelimiter start=/^\s*\z(`\{3,}\)[^`]*$/                       end=/^\s*\z1`*\s*$/'            . s:concealcode
execute 'syn region mkdCodeBlock matchgroup=mkdCodeDelimiter start=/\(\([^\\]\|^\)\\\)\@<!\~\~/  end=/\(\([^\\]\|^\)\\\)\@<!\~\~/'               . s:concealcode
execute 'syn region mkdCodeBlock matchgroup=mkdCodeDelimiter start=/^\s*\z(\~\{3,}\)\s*[0-9A-Za-z_+-]*\s*$/      end=/^\s*\z1\~*\s*$/'           . s:concealcode
execute 'syn region mkdCodeBlock matchgroup=mkdCodeDelimiter start="<pre\(\|\_s[^>]*\)\\\@<!>"                   end="</pre>"'                   . s:concealcode
execute 'syn region mkdCodeBlock matchgroup=mkdCodeDelimiter start="<code\(\|\_s[^>]*\)\\\@<!>"                  end="</code>"'                  . s:concealcode
syn region mkdFootnote          start="\[^"                     end="\]"
syn match  mkdCodeBlock         /^\s*\n\(\(\s\{8,}[^ ]\|\t\t\+[^\t]\).*\n\)\+/
syn match  mkdCodeBlock         /\%^\(\(\s\{4,}[^ ]\|\t\+[^\t]\).*\n\)\+/
syn match  mkdCodeBlock         /^\s*\n\(\(\s\{4,}[^ ]\|\t\+[^\t]\).*\n\)\+/ contained
syn match  mkdListItem          /^\s*\%([-*+]\|\d\+\.\)\ze\s\+/ contained nextgroup=mkdListItemCheckbox
syn match  mkdListItemCheckbox  /\[[xXoO ]\]\ze\s\+/ contained contains=mkdListItem
syn region mkdListItemLine      start="^\s*\%([-*+]\|\d\+\.\)\s\+" end="$" oneline contains=@mkdNonListItem,mkdListItem,mkdListItemCheckbox,@Spell
syn region mkdNonListItemBlock  start="\(\%^\(\s*\([-*+]\|\d\+\.\)\s\+\)\@!\|\n\(\_^\_$\|\s\{4,}[^ ]\|\t+[^\t]\)\@!\)" end="^\(\s*\([-*+]\|\d\+\.\)\s\+\)\@=" contains=@mkdNonListItem,@Spell
syn match  mkdRule              /^\s*\*\s\{0,1}\*\s\{0,1}\*\(\*\|\s\)*$/
syn match  mkdRule              /^\s*-\s\{0,1}-\s\{0,1}-\(-\|\s\)*$/
syn match  mkdRule              /^\s*_\s\{0,1}_\s\{0,1}_\(_\|\s\)*$/

execute 'syn region mkdStrike matchgroup=htmlStrike start="\%(\~\~\)" end="\%(\~\~\)"' . s:concealends
HtmlHiLink mkdStrike        htmlStrike

syn cluster mkdNonListItem contains=@htmlTop,htmlItalic,htmlBold,htmlBoldItalic,mkdFootnotes,mkdInlineURL,mkdLink,mkdLinkDef,mkdLineBreak,mkdBlockquote,mkdCodeBlock,mkdCode,mkdRule,htmlH1,htmlH2,htmlH3,htmlH4,htmlH5,htmlH6,mkdMath,mkdStrike

"highlighting for Markdown groups
HtmlHiLink mkdString           String
HtmlHiLink mkdCode             markdownCode
HtmlHiLink mkdCodeBlock        markdownCodeBlock
HtmlHiLink mkdCodeDelimiter    Delimiter
HtmlHiLink mkdCodeStart        markdownCode
HtmlHiLink mkdCodeEnd          markdownCode
HtmlHiLink mkdFootnote         Comment
HtmlHiLink mkdBlockquote       Comment
HtmlHiLink mkdListItem         markdownListMarker
HtmlHiLink mkdListItemCheckbox markdownListMarker
HtmlHiLink mkdRule             Identifier
HtmlHiLink mkdLineBreak        Visual
HtmlHiLink mkdFootnotes        htmlLink
HtmlHiLink mkdLink             htmlLink
HtmlHiLink mkdURL              htmlString
HtmlHiLink mkdInlineURL        htmlLink
HtmlHiLink mkdID               Identifier
HtmlHiLink mkdLinkDef          mkdID
HtmlHiLink mkdLinkDefTarget    mkdURL
HtmlHiLink mkdLinkTitle        htmlString
HtmlHiLink mkdDelimiter        Delimiter

let b:current_syntax = 'mkd'

delcommand HtmlHiLink
" vim: ts=8
