"syn match  mkdLineContinue                             ".$"                                                                                  contained
"syn match  mkdLineBreak                                /  \+$/
"syn region mkdBlockquote                               start=/^\s*>/                                  end=/$/                                contains=mkdLineBreak,mkdLineContinue,@Spell
"syn region mkdCode             matchgroup=mkdDelimiter start=/\(\([^\\]\|^\)\\\)\@<!`/                end=/\(\([^\\]\|^\)\\\)\@<!`/          concealends
"syn region mkdCode             matchgroup=mkdDelimiter start=/\s*``[^`]*/                             end=/[^`]*``\s*/                       concealends
"syn region mkdCode             matchgroup=mkdDelimiter start=/^\s*```.*$/                             end=/^\s*```\s*$/                      concealends contains=mkdCodeCfg
"syn match  mkdCodeCfg                                  "{[^}]*}"                                                                             contained conceal
"syn region mkdCode             matchgroup=mkdDelimiter start="<pre[^>\\]*>"                           end="</pre>"                           concealends
"syn region mkdCode             matchgroup=mkdDelimiter start="<code[^>\\]*>"                          end="</code>"                          concealends
"syn region mkdFootnote         matchgroup=mkdDelimiter start="\[^"                                    end="\]"
"syn match  mkdCode                                     /^\s*\n\(\(\s\{8,}[^ ]\|\t\t\+[^\t]\).*\n\)\+/
"syn match  mkdIndentCode                               /^\s*\n\(\(\s\{4,}[^ ]\|\t\+[^\t]\).*\n\)\+/                                          contained
"syn match  mkdListItem                                 "^\s*[-*+]\s\+"                                                                       contains=mkdListTab,mkdListBullet2
"syn match  mkdListItem                                 "^\s*\d\+\.\s\+"                                                                      contains=mkdListTab
"syn match  mkdListTab                                  "^\s*\*"                                                                              contained contains=mkdListBullet1
"" syn match  mkdListBullet1                              "\*"                                                                                  contained conceal cchar=•
"" syn match  mkdListBullet2                              "[-*+]"                                                                               contained conceal cchar=•
"
"syn region mkdNonListItemBlock                         start="\n\(\_^\_$\|\s\{4,}[^ ]\|\t+[^\t]\)\@!" end="^\(\s*\([-*+]\|\d\+\.\)\s\+\)\@=" contains=@mkdNonListItem,@Spell
"syn match  mkdRule                                     /^\s*\*\s\{0,1}\*\s\{0,1}\*$/
"syn match  mkdRule                                     /^\s*-\s\{0,1}-\s\{0,1}-$/
"syn match  mkdRule                                     /^\s*_\s\{0,1}_\s\{0,1}_$/
"syn match  mkdRule                                     /^\s*-\{3,}$/
"syn match  mkdRule                                     /^\s*\*\{3,5}$/
"syn region markdownLink matchgroup=markdownLinkDelimiter start="(" end=")" contains=markdownUrl keepend contained conceal
"syn region markdownLinkText matchgroup=markdownLinkTextDelimiter start="!\=\[\%(\%(\_[^][]\|\[\_[^][]*\]\)*]\%( \=[[(]\)\)\@=" end="\]\%( \=[[(]\)\@=" nextgroup=markdownLink,markdownId skipwhite contains=@markdownInline,markdownLineStart concealends
"
"set conceallevel=2
"let b:current_syntax = "markdown"
