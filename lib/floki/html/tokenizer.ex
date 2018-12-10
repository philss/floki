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
    defstruct return_state: nil,
              eof_last_state: nil,
              adjusted_current_node: nil,
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

  # EMPTY functions that needs to be defined
  def character_reference(_y, _z), do: nil
  def cdata_section(_html, _s), do: nil
  def after_doctype_public_keyword(_y, _z), do: nil

  # TODO:
  # 1. ~~Keep replacing tokens from tuples to Structs~~
  # 2. Use `s.emit.(token)` before append it to list of tokens
  # 3. Keep adding the state that you was working.

  def tokenize(html) do
    data(html, %State{emit: fn token -> token end})
  end

  defp eof(last_state, s) do
    %{s | eof_last_state: last_state, tokens: [%EOF{line: s.line, column: s.column} | s.tokens]}
  end

  # § tokenizer-data-state

  defp data(<<"&", html::binary>>, s) do
    character_reference(html, %{s | return_state: :data, column: s.column + 1})
  end

  defp data(<<"<", html::binary>>, s) do
    tag_open(html, %{s | column: s.column + 1})
  end

  defp data(<<"\0", html::binary>>, s) do
    data(html, %{s | tokens: [%Char{data: "\0"} | s.tokens]})
  end

  defp data("", s) do
    eof(:data, s)
  end

  defp data(<<c::utf8, html::binary>>, s) do
    data(html, %{s | tokens: [%Char{data: <<c::utf8>>} | s.tokens]})
  end

  # § tokenizer-rcdata-state

  defp rcdata(<<"&", html::binary>>, s) do
    character_reference(html, %{s | return_state: :rcdata, column: s.column + 1})
  end

  defp rcdata(<<"<", html::binary>>, s) do
    rcdata_less_than_sign(html, %{s | column: s.column + 1})
  end

  defp rcdata(<<"\0", html::binary>>, s) do
    rcdata(html, %{s | tokens: [%Char{data: @replacement_char} | s.tokens]})
  end

  defp rcdata("", s) do
    eof(:rcdata, s)
  end

  defp rcdata(<<c::utf8, html::binary>>, s) do
    rcdata(html, %{s | tokens: [%Char{data: <<c::utf8>>} | s.tokens], column: s.column + 1})
  end

  # § tokenizer-rawtext-state

  defp rawtext(<<"<", html::binary>>, s) do
    rawtext_less_than_sign(html, s)
  end

  defp rawtext(<<"\0", html::binary>>, s) do
    rawtext(html, %{s | tokens: [%Char{data: @replacement_char} | s.tokens]})
  end

  defp rawtext("", s) do
    eof(:rawtext, s)
  end

  defp rawtext(<<c::utf8, html::binary>>, s) do
    rawtext(html, %{s | tokens: [%Char{data: <<c::utf8>>} | s.tokens], column: s.column + 1})
  end

  # § tokenizer-script-data-state

  defp script_data(<<"<", html::binary>>, s) do
    script_data_less_than_sign(html, s)
  end

  defp script_data(<<"\0", html::binary>>, s) do
    script_data(html, %{s | tokens: [%Char{data: @replacement_char} | s.tokens]})
  end

  defp script_data("", s) do
    eof(:script_data, s)
  end

  defp script_data(<<c::utf8, html::binary>>, s) do
    script_data(html, %{s | tokens: [%Char{data: <<c::utf8>>} | s.tokens], column: s.column + 1})
  end

  # § tokenizer-plaintext-state

  defp plaintext(<<"\0", html::binary>>, s) do
    plaintext(html, %{s | tokens: [%Char{data: @replacement_char} | s.tokens]})
  end

  defp plaintext("", s) do
    eof(:plaintext, s)
  end

  defp plaintext(<<c::utf8, html::binary>>, s) do
    plaintext(html, %{s | tokens: [%Char{data: <<c::utf8>>} | s.tokens], column: s.column + 1})
  end

  # § tokenizer-tag-open-state

  defp tag_open(<<"!", html::binary>>, s) do
    markup_declaration_open(html, %{s | column: s.column + 1})
  end

  defp tag_open(<<"/", html::binary>>, s) do
    end_tag_open(html, %{s | column: s.column + 1})
  end

  defp tag_open(html = <<c::utf8, _rest::binary>>, s)
       when <<c::utf8>> in @all_ASCII_letters do
    token = %Tag{type: :start, name: "", line: s.line, column: s.column}

    tag_name(html, %{s | token: token})
  end

  defp tag_open(html = <<"?", _rest::binary>>, s) do
    token = %Comment{data: "", line: s.line, column: s.column}

    bogus_comment(html, %{s | token: token, column: s.column + 1})
  end

  defp tag_open(html, s) do
    data(html, %{
      s
      | token: nil,
        tokens: [%Char{data: @less_than_sign} | s.tokens]
    })
  end

  # § tokenizer-end-tag-open-state

  defp end_tag_open(html = <<c::utf8, _rest::binary>>, s)
       when <<c::utf8>> in @all_ASCII_letters do
    token = %Tag{type: :end, name: "", line: s.line, column: s.column}

    tag_name(html, %{s | token: token})
  end

  defp end_tag_open(<<">", html::binary>>, s) do
    data(html, %{s | token: nil})
  end

  defp end_tag_open("", s) do
    tokens = [%Char{data: @solidus}, %Char{data: @less_than_sign} | s.tokens]

    eof(:data, %{
      s
      | token: nil,
        tokens: tokens,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp end_tag_open(html, s) do
    token = %Comment{data: "", line: s.line, column: s.column}

    bogus_comment(html, %{s | token: token})
  end

  # § tokenizer-tag-name-state

  defp tag_name(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in @space_chars do
    line = line_number(<<c::utf8>>, s.line)
    col = column_number(line, s)
    before_attribute_name(html, %{s | column: col, line: line})
  end

  defp tag_name(<<"/", html::binary>>, s) do
    self_closing_start_tag(html, %{s | column: s.column + 1})
  end

  defp tag_name(<<">", html::binary>>, s) do
    data(html, %{
      s
      | last_start_tag: s.token,
        tokens: [s.token | s.tokens],
        token: nil,
        column: s.column + 1
    })
  end

  defp tag_name(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in @upper_ASCII_letters do
    new_token = %{s.token | name: s.token.name <> String.downcase(<<c::utf8>>)}

    tag_name(html, %{s | token: new_token, column: s.column + 1})
  end

  defp tag_name(<<"\0", html::binary>>, s) do
    tag_name(html, %{
      s
      | token: %{s.token | name: s.token.name <> "\uFFFD"},
        errors: [
          %ParseError{id: "unexpected-null-character", line: s.line, column: s.column}
          | s.errors
        ]
    })
  end

  defp tag_name("", s) do
    eof(:tag_name, %{
      s
      | errors: [%ParseError{id: "eof-in-tag", line: s.line, column: s.column} | s.errors]
    })
  end

  defp tag_name(<<c::utf8, html::binary>>, s) do
    new_token = %{s.token | name: s.token.name <> <<c::utf8>>}

    tag_name(html, %{s | token: new_token, column: s.column + 1})
  end

  # § tokenizer-rcdata-less-than-sign-state

  defp rcdata_less_than_sign(<<"/", html::binary>>, s) do
    rcdata_end_tag_open(html, %{s | buffer: "", column: s.column + 1})
  end

  defp rcdata_less_than_sign(html, s) do
    rcdata(html, %{
      s
      | token: nil,
        tokens: [%Char{data: @less_than_sign} | s.tokens]
    })
  end

  # § tokenizer-rcdata-end-tag-open-state

  defp rcdata_end_tag_open(
         html = <<c::utf8, _rest::binary>>,
         s
       )
       when <<c::utf8>> in @all_ASCII_letters do
    token = %Tag{type: :end, name: "", line: s.line, column: s.column}
    rcdata_end_tag_name(html, %{s | token: token})
  end

  defp rcdata_end_tag_open(html, s) do
    tokens = [%Char{data: @solidus}, %Char{data: @less_than_sign} | s.tokens]
    rcdata(html, %{s | tokens: tokens})
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

  Enum.each(@raw_end_tag_name_states, fn state ->
    next_state =
      case state do
        :rcdata_end_tag_name ->
          :rcdata

        :rawtext_end_tag_name ->
          :rawtext

        :script_data_end_tag_name ->
          :script_data

        :script_data_escaped_end_tag_name ->
          :script_data_escaped
      end

    defp unquote(state)(html = <<c::utf8, rest::binary>>, s)
         when <<c::utf8>> in @space_chars do
      line = line_number(<<c::utf8>>, s.line)

      if appropriate_tag?(s) do
        before_attribute_name(rest, %{s | column: s.column + 1, line: line})
      else
        unquote(next_state)(html, %{
          s
          | tokens: tokens_for_inappropriate_end_tag(s),
            buffer: ""
        })
      end
    end

    defp unquote(state)(html = <<"/", rest::binary>>, s) do
      if appropriate_tag?(s) do
        self_closing_start_tag(rest, %{s | column: s.column + 1})
      else
        unquote(next_state)(html, %{
          s
          | tokens: tokens_for_inappropriate_end_tag(s),
            buffer: ""
        })
      end
    end

    defp unquote(html = <<">", rest::binary>>, s) do
      if appropriate_tag?(s) do
        data(rest, %{
          s
          | token: nil,
            tokens: [s.token | s.tokens],
            column: s.column + 1
        })
      else
        unquote(next_state)(html, %{
          s
          | tokens: tokens_for_inappropriate_end_tag(s),
            buffer: ""
        })
      end
    end

    defp unquote(state)(<<c::utf8, html::binary>>, s)
         when <<c::utf8>> in @upper_ASCII_letters do
      col = s.col + 1
      char = <<c::utf8>>
      new_token = %{s.token | name: s.name <> String.downcase(char), column: col}

      unquote(next_state)(html, %{s | token: new_token, buffer: s.buffer <> char, col: col})
    end

    defp unquote(state)(<<c::utf8, html::binary>>, s)
         when <<c::utf8>> in @lower_ASCII_letters do
      col = s.col + 1
      char = <<c::utf8>>
      new_token = %{s.token | name: s.name <> char, column: col}

      unquote(state)(html, %{s | token: new_token, buffer: s.buffer <> char, col: col})
    end

    defp unquote(state)(html, s) do
      unquote(next_state)(html, %{
        s
        | tokens: tokens_for_inappropriate_end_tag(s),
          buffer: ""
      })
    end
  end)

  # § tokenizer-rawtext-less-than-sign-state

  defp rawtext_less_than_sign(<<"/", html::binary>>, s) do
    rawtext_end_tag_open(html, %{s | buffer: ""})
  end

  defp rawtext_less_than_sign(html, s) do
    rawtext(html, %{s | tokens: [%Char{data: "\u003C"} | s.tokens]})
  end

  # § tokenizer-rawtext-end-tag-open-state

  defp rawtext_end_tag_open(
         html = <<c::utf8, _rest::binary>>,
         s
       )
       when <<c::utf8>> in @all_ASCII_letters do
    token = %Tag{type: :end, name: "", line: s.line, column: s.column}
    rawtext_end_tag_name(html, %{s | token: token})
  end

  defp rawtext_end_tag_open(html, s) do
    tokens = [%Char{data: @solidus}, %Char{data: @less_than_sign} | s.tokens]
    rawtext(html, %{s | tokens: tokens})
  end

  # § tokenizer-script-data-less-than-sign-state

  defp script_data_less_than_sign(<<"/", html::binary>>, s) do
    script_data_end_tag_open_state(html, %{s | buffer: ""})
  end

  defp script_data_less_than_sign(<<"!", html::binary>>, s) do
    tokens = [%Char{data: @exclamation_mark}, %Char{data: @less_than_sign} | s.tokens]
    script_data_less_than_sign(html, %{s | tokens: tokens})
  end

  defp script_data_less_than_sign(html, s) do
    script_data(html, %{s | tokens: [%Char{data: @less_than_sign} | s.tokens]})
  end

  # § tokenizer-script-data-end-tag-open-state

  defp script_data_end_tag_open(
         html = <<c::utf8, _rest::binary>>,
         s
       )
       when <<c::utf8>> in @all_ASCII_letters do
    col = s.column + 1
    end_tag = %Tag{type: :end, name: "", line: s.line, column: col}
    script_data_end_tag_name(html, %{s | token: end_tag, column: col})
  end

  defp script_data_end_tag_open(html, s) do
    script_data(html, %{
      s
      | tokens: [%Char{data: @solidus}, %Char{data: @less_than_sign} | s.tokens]
    })
  end

  # § tokenizer-script-data-escape-start-state

  defp script_data_escape_start(<<"-", html::binary>>, s) do
    script_data_escape_start_dash(
      html,
      %{
        s
        | tokens: [%Char{data: @hyphen_minus} | s.tokens]
      }
    )
  end

  defp script_data_escape_start(html, s) do
    script_data(html, s)
  end

  # § tokenizer-script-data-escape-start-dash-state

  defp script_data_escape_start_dash(<<"-", html::binary>>, s) do
    script_data_escaped_dash_dash(
      html,
      %{
        s
        | tokens: [%Char{data: @hyphen_minus} | s.tokens]
      }
    )
  end

  defp script_data_escape_start_dash(html, s) do
    script_data(html, s)
  end

  # § tokenizer-script-data-escaped-state

  defp script_data_escaped(<<"-", html::binary>>, s) do
    script_data_escaped_dash(
      html,
      %{s | tokens: [%Char{data: @hyphen_minus} | s.tokens]}
    )
  end

  defp script_data_escaped(<<"<", html::binary>>, s) do
    script_data_escaped_less_than_sign(html, s)
  end

  defp script_data_escaped(<<"\0", html::binary>>, s) do
    script_data_escaped(html, %{s | tokens: [%Char{data: @replacement_char} | s.tokens]})
  end

  defp script_data_escaped("", s) do
    eof(:script_data_escaped, s)
  end

  defp script_data_escaped(<<c::utf8, html::binary>>, s) do
    script_data_escaped(html, %{s | tokens: [%Char{data: <<c::utf8>>} | s.tokens]})
  end

  # § tokenizer-script-data-escaped-dash-state

  defp script_data_escaped_dash(<<"-", html::binary>>, s) do
    script_data_escaped_dash_dash(
      html,
      %{
        s
        | tokens: [%Char{data: @hyphen_minus} | s.tokens]
      }
    )
  end

  defp script_data_escaped_dash(<<"<", html::binary>>, s) do
    script_data_escaped_less_than_sign(html, s)
  end

  defp script_data_escaped_dash(<<"\0", html::binary>>, s) do
    script_data_escaped(html, %{
      s
      | tokens: [%Char{data: @replacement_char} | s.tokens]
    })
  end

  defp script_data_escaped_dash("", s) do
    eof(:tokenize, s)
  end

  defp script_data_escaped_dash(
         <<c::utf8, html::binary>>,
         s
       ) do
    script_data_escaped(html, %{
      s
      | tokens: [%Char{data: <<c::utf8>>} | s.tokens]
    })
  end

  # § tokenizer-script-data-escaped-dash-dash-state

  defp script_data_escaped_dash_dash(<<"-", html::binary>>, s) do
    script_data_escaped_dash_dash(
      html,
      %{s | tokens: [%Char{data: @hyphen_minus} | s.tokens]}
    )
  end

  defp script_data_escaped_dash_dash(<<"<", html::binary>>, s) do
    script_data_escaped_less_than_sign(html, s)
  end

  defp script_data_escaped_dash_dash(<<">", html::binary>>, s) do
    script_data(html, %{
      s
      | tokens: [%Char{data: @greater_than_sign} | s.tokens]
    })
  end

  defp script_data_escaped_dash_dash(<<"\0", html::binary>>, s) do
    script_data_escaped(html, %{
      s
      | tokens: [%Char{data: @replacement_char} | s.tokens]
    })
  end

  defp script_data_escaped_dash_dash("", s) do
    eof(:script_data_escaped_dash_dash, s)
  end

  defp script_data_escaped_dash_dash(
         <<c::utf8, html::binary>>,
         s
       ) do
    script_data_escaped(html, %{
      s
      | tokens: [%Char{data: <<c::utf8>>} | s.tokens]
    })
  end

  # § tokenizer-script-data-escaped-less-than-sign-state

  defp script_data_escaped_less_than_sign(<<"/", html::binary>>, s) do
    script_data_escaped_end_tag_open(html, %{s | buffer: ""})
  end

  defp script_data_escaped_less_than_sign(
         html = <<c::utf8, _rest::binary>>,
         s
       )
       when <<c::utf8>> in @all_ASCII_letters do
    script_data_double_escape_start(
      html,
      %{
        s
        | buffer: "",
          tokens: [%Char{data: @less_than_sign} | s.tokens]
      }
    )
  end

  defp script_data_escaped_less_than_sign(html, s) do
    script_data_escaped(html, %{
      s
      | tokens: [%Char{data: @less_than_sign} | s.tokens]
    })
  end

  # § tokenizer-script-data-escaped-end-tag-open-state

  defp script_data_escaped_end_tag_open(
         html = <<c::utf8, _rest::binary>>,
         s
       )
       when <<c::utf8>> in @all_ASCII_letters do
    script_data_escaped_end_tag_name(
      html,
      %{
        s
        | token: %Tag{type: :end, name: "", line: s.line, column: s.column}
      }
    )
  end

  defp script_data_escaped_end_tag_open(html, s) do
    script_data_escaped(html, %{
      s
      | tokens: [%Char{data: @solidus}, %Char{data: @less_than_sign} | s.tokens]
    })
  end

  # § tokenizer-script-data-double-escape-start-state

  defp script_data_escaped_end_tag_open(
         <<c::utf8, html::binary>>,
         s
       )
       when <<c::utf8>> in ["/", ">" | @space_chars] do
    if s.buffer == "script" do
      script_data_double_escaped(html, %{s | tokens: [%Char{data: <<c::utf8>>} | s.tokens]})
    else
      script_data_escaped(html, %{s | tokens: [%Char{data: <<c::utf8>>} | s.tokens]})
    end
  end

  defp script_data_escaped_end_tag_open(
         <<c::utf8, html::binary>>,
         s
       )
       when <<c::utf8>> in @upper_ASCII_letters do
    char = <<c::utf8>>

    script_data_escaped_end_tag_open(html, %{
      s
      | buffer: s.buffer <> String.downcase(char),
        tokens: [%Char{data: char} | s.tokens]
    })
  end

  defp script_data_escaped_end_tag_open(
         <<c::utf8, html::binary>>,
         s
       )
       when <<c::utf8>> in @lower_ASCII_letters do
    char = <<c::utf8>>

    script_data_escaped_end_tag_open(html, %{
      s
      | buffer: s.buffer <> char,
        tokens: [%Char{data: char} | s.tokens]
    })
  end

  defp script_data_escaped_end_tag_open(html, s) do
    script_data_escaped(html, s)
  end

  # § tokenizer-script-data-double-escaped-state

  defp script_data_double_escaped(<<"-", html::binary>>, s) do
    script_data_double_escaped_dash(html, %{
      s
      | tokens: [%Char{data: @hyphen_minus} | s.tokens]
    })
  end

  defp script_data_double_escaped(<<"<", html::binary>>, s) do
    script_data_double_escaped_less_than_sign(html, %{
      s
      | tokens: [%Char{data: @less_than_sign} | s.tokens]
    })
  end

  defp script_data_double_escaped(<<"\0", html::binary>>, s) do
    script_data_double_escaped(html, %{s | tokens: [%Char{data: @replacement_char} | s.tokens]})
  end

  defp script_data_double_escaped("", s) do
    eof(:script_data_double_escaped, s)
  end

  defp script_data_double_escaped(<<c::utf8, html::binary>>, s) do
    script_data_double_escaped(html, %{s | tokens: [%Char{data: <<c::utf8>>} | s.tokens]})
  end

  # § tokenizer-script-data-double-escaped-dash-state

  defp script_data_double_escaped_dash(<<"-", html::binary>>, s) do
    script_data_double_escaped_dash_dash(html, %{
      s
      | tokens: [%Char{data: @hyphen_minus} | s.tokens]
    })
  end

  defp script_data_double_escaped_dash(<<"<", html::binary>>, s) do
    script_data_double_escaped_less_than_sign(html, %{
      s
      | tokens: [%Char{data: @less_than_sign} | s.tokens]
    })
  end

  defp script_data_double_escaped_dash(<<"\0", html::binary>>, s) do
    script_data_double_escaped(html, %{
      s
      | tokens: [%Char{data: @replacement_char} | s.tokens]
    })
  end

  defp script_data_double_escaped_dash("", s) do
    eof(:script_data_double_escaped_dash, s)
  end

  defp script_data_double_escaped_dash(<<c::utf8, html::binary>>, s) do
    script_data_double_escaped(html, %{
      s
      | tokens: [%Char{data: <<c::utf8>>} | s.tokens]
    })
  end

  # § tokenizer-script-data-double-escaped-dash-dash-state

  defp script_data_double_escaped_dash_dash(<<"-", html::binary>>, s) do
    script_data_double_escaped_dash_dash(html, %{
      s
      | tokens: [%Char{data: @hyphen_minus} | s.tokens]
    })
  end

  defp script_data_double_escaped_dash_dash(<<"<", html::binary>>, s) do
    script_data_double_escaped_less_than_sign(html, %{
      s
      | tokens: [%Char{data: @less_than_sign} | s.tokens]
    })
  end

  defp script_data_double_escaped_dash_dash(<<">", html::binary>>, s) do
    script_data(html, %{
      s
      | tokens: [%Char{data: @greater_than_sign} | s.tokens]
    })
  end

  defp script_data_double_escaped_dash_dash(
         <<"\0", html::binary>>,
         s
       ) do
    script_data_double_escaped(html, %{
      s
      | tokens: [%Char{data: @replacement_char} | s.tokens]
    })
  end

  defp script_data_double_escaped_dash_dash("", s) do
    eof(:script_data_double_escaped_dash_dash, s)
  end

  defp script_data_double_escaped_dash_dash(
         <<c::utf8, html::binary>>,
         s
       ) do
    script_data_double_escaped(html, %{
      s
      | tokens: [%Char{data: <<c::utf8>>} | s.tokens]
    })
  end

  # § tokenizer-script-data-double-escaped-less-than-sign-state

  defp script_data_double_escaped_less_than_sign(
         <<"/", html::binary>>,
         s
       ) do
    script_data_double_escape_end(html, %{
      s
      | buffer: "",
        tokens: [%Char{data: @solidus} | s.tokens]
    })
  end

  defp script_data_double_escaped_less_than_sign(html, s) do
    script_data_double_escaped(html, s)
  end

  # § tokenizer-script-data-double-escape-end-state

  defp script_data_double_escape_end(
         <<c::utf8, html::binary>>,
         s
       )
       when <<c::utf8>> in ["/", ">" | @space_chars] do
    if s.buffer == "script" do
      script_data_escaped(html, %{s | tokens: [%Char{data: <<c::utf8>>} | s.tokens]})
    else
      script_data_double_escaped(html, %{s | tokens: [%Char{data: <<c::utf8>>} | s.tokens]})
    end
  end

  defp script_data_double_escape_end(
         <<c::utf8, html::binary>>,
         s
       )
       when <<c::utf8>> in @upper_ASCII_letters do
    char = <<c::utf8>>

    script_data_double_escape_end(html, %{
      s
      | buffer: s.buffer <> String.downcase(char),
        tokens: [%Char{data: char} | s.tokens]
    })
  end

  defp script_data_double_escape_end(
         <<c::utf8, html::binary>>,
         s
       )
       when <<c::utf8>> in @lower_ASCII_letters do
    char = <<c::utf8>>

    script_data_double_escape_end(html, %{
      s
      | buffer: s.buffer <> char,
        tokens: [%Char{data: char} | s.tokens]
    })
  end

  defp script_data_double_escape_end(html, s) do
    script_data_double_escaped(html, s)
  end

  # § tokenizer-before-attribute-name-state

  defp before_attribute_name(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in @space_chars do
    line = line_number(<<c::utf8>>, s.line)
    col = column_number(line, s)
    before_attribute_name(html, %{s | line: line, column: col})
  end

  defp before_attribute_name(html = <<c::utf8, _rest::binary>>, s)
       when <<c::utf8>> in ["/", ">"] do
    after_attribute_name(html, s)
  end

  defp before_attribute_name("", s) do
    after_attribute_name("", s)
  end

  defp before_attribute_name(html = <<"=", _rest::binary>>, s) do
    new_token = %Tag{
      s.token
      | current_attribute: %Attribute{name: "=", value: "", line: s.line, column: s.column}
    }

    attribute_name(html, %{
      s
      | errors: [%ParseError{line: s.line, column: s.column} | s.errors],
        token: new_token
    })
  end

  defp before_attribute_name(html, s) do
    new_token = %Tag{
      s.token
      | current_attribute: %Attribute{name: "", value: "", line: s.line, column: s.column}
    }

    attribute_name(html, %{
      s
      | token: new_token
    })
  end

  # § tokenizer-attribute-name-state

  defp attribute_name(html = <<c::utf8, _rest::binary>>, s)
       when <<c::utf8>> in [@solidus, @greater_than_sign | @space_chars] do
    # FIXME: before changing the state, verify if same attr already exists.
    after_attribute_name(html, s)
  end

  defp attribute_name("", s) do
    # FIXME: before changing the state, verify if same attr already exists.
    after_attribute_name("", s)
  end

  defp attribute_name(<<"=", html::binary>>, s) do
    # FIXME: before changing the state, verify if same attr already exists.
    before_attribute_value(html, s)
  end

  defp attribute_name(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in @upper_ASCII_letters do
    current_attr = s.token.current_attribute
    new_attr = %Attribute{current_attr | name: current_attr.name <> String.downcase(<<c::utf8>>)}
    new_token = %Tag{s.token | current_attribute: new_attr}

    attribute_name(html, %{s | token: new_token, column: s.column + 1})
  end

  defp attribute_name(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in ["\"", "'", "<"] do
    col = s.column + 1
    current_attr = s.token.current_attribute
    new_attr = %Attribute{current_attr | name: current_attr.name <> <<c::utf8>>}
    new_token = %Tag{s.token | current_attribute: new_attr}

    attribute_name(html, %{
      s
      | errors: [%ParseError{line: s.line, column: col} | s.errors],
        token: new_token,
        column: col
    })
  end

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :attribute_name}) do
    col = s.column + 1
    current_attr = s.token.current_attribute
    new_attr = %{current_attr | name: current_attr.name <> <<c::utf8>>}
    new_token = %{s.token | current_attribute: new_attr}

    tokenize(html, %{s | token: new_token, column: col})
  end

  # § tokenizer-after-attribute-name-state

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :after_attribute_name})
       when <<c::utf8>> in @space_chars do
    line = line_number(<<c::utf8>>, s.line)
    col = column_number(line, s)

    tokenize(html, %{s | line: line, column: col})
  end

  defp tokenize(<<"/", html::binary>>, s = %State{current: :after_attribute_name}) do
    tokenize(html, %{s | current: :self_closing_start_tag, column: s.column + 1})
  end

  defp tokenize(<<"=", html::binary>>, s = %State{current: :after_attribute_name}) do
    tokenize(html, %{s | current: :before_attribute_value, column: s.column + 1})
  end

  defp tokenize(<<">", html::binary>>, s = %State{current: :after_attribute_name}) do
    tokenize(html, %{
      s
      | current: :data,
        tokens: [s.token | s.tokens],
        token: nil,
        column: s.column + 1
    })
  end

  defp tokenize(html = "", s = %State{current: :after_attribute_name}) do
    tokenize(html, %{
      s
      | current: :data,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors],
        tokens: [%EOF{line: s.line, column: s.column} | s.tokens]
    })
  end

  defp tokenize(html, s = %State{current: :after_attribute_name}) do
    attribute = %Attribute{name: "", value: "", line: s.line, column: s.column}
    new_token = %{s.token | current_attribute: attribute}

    tokenize(html, %{s | token: new_token})
  end

  # § tokenizer-before-attribute-value-state

  defp tokenize(<<c::utf8, html::binary>>, s = %State{current: :before_attribute_value})
       when <<c::utf8>> in @space_chars do
    line = line_number(<<c::utf8>>, s.line)
    col = column_number(line, s)

    tokenize(html, %{s | line: line, column: col})
  end

  defp tokenize(<<"\"", html::binary>>, s = %State{current: :before_attribute_value}) do
    tokenize(html, %{s | current: :attribute_value_double_quoted, column: s.column + 1})
  end

  defp tokenize(<<"'", html::binary>>, s = %State{current: :before_attribute_value}) do
    tokenize(html, %{s | current: :attribute_value_single_quoted, column: s.column + 1})
  end

  defp tokenize(html = <<">", _rest::binary>>, s = %State{current: :before_attribute_value}) do
    tokenize(html, %{s | errors: [%ParseError{line: s.line, column: s.column} | s.errors]})
  end

  defp tokenize(html, s = %State{current: :before_attribute_value}) do
    tokenize(html, %{s | current: :attribute_value_unquoted})
  end

  # § tokenizer-attribute-value-double-quoted-state

  defp tokenize(<<"\"", html::binary>>, s = %State{current: :attribute_value_double_quoted}) do
    tokenize(html, %{s | current: :after_attribute_value_quoted})
  end

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
end
