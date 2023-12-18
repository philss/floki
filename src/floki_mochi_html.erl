%% @author Bob Ippolito <bob@mochimedia.com>
%% @copyright 2007 Mochi Media, Inc.
%%
%% Permission is hereby granted, free of charge, to any person obtaining a
%% copy of this software and associated documentation files (the "Software"),
%% to deal in the Software without restriction, including without limitation
%% the rights to use, copy, modify, merge, publish, distribute, sublicense,
%% and/or sell copies of the Software, and to permit persons to whom the
%% Software is furnished to do so, subject to the following conditions:
%%
%% The above copyright notice and this permission notice shall be included in
%% all copies or substantial portions of the Software.
%%
%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
%% THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
%% FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
%% DEALINGS IN THE SOFTWARE.

%% @doc Loosely tokenizes and generates parse trees for HTML 4.
-module(floki_mochi_html).
-export([
    tokens/1,
    parse/2
]).
-ifdef(TEST).
-export([destack/1, destack/2, is_singleton/1]).
-endif.

%% This is a macro to placate syntax highlighters..

%% $\"
-define(QUOTE, $\").
%% $\'
-define(SQUOTE, $\').
-define(ADV_COL(S, N), S#decoder{
    column = N + S#decoder.column,
    offset = N + S#decoder.offset
}).
-define(INC_COL(S), S#decoder{
    column = 1 + S#decoder.column,
    offset = 1 + S#decoder.offset
}).
-define(INC_LINE(S), S#decoder{
    column = 1,
    line = 1 + S#decoder.line,
    offset = 1 + S#decoder.offset
}).
-define(INC_CHAR(S, C),
    case C of
        $\n ->
            S#decoder{
                column = 1,
                line = 1 + S#decoder.line,
                offset = 1 + S#decoder.offset
            };
        _ ->
            S#decoder{
                column = 1 + S#decoder.column,
                offset = 1 + S#decoder.offset
            }
    end
).

-define(IS_WHITESPACE(C),
    (C =:= $\s orelse C =:= $\t orelse C =:= $\r orelse C =:= $\n)
).
-define(IS_LETTER(C),
    ((C >= $A andalso C =< $Z) orelse (C >= $a andalso C =< $z))
).
-define(IS_LITERAL_SAFE(C),
    ((C >= $A andalso C =< $Z) orelse (C >= $a andalso C =< $z) orelse
        (C >= $0 andalso C =< $9))
).
-define(PROBABLE_CLOSE(C),
    (C =:= $> orelse ?IS_WHITESPACE(C))
).

-record(decoder, {
    line = 1,
    column = 1,
    offset = 0
}).

%% @type html_node() = {string(), [html_attr()], [html_node() | string()]}
%% @type html_attr() = {string(), string()}
%% @type html_token() = html_data() | start_tag() | end_tag() | inline_html() | html_comment() | html_doctype()
%% @type html_data() = {data, string(), Whitespace::boolean()}
%% @type start_tag() = {start_tag, Name, [html_attr()], Singleton::boolean()}
%% @type end_tag() = {end_tag, Name}
%% @type html_comment() = {comment, Comment}
%% @type html_doctype() = {doctype, [Doctype]}
%% @type inline_html() = {'=', iolist()}

%% External API.

%% @spec parse(string() | binary(), list()) -> html_node()
%% @doc tokenize and then transform the token stream into a HTML tree.
%%
%% The following option is supported:
%%
%% <dl>
%% <dt>`attributes_as_maps`</dt>
%% <dd>
%% When `true`, it configures the parser to use maps for the attributes.
%% It is `false` by default, which means attributes are going to be represented
%% as a list of tuples.
%% </dd>
%% </dl>
parse(Input, Opts) ->
    parse_tokens(tokens(Input), Opts).

%% @spec parse_tokens([html_token()]) -> html_node()
%% @doc Transform the output of tokens(Doc) into a HTML tree.
parse_tokens(Tokens, Opts) when is_list(Tokens) andalso is_list(Opts) ->
    %% Skip over doctype, processing instructions
    [{start_tag, Tag, Attrs, false} | Rest] = find_document(Tokens, normal),
    {Tree, _} = tree(Rest, [norm({Tag, Attrs}, Opts)], Opts),
    Tree.

find_document(Tokens = [{start_tag, _Tag, _Attrs, false} | _Rest], Mode) ->
    maybe_add_html_tag(Tokens, Mode);
find_document([{doctype, [<<"html">>]} | Rest], _Mode) ->
    find_document(Rest, html5);
find_document([_T | Rest], Mode) ->
    find_document(Rest, Mode);
find_document([], _Mode) ->
    [].

maybe_add_html_tag(Tokens = [{start_tag, Tag, _Attrs, false} | _], html5) when
    Tag =/= <<"html">>
->
    [{start_tag, <<"html">>, [], false} | Tokens];
maybe_add_html_tag(Tokens, _Mode) ->
    Tokens.

%% @spec tokens(StringOrBinary) -> [html_token()]
%% @doc Transform the input UTF-8 HTML into a token stream.
tokens(Input) ->
    tokens(iolist_to_binary(Input), #decoder{}, []).

tokens(B, S = #decoder{offset = O}, Acc) ->
    case B of
        <<_:O/binary>> ->
            lists:reverse(Acc);
        _ ->
            {Tag, S1} = tokenize(B, S),
            case parse_flag(Tag) of
                script ->
                    {Tag2, S2} = tokenize_script(B, S1),
                    tokens(B, S2, [Tag2, Tag | Acc]);
                style ->
                    {Tag2, S2} = tokenize_style(B, S1),
                    tokens(B, S2, [Tag2, Tag | Acc]);
                title ->
                    {Tag2, S2} = tokenize_title(B, S1),
                    tokens(B, S2, [Tag2, Tag | Acc]);
                textarea ->
                    {Tag2, S2} = tokenize_textarea(B, S1),
                    tokens(B, S2, [Tag2, Tag | Acc]);
                none ->
                    tokens(B, S1, [Tag | Acc])
            end
    end.

parse_flag({start_tag, B, _, false}) ->
    case B of
        <<"script">> ->
            script;
        <<"style">> ->
            style;
        <<"title">> ->
            title;
        <<"textarea">> ->
            textarea;
        _ ->
            none
    end;
parse_flag(_) ->
    none.

tokenize(B, S = #decoder{offset = O}) ->
    case B of
        <<_:O/binary, "<!--", _/binary>> ->
            tokenize_comment(B, ?ADV_COL(S, 4));
        <<_:O/binary, "<!doctype", _/binary>> ->
            tokenize_doctype(B, ?ADV_COL(S, 10));
        <<_:O/binary, "<!DOCTYPE", _/binary>> ->
            tokenize_doctype(B, ?ADV_COL(S, 10));
        <<_:O/binary, "<![CDATA[", _/binary>> ->
            tokenize_cdata(B, ?ADV_COL(S, 9));
        <<_:O/binary, "<?php", _/binary>> ->
            {Body, S1} = raw_qgt(B, ?ADV_COL(S, 2)),
            {{pi, Body, []}, S1};
        <<_:O/binary, "<?", _/binary>> ->
            {Tag, S1} = tokenize_literal(B, ?ADV_COL(S, 2)),
            {Attrs, S2} = tokenize_attributes(B, S1),
            S3 = find_qgt(B, S2),
            {{pi, Tag, Attrs}, S3};
        <<_:O/binary, "&", _/binary>> ->
            tokenize_charref(B, ?INC_COL(S));
        <<_:O/binary, "</", _/binary>> ->
            {Tag, S1} = tokenize_literal(B, ?ADV_COL(S, 2)),
            {S2, _} = find_gt(B, S1),
            {{end_tag, Tag}, S2};
        <<_:O/binary, "<", C, _/binary>> when
            ?IS_WHITESPACE(C); not ?IS_LETTER(C)
        ->
            %% This isn't really strict HTML
            {{data, Data, _Whitespace}, S1} = tokenize_data(B, ?INC_COL(S)),
            {{data, <<$<, Data/binary>>, false}, S1};
        <<_:O/binary, "<", _/binary>> ->
            {Tag, S1} = tokenize_literal(B, ?INC_COL(S)),
            {Attrs, S2} = tokenize_attributes(B, S1),
            {S3, HasSlash} = find_gt(B, S2),
            Singleton = HasSlash orelse is_singleton(Tag),
            {{start_tag, Tag, Attrs, Singleton}, S3};
        _ ->
            tokenize_data(B, S)
    end.

tree_data([{data, Data, Whitespace} | Rest], AllWhitespace, Acc) ->
    tree_data(Rest, (Whitespace andalso AllWhitespace), [Data | Acc]);
tree_data(Rest, AllWhitespace, Acc) ->
    {iolist_to_binary(lists:reverse(Acc)), AllWhitespace, Rest}.

tree([], Stack, _Opts) ->
    {destack(Stack), []};
tree([{end_tag, Tag} | Rest], Stack, Opts) ->
    case destack(norm(Tag, Opts), Stack) of
        S when is_list(S) ->
            tree(Rest, S, Opts);
        Result ->
            {Result, []}
    end;
tree([{start_tag, Tag, Attrs, true} | Rest], S, Opts) ->
    tree(Rest, append_stack_child(norm({Tag, Attrs}, Opts), S), Opts);
tree([{start_tag, Tag, Attrs, false} | Rest], S, Opts) ->
    tree(Rest, stack(norm({Tag, Attrs}, Opts), S), Opts);
tree([T = {pi, _Tag, _Attrs} | Rest], S, Opts) ->
    tree(Rest, append_stack_child(T, S), Opts);
tree([T = {comment, _Comment} | Rest], S, Opts) ->
    tree(Rest, append_stack_child(T, S), Opts);
tree(L = [{data, _Data, _Whitespace} | _], S, Opts) ->
    case tree_data(L, true, []) of
        {_, true, Rest} ->
            tree(Rest, S, Opts);
        {Data, false, Rest} ->
            tree(Rest, append_stack_child(Data, S), Opts)
    end;
tree([{doctype, _} | Rest], Stack, Opts) ->
    tree(Rest, Stack, Opts).

norm({Tag, Attrs}, Opts) ->
    Attrs0 = [{norm(K, Opts), iolist_to_binary(V)} || {K, V} <- Attrs],
    case lists:keyfind(attributes_as_maps, 1, Opts) of
        {attributes_as_maps, true} ->
            % The HTML specs says we should ignore duplicated attributes and keep the first
            % occurence of a given key.
            % Since `maps:from_list/1` does the opposite, we need to reverse the attributes.
            % See https://github.com/philss/floki/pull/467#discussion_r1225548333
            {norm(Tag, Opts), maps:from_list(lists:reverse(Attrs0)), []};
        _ ->
            {norm(Tag, Opts), Attrs0, []}
    end;
norm(Tag, _Opts) when is_binary(Tag) ->
    Tag;
norm(Tag, _Opts) ->
    list_to_binary(string:to_lower(Tag)).

stack(T1 = {TN, _, _}, Stack = [{TN, _, _} | _Rest]) when
    TN =:= <<"li">> orelse TN =:= <<"option">>
->
    [T1 | destack(TN, Stack)];
stack(T1 = {TN0, _, _}, Stack = [{TN1, _, _} | _Rest]) when
    (TN0 =:= <<"dd">> orelse TN0 =:= <<"dt">>) andalso
        (TN1 =:= <<"dd">> orelse TN1 =:= <<"dt">>)
->
    [T1 | destack(TN1, Stack)];
stack(T1, Stack) ->
    [T1 | Stack].

append_stack_child(StartTag, [{Name, Attrs, Acc} | Stack]) ->
    [{Name, Attrs, [StartTag | Acc]} | Stack].

destack(<<"br">>, Stack) ->
    %% This is an ugly hack to make dumb_br_test() pass,
    %% this makes it such that br can never have children.
    Stack;
destack(TagName, Stack) when is_list(Stack) ->
    F = fun(X) ->
        case X of
            {TagName, _, _} ->
                false;
            _ ->
                true
        end
    end,
    case lists:splitwith(F, Stack) of
        {_, []} ->
            %% If we're parsing something like XML we might find
            %% a <link>tag</link> that is normally a singleton
            %% in HTML but isn't here
            case {is_singleton(TagName), Stack} of
                {true, [{T0, A0, Acc0} | Post0]} ->
                    case lists:splitwith(F, Acc0) of
                        {_, []} ->
                            %% Actually was a singleton
                            Stack;
                        {Pre, [{T1, A1, Acc1} | Post1]} ->
                            [
                                {T0, A0, [{T1, A1, Acc1 ++ lists:reverse(Pre)} | Post1]}
                                | Post0
                            ]
                    end;
                _ ->
                    %% No match, no state change
                    Stack
            end;
        {_Pre, [_T]} ->
            %% Unfurl the whole stack, we're done
            destack(Stack);
        {Pre, [T, {T0, A0, Acc0} | Post]} ->
            %% Unfurl up to the tag, then accumulate it
            [{T0, A0, [destack(Pre ++ [T]) | Acc0]} | Post]
    end.

destack([{Tag, Attrs, Acc}]) ->
    {Tag, Attrs, lists:reverse(Acc)};
destack([{T1, A1, Acc1}, {T0, A0, Acc0} | Rest]) ->
    destack([{T0, A0, [{T1, A1, lists:reverse(Acc1)} | Acc0]} | Rest]).

is_singleton(<<"area">>) -> true;
is_singleton(<<"base">>) -> true;
is_singleton(<<"br">>) -> true;
is_singleton(<<"col">>) -> true;
is_singleton(<<"embed">>) -> true;
is_singleton(<<"hr">>) -> true;
is_singleton(<<"img">>) -> true;
is_singleton(<<"input">>) -> true;
is_singleton(<<"keygen">>) -> true;
is_singleton(<<"link">>) -> true;
is_singleton(<<"meta">>) -> true;
is_singleton(<<"param">>) -> true;
is_singleton(<<"source">>) -> true;
is_singleton(<<"track">>) -> true;
is_singleton(<<"wbr">>) -> true;
is_singleton(_) -> false.

tokenize_data(B, S = #decoder{offset = O}) ->
    tokenize_data(B, S, O, true).

tokenize_data(B, S = #decoder{offset = O}, Start, Whitespace) ->
    case B of
        <<_:O/binary, C, _/binary>> when (C =/= $< andalso C =/= $&) ->
            tokenize_data(
                B,
                ?INC_CHAR(S, C),
                Start,
                (Whitespace andalso ?IS_WHITESPACE(C))
            );
        _ ->
            Len = O - Start,
            <<_:Start/binary, Data:Len/binary, _/binary>> = B,
            {{data, Data, Whitespace}, S}
    end.

tokenize_attributes(B, S) ->
    tokenize_attributes(B, S, []).

tokenize_attributes(B, S = #decoder{offset = O}, Acc) ->
    case B of
        <<_:O/binary>> ->
            {lists:reverse(Acc), S};
        <<_:O/binary, C, _/binary>> when (C =:= $> orelse C =:= $/) ->
            {lists:reverse(Acc), S};
        <<_:O/binary, "?>", _/binary>> ->
            {lists:reverse(Acc), S};
        <<_:O/binary, C, _/binary>> when ?IS_WHITESPACE(C) ->
            tokenize_attributes(B, ?INC_CHAR(S, C), Acc);
        _ ->
            {Attr, S1} = tokenize_literal(B, S),
            {Value, S2} = tokenize_attr_value(Attr, B, S1),
            tokenize_attributes(B, S2, [{Attr, Value} | Acc])
    end.

tokenize_attr_value(Attr, B, S) ->
    S1 = skip_whitespace(B, S),
    O = S1#decoder.offset,
    case B of
        <<_:O/binary, "=", _/binary>> ->
            S2 = skip_whitespace(B, ?INC_COL(S1)),
            tokenize_quoted_or_unquoted_attr_value(B, S2);
        _ ->
            {Attr, S1}
    end.

tokenize_quoted_or_unquoted_attr_value(B, S = #decoder{offset = O}) ->
    case B of
        <<_:O/binary>> ->
            {[], S};
        <<_:O/binary, Q, _/binary>> when
            Q =:= ?QUOTE orelse
                Q =:= ?SQUOTE
        ->
            tokenize_quoted_attr_value(B, ?INC_COL(S), [], Q);
        <<_:O/binary, _/binary>> ->
            tokenize_unquoted_attr_value(B, S, [])
    end.

tokenize_quoted_attr_value(B, S = #decoder{offset = O}, Acc, Q) ->
    case B of
        <<_:O/binary>> ->
            {iolist_to_binary(lists:reverse(Acc)), S};
        <<_:O/binary, $&, _/binary>> ->
            {{data, Data, false}, S1} = tokenize_charref(B, ?INC_COL(S)),
            tokenize_quoted_attr_value(B, S1, [Data | Acc], Q);
        <<_:O/binary, Q, _/binary>> ->
            {iolist_to_binary(lists:reverse(Acc)), ?INC_COL(S)};
        <<_:O/binary, C, _/binary>> ->
            tokenize_quoted_attr_value(B, ?INC_COL(S), [C | Acc], Q)
    end.

tokenize_unquoted_attr_value(B, S = #decoder{offset = O}, Acc) ->
    case B of
        <<_:O/binary>> ->
            {iolist_to_binary(lists:reverse(Acc)), S};
        <<_:O/binary, $&, _/binary>> ->
            {{data, Data, false}, S1} = tokenize_charref(B, ?INC_COL(S)),
            tokenize_unquoted_attr_value(B, S1, [Data | Acc]);
        <<_:O/binary, $/, $>, _/binary>> ->
            {iolist_to_binary(lists:reverse(Acc)), S};
        <<_:O/binary, C, _/binary>> when ?PROBABLE_CLOSE(C) ->
            {iolist_to_binary(lists:reverse(Acc)), S};
        <<_:O/binary, C, _/binary>> ->
            tokenize_unquoted_attr_value(B, ?INC_COL(S), [C | Acc])
    end.

skip_whitespace(B, S = #decoder{offset = O}) ->
    case B of
        <<_:O/binary, C, _/binary>> when ?IS_WHITESPACE(C) ->
            skip_whitespace(B, ?INC_CHAR(S, C));
        _ ->
            S
    end.

tokenize_literal(Bin, S = #decoder{offset = O}) ->
    case Bin of
        <<_:O/binary, C, _/binary>> when
            C =:= $> orelse
                C =:= $/ orelse
                C =:= $=
        ->
            %% Handle case where tokenize_literal would consume
            %% 0 chars. http://github.com/mochi/mochiweb/pull/13
            {[C], ?INC_COL(S)};
        _ ->
            tokenize_literal(Bin, S, [])
    end.

tokenize_literal(Bin, S = #decoder{offset = O}, Acc) ->
    case Bin of
        <<_:O/binary, $&, _/binary>> ->
            {{data, Data, false}, S1} = tokenize_charref(Bin, ?INC_COL(S)),
            tokenize_literal(Bin, S1, [Data | Acc]);
        <<_:O/binary, C, _/binary>> when
            not (?IS_WHITESPACE(C) orelse
                C =:= $> orelse
                C =:= $/ orelse
                C =:= $=)
        ->
            tokenize_literal(Bin, ?INC_COL(S), [C | Acc]);
        _ ->
            {iolist_to_binary(string:to_lower(lists:reverse(Acc))), S}
    end.

raw_qgt(Bin, S = #decoder{offset = O}) ->
    raw_qgt(Bin, S, O).

raw_qgt(Bin, S = #decoder{offset = O}, Start) ->
    case Bin of
        <<_:O/binary, "?>", _/binary>> ->
            Len = O - Start,
            <<_:Start/binary, Raw:Len/binary, _/binary>> = Bin,
            {Raw, ?ADV_COL(S, 2)};
        <<_:O/binary, C, _/binary>> ->
            raw_qgt(Bin, ?INC_CHAR(S, C), Start);
        <<_:O/binary>> ->
            <<_:Start/binary, Raw/binary>> = Bin,
            {Raw, S}
    end.

find_qgt(Bin, S = #decoder{offset = O}) ->
    case Bin of
        <<_:O/binary, "?>", _/binary>> ->
            ?ADV_COL(S, 2);
        <<_:O/binary, ">", _/binary>> ->
            ?ADV_COL(S, 1);
        <<_:O/binary, "/>", _/binary>> ->
            ?ADV_COL(S, 2);
        <<_:O/binary, C, _/binary>> ->
            find_qgt(Bin, ?INC_CHAR(S, C));
        <<_:O/binary>> ->
            S
    end.

find_gt(Bin, S) ->
    find_gt(Bin, S, false).

find_gt(Bin, S = #decoder{offset = O}, HasSlash) ->
    case Bin of
        <<_:O/binary, $/, _/binary>> ->
            find_gt(Bin, ?INC_COL(S), true);
        <<_:O/binary, $>, _/binary>> ->
            {?INC_COL(S), HasSlash};
        <<_:O/binary, C, _/binary>> ->
            find_gt(Bin, ?INC_CHAR(S, C), HasSlash);
        _ ->
            {S, HasSlash}
    end.

tokenize_charref(Bin, S = #decoder{offset = O}) ->
    try
        case tokenize_charref_raw(Bin, S, O) of
            {C1, S1} when C1 >= 16#D800 andalso C1 =< 16#DFFF ->
                %% Surrogate pair
                tokeninize_charref_surrogate_pair(Bin, S1, C1);
            {Unichar, S1} when is_integer(Unichar) ->
                %% CHANGED: Previously this was mochiutf8:codepoint_to_bytes(Unichar)
                %% but that is equivalent to the below.
                {{data, <<Unichar/utf8>>, false}, S1}
        end
    catch
        throw:invalid_charref ->
            {{data, <<"&">>, false}, S}
    end.

tokeninize_charref_surrogate_pair(Bin, S = #decoder{offset = O}, C1) ->
    case Bin of
        <<_:O/binary, $&, _/binary>> ->
            case tokenize_charref_raw(Bin, ?INC_COL(S), O + 1) of
                {C2, S1} when C2 >= 16#D800 andalso C1 =< 16#DFFF ->
                    {
                        {data,
                            unicode:characters_to_binary(
                                <<C1:16, C2:16>>,
                                utf16,
                                utf8
                            ),
                            false},
                        S1
                    };
                _ ->
                    throw(invalid_charref)
            end;
        _ ->
            throw(invalid_charref)
    end.

tokenize_charref_raw(Bin, S = #decoder{offset = O}, Start) ->
    case Bin of
        <<_:O/binary>> ->
            throw(invalid_charref);
        <<_:O/binary, C, _/binary>> when
            ?IS_WHITESPACE(C) orelse
                C =:= ?SQUOTE orelse
                C =:= ?QUOTE orelse
                C =:= $/ orelse
                C =:= $>
        ->
            throw(invalid_charref);
        <<_:O/binary, $;, _/binary>> ->
            Len = O - Start,
            %% CHANGED: Previously this was mochiweb_charref:charref/1
            %% but the functionality below is equivalent;
            <<_:Start/binary, Raw:Len/binary, _/binary>> = Bin,

            case 'Elixir.Floki.Entities':decode(<<$&, Raw/binary, $;>>) of
                {ok, <<CP/utf8>>} ->
                    {CP, ?INC_COL(S)};
                _ ->
                    throw(invalid_charref)
            end;
        _ ->
            tokenize_charref_raw(Bin, ?INC_COL(S), Start)
    end.

tokenize_doctype(Bin, S) ->
    tokenize_doctype(Bin, S, []).

tokenize_doctype(Bin, S = #decoder{offset = O}, Acc) ->
    case Bin of
        <<_:O/binary>> ->
            {{doctype, lists:reverse(Acc)}, S};
        <<_:O/binary, $>, _/binary>> ->
            {{doctype, lists:reverse(Acc)}, ?INC_COL(S)};
        <<_:O/binary, C, _/binary>> when ?IS_WHITESPACE(C) ->
            tokenize_doctype(Bin, ?INC_CHAR(S, C), Acc);
        _ ->
            {Word, S1} = tokenize_word_or_literal(Bin, S),
            tokenize_doctype(Bin, S1, [Word | Acc])
    end.

tokenize_word_or_literal(Bin, S = #decoder{offset = O}) ->
    case Bin of
        <<_:O/binary, C, _/binary>> when C =:= ?QUOTE orelse C =:= ?SQUOTE ->
            tokenize_word(Bin, ?INC_COL(S), C);
        <<_:O/binary, C, _/binary>> when not ?IS_WHITESPACE(C) ->
            %% Sanity check for whitespace
            tokenize_literal(Bin, S)
    end.

tokenize_word(Bin, S, Quote) ->
    tokenize_word(Bin, S, Quote, []).

tokenize_word(Bin, S = #decoder{offset = O}, Quote, Acc) ->
    case Bin of
        <<_:O/binary>> ->
            {iolist_to_binary(lists:reverse(Acc)), S};
        <<_:O/binary, Quote, _/binary>> ->
            {iolist_to_binary(lists:reverse(Acc)), ?INC_COL(S)};
        <<_:O/binary, $&, _/binary>> ->
            {{data, Data, false}, S1} = tokenize_charref(Bin, ?INC_COL(S)),
            tokenize_word(Bin, S1, Quote, [Data | Acc]);
        <<_:O/binary, C, _/binary>> ->
            tokenize_word(Bin, ?INC_CHAR(S, C), Quote, [C | Acc])
    end.

tokenize_cdata(Bin, S = #decoder{offset = O}) ->
    tokenize_cdata(Bin, S, O).

tokenize_cdata(Bin, S = #decoder{offset = O}, Start) ->
    case Bin of
        <<_:O/binary, "]]>", _/binary>> ->
            Len = O - Start,
            <<_:Start/binary, Raw:Len/binary, _/binary>> = Bin,
            {{data, Raw, false}, ?ADV_COL(S, 3)};
        <<_:O/binary, C, _/binary>> ->
            tokenize_cdata(Bin, ?INC_CHAR(S, C), Start);
        _ ->
            <<_:O/binary, Raw/binary>> = Bin,
            {{data, Raw, false}, S}
    end.

tokenize_comment(Bin, S = #decoder{offset = O}) ->
    tokenize_comment(Bin, S, O).

tokenize_comment(Bin, S = #decoder{offset = O}, Start) ->
    case Bin of
        <<_:O/binary, "-->", _/binary>> ->
            Len = O - Start,
            <<_:Start/binary, Raw:Len/binary, _/binary>> = Bin,
            {{comment, Raw}, ?ADV_COL(S, 3)};
        <<_:O/binary, C, _/binary>> ->
            tokenize_comment(Bin, ?INC_CHAR(S, C), Start);
        <<_:Start/binary, Raw/binary>> ->
            {{comment, Raw}, S}
    end.

tokenize_script(Bin, S = #decoder{offset = O}) ->
    tokenize_script(Bin, S, O).

tokenize_script(Bin, S = #decoder{offset = O}, Start) ->
    case Bin of
        %% Just a look-ahead, we want the end_tag separately
        <<_:O/binary, $<, $/, SS, CC, RR, II, PP, TT, ZZ, _/binary>> when
            (SS =:= $s orelse SS =:= $S) andalso
                (CC =:= $c orelse CC =:= $C) andalso
                (RR =:= $r orelse RR =:= $R) andalso
                (II =:= $i orelse II =:= $I) andalso
                (PP =:= $p orelse PP =:= $P) andalso
                (TT =:= $t orelse TT =:= $T) andalso
                ?PROBABLE_CLOSE(ZZ)
        ->
            Len = O - Start,
            <<_:Start/binary, Raw:Len/binary, _/binary>> = Bin,
            {{data, Raw, false}, S};
        <<_:O/binary, C, _/binary>> ->
            tokenize_script(Bin, ?INC_CHAR(S, C), Start);
        <<_:Start/binary, Raw/binary>> ->
            {{data, Raw, false}, S}
    end.

tokenize_style(Bin, S = #decoder{offset = O}) ->
    tokenize_style(Bin, S, O).

tokenize_style(Bin, S = #decoder{offset = O}, Start) ->
    case Bin of
        %% Just a look-ahead, we want the end_tag separately
        <<_:O/binary, $<, $/, SS, TT, YY, LL, EE, ZZ, _/binary>> when
            (SS =:= $s orelse SS =:= $S) andalso
                (TT =:= $t orelse TT =:= $T) andalso
                (YY =:= $y orelse YY =:= $Y) andalso
                (LL =:= $l orelse LL =:= $L) andalso
                (EE =:= $e orelse EE =:= $E) andalso
                ?PROBABLE_CLOSE(ZZ)
        ->
            Len = O - Start,
            <<_:Start/binary, Raw:Len/binary, _/binary>> = Bin,
            {{data, Raw, false}, S};
        <<_:O/binary, C, _/binary>> ->
            tokenize_style(Bin, ?INC_CHAR(S, C), Start);
        <<_:Start/binary, Raw/binary>> ->
            {{data, Raw, false}, S}
    end.

tokenize_title(Bin, S = #decoder{offset = O}) ->
    tokenize_title(Bin, S, O).

tokenize_title(Bin, S = #decoder{offset = O}, Start) ->
    case Bin of
        %% Just a look-ahead, we want the end_tag separately
        <<_:O/binary, $<, $/, TT, II, TT2, LL, EE, ZZ, _/binary>> when
            (TT =:= $t orelse TT =:= $T) andalso
                (II =:= $i orelse II =:= $I) andalso
                (TT2 =:= $t orelse TT2 =:= $T) andalso
                (LL =:= $l orelse LL =:= $L) andalso
                (EE =:= $e orelse EE =:= $E) andalso
                ?PROBABLE_CLOSE(ZZ)
        ->
            Len = O - Start,
            <<_:Start/binary, Raw:Len/binary, _/binary>> = Bin,
            {{data, Raw, false}, S};
        <<_:O/binary, C, _/binary>> ->
            tokenize_title(Bin, ?INC_CHAR(S, C), Start);
        <<_:Start/binary, Raw/binary>> ->
            {{data, Raw, false}, S}
    end.

tokenize_textarea(Bin, S = #decoder{offset = O}) ->
    tokenize_textarea(Bin, S, O).

tokenize_textarea(Bin, S = #decoder{offset = O}, Start) ->
    case Bin of
        %% Just a look-ahead, we want the end_tag separately
        <<_:O/binary, $<, $/, TT, EE, XX, TT2, AA, RR, EE2, AA2, ZZ, _/binary>> when
            (TT =:= $t orelse TT =:= $T) andalso
                (EE =:= $e orelse EE =:= $E) andalso
                (XX =:= $x orelse XX =:= $X) andalso
                (TT2 =:= $t orelse TT2 =:= $T) andalso
                (AA =:= $a orelse AA =:= $A) andalso
                (RR =:= $r orelse RR =:= $R) andalso
                (EE2 =:= $e orelse EE2 =:= $E) andalso
                (AA2 =:= $a orelse AA2 =:= $A) andalso
                ?PROBABLE_CLOSE(ZZ)
        ->
            Len = O - Start,
            <<_:Start/binary, Raw:Len/binary, _/binary>> = Bin,
            {{data, Raw, false}, S};
        <<_:O/binary, C, _/binary>> ->
            tokenize_textarea(Bin, ?INC_CHAR(S, C), Start);
        <<_:Start/binary, Raw/binary>> ->
            {{data, Raw, false}, S}
    end.
