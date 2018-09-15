defmodule Floki.HTML.Tokenizer do
  @lower_ASCII_letters Enum.map(?a..?z, fn l -> <<l::utf8>> end)
  @upper_ASCII_letters Enum.map(?A..?Z, fn l -> <<l::utf8>> end)
  @all_ASCII_letters @lower_ASCII_letters ++ @upper_ASCII_letters
  @space_chars ["\t", "\n", "\f", "\s"]

  @less_than_sign {:char, "\u003C"}
  @greater_than_sign {:char, "\u003E"}
  @exclamation_mark {:char, "\u0021"}
  @solidus {:char, "\u002F"}
  @hyphen_minus {:char, "\u002D"}
  @replacement_char {:char, "\uFFFD"}

  # It represents the state of tokenization.
  defmodule State do
    defstruct current: nil,
              return_state: nil,
              token: nil,
              tokens: [],
              buffer: "",
              last_start_tag: nil,
              open_tags: [],
              line: 1,
              column: 1
  end

  def tokenize(html) do
    tokenize(html, %State{current: :data})
  end

  defp tokenize(_, %State{tokens: [{:eof, _, _} | tokens]}), do: Enum.reverse(tokens)

  # § tokenizer-data-state

  defp tokenize(<<"&", html::binary>>, s = %State{current: :data}) do
    tokenize(html, %{s | return_state: :data, current: :char_ref, column: s.column + 1})
  end

  defp tokenize(<<"<", html::binary>>, s = %State{current: :data}) do
    tokenize(html, %{s | current: :tag_open, column: s.column + 1})
  end

  defp tokenize(<<"\0", html::binary>>, s = %State{current: :data}) do
    tokenize(html, %{s | tokens: [{:char, "\0"} | s.tokens]})
  end

  defp tokenize(html = "", s = %State{current: :data}) do
    tokenize(html, %{s | tokens: [{:eof, s.column, s.line} | s.tokens]})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :data}) do
    tokenize(html, %{s | tokens: [{:char, <<c::utf8>>} | s.tokens]})
  end

  # § tokenizer-rcdata-state

  defp tokenize(<<"&", html::binary>>, s = %State{current: :rcdata}) do
    tokenize(html, %{s | return_state: :rcdata, current: :char_ref, column: s.column + 1})
  end

  defp tokenize(<<"<", html::binary>>, s = %State{current: :rcdata}) do
    tokenize(html, %{s | current: :rcdata_less_than_sign, column: s.column + 1})
  end

  defp tokenize(<<"\0", html::binary>>, s = %State{current: :rcdata}) do
    tokenize(html, %{s | tokens: [@replacement_char | s.tokens]})
  end

  defp tokenize(html = "", s = %State{current: :rcdata}) do
    tokenize(html, %{s | tokens: [{:eof, s.column, s.line} | s.tokens]})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :rcdata}) do
    tokenize(html, %{s | tokens: [{:char, <<c::utf8>>} | s.tokens], column: s.column + 1})
  end

  # § tokenizer-rawtext-state

  defp tokenize(<<"<", html::binary>>, s = %State{current: :rawtext}) do
    tokenize(html, %{s | current: :rawtext_less_than_sign})
  end

  defp tokenize(<<"\0", html::binary>>, s = %State{current: :rawtext}) do
    tokenize(html, %{s | tokens: [@replacement_char | s.tokens]})
  end

  defp tokenize(html = "", s = %State{current: :rawtext}) do
    tokenize(html, %{s | tokens: [{:eof, s.column, s.line} | s.tokens]})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :rawtext}) do
    tokenize(html, %{s | tokens: [{:char, <<c::utf8>>} | s.tokens], column: s.column + 1})
  end

  # § tokenizer-script-data-state

  defp tokenize(<<"<", html::binary>>, s = %State{current: :script_data}) do
    tokenize(html, %{s | current: :script_data_less_than_sign})
  end

  defp tokenize(<<"\0", html::binary>>, s = %State{current: :script_data}) do
    tokenize(html, %{s | tokens: [@replacement_char | s.tokens]})
  end

  defp tokenize(html = "", s = %State{current: :script_data}) do
    tokenize(html, %{s | tokens: [{:eof, s.column, s.line} | s.tokens]})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :script_data}) do
    tokenize(html, %{s | tokens: [{:char, <<c::utf8>>} | s.tokens], column: s.column + 1})
  end

  # § tokenizer-plaintext-state

  defp tokenize(<<"\0", html::binary>>, s = %State{current: :plaintext}) do
    tokenize(html, %{s | tokens: [@replacement_char | s.tokens]})
  end

  defp tokenize(html = "", s = %State{current: :plaintext}) do
    tokenize(html, %{s | tokens: [{:eof, s.column, s.line} | s.tokens]})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :plaintext}) do
    tokenize(html, %{s | tokens: [{:char, <<c::utf8>>} | s.tokens], column: s.column + 1})
  end

  # § tokenizer-tag-open-state

  defp tokenize(<<"!", html::binary>>, s = %State{current: :tag_open}) do
    tokenize(html, %{s | current: :markup_declaration_open, column: s.column + 1})
  end

  defp tokenize(<<"/", html::binary>>, s = %State{current: :tag_open}) do
    tokenize(html, %{s | current: :end_tag_open, column: s.column + 1})
  end

  defp tokenize(html = <<c::utf8, _rest::binary>>, s = %State{current: :tag_open})
       when <<c::utf8>> in @all_ASCII_letters do
    token = {:start_tag, "", s.column, s.line}

    tokenize(html, %{s | token: token, current: :tag_name})
  end

  defp tokenize(html = <<"?", _rest::binary>>, s = %State{current: :tag_open}) do
    token = {:comment, "", s.column, s.line}

    tokenize(html, %{s | token: token, current: :bogus_comment})
  end

  defp tokenize(html, s = %State{current: :tag_open}) do
    tokenize(html, %{s | token: nil, tokens: [@less_than_sign | s.tokens], current: :data})
  end

  # § tokenizer-end-tag-open-state

  defp tokenize(html = <<c::utf8, _rest::binary>>, s = %State{current: :end_tag_open})
       when <<c::utf8>> in @all_ASCII_letters do
    token = {:end_tag, "", s.column, s.line}

    tokenize(html, %{s | token: token, current: :tag_name})
  end

  defp tokenize(<<">", html::binary>>, s = %State{current: :end_tag_open}) do
    tokenize(html, %{s | token: nil, current: :data})
  end

  defp tokenize(html = "", s = %State{current: :end_tag_open}) do
    eof = {:eof, s.column, s.line}

    tokens = [eof, @solidus, @less_than_sign | s.tokens]
    tokenize(html, %{s | token: nil, tokens: tokens, current: :data})
  end

  defp tokenize(html, s = %State{current: :end_tag_open}) do
    token = {:comment, "", s.column, s.line}

    tokenize(html, %{s | token: token, current: :bogus_comment})
  end

  # § tokenizer-tag-name-state

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :tag_name})
       when <<c::utf8>> in @space_chars do
    line = line_number(<<c::utf8>>, s.line)
    tokenize(html, %{s | current: :before_attribute_name, column: s.column + 1, line: line})
  end

  defp tokenize(<<"/", html::binary>>, s = %State{current: :tag_name}) do
    tokenize(html, %{s | current: :self_closing_start_tag, column: s.column + 1})
  end

  defp tokenize(<<">", html::binary>>, s = %State{current: :tag_name}) do
    tokenize(html, %{
      s
      | current: :data,
        last_start_tag: s.token,
        tokens: [s.token | s.tokens],
        token: nil,
        column: s.column + 1
    })
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :tag_name})
       when <<c::utf8>> in @upper_ASCII_letters do
    {start_or_end_tag, tag_name, col, line} = s.token
    new_token = {start_or_end_tag, tag_name <> String.downcase(<<c::utf8>>), col + 1, line}

    tokenize(html, %{s | token: new_token, column: col + 1})
  end

  defp tokenize(<<"\0", html::binary>>, s = %State{current: :tag_name}) do
    {start_or_end_tag, tag_name, col, line} = s.token

    tokenize(html, %{
      s
      | token: {start_or_end_tag, tag_name <> "\uFFFD", col + 1, line},
        column: col + 1
    })
  end

  defp tokenize(html = "", s = %State{current: :tag_name}) do
    tokenize(html, %{s | token: nil, tokens: [{:eof, s.column, s.line} | s.tokens]})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :tag_name}) do
    {start_or_end_tag, tag_name, col, line} = s.token
    new_token = {start_or_end_tag, tag_name <> <<c::utf8>>, col + 1, line}

    tokenize(html, %{s | token: new_token, column: col + 1})
  end

  # § tokenizer-rcdata-less-than-sign-state

  defp tokenize(<<"/", html::binary>>, s = %State{current: :rcdata_less_than_sign}) do
    tokenize(html, %{s | buffer: "", current: :rcdata_end_tag_open, column: s.column + 1})
  end

  defp tokenize(html, s = %State{current: :rcdata_less_than_sign}) do
    tokenize(html, %{s | token: nil, tokens: [@less_than_sign | s.tokens], current: :rcdata})
  end

  # § tokenizer-rcdata-end-tag-open-state

  defp tokenize(
         html = <<c::utf8, _rest::binary>>,
         s = %State{current: :rcdata_end_tag_open}
       )
       when <<c::utf8>> in @all_ASCII_letters do
    token = {:end_tag, "", s.column, s.line}
    tokenize(html, %{s | token: token, current: :rcdata_end_tag_name})
  end

  defp tokenize(html, s = %State{current: :rcdata_end_tag_open}) do
    tokens = [@solidus, @less_than_sign | s.tokens]
    tokenize(html, %{s | tokens: tokens, current: :rcdata})
  end

  # § tokenizer-rcdata-end-tag-name-state
  # § tokenizer-rawtext-end-tag-name-state
  # § tokenizer-script-data-end-tag-name-state
  # § tokenizer-script-data-escaped-end-tag-name-state

  @raw_end_tag_name_states [
    :rcdata_end_tag_name,
    :rawtext_end_tag_name,
    :script_data_end_tag_name,
    :script_data_escaped_end_tag_name
  ]

  defp tokenize(
         html = <<c::utf8, rest::binary>>,
         s = %State{current: state}
       )
       when <<c::utf8>> in @space_chars and state in @raw_end_tag_name_states do
    line = line_number(<<c::utf8>>, s.line)

    if appropriate_tag?(s) do
      tokenize(rest, %{s | current: :before_attribute_name, column: s.column + 1, line: line})
    else
      tokenize(html, %{
        s
        | tokens: tokens_for_inappropriate_end_tag(s),
          buffer: "",
          current: next_state_for_raw_end_tag(state)
      })
    end
  end

  defp tokenize(html = <<"/", rest::binary>>, s = %State{current: state})
       when state in @raw_end_tag_name_states do
    if appropriate_tag?(s) do
      tokenize(rest, %{s | current: :self_closing_start_tag, column: s.column + 1})
    else
      tokenize(html, %{
        s
        | tokens: tokens_for_inappropriate_end_tag(s),
          buffer: "",
          current: next_state_for_raw_end_tag(state)
      })
    end
  end

  defp tokenize(html = <<">", rest::binary>>, s = %State{current: state})
       when state in @raw_end_tag_name_states do
    if appropriate_tag?(s) do
      tokenize(rest, %{
        s
        | current: :data,
          token: nil,
          tokens: [s.token | s.tokens],
          column: s.column + 1
      })
    else
      tokenize(html, %{
        s
        | tokens: tokens_for_inappropriate_end_tag(s),
          buffer: "",
          current: next_state_for_raw_end_tag(state)
      })
    end
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: state})
       when <<c::utf8>> in @upper_ASCII_letters and state in @raw_end_tag_name_states do
    char = <<c::utf8>>
    {:end_tag, end_tag, col, line} = s.token
    downcase_char = String.downcase(char)
    new_token = {:end_tag, end_tag <> downcase_char, col + 1, line}

    tokenize(html, %{s | token: new_token, buffer: s.buffer <> char})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: state})
       when <<c::utf8>> in @lower_ASCII_letters and state in @raw_end_tag_name_states do
    char = <<c::utf8>>
    {:end_tag, end_tag, col, line} = s.token
    new_token = {:end_tag, end_tag <> char, col + 1, line}

    tokenize(html, %{s | token: new_token, buffer: s.buffer <> char})
  end

  defp tokenize(html, s = %State{current: state}) when state in @raw_end_tag_name_states do
    tokenize(html, %{
      s
      | tokens: tokens_for_inappropriate_end_tag(s),
        buffer: "",
        current: next_state_for_raw_end_tag(state)
    })
  end

  # § tokenizer-rawtext-less-than-sign-state

  defp tokenize(<<"/", html::binary>>, s = %State{current: :rawtext_less_than_sign}) do
    tokenize(html, %{s | buffer: "", current: :rawtext_end_tag_open})
  end

  defp tokenize(html, s = %State{current: :rawtext_less_than_sign}) do
    tokenize(html, %{
      s
      | tokens: [{:char, "\u003C"} | s.tokens],
        current: :rawtext
    })
  end

  # § tokenizer-rawtext-end-tag-open-state

  defp tokenize(
         html = <<c::utf8, _rest::binary>>,
         s = %State{current: :rawtext_end_tag_open}
       )
       when <<c::utf8>> in @all_ASCII_letters do
    token = {:end_tag, "", s.column, s.line}
    tokenize(html, %{s | token: token, current: :rawtext_end_tag_name})
  end

  defp tokenize(html, s = %State{current: :rawtext_end_tag_open}) do
    tokens = [@solidus, @less_than_sign | s.tokens]
    tokenize(html, %{s | tokens: tokens, current: :rawtext})
  end

  # § tokenizer-script-data-less-than-sign-state

  defp tokenize(<<"/", html::binary>>, s = %State{current: :script_data_less_than_sign}) do
    tokenize(html, %{s | buffer: "", current: :script_data_end_tag_open_state})
  end

  defp tokenize(<<"!", html::binary>>, s = %State{current: :script_data_less_than_sign}) do
    tokens = [@exclamation_mark, @less_than_sign | s.tokens]
    tokenize(html, %{s | tokens: tokens})
  end

  defp tokenize(html, s = %State{current: :script_data_less_than_sign}) do
    tokenize(html, %{s | tokens: [@less_than_sign | s.tokens], current: :script_data})
  end

  # § tokenizer-script-data-end-tag-open-state

  defp tokenize(
         html = <<c::utf8, _rest::binary>>,
         s = %State{current: :script_data_end_tag_open}
       )
       when <<c::utf8>> in @all_ASCII_letters do
    end_tag = {:end_tag, "", s.column + 1, s.line}

    tokenize(html, %{s | token: end_tag, current: :script_data_end_tag_name})
  end

  defp tokenize(html, s = %State{current: :script_data_end_tag_open}) do
    tokenize(html, %{s | tokens: [@solidus, @less_than_sign | s.tokens], current: :script_data})
  end

  # § tokenizer-script-data-escape-start-state

  defp tokenize(<<"-", html::binary>>, s = %State{current: :script_data_escape_start}) do
    tokenize(
      html,
      %{s | tokens: [@hyphen_minus | s.tokens], current: :script_data_escape_start_dash}
    )
  end

  defp tokenize(html, s = %State{current: :script_data_escape_start}) do
    tokenize(html, %{s | current: :script_data})
  end

  # § tokenizer-script-data-escape-start-dash-state

  defp tokenize(<<"-", html::binary>>, s = %State{current: :script_data_escape_start_dash}) do
    tokenize(
      html,
      %{s | tokens: [@hyphen_minus | s.tokens], current: :script_data_escaped_dash_dash}
    )
  end

  defp tokenize(html, s = %State{current: :script_data_escape_start_dash}) do
    tokenize(html, %{s | current: :script_data})
  end

  # § tokenizer-script-data-escaped-state

  defp tokenize(<<"-", html::binary>>, s = %State{current: :script_data_escaped}) do
    tokenize(
      html,
      %{s | tokens: [@hyphen_minus | s.tokens], current: :script_data_escaped_dash}
    )
  end

  defp tokenize(<<"<", html::binary>>, s = %State{current: :script_data_escaped}) do
    tokenize(html, %{s | current: :script_data_escaped_less_than_sign})
  end

  defp tokenize(<<"\0", html::binary>>, s = %State{current: :script_data_escaped}) do
    tokenize(html, %{s | tokens: [@replacement_char | s.tokens]})
  end

  defp tokenize(html = "", s = %State{current: :script_data_escaped}) do
    tokenize(html, %{s | tokens: [{:eof, s.column, s.line} | s.tokens]})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :script_data_escaped}) do
    tokenize(html, %{s | tokens: [{:char, <<c::utf8>>} | s.tokens]})
  end

  # § tokenizer-script-data-escaped-dash-state

  defp tokenize(<<"-", html::binary>>, s = %State{current: :script_data_escaped_dash}) do
    tokenize(
      html,
      %{s | tokens: [@hyphen_minus | s.tokens], current: :script_data_escaped_dash_dash}
    )
  end

  defp tokenize(<<"<", html::binary>>, s = %State{current: :script_data_escaped_dash}) do
    tokenize(html, %{s | current: :script_data_escaped_less_than_sign})
  end

  defp tokenize(<<"\0", html::binary>>, s = %State{current: :script_data_escaped_dash}) do
    tokenize(html, %{s | tokens: [@replacement_char | s.tokens], current: :script_data_escaped})
  end

  defp tokenize(html = "", s = %State{current: :script_data_escaped_dash}) do
    tokenize(html, %{s | tokens: [{:eof, s.column, s.line} | s.tokens]})
  end

  defp tokenize(
         <<c::utf8, html::binary>>,
         s = %State{current: :script_data_escaped_dash}
       ) do
    tokenize(html, %{s | tokens: [{:char, <<c::utf8>>} | s.tokens], current: :script_data_escaped})
  end

  # § tokenizer-script-data-escaped-dash-dash-state

  defp tokenize(<<"-", html::binary>>, s = %State{current: :script_data_escaped_dash_dash}) do
    tokenize(
      html,
      %{s | tokens: [@hyphen_minus | s.tokens]}
    )
  end

  defp tokenize(<<"<", html::binary>>, s = %State{current: :script_data_escaped_dash_dash}) do
    tokenize(html, %{s | current: :script_data_escaped_less_than_sign})
  end

  defp tokenize(<<">", html::binary>>, s = %State{current: :script_data_escaped_dash_dash}) do
    tokenize(html, %{s | tokens: [@greater_than_sign | s.tokens], current: :script_data})
  end

  defp tokenize(<<"\0", html::binary>>, s = %State{current: :script_data_escaped_dash_dash}) do
    tokenize(html, %{s | tokens: [@replacement_char | s.tokens], current: :script_data_escaped})
  end

  defp tokenize(html = "", s = %State{current: :script_data_escaped_dash_dash}) do
    tokenize(html, %{s | tokens: [{:eof, s.column, s.line} | s.tokens]})
  end

  defp tokenize(
         <<c::utf8, html::binary>>,
         s = %State{current: :script_data_escaped_dash_dash}
       ) do
    tokenize(html, %{s | tokens: [{:char, <<c::utf8>>} | s.tokens], current: :script_data_escaped})
  end

  # § tokenizer-script-data-escaped-less-than-sign-state

  defp tokenize(<<"/", html::binary>>, s = %State{current: :script_data_escaped_less_than_sign}) do
    tokenize(html, %{s | buffer: "", current: :script_data_escaped_end_tag_open})
  end

  defp tokenize(
         html = <<c::utf8, _rest::binary>>,
         s = %State{current: :script_data_escaped_less_than_sign}
       )
       when <<c::utf8>> in @all_ASCII_letters do
    tokenize(
      html,
      %{
        s
        | buffer: "",
          tokens: [@less_than_sign | s.tokens],
          current: :script_data_double_escape_start
      }
    )
  end

  defp tokenize(html, s = %State{current: :script_data_escaped_less_than_sign}) do
    tokenize(html, %{s | tokens: [@less_than_sign | s.tokens], current: :script_data_escaped})
  end

  # § tokenizer-script-data-escaped-end-tag-open-state

  defp tokenize(
         html = <<c::utf8, _rest::binary>>,
         s = %State{current: :script_data_escaped_end_tag_open}
       )
       when <<c::utf8>> in @all_ASCII_letters do
    tokenize(
      html,
      %{
        s
        | token: {:end_tag, "", s.column, s.line},
          current: :script_data_escaped_end_tag_name
      }
    )
  end

  defp tokenize(html, s = %State{current: :script_data_escaped_end_tag_open}) do
    tokenize(html, %{
      s
      | tokens: [@solidus, @less_than_sign | s.tokens],
        current: :script_data_escaped
    })
  end

  # § tokenizer-script-data-double-escape-start-state

  defp tokenize(
         <<c::utf8, html::binary>>,
         s = %State{current: :script_data_escaped_end_tag_open}
       )
       when <<c::utf8>> in ["/", ">" | @space_chars] do
    next =
      if s.buffer == "script" do
        :script_data_double_escaped
      else
        :script_data_escaped
      end

    tokenize(html, %{s | tokens: [{:char, <<c::utf8>>} | s.tokens], current: next})
  end

  defp tokenize(
         <<c::utf8, html::binary>>,
         s = %State{current: :script_data_escaped_end_tag_open}
       )
       when <<c::utf8>> in @upper_ASCII_letters do
    char = <<c::utf8>>

    tokenize(html, %{
      s
      | buffer: s.buffer <> String.downcase(char),
        tokens: [{:char, char} | s.tokens]
    })
  end

  defp tokenize(
         <<c::utf8, html::binary>>,
         s = %State{current: :script_data_escaped_end_tag_open}
       )
       when <<c::utf8>> in @lower_ASCII_letters do
    char = <<c::utf8>>
    tokenize(html, %{s | buffer: s.buffer <> char, tokens: [{:char, char} | s.tokens]})
  end

  defp tokenize(html, s = %State{current: :script_data_escaped_end_tag_open}) do
    tokenize(html, %{s | current: :script_data_escaped})
  end

  # TODO: continue

  defp tokenize(<<"!", html::binary>>, s = %State{current: :markup_declaration_open}) do
    case html do
      <<"--", rest::binary>> ->
        token = {:comment, "", s.line, s.column}

        tokenize(
          rest,
          %{s | current: :comment_start, token: token, column: s.column + 3}
        )

      <<"[", cdata::bytes-size(5), "]", rest::binary>> ->
        if String.match?(cdata, ~r/cdata/i) do
          # TODO: fix cdata state
          tokenize(
            rest,
            s
          )
        end

      <<doctype::bytes-size(7), rest::binary>> when doctype in ["doctype", "DOCTYPE"] ->
        token = {:doctype, nil, nil, nil, false, s.line, s.column}

        tokenize(
          rest,
          %{s | current: :doctype, token: token, column: s.column + 7}
        )

      _ ->
        tokenize(html, s)
    end
  end

  defp tokenize(<<"-", html::binary>>, s = %State{current: :comment_start}) do
    tokenize(html, %{s | current: :comment_start_dash, column: s.column + 1})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :comment_start}) do
    {:comment, comment, _, _} = s.token
    new_token = {:comment, comment <> c, s.line, s.column}

    tokenize(
      html,
      %{s | current: :comment, token: new_token, column: s.column + 1}
    )
  end

  defp tokenize(<<"-", html::binary>>, s = %State{current: :comment}) do
    tokenize(html, %{s | current: :comment_end_dash, column: s.column + 1})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :comment}) do
    {:comment, comment, l, cl} = s.token
    new_token = {:comment, comment <> <<c::utf8>>, l, cl}

    tokenize(
      html,
      %{s | current: :comment, token: new_token, column: s.column + 1}
    )
  end

  defp tokenize(<<"-", html::binary>>, s = %State{current: :comment_start_dash}) do
    tokenize(html, %{s | current: :comment_end, column: s.column + 1})
  end

  defp tokenize(<<"-", html::binary>>, s = %State{current: :comment_end_dash}) do
    tokenize(html, %{s | current: :comment_end, column: s.column + 1})
  end

  defp tokenize(<<">", html::binary>>, s = %State{current: :comment_end}) do
    tokenize(
      html,
      %{s | current: :data, tokens: [s.token | s.tokens], token: nil, column: s.column + 1}
    )
  end

  defp tokenize(html = "", s = %State{current: :comment_end}) do
    tokenize(
      html,
      %{
        s
        | current: :data,
          tokens: [{:eof, s.column, s.line} | [s.token | s.tokens]],
          token: nil,
          column: s.column + 1
      }
    )
  end

  defp tokenize(<<"!", html::binary>>, s = %State{current: :comment_end}) do
    tokenize(html, %{s | current: :comment_end_bang})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :doctype})
       when <<c::utf8>> in @space_chars do
    line = line_number(<<c::utf8>>, s.line)
    tokenize(html, %{s | current: :before_doctype_name, column: s.column + 1, line: line})
  end

  # This is a case of error, when there is no token left. It shouldn't be executed because
  # of the base function that stops the recursion.
  # TODO: implement me, since the problem describe was solved.
  # defp tokenize("", s = %State{current: :doctype}) do
  # end

  defp tokenize(html, s = %State{current: :doctype}) do
    tokenize(html, %{s | current: :before_doctype_name})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :before_doctype_name})
       when <<c::utf8>> in @space_chars do
    line = line_number(<<c::utf8>>, s.line)
    tokenize(html, %{s | current: :before_doctype_name, column: s.column + 1, line: line})
  end

  defp tokenize(<<">", html::binary>>, s = %State{current: :before_doctype_name}) do
    token = {:doctype, nil, nil, nil, true, s.line, s.column}

    tokenize(html, %{
      s
      | current: :data,
        tokens: [token | s.tokens],
        token: nil,
        column: s.column + 1
    })
  end

  defp tokenize(<<"\0", html::binary>>, s = %State{current: :before_doctype_name}) do
    token = {:doctype, "\uFFFD", nil, nil, true, s.line, s.column}
    tokenize(html, %{s | current: :doctype_name, token: token, column: s.column + 1})
  end

  defp tokenize("", s = %State{current: :before_doctype_name}) do
    token = {:doctype, nil, nil, nil, true, s.line, s.column}

    tokenize("", %{
      s
      | tokens: [{:eof, s.line, s.column} | [token | s.tokens]],
        token: nil,
        column: s.column + 1
    })
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :before_doctype_name}) do
    token = {:doctype, String.downcase(<<c::utf8>>), nil, nil, false, s.line, s.column + 1}
    tokenize(html, %{s | current: :doctype_name, token: token, column: s.column + 1})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :doctype_name})
       when <<c::utf8>> in @space_chars do
    line = line_number(<<c::utf8>>, s.line)
    tokenize(html, %{s | current: :after_doctype_name, column: s.column + 1, line: line})
  end

  defp tokenize(<<">", html::binary>>, s = %State{current: :doctype_name}) do
    # TODO: get column from tuple instead
    token = put_elem(s.token, 6, s.column + 1)

    tokenize(html, %{
      s
      | current: :data,
        tokens: [token | s.tokens],
        token: nil,
        column: s.column + 1
    })
  end

  defp tokenize(<<"\0", html::binary>>, s = %State{current: :doctype_name}) do
    {:doctype, name, _, _, _, _, column} = s.token
    new_token =
      s.token
      |> put_elem(1, name <> "\uFFFD")
      |> put_elem(6, column + 1)

    tokenize(html, %{s | current: :doctype_name, token: new_token, column: s.column + 1})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :doctype_name}) do
    {:doctype, name, _, _, _, _, column} = s.token

    new_token =
      s.token
      |> put_elem(1, name <> String.downcase(<<c::utf8>>))
      |> put_elem(6, column + 1)

    tokenize(html, %{s | current: :doctype_name, token: new_token, column: s.column + 1})
  end

  defp tokenize("", s = %State{current: :doctype_name}) do
    token = put_elem(s.token, 4, true)

    tokenize("", %{
      s
      | tokens: [{:eof, s.line, s.column} | [token | s.tokens]],
        token: nil,
        column: s.column + 1
    })
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :after_doctype_name})
       when <<c::utf8>> in @space_chars do
    line = line_number(c, s.line)
    tokenize(html, %{s | current: :after_doctype_name, column: s.column + 1, line: line})
  end

  defp tokenize(<<">", html::binary>>, s = %State{current: :after_doctype_name}) do
    # TODO: get column from tuple instead
    token = put_elem(s.token, 6, s.column + 1)

    tokenize(html, %{
      s
      | current: :data,
        tokens: [token | s.tokens],
        token: nil,
        column: s.column + 1
    })
  end

  defp tokenize("", s = %State{current: :after_doctype_name}) do
    token = put_elem(s.token, 4, true)

    tokenize("", %{
      s
      | tokens: [{:eof, s.line, s.column} | [token | s.tokens]],
        token: nil,
        column: s.column + 1
    })
  end

  defp tokenize(<<public::bytes-size(6), html::binary>>, s = %State{current: :after_doctype_name})
       when public in ["public", "PUBLIC"] do
    tokenize(html, %{s | current: :after_doctype_public_keyword, column: s.column + 6})
  end

  defp line_number("\n", current_line), do: current_line + 1
  defp line_number(_, current_line), do: current_line

  defp appropriate_tag?(state) do
    with {:start_tag, start_tag_name, _, _} <- state.last_start_tag,
         {:end_tag, end_tag_name, _, _} <- state.token,
         true <- start_tag_name == end_tag_name do
      true
    else
      _ -> false
    end
  end

  defp tokens_for_inappropriate_end_tag(state) do
    buffer_chars =
      state.buffer
      |> String.codepoints()
      |> Enum.map(&{:char, &1})

    tokens = [@solidus, @less_than_sign | state.tokens]
    Enum.reduce(buffer_chars, tokens, fn char, acc -> [char | acc] end)
  end

  defp next_state_for_raw_end_tag(current) do
    case current do
      :rcdata_end_tag_name ->
        :rcdata

      :rawtext_end_tag_name ->
        :rawtext

      :script_data_end_tag_name ->
        :script_data

      :script_data_escaped_end_tag_name ->
        :script_data_escaped
    end
  end
end
