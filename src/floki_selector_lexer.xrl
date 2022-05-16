Definitions.

IDENTIFIER = [-A-Za-z0-9_]+(\\\.[-A-Za-z0-9_]+)*
QUOTED = (\"[^"]*\"|\'[^']*\')
PARENTESIS = \([^)]*\)
INT = [0-9]+
NOT = (n|N)(o|O)(t|T)
ODD = (o|O)(d|D)(d|D)
EVEN = (e|E)(v|V)(e|E)(n|N)
PSEUDO_PATT = (\+|-)?({INT})?(n|N)((\+|-){INT})?
SYMBOL = [\[\]*]
ATTRIBUTE_IDENTIFIER = \s[is]\]
W = [\s\t\r\n\f]

Rules.

{IDENTIFIER}                         : {token, {identifier, TokenLine, TokenChars}}.
{QUOTED}                             : {token, {quoted, TokenLine, remove_wrapper(TokenChars)}}.
{ATTRIBUTE_IDENTIFIER}               : {token, {attribute_identifier, TokenLine, TokenChars}}.
{SYMBOL}                             : {token, {TokenChars, TokenLine}}.
#{IDENTIFIER}                        : {token, {hash, TokenLine, tail(TokenChars)}}.
\.{IDENTIFIER}                       : {token, {class, TokenLine, tail(TokenChars)}}.
\:{NOT}\(                            : {token, {pseudo_not, TokenLine}}.
\:{IDENTIFIER}                       : {token, {pseudo, TokenLine, tail(TokenChars)}}.
\({INT}\)                            : {token, {pseudo_class_int, TokenLine, list_to_integer(remove_wrapper(TokenChars))}}.
\({ODD}\)                            : {token, {pseudo_class_odd, TokenLine}}.
\({EVEN}\)                           : {token, {pseudo_class_even, TokenLine}}.
\({PSEUDO_PATT}\)                    : {token, {pseudo_class_pattern, TokenLine, remove_wrapper(TokenChars)}}.
\({QUOTED}\)                         : {token, {pseudo_class_quoted, TokenLine, remove_wrapper(remove_wrapper(TokenChars))}}.
{W}*\)                               : {token, {close_parentesis, TokenLine}}.
~=                                   : {token, {includes, TokenLine}}.
\|=                                  : {token, {dash_match, TokenLine}}.
\^=                                  : {token, {prefix_match, TokenLine}}.
\$=                                  : {token, {suffix_match, TokenLine}}.
\*=                                  : {token, {substring_match, TokenLine}}.
=                                    : {token, {equal, TokenLine}}.
{W}*,{W}*                            : {token, {comma, TokenLine}}.
{W}*>{W}*                            : {token, {greater, TokenLine}}.
{W}*\+{W}*                           : {token, {plus, TokenLine}}.
{W}*~{W}*                            : {token, {tilde, TokenLine}}.
{W}*\|{W}*                           : {token, {namespace_pipe, TokenLine}}.
{W}+                                 : {token, {space, TokenLine}}.
.                                    : {token, {unknown, TokenLine, TokenChars}}.

Erlang code.

remove_wrapper(Chars) ->
  Len = string:len(Chars),
  string:substr(Chars, 2, Len - 2).

tail([_|T]) ->
  T.
