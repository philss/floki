defmodule Floki.HTML.Tokenizer do
  @moduledoc false

  # It parses a HTML file according to the specs of W3C:
  # https://w3c.github.io/html/syntax.html
  #
  # In order to find the docs of a given state, add it as an anchor to the link above.
  # Example: https://w3c.github.io/html/syntax.html#tokenizer-data-state
  # TODO: add tests: https://github.com/html5lib/html5lib-tests

  defmodule Doctype do
    defstruct name: nil,
              public_id: nil,
              system_id: nil,
              force_quirks: :off,
              line: nil,
              column: nil
  end

  defmodule Attribute do
    defstruct name: "", value: "", line: nil, column: nil
  end

  defmodule Tag do
    defstruct name: "",
              type: :start,
              self_close: nil,
              attributes: [],
              current_attribute: nil,
              line: nil,
              column: nil
  end

  defmodule Comment do
    defstruct data: "", line: nil, column: nil
  end

  defmodule Char do
    defstruct data: ""
  end

  # It represents the state of tokenization.
  defmodule State do
    defstruct current: nil,
              return_state: nil,
              token: nil,
              tokens: [],
              buffer: "",
              last_start_tag: nil,
              open_tags: [],
              errors: [],
              emit: nil,
              line: 1,
              column: 1
  end

  defmodule ParseError do
    defstruct id: nil, line: nil, column: nil
  end

  defmodule EOF do
    defstruct line: nil, column: nil
  end

  @lower_ASCII_letters Enum.map(?a..?z, fn l -> <<l::utf8>> end)
  @upper_ASCII_letters Enum.map(?A..?Z, fn l -> <<l::utf8>> end)
  @all_ASCII_letters @lower_ASCII_letters ++ @upper_ASCII_letters
  @space_chars ["\t", "\n", "\f", "\s"]

  @less_than_sign "\u003C"
  @greater_than_sign "\u003E"
  @exclamation_mark "\u0021"
  @solidus "\u002F"
  @hyphen_minus "\u002D"
  @replacement_char "\uFFFD"

  # TODO:
  # 1. Keep replacing tokens from tuples to Structs
  # 2. Use `s.emit.(token)` before append it to list of tokens
  # 3. Keep adding the state that you was working.
  # 4. Consider inverting the order of args to state, html

  def tokenize(html) do
    tokenize(html, %State{current: :data, emit: fn token -> token end})
  end

  defp tokenize(_, %State{tokens: [%EOF{} | tokens]}), do: Enum.reverse(tokens)

  # § tokenizer-data-state

  defp tokenize(<<"&", html::binary>>, s = %State{current: :data}) do
    tokenize(html, %{s | return_state: :data, current: :char_ref, column: s.column + 1})
  end

  defp tokenize(<<"<", html::binary>>, s = %State{current: :data}) do
    tokenize(html, %{s | current: :tag_open, column: s.column + 1})
  end

  defp tokenize(<<"\0", html::binary>>, s = %State{current: :data}) do
    tokenize(html, %{s | tokens: [%Char{data: "\0"} | s.tokens]})
  end

  defp tokenize(html = "", s = %State{current: :data}) do
    tokenize(html, %{s | tokens: [%EOF{line: s.line, column: s.column} | s.tokens]})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :data}) do
    tokenize(html, %{s | tokens: [%Char{data: <<c::utf8>>} | s.tokens]})
  end

  # § tokenizer-rcdata-state

  defp tokenize(<<"&", html::binary>>, s = %State{current: :rcdata}) do
    tokenize(html, %{s | return_state: :rcdata, current: :char_ref, column: s.column + 1})
  end

  defp tokenize(<<"<", html::binary>>, s = %State{current: :rcdata}) do
    tokenize(html, %{s | current: :rcdata_less_than_sign, column: s.column + 1})
  end

  defp tokenize(<<"\0", html::binary>>, s = %State{current: :rcdata}) do
    tokenize(html, %{s | tokens: [%Char{data: @replacement_char} | s.tokens]})
  end

  defp tokenize(html = "", s = %State{current: :rcdata}) do
    tokenize(html, %{s | tokens: [%EOF{line: s.line, column: s.column} | s.tokens]})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :rcdata}) do
    tokenize(html, %{s | tokens: [%Char{data: <<c::utf8>>} | s.tokens], column: s.column + 1})
  end

  # § tokenizer-rawtext-state

  defp tokenize(<<"<", html::binary>>, s = %State{current: :rawtext}) do
    tokenize(html, %{s | current: :rawtext_less_than_sign})
  end

  defp tokenize(<<"\0", html::binary>>, s = %State{current: :rawtext}) do
    tokenize(html, %{s | tokens: [%Char{data: @replacement_char} | s.tokens]})
  end

  defp tokenize(html = "", s = %State{current: :rawtext}) do
    tokenize(html, %{s | tokens: [%EOF{line: s.line, column: s.column} | s.tokens]})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :rawtext}) do
    tokenize(html, %{s | tokens: [%Char{data: <<c::utf8>>} | s.tokens], column: s.column + 1})
  end

  # § tokenizer-script-data-state

  defp tokenize(<<"<", html::binary>>, s = %State{current: :script_data}) do
    tokenize(html, %{s | current: :script_data_less_than_sign})
  end

  defp tokenize(<<"\0", html::binary>>, s = %State{current: :script_data}) do
    tokenize(html, %{s | tokens: [%Char{data: @replacement_char} | s.tokens]})
  end

  defp tokenize(html = "", s = %State{current: :script_data}) do
    tokenize(html, %{s | tokens: [%EOF{line: s.line, column: s.column} | s.tokens]})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :script_data}) do
    tokenize(html, %{s | tokens: [%Char{data: <<c::utf8>>} | s.tokens], column: s.column + 1})
  end

  # § tokenizer-plaintext-state

  defp tokenize(<<"\0", html::binary>>, s = %State{current: :plaintext}) do
    tokenize(html, %{s | tokens: [%Char{data: @replacement_char} | s.tokens]})
  end

  defp tokenize(html = "", s = %State{current: :plaintext}) do
    tokenize(html, %{s | tokens: [%EOF{line: s.line, column: s.column} | s.tokens]})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :plaintext}) do
    tokenize(html, %{s | tokens: [%Char{data: <<c::utf8>>} | s.tokens], column: s.column + 1})
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
    token = %Tag{type: :start, name: "", line: s.line, column: s.column}

    tokenize(html, %{s | token: token, current: :tag_name})
  end

  defp tokenize(html = <<"?", _rest::binary>>, s = %State{current: :tag_open}) do
    token = %Comment{data: "", line: s.line, column: s.column}

    tokenize(html, %{s | token: token, current: :bogus_comment, column: s.column + 1})
  end

  defp tokenize(html, s = %State{current: :tag_open}) do
    tokenize(html, %{
      s
      | token: nil,
        tokens: [%Char{data: @less_than_sign} | s.tokens],
        current: :data
    })
  end

  # § tokenizer-end-tag-open-state

  defp tokenize(html = <<c::utf8, _rest::binary>>, s = %State{current: :end_tag_open})
       when <<c::utf8>> in @all_ASCII_letters do
    token = %Tag{type: :end, name: "", line: s.line, column: s.column}

    tokenize(html, %{s | token: token, current: :tag_name})
  end

  defp tokenize(<<">", html::binary>>, s = %State{current: :end_tag_open}) do
    tokenize(html, %{s | token: nil, current: :data})
  end

  defp tokenize(html = "", s = %State{current: :end_tag_open}) do
    eof = %EOF{line: s.line, column: s.column}

    tokens = [eof, %Char{data: @solidus}, %Char{data: @less_than_sign} | s.tokens]
    tokenize(html, %{s | token: nil, tokens: tokens, current: :data})
  end

  defp tokenize(html, s = %State{current: :end_tag_open}) do
    token = %Comment{data: "", line: s.line, column: s.column}

    tokenize(html, %{s | token: token, current: :bogus_comment})
  end

  # § tokenizer-tag-name-state

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :tag_name})
       when <<c::utf8>> in @space_chars do
    line = line_number(<<c::utf8>>, s.line)
    col = column_number(line, s)
    tokenize(html, %{s | current: :before_attribute_name, column: col, line: line})
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
    new_token = %{s.token | name: s.token.name <> String.downcase(<<c::utf8>>)}

    tokenize(html, %{s | token: new_token, column: s.column + 1})
  end

  defp tokenize(<<"\0", html::binary>>, s = %State{current: :tag_name}) do
    tokenize(html, %{
      s
      | token: %{s.token | name: s.token.name <> "\uFFFD"},
        errors: [
          %ParseError{id: "unexpected-null-character", line: s.line, column: s.column}
          | s.errors
        ]
    })
  end

  defp tokenize(html = "", s = %State{current: :tag_name}) do
    tokenize(html, %{
      s
      | errors: [%ParseError{id: "eof-in-tag", line: s.line, column: s.column} | s.errors],
        tokens: [%EOF{line: s.line, column: s.column} | s.tokens]
    })
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :tag_name}) do
    new_token = %{s.token | name: s.token.name <> <<c::utf8>>}

    tokenize(html, %{s | token: new_token, column: s.column + 1})
  end

  # § tokenizer-rcdata-less-than-sign-state

  defp tokenize(<<"/", html::binary>>, s = %State{current: :rcdata_less_than_sign}) do
    tokenize(html, %{s | buffer: "", current: :rcdata_end_tag_open, column: s.column + 1})
  end

  defp tokenize(html, s = %State{current: :rcdata_less_than_sign}) do
    tokenize(html, %{
      s
      | token: nil,
        tokens: [%Char{data: @less_than_sign} | s.tokens],
        current: :rcdata
    })
  end

  # § tokenizer-rcdata-end-tag-open-state

  defp tokenize(
         html = <<c::utf8, _rest::binary>>,
         s = %State{current: :rcdata_end_tag_open}
       )
       when <<c::utf8>> in @all_ASCII_letters do
    token = %Tag{type: :end, name: "", line: s.line, column: s.column}
    tokenize(html, %{s | token: token, current: :rcdata_end_tag_name})
  end

  defp tokenize(html, s = %State{current: :rcdata_end_tag_open}) do
    tokens = [%Char{data: @solidus}, %Char{data: @less_than_sign} | s.tokens]
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
    col = s.col + 1
    char = <<c::utf8>>
    new_token = %{s.token | name: s.name <> String.downcase(char), column: col}

    tokenize(html, %{s | token: new_token, buffer: s.buffer <> char, col: col})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: state})
       when <<c::utf8>> in @lower_ASCII_letters and state in @raw_end_tag_name_states do
    col = s.col + 1
    char = <<c::utf8>>
    new_token = %{s.token | name: s.name <> char, column: col}

    tokenize(html, %{s | token: new_token, buffer: s.buffer <> char, col: col})
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
      | tokens: [%Char{data: "\u003C"} | s.tokens],
        current: :rawtext
    })
  end

  # § tokenizer-rawtext-end-tag-open-state

  defp tokenize(
         html = <<c::utf8, _rest::binary>>,
         s = %State{current: :rawtext_end_tag_open}
       )
       when <<c::utf8>> in @all_ASCII_letters do
    token = %Tag{type: :end, name: "", line: s.line, column: s.column}
    tokenize(html, %{s | token: token, current: :rawtext_end_tag_name})
  end

  defp tokenize(html, s = %State{current: :rawtext_end_tag_open}) do
    tokens = [%Char{data: @solidus}, %Char{data: @less_than_sign} | s.tokens]
    tokenize(html, %{s | tokens: tokens, current: :rawtext})
  end

  # § tokenizer-script-data-less-than-sign-state

  defp tokenize(<<"/", html::binary>>, s = %State{current: :script_data_less_than_sign}) do
    tokenize(html, %{s | buffer: "", current: :script_data_end_tag_open_state})
  end

  defp tokenize(<<"!", html::binary>>, s = %State{current: :script_data_less_than_sign}) do
    tokens = [%Char{data: @exclamation_mark}, %Char{data: @less_than_sign} | s.tokens]
    tokenize(html, %{s | tokens: tokens})
  end

  defp tokenize(html, s = %State{current: :script_data_less_than_sign}) do
    tokenize(html, %{s | tokens: [%Char{data: @less_than_sign} | s.tokens], current: :script_data})
  end

  # § tokenizer-script-data-end-tag-open-state

  defp tokenize(
         html = <<c::utf8, _rest::binary>>,
         s = %State{current: :script_data_end_tag_open}
       )
       when <<c::utf8>> in @all_ASCII_letters do
    col = s.column + 1
    end_tag = %Tag{type: :end, name: "", line: s.line, column: col}
    tokenize(html, %{s | token: end_tag, current: :script_data_end_tag_name, column: col})
  end

  defp tokenize(html, s = %State{current: :script_data_end_tag_open}) do
    tokenize(html, %{
      s
      | tokens: [%Char{data: @solidus}, %Char{data: @less_than_sign} | s.tokens],
        current: :script_data
    })
  end

  # § tokenizer-script-data-escape-start-state

  defp tokenize(<<"-", html::binary>>, s = %State{current: :script_data_escape_start}) do
    tokenize(
      html,
      %{
        s
        | tokens: [%Char{data: @hyphen_minus} | s.tokens],
          current: :script_data_escape_start_dash
      }
    )
  end

  defp tokenize(html, s = %State{current: :script_data_escape_start}) do
    tokenize(html, %{s | current: :script_data})
  end

  # § tokenizer-script-data-escape-start-dash-state

  defp tokenize(<<"-", html::binary>>, s = %State{current: :script_data_escape_start_dash}) do
    tokenize(
      html,
      %{
        s
        | tokens: [%Char{data: @hyphen_minus} | s.tokens],
          current: :script_data_escaped_dash_dash
      }
    )
  end

  defp tokenize(html, s = %State{current: :script_data_escape_start_dash}) do
    tokenize(html, %{s | current: :script_data})
  end

  # § tokenizer-script-data-escaped-state

  defp tokenize(<<"-", html::binary>>, s = %State{current: :script_data_escaped}) do
    tokenize(
      html,
      %{s | tokens: [%Char{data: @hyphen_minus} | s.tokens], current: :script_data_escaped_dash}
    )
  end

  defp tokenize(<<"<", html::binary>>, s = %State{current: :script_data_escaped}) do
    tokenize(html, %{s | current: :script_data_escaped_less_than_sign})
  end

  defp tokenize(<<"\0", html::binary>>, s = %State{current: :script_data_escaped}) do
    tokenize(html, %{s | tokens: [%Char{data: @replacement_char} | s.tokens]})
  end

  defp tokenize(html = "", s = %State{current: :script_data_escaped}) do
    tokenize(html, %{s | tokens: [%EOF{line: s.line, column: s.column} | s.tokens]})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :script_data_escaped}) do
    tokenize(html, %{s | tokens: [%Char{data: <<c::utf8>>} | s.tokens]})
  end

  # § tokenizer-script-data-escaped-dash-state

  defp tokenize(<<"-", html::binary>>, s = %State{current: :script_data_escaped_dash}) do
    tokenize(
      html,
      %{
        s
        | tokens: [%Char{data: @hyphen_minus} | s.tokens],
          current: :script_data_escaped_dash_dash
      }
    )
  end

  defp tokenize(<<"<", html::binary>>, s = %State{current: :script_data_escaped_dash}) do
    tokenize(html, %{s | current: :script_data_escaped_less_than_sign})
  end

  defp tokenize(<<"\0", html::binary>>, s = %State{current: :script_data_escaped_dash}) do
    tokenize(html, %{
      s
      | tokens: [%Char{data: @replacement_char} | s.tokens],
        current: :script_data_escaped
    })
  end

  defp tokenize(html = "", s = %State{current: :script_data_escaped_dash}) do
    tokenize(html, %{s | tokens: [%EOF{line: s.line, column: s.column} | s.tokens]})
  end

  defp tokenize(
         <<c::utf8, html::binary>>,
         s = %State{current: :script_data_escaped_dash}
       ) do
    tokenize(html, %{
      s
      | tokens: [%Char{data: <<c::utf8>>} | s.tokens],
        current: :script_data_escaped
    })
  end

  # § tokenizer-script-data-escaped-dash-dash-state

  defp tokenize(<<"-", html::binary>>, s = %State{current: :script_data_escaped_dash_dash}) do
    tokenize(
      html,
      %{s | tokens: [%Char{data: @hyphen_minus} | s.tokens]}
    )
  end

  defp tokenize(<<"<", html::binary>>, s = %State{current: :script_data_escaped_dash_dash}) do
    tokenize(html, %{s | current: :script_data_escaped_less_than_sign})
  end

  defp tokenize(<<">", html::binary>>, s = %State{current: :script_data_escaped_dash_dash}) do
    tokenize(html, %{
      s
      | tokens: [%Char{data: @greater_than_sign} | s.tokens],
        current: :script_data
    })
  end

  defp tokenize(<<"\0", html::binary>>, s = %State{current: :script_data_escaped_dash_dash}) do
    tokenize(html, %{
      s
      | tokens: [%Char{data: @replacement_char} | s.tokens],
        current: :script_data_escaped
    })
  end

  defp tokenize(html = "", s = %State{current: :script_data_escaped_dash_dash}) do
    tokenize(html, %{s | tokens: [%EOF{line: s.line, column: s.column} | s.tokens]})
  end

  defp tokenize(
         <<c::utf8, html::binary>>,
         s = %State{current: :script_data_escaped_dash_dash}
       ) do
    tokenize(html, %{
      s
      | tokens: [%Char{data: <<c::utf8>>} | s.tokens],
        current: :script_data_escaped
    })
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
          tokens: [%Char{data: @less_than_sign} | s.tokens],
          current: :script_data_double_escape_start
      }
    )
  end

  defp tokenize(html, s = %State{current: :script_data_escaped_less_than_sign}) do
    tokenize(html, %{
      s
      | tokens: [%Char{data: @less_than_sign} | s.tokens],
        current: :script_data_escaped
    })
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
        | token: %Tag{type: :end, name: "", line: s.line, column: s.column},
          current: :script_data_escaped_end_tag_name
      }
    )
  end

  defp tokenize(html, s = %State{current: :script_data_escaped_end_tag_open}) do
    tokenize(html, %{
      s
      | tokens: [%Char{data: @solidus}, %Char{data: @less_than_sign} | s.tokens],
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

    tokenize(html, %{s | tokens: [%Char{data: <<c::utf8>>} | s.tokens], current: next})
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
        tokens: [%Char{data: char} | s.tokens]
    })
  end

  defp tokenize(
         <<c::utf8, html::binary>>,
         s = %State{current: :script_data_escaped_end_tag_open}
       )
       when <<c::utf8>> in @lower_ASCII_letters do
    char = <<c::utf8>>
    tokenize(html, %{s | buffer: s.buffer <> char, tokens: [%Char{data: char} | s.tokens]})
  end

  defp tokenize(html, s = %State{current: :script_data_escaped_end_tag_open}) do
    tokenize(html, %{s | current: :script_data_escaped})
  end

  # § tokenizer-script-data-double-escaped-state

  defp tokenize(<<"-", html::binary>>, s = %State{current: :script_data_double_escaped}) do
    tokenize(html, %{
      s
      | current: :script_data_double_escaped_dash,
        tokens: [%Char{data: @hyphen_minus} | s.tokens]
    })
  end

  defp tokenize(<<"<", html::binary>>, s = %State{current: :script_data_double_escaped}) do
    tokenize(html, %{
      s
      | current: :script_data_double_escaped_less_than_sign,
        tokens: [%Char{data: @less_than_sign} | s.tokens]
    })
  end

  defp tokenize(<<"\0", html::binary>>, s = %State{current: :script_data_double_escaped}) do
    tokenize(html, %{s | tokens: [%Char{data: @replacement_char} | s.tokens]})
  end

  defp tokenize(html = "", s = %State{current: :script_data_double_escaped}) do
    tokenize(html, %{s | tokens: [%EOF{line: s.line, column: s.column} | s.tokens]})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :script_data_double_escaped}) do
    tokenize(html, %{s | tokens: [%Char{data: <<c::utf8>>} | s.tokens]})
  end

  # § tokenizer-script-data-double-escaped-dash-state

  defp tokenize(<<"-", html::binary>>, s = %State{current: :script_data_double_escaped_dash}) do
    tokenize(html, %{
      s
      | current: :script_data_double_escaped_dash_dash,
        tokens: [%Char{data: @hyphen_minus} | s.tokens]
    })
  end

  defp tokenize(<<"<", html::binary>>, s = %State{current: :script_data_double_escaped_dash}) do
    tokenize(html, %{
      s
      | current: :script_data_double_escaped_less_than_sign,
        tokens: [%Char{data: @less_than_sign} | s.tokens]
    })
  end

  defp tokenize(<<"\0", html::binary>>, s = %State{current: :script_data_double_escaped_dash}) do
    tokenize(html, %{
      s
      | tokens: [%Char{data: @replacement_char} | s.tokens],
        current: :script_data_double_escaped
    })
  end

  defp tokenize(html = "", s = %State{current: :script_data_double_escaped_dash}) do
    tokenize(html, %{s | tokens: [%EOF{line: s.line, column: s.column} | s.tokens]})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :script_data_double_escaped_dash}) do
    tokenize(html, %{
      s
      | tokens: [%Char{data: <<c::utf8>>} | s.tokens],
        current: :script_data_double_escaped
    })
  end

  # § tokenizer-script-data-double-escaped-dash-dash-state

  defp tokenize(<<"-", html::binary>>, s = %State{current: :script_data_double_escaped_dash_dash}) do
    tokenize(html, %{s | tokens: [%Char{data: @hyphen_minus} | s.tokens]})
  end

  defp tokenize(<<"<", html::binary>>, s = %State{current: :script_data_double_escaped_dash_dash}) do
    tokenize(html, %{
      s
      | current: :script_data_double_escaped_less_than_sign,
        tokens: [%Char{data: @less_than_sign} | s.tokens]
    })
  end

  defp tokenize(<<">", html::binary>>, s = %State{current: :script_data_double_escaped_dash_dash}) do
    tokenize(html, %{
      s
      | current: :script_data,
        tokens: [%Char{data: @greater_than_sign} | s.tokens]
    })
  end

  defp tokenize(
         <<"\0", html::binary>>,
         s = %State{current: :script_data_double_escaped_dash_dash}
       ) do
    tokenize(html, %{
      s
      | tokens: [%Char{data: @replacement_char} | s.tokens],
        current: :script_data_double_escaped
    })
  end

  defp tokenize(html = "", s = %State{current: :script_data_double_escaped_dash_dash}) do
    tokenize(html, %{s | tokens: [%EOF{line: s.line, column: s.column} | s.tokens]})
  end

  defp tokenize(
         <<c::utf8, html::binary>>,
         s = %State{current: :script_data_double_escaped_dash_dash}
       ) do
    tokenize(html, %{
      s
      | tokens: [%Char{data: <<c::utf8>>} | s.tokens],
        current: :script_data_double_escaped
    })
  end

  # § tokenizer-script-data-double-escaped-less-than-sign-state

  defp tokenize(
         <<"/", html::binary>>,
         s = %State{current: :script_data_double_escaped_less_than_sign}
       ) do
    tokenize(html, %{
      s
      | buffer: "",
        current: :script_data_double_escape_end,
        tokens: [%Char{data: @solidus} | s.tokens]
    })
  end

  defp tokenize(html, s = %State{current: :script_data_double_escaped_less_than_sign}) do
    tokenize(html, %{s | current: :script_data_double_escaped})
  end

  # § tokenizer-script-data-double-escape-end-state

  defp tokenize(
         <<c::utf8, html::binary>>,
         s = %State{current: :script_data_double_escape_end}
       )
       when <<c::utf8>> in ["/", ">" | @space_chars] do
    next =
      if s.buffer == "script" do
        :script_data_escaped
      else
        :script_data_double_escaped
      end

    tokenize(html, %{s | tokens: [%Char{data: <<c::utf8>>} | s.tokens], current: next})
  end

  defp tokenize(
         <<c::utf8, html::binary>>,
         s = %State{current: :script_data_double_escape_end}
       )
       when <<c::utf8>> in @upper_ASCII_letters do
    char = <<c::utf8>>

    tokenize(html, %{
      s
      | buffer: s.buffer <> String.downcase(char),
        tokens: [%Char{data: char} | s.tokens]
    })
  end

  defp tokenize(
         <<c::utf8, html::binary>>,
         s = %State{current: :script_data_double_escape_end}
       )
       when <<c::utf8>> in @lower_ASCII_letters do
    char = <<c::utf8>>
    tokenize(html, %{s | buffer: s.buffer <> char, tokens: [%Char{data: char} | s.tokens]})
  end

  defp tokenize(html, s = %State{current: :script_data_double_escape_end}) do
    tokenize(html, %{s | current: :script_data_double_escaped})
  end

  # § tokenizer-before-attribute-name-state

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :before_attribute_name})
       when <<c::utf8>> in @space_chars do
    line = line_number(<<c::utf8>>, s.line)
    col = column_number(line, s)
    tokenize(html, %{s | line: line, column: col})
  end

  defp tokenize(html = <<c::utf8, _rest::binary>>, s = %State{current: :before_attribute_name})
       when <<c::utf8>> in ["/", ">"] do
    tokenize(html, %{s | current: :after_attribute_name})
  end

  defp tokenize(html = "", s = %State{current: :before_attribute_name}) do
    tokenize(html, %{s | current: :after_attribute_name})
  end

  defp tokenize(html = <<"=", _rest::binary>>, s = %State{current: :before_attribute_name}) do
    new_token = %{
      s.token
      | current_attribute: %Attribute{name: "=", value: "", line: s.line, column: s.column}
    }

    tokenize(html, %{
      s
      | errors: [%ParseError{line: s.line, column: s.column} | s.errors],
        token: new_token,
        current: :attribute_name
    })
  end

  defp tokenize(html, s = %State{current: :before_attribute_name}) do
    new_token = %{
      s.token
      | current_attribute: %Attribute{name: "", value: "", line: s.line, column: s.column}
    }

    tokenize(html, %{
      s
      | token: new_token,
        current: :attribute_name
    })
  end

  # § tokenizer-attribute-name-state
  #
  # TODO: continue
  # https://w3c.github.io/html/syntax.html#tokenizer-attribute-name-state

  defp tokenize(html = <<c::utf8, _rest::binary>>, s = %State{current: :attribute_name})
       when <<c::utf8>> in [@solidus, @greater_than_sign | @space_chars] do
    # FIXME: before changing the state, verify if same attr already exists.
    tokenize(html, %{s | current: :after_attribute_name})
  end

  defp tokenize(html = "", s = %State{current: :attribute_name}) do
    # FIXME: before changing the state, verify if same attr already exists.
    tokenize(html, %{s | current: :after_attribute_name})
  end

  defp tokenize(<<"=", html::binary>>, s = %State{current: :attribute_name}) do
    # FIXME: before changing the state, verify if same attr already exists.
    tokenize(html, %{s | current: :before_attribute_value})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :attribute_name}) when <<c::utf8>> in @upper_ASCII_letters do
    current_attr = s.token.current_attribute
    new_attr = %{current_attr | name: current_attr.name <> String.downcase(<<c::utf8>>)}
    new_token = %{s.token | current_attribute: new_attr}

    tokenize(html, %{s | token: new_token, column: s.column + 1})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :attribute_name}) when <<c::utf8>> in ["\"", "'", "<"] do
    col = s.column + 1
    current_attr = s.token.current_attribute
    new_attr = %{current_attr | name: current_attr.name <> <<c::utf8>>}
    new_token = %{s.token | current_attribute: new_attr}

    tokenize(html, %{s | errors: [%ParseError{line: s.line, column: col} | s.errors], token: new_token, column: col})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :attribute_name}) do
    col = s.column + 1
    current_attr = s.token.current_attribute
    new_attr = %{current_attr | name: current_attr.name <> <<c::utf8>>}
    new_token = %{s.token | current_attribute: new_attr}

    tokenize(html, %{s | token: new_token, column: col})
  end

  # TODO: continuar: tokenizer-after-attribute-name-state

  defp tokenize(<<"!", html::binary>>, s = %State{current: :markup_declaration_open}) do
    case html do
      <<"--", rest::binary>> ->
        token = %Comment{data: "", line: s.line, column: s.column}

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
        token = %Doctype{
          name: nil,
          public_id: nil,
          system_id: nil,
          force_quirks: :off,
          line: s.line,
          column: s.column
        }

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
    new_token = %{s.token | data: s.token.comment <> <<c::utf8>>}

    tokenize(
      html,
      %{s | current: :comment, token: new_token, column: s.column + 1}
    )
  end

  defp tokenize(<<"-", html::binary>>, s = %State{current: :comment}) do
    tokenize(html, %{s | current: :comment_end_dash, column: s.column + 1})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :comment}) do
    new_token = %{s.token | data: s.token.comment <> <<c::utf8>>}

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
          tokens: [%EOF{line: s.line, column: s.column} | [s.token | s.tokens]],
          token: nil
      }
    )
  end

  defp tokenize(<<"!", html::binary>>, s = %State{current: :comment_end}) do
    tokenize(html, %{s | current: :comment_end_bang})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :doctype})
       when <<c::utf8>> in @space_chars do
    line = line_number(<<c::utf8>>, s.line)
    col = column_number(line, s)
    tokenize(html, %{s | current: :before_doctype_name, column: col, line: line})
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
    token = %Doctype{
      name: nil,
      public_id: nil,
      system_id: nil,
      force_quirks: :on,
      line: s.line,
      column: s.column
    }

    tokenize(html, %{
      s
      | current: :data,
        tokens: [token | s.tokens],
        token: nil,
        column: s.column + 1
    })
  end

  defp tokenize(<<"\0", html::binary>>, s = %State{current: :before_doctype_name}) do
    token = %Doctype{
      name: "\uFFFD",
      public_id: nil,
      system_id: nil,
      force_quirks: :on,
      line: s.line,
      column: s.column
    }

    tokenize(html, %{s | current: :doctype_name, token: token})
  end

  defp tokenize("", s = %State{current: :before_doctype_name}) do
    token = %Doctype{
      name: nil,
      public_id: nil,
      system_id: nil,
      force_quirks: :on,
      line: s.line,
      column: s.column
    }

    tokenize("", %{
      s
      | tokens: [%EOF{line: s.column, column: s.line} | [token | s.tokens]],
        token: nil
    })
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :before_doctype_name}) do
    line = line_number(<<c::utf8>>, s.line)
    col = column_number(line, s)

    token = %Doctype{
      name: String.downcase(<<c::utf8>>),
      public_id: nil,
      system_id: nil,
      force_quirks: :off,
      line: line,
      column: col
    }

    tokenize(html, %{s | current: :doctype_name, token: token, column: col, line: line})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :doctype_name})
       when <<c::utf8>> in @space_chars do
    line = line_number(<<c::utf8>>, s.line)
    col = column_number(line, s)

    tokenize(html, %{s | current: :after_doctype_name, column: col, line: line})
  end

  defp tokenize(<<">", html::binary>>, s = %State{current: :doctype_name}) do
    col = s.column + 1
    token = %{s.token | column: col}

    tokenize(html, %{
      s
      | current: :data,
        tokens: [token | s.tokens],
        token: nil,
        column: col
    })
  end

  defp tokenize(<<"\0", html::binary>>, s = %State{current: :doctype_name}) do
    new_token = %{s.token | name: s.token.name <> "\uFFFD"}

    tokenize(html, %{s | current: :doctype_name, token: new_token})
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :doctype_name}) do
    col = s.column + 1
    new_token = %{s.token | name: s.token.name <> String.downcase(<<c::utf8>>), column: col}

    tokenize(html, %{s | current: :doctype_name, token: new_token, column: col})
  end

  defp tokenize("", s = %State{current: :doctype_name}) do
    new_token = %{s.token | force_quirks: :on}

    tokenize("", %{
      s
      | tokens: [%EOF{line: s.column, column: s.line} | [new_token | s.tokens]],
        token: nil
    })
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :after_doctype_name})
       when <<c::utf8>> in @space_chars do
    line = line_number(c, s.line)
    col = column_number(line, s)

    tokenize(html, %{s | current: :after_doctype_name, column: col, line: line})
  end

  defp tokenize(<<">", html::binary>>, s = %State{current: :after_doctype_name}) do
    col = s.column + 1
    token = %{s.token | column: col}

    tokenize(html, %{
      s
      | current: :data,
        tokens: [token | s.tokens],
        token: nil,
        column: col
    })
  end

  defp tokenize("", s = %State{current: :after_doctype_name}) do
    token = %{s.token | force_quirks: :on}

    tokenize("", %{
      s
      | tokens: [%EOF{line: s.column, column: s.line} | [token | s.tokens]],
        token: nil
    })
  end

  defp tokenize(<<public::bytes-size(6), html::binary>>, s = %State{current: :after_doctype_name})
       when public in ["public", "PUBLIC"] do
    tokenize(html, %{s | current: :after_doctype_public_keyword, column: s.column + 6})
  end

  defp line_number("\n", current_line), do: current_line + 1
  defp line_number(_, current_line), do: current_line

  defp column_number(new_line, %State{line: line, column: column}) do
    if new_line > line do
      0
    else
      column + 1
    end
  end

  defp appropriate_tag?(state) do
    with %Tag{type: :start, name: start_tag_name} <- state.last_start_tag,
         %Tag{type: :end, name: end_tag_name} <- state.token,
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
      |> Enum.map(&%Char{data: &1})

    tokens = [%Char{data: @solidus}, %Char{data: @less_than_sign} | state.tokens]
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
