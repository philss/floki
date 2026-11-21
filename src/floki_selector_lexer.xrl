Definitions.

ESCAPED = \\[:.]
IDENTIFIER = [-A-Za-z0-9_]+(({ESCAPED})?[-A-Za-z0-9_]+)*
QUOTED = (\"[^"]*\"|\'[^']*\')
PARENTESIS = \([^)]*\)
INT = [0-9]+
NOT = (n|N)(o|O)(t|T)
HAS = (h|H)(a|A)(s|S)
ODD = (o|O)(d|D)(d|D)
EVEN = (e|E)(v|V)(e|E)(n|N)
W = [\s\t\r\n\f]
PSEUDO_PATT = (\+|-)?({INT})?(n|N)({W}*(\+|-){W}*{INT})?
SYMBOL = [\[\]*]
ATTRIBUTE_IDENTIFIER = \s[is]\]

Rules.

{IDENTIFIER}                         : {token, {identifier, TokenLine, TokenChars}}.
{QUOTED}                             : {token, {quoted, TokenLine, remove_wrapper(TokenChars)}}.
{ATTRIBUTE_IDENTIFIER}               : {token, {attribute_identifier, TokenLine, TokenChars}}.
{SYMBOL}                             : {token, {TokenChars, TokenLine}}.
#{IDENTIFIER}                        : {token, {hash, TokenLine, unescape_inside_id_name(tail(TokenChars))}}.
\.{IDENTIFIER}                       : {token, {class, TokenLine, unescape_inside_class_name(tail(TokenChars))}}.
\:{NOT}\(                            : {token, {pseudo_not, TokenLine}}.
\:{HAS}\(                            : {token, {pseudo_has, TokenLine}}.
\:{IDENTIFIER}                       : {token, {pseudo, TokenLine, tail(TokenChars)}}.
\({W}*(\+|-)?{INT}{W}*\)               : {token, {pseudo_class_int, TokenLine, list_to_integer(string:trim(remove_wrapper(TokenChars)))}}.
\({W}*{ODD}{W}*\)                    : {token, {pseudo_class_odd, TokenLine}}.
\({W}*{EVEN}{W}*\)                   : {token, {pseudo_class_even, TokenLine}}.
\({W}*{PSEUDO_PATT}{W}*\)            : {token, {pseudo_class_pattern, TokenLine, remove_wrapper(TokenChars)}}.
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

unescape_inside_class_name(Chars) ->
  lists:flatten(string:replace(Chars, "\\:", ":", all)).

unescape_inside_id_name(Chars) ->
  lists:flatten(string:replace(Chars, "\\.", ".", all)).
