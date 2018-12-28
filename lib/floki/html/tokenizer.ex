defmodule Floki.HTML.Tokenizer do
  @moduledoc false

  # It parses a HTML file according to the specs of W3C:
  # https://w3c.github.io/html/syntax.html
  #
  # In order to find the docs of a given state, add it as an anchor to the link above.
  # Example: https://w3c.github.io/html/syntax.html#tokenizer-data-state
  # TODO: add tests: https://github.com/html5lib/html5lib-tests

  # defmodule Pos do
  #   defstruct line: 0, col: 0
  # end

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
              charref_state: nil,
              line: 1,
              column: 1
  end

  defmodule CharrefState do
    defstruct candidate: nil, done: false, length: 0
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
  @alphanumerics @all_ASCII_letters ++ Enum.map(0..9, fn n -> Integer.to_string(n) end)
  @space_chars ["\t", "\n", "\f", "\s"]

  @less_than_sign "\u003C"
  @greater_than_sign "\u003E"
  @exclamation_mark "\u0021"
  @solidus "\u002F"
  @hyphen_minus "\u002D"
  @replacement_char "\uFFFD"

  @entities Floki.Entities.load_entities("priv/entities.json")

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

  defp rcdata_end_tag_name(html = <<c::utf8, rest::binary>>, s)
       when <<c::utf8>> in @space_chars do
    line = line_number(<<c::utf8>>, s.line)

    if appropriate_tag?(s) do
      before_attribute_name(rest, %{s | column: s.column + 1, line: line})
    else
      rcdata(html, %{
        s
        | tokens: tokens_for_inappropriate_end_tag(s),
          buffer: ""
      })
    end
  end

  defp rcdata_end_tag_name(html = <<"/", rest::binary>>, s) do
    if appropriate_tag?(s) do
      self_closing_start_tag(rest, %{s | column: s.column + 1})
    else
      rcdata(html, %{
        s
        | tokens: tokens_for_inappropriate_end_tag(s),
          buffer: ""
      })
    end
  end

  defp rcdata_end_tag_name(html = <<">", rest::binary>>, s) do
    if appropriate_tag?(s) do
      data(rest, %{
        s
        | token: nil,
          tokens: [s.token | s.tokens],
          column: s.column + 1
      })
    else
      rcdata(html, %{
        s
        | tokens: tokens_for_inappropriate_end_tag(s),
          buffer: ""
      })
    end
  end

  defp rcdata_end_tag_name(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in @upper_ASCII_letters do
    col = s.col + 1
    char = <<c::utf8>>
    new_token = %{s.token | name: s.name <> String.downcase(char), column: col}

    rcdata(html, %{s | token: new_token, buffer: s.buffer <> char, col: col})
  end

  defp rcdata_end_tag_name(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in @lower_ASCII_letters do
    col = s.col + 1
    char = <<c::utf8>>
    new_token = %{s.token | name: s.name <> char, column: col}

    rcdata_end_tag_name(html, %{s | token: new_token, buffer: s.buffer <> char, col: col})
  end

  defp rcdata_end_tag_name(html, s) do
    rcdata(html, %{
      s
      | tokens: tokens_for_inappropriate_end_tag(s),
        buffer: ""
    })
  end

  # § tokenizer-rawtext-end-tag-name-state

  defp rawtext_end_tag_name(html = <<c::utf8, rest::binary>>, s)
       when <<c::utf8>> in @space_chars do
    line = line_number(<<c::utf8>>, s.line)

    if appropriate_tag?(s) do
      before_attribute_name(rest, %{s | column: s.column + 1, line: line})
    else
      rawtext(html, %{
        s
        | tokens: tokens_for_inappropriate_end_tag(s),
          buffer: ""
      })
    end
  end

  defp rawtext_end_tag_name(html = <<"/", rest::binary>>, s) do
    if appropriate_tag?(s) do
      self_closing_start_tag(rest, %{s | column: s.column + 1})
    else
      rawtext(html, %{
        s
        | tokens: tokens_for_inappropriate_end_tag(s),
          buffer: ""
      })
    end
  end

  defp rawtext_end_tag_name(html = <<">", rest::binary>>, s) do
    if appropriate_tag?(s) do
      data(rest, %{
        s
        | token: nil,
          tokens: [s.token | s.tokens],
          column: s.column + 1
      })
    else
      rawtext(html, %{
        s
        | tokens: tokens_for_inappropriate_end_tag(s),
          buffer: ""
      })
    end
  end

  defp rawtext_end_tag_name(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in @upper_ASCII_letters do
    col = s.col + 1
    char = <<c::utf8>>
    new_token = %{s.token | name: s.name <> String.downcase(char), column: col}

    rawtext(html, %{s | token: new_token, buffer: s.buffer <> char, col: col})
  end

  defp rawtext_end_tag_name(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in @lower_ASCII_letters do
    col = s.col + 1
    char = <<c::utf8>>
    new_token = %{s.token | name: s.name <> char, column: col}

    rawtext_end_tag_name(html, %{s | token: new_token, buffer: s.buffer <> char, col: col})
  end

  defp rawtext_end_tag_name(html, s) do
    rawtext(html, %{
      s
      | tokens: tokens_for_inappropriate_end_tag(s),
        buffer: ""
    })
  end

  # § tokenizer-script-data-end-tag-name-state

  defp script_data_end_tag_name(html = <<c::utf8, rest::binary>>, s)
       when <<c::utf8>> in @space_chars do
    line = line_number(<<c::utf8>>, s.line)

    if appropriate_tag?(s) do
      before_attribute_name(rest, %{s | column: s.column + 1, line: line})
    else
      script_data(html, %{
        s
        | tokens: tokens_for_inappropriate_end_tag(s),
          buffer: ""
      })
    end
  end

  defp script_data_end_tag_name(html = <<"/", rest::binary>>, s) do
    if appropriate_tag?(s) do
      self_closing_start_tag(rest, %{s | column: s.column + 1})
    else
      script_data(html, %{
        s
        | tokens: tokens_for_inappropriate_end_tag(s),
          buffer: ""
      })
    end
  end

  defp script_data_end_tag_name(html = <<">", rest::binary>>, s) do
    if appropriate_tag?(s) do
      data(rest, %{
        s
        | token: nil,
          tokens: [s.token | s.tokens],
          column: s.column + 1
      })
    else
      script_data(html, %{
        s
        | tokens: tokens_for_inappropriate_end_tag(s),
          buffer: ""
      })
    end
  end

  defp script_data_end_tag_name(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in @upper_ASCII_letters do
    col = s.col + 1
    char = <<c::utf8>>
    new_token = %{s.token | name: s.name <> String.downcase(char), column: col}

    script_data(html, %{s | token: new_token, buffer: s.buffer <> char, col: col})
  end

  defp script_data_end_tag_name(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in @lower_ASCII_letters do
    col = s.col + 1
    char = <<c::utf8>>
    new_token = %{s.token | name: s.name <> char, column: col}

    script_data_end_tag_name(html, %{s | token: new_token, buffer: s.buffer <> char, col: col})
  end

  defp script_data_end_tag_name(html, s) do
    script_data(html, %{
      s
      | tokens: tokens_for_inappropriate_end_tag(s),
        buffer: ""
    })
  end

  # § tokenizer-script-data-escaped-end-tag-name-state

  defp script_data_escaped_end_tag_name(html = <<c::utf8, rest::binary>>, s)
       when <<c::utf8>> in @space_chars do
    line = line_number(<<c::utf8>>, s.line)

    if appropriate_tag?(s) do
      before_attribute_name(rest, %{s | column: s.column + 1, line: line})
    else
      script_data_escaped(html, %{
        s
        | tokens: tokens_for_inappropriate_end_tag(s),
          buffer: ""
      })
    end
  end

  defp script_data_escaped_end_tag_name(html = <<"/", rest::binary>>, s) do
    if appropriate_tag?(s) do
      self_closing_start_tag(rest, %{s | column: s.column + 1})
    else
      script_data_escaped(html, %{
        s
        | tokens: tokens_for_inappropriate_end_tag(s),
          buffer: ""
      })
    end
  end

  defp script_data_escaped_end_tag_name(html = <<">", rest::binary>>, s) do
    if appropriate_tag?(s) do
      data(rest, %{
        s
        | token: nil,
          tokens: [s.token | s.tokens],
          column: s.column + 1
      })
    else
      script_data_escaped(html, %{
        s
        | tokens: tokens_for_inappropriate_end_tag(s),
          buffer: ""
      })
    end
  end

  defp script_data_escaped_end_tag_name(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in @upper_ASCII_letters do
    col = s.col + 1
    char = <<c::utf8>>
    new_token = %{s.token | name: s.name <> String.downcase(char), column: col}

    script_data_escaped(html, %{s | token: new_token, buffer: s.buffer <> char, col: col})
  end

  defp script_data_escaped_end_tag_name(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in @lower_ASCII_letters do
    col = s.col + 1
    char = <<c::utf8>>
    new_token = %{s.token | name: s.name <> char, column: col}

    script_data_escaped_end_tag_name(html, %{
      s
      | token: new_token,
        buffer: s.buffer <> char,
        col: col
    })
  end

  defp script_data_escaped_end_tag_name(html, s) do
    script_data_escaped(html, %{
      s
      | tokens: tokens_for_inappropriate_end_tag(s),
        buffer: ""
    })
  end

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
         s = %State{buffer: "script"}
       )
       when <<c::utf8>> in ["/", ">" | @space_chars] do
    script_data_double_escaped(html, %{s | tokens: [%Char{data: <<c::utf8>>} | s.tokens]})
  end

  defp script_data_escaped_end_tag_open(
         <<c::utf8, html::binary>>,
         s
       )
       when <<c::utf8>> in ["/", ">" | @space_chars] do
    script_data_escaped(html, %{s | tokens: [%Char{data: <<c::utf8>>} | s.tokens]})
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

  defp attribute_name(<<c::utf8, html::binary>>, s) do
    col = s.column + 1
    current_attr = s.token.current_attribute
    new_attr = %Attribute{current_attr | name: current_attr.name <> <<c::utf8>>}
    new_token = %Tag{s.token | current_attribute: new_attr}

    attribute_name(html, %{s | token: new_token, column: col})
  end

  # § tokenizer-after-attribute-name-state

  defp after_attribute_name(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in @space_chars do
    line = line_number(<<c::utf8>>, s.line)
    col = column_number(line, s)

    after_attribute_name(html, %{s | line: line, column: col})
  end

  defp after_attribute_name(<<"/", html::binary>>, s) do
    self_closing_start_tag(html, %{s | column: s.column + 1})
  end

  defp after_attribute_name(<<"=", html::binary>>, s) do
    before_attribute_value(html, %{s | column: s.column + 1})
  end

  defp after_attribute_name(<<">", html::binary>>, s) do
    data(html, %{
      s
      | tokens: [s.token | s.tokens],
        token: nil,
        column: s.column + 1
    })
  end

  defp after_attribute_name("", s) do
    eof(:data, %{
      s
      | errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp after_attribute_name(html, s) do
    attribute = %Attribute{name: "", value: "", line: s.line, column: s.column}
    new_token = %Tag{s.token | current_attribute: attribute}

    after_attribute_name(html, %{s | token: new_token})
  end

  # § tokenizer-before-attribute-value-state

  defp before_attribute_value(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in @space_chars do
    line = line_number(<<c::utf8>>, s.line)
    col = column_number(line, s)

    before_attribute_value(html, %{s | line: line, column: col})
  end

  defp before_attribute_value(<<"\"", html::binary>>, s) do
    attribute_value_double_quoted(html, %{s | column: s.column + 1})
  end

  defp before_attribute_value(<<"'", html::binary>>, s) do
    attribute_value_single_quoted(html, %{s | column: s.column + 1})
  end

  defp before_attribute_value(html = <<">", _rest::binary>>, s) do
    before_attribute_value(html, %{
      s
      | errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp before_attribute_value(html, s) do
    attribute_value_unquoted(html, s)
  end

  # § tokenizer-attribute-value-double-quoted-state

  defp attribute_value_double_quoted(<<"\"", html::binary>>, s) do
    after_attribute_value_quoted(html, s)
  end

  defp attribute_value_double_quoted(<<"&", html::binary>>, s) do
    character_reference(html, %{s | return_state: :attribute_value_double_quoted})
  end

  defp attribute_value_double_quoted(<<"\0", html::binary>>, s) do
    attr = s.token.current_attribute
    new_attr = %Attribute{attr | value: attr.value <> @replacement_char}

    attribute_value_double_quoted(html, %{
      s
      | errors: [%ParseError{line: s.line, column: s.column} | s.errors],
        token: %Tag{s.token | current_attribute: new_attr}
    })
  end

  defp attribute_value_double_quoted("", s) do
    eof(:attribute_value_double_quoted, %{
      s
      | errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp attribute_value_double_quoted(<<c::utf8, html::binary>>, s) do
    attr = s.token.current_attribute
    new_attr = %Attribute{attr | value: attr.value <> <<c::utf8>>}

    attribute_value_double_quoted(html, %{
      s
      | token: %Tag{s.token | current_attribute: new_attr}
    })
  end

  # § tokenizer-attribute-value-single-quoted-state

  defp attribute_value_single_quoted(<<"\'", html::binary>>, s) do
    after_attribute_value_quoted(html, s)
  end

  defp attribute_value_single_quoted(<<"&", html::binary>>, s) do
    character_reference(html, %{s | return_state: :attribute_value_single_quoted})
  end

  defp attribute_value_single_quoted(<<"\0", html::binary>>, s) do
    attr = s.token.current_attribute
    new_attr = %Attribute{attr | value: attr.value <> @replacement_char}

    attribute_value_single_quoted(html, %{
      s
      | errors: [%ParseError{line: s.line, column: s.column} | s.errors],
        token: %Tag{s.token | current_attribute: new_attr}
    })
  end

  defp attribute_value_single_quoted("", s) do
    eof(:attribute_value_single_quoted, %{
      s
      | errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp attribute_value_single_quoted(<<c::utf8, html::binary>>, s) do
    attr = s.token.current_attribute
    new_attr = %Attribute{attr | value: attr.value <> <<c::utf8>>}

    attribute_value_single_quoted(html, %{
      s
      | token: %Tag{s.token | current_attribute: new_attr}
    })
  end

  # § tokenizer-attribute-value-unquoted-state

  defp attribute_value_unquoted(<<c::utf8, html::binary>>, s) when <<c::utf8>> in @space_chars do
    before_attribute_name(html, s)
  end

  defp attribute_value_unquoted(<<"&", html::binary>>, s) do
    character_reference(html, %{s | return_state: :attribute_value_unquoted})
  end

  defp attribute_value_unquoted(<<">", html::binary>>, s) do
    data(html, %{s | tokens: [s.token | s.tokens], token: nil})
  end

  defp attribute_value_unquoted(<<"\0", html::binary>>, s) do
    attr = s.token.current_attribute
    new_attr = %Attribute{attr | value: attr.value <> @replacement_char}

    attribute_value_unquoted(html, %{
      s
      | errors: [%ParseError{line: s.line, column: s.column} | s.errors],
        token: %Tag{s.token | current_attribute: new_attr}
    })
  end

  defp attribute_value_unquoted(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in ["\"", "'", "<", "=", "`"] do
    attr = s.token.current_attribute
    new_attr = %Attribute{attr | value: attr.value <> <<c::utf8>>}

    attribute_value_unquoted(html, %{
      s
      | errors: [%ParseError{line: s.line, column: s.column} | s.errors],
        token: %Tag{s.token | current_attribute: new_attr}
    })
  end

  defp attribute_value_unquoted("", s) do
    eof(:attribute_value_unquoted, %{
      s
      | errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp attribute_value_unquoted(<<c::utf8, html::binary>>, s) do
    attr = s.token.current_attribute
    new_attr = %Attribute{attr | value: attr.value <> <<c::utf8>>}

    attribute_value_unquoted(html, %{
      s
      | token: %Tag{s.token | current_attribute: new_attr}
    })
  end

  # § tokenizer-after-attribute-value-quoted-state

  defp after_attribute_value_quoted(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in @space_chars do
    before_attribute_name(html, s)
  end

  defp after_attribute_value_quoted(<<"/", html::binary>>, s) do
    self_closing_start_tag(html, s)
  end

  defp after_attribute_value_quoted(<<">", html::binary>>, s) do
    data(html, %{s | tokens: [s.token | s.tokens], token: nil})
  end

  defp after_attribute_value_quoted("", s) do
    eof(:after_attribute_value_quoted, %{
      s
      | errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp after_attribute_value_quoted(html, s) do
    before_attribute_name(html, s)
  end

  # § tokenizer-self-closing-start-tag-state

  defp self_closing_start_tag(<<">", html::binary>>, s) do
    tag = %Tag{s.token | self_close: true}
    data(html, %{s | tokens: [tag | s.tokens], token: nil})
  end

  defp self_closing_start_tag("", s) do
    eof(:self_closing_start_tag, %{
      s
      | errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp self_closing_start_tag(html, s) do
    before_attribute_name(html, %{
      s
      | errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  # § tokenizer-bogus-comment-state

  defp bogus_comment(<<">", html::binary>>, s) do
    data(html, %{s | tokens: [s.token | s.tokens], token: nil})
  end

  defp bogus_comment("", s) do
    eof(:bogus_comment, %{s | tokens: [s.token | s.tokens], token: nil})
  end

  defp bogus_comment(<<"\0", html::binary>>, s) do
    comment = %Comment{s.token | data: s.token.data <> @replacement_char}

    bogus_comment(html, %{s | token: comment})
  end

  defp bogus_comment(<<c::utf8, html::binary>>, s) do
    comment = %Comment{s.token | data: s.token.data <> <<c::utf8>>}

    bogus_comment(html, %{s | token: comment})
  end

  # § tokenizer-markup-declaration-open-state

  defp markup_declaration_open(<<"--", html::binary>>, s) do
    token = %Comment{data: "", line: s.line, column: s.column}

    comment_start(
      html,
      %{s | token: token, column: s.column + 2}
    )
  end

  defp markup_declaration_open(
         <<d::utf8, o::utf8, c::utf8, t::utf8, y::utf8, p::utf8, e::utf8, html::binary>>,
         s
       )
       when <<d::utf8>> in ["D", "d"] and <<o::utf8>> in ["O", "o"] and <<c::utf8>> in ["C", "c"] and
              <<t::utf8>> in ["T", "t"] and <<y::utf8>> in ["Y", "y"] and
              <<p::utf8>> in ["P", "p"] and <<e::utf8>> in ["E", "e"] do
    doctype(html, %{s | column: s.column + 7})
  end

  # TODO: fix the check for adjusted current node in HTML namespace
  defp markup_declaration_open(<<"[CDATA[", html::binary>>, s = %State{adjusted_current_node: n})
       when not is_nil(n) do
    cdata_section(html, s)
  end

  defp markup_declaration_open(html, s) do
    bogus_comment(html, %{s | errors: [%ParseError{line: s.line, column: s.column} | s.errors]})
  end

  # § tokenizer-comment-start-state

  defp comment_start(<<"-", html::binary>>, s) do
    comment_start_dash(html, %{s | column: s.column + 1})
  end

  defp comment_start(<<">", html::binary>>, s) do
    data(html, %{
      s
      | tokens: [s.token | s.tokens],
        token: nil,
        column: s.column + 1,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp comment_start(html, s) do
    comment(html, s)
  end

  # § tokenizer-comment-start-dash-state

  defp comment_start_dash(<<"-", html::binary>>, s) do
    comment_end(html, %{s | column: s.column + 1})
  end

  defp comment_start_dash(<<">", html::binary>>, s) do
    data(html, %{
      s
      | tokens: [s.token | s.tokens],
        token: nil,
        column: s.column + 1,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp comment_start_dash("", s) do
    eof(:comment_start_dash, %{
      s
      | errors: [%ParseError{line: s.line, column: s.column} | s.errors],
        tokens: [s.token | s.tokens],
        token: nil
    })
  end

  defp comment_start_dash(html, s) do
    new_comment = %Comment{s.token | data: s.token.data <> "-"}

    comment(html, %{s | token: new_comment})
  end

  # § tokenizer-comment-state

  defp comment(<<"<", html::binary>>, s) do
    new_comment = %Comment{s.token | data: s.token.data <> "<"}

    comment_less_than_sign(html, %{s | token: new_comment, column: s.column + 1})
  end

  defp comment(<<"-", html::binary>>, s) do
    comment_end_dash(html, s)
  end

  defp comment(<<"\0", html::binary>>, s) do
    new_comment = %Comment{s.token | data: s.token.data <> @replacement_char}

    comment(html, %{
      s
      | token: new_comment,
        column: s.column + 1,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp comment("", s) do
    eof(:comment, %{
      s
      | errors: [%ParseError{line: s.line, column: s.column} | s.errors],
        tokens: [s.token | s.tokens],
        token: nil
    })
  end

  defp comment(<<c::utf8, html::binary>>, s) do
    new_token = %{s.token | data: s.token.comment <> <<c::utf8>>}

    comment(
      html,
      %{s | token: new_token, column: s.column + 1}
    )
  end

  # § tokenizer-comment-less-than-sign-state

  defp comment_less_than_sign(<<"!", html::binary>>, s) do
    new_comment = %Comment{s.token | data: s.token.data <> "!"}

    comment_less_than_sign_bang(html, %{s | token: new_comment, column: s.column + 1})
  end

  defp comment_less_than_sign(<<"<", html::binary>>, s) do
    new_comment = %Comment{s.token | data: s.token.data <> "<"}

    comment_less_than_sign(html, %{s | token: new_comment, column: s.column + 1})
  end

  defp comment_less_than_sign(html, s) do
    comment(html, s)
  end

  # § tokenizer-comment-less-than-sign-bang-state

  defp comment_less_than_sign_bang(<<"-", html::binary>>, s) do
    comment_less_than_sign_bang_dash(html, s)
  end

  defp comment_less_than_sign_bang(html, s) do
    comment(html, s)
  end

  # § tokenizer-comment-less-than-sign-bang-dash-state

  defp comment_less_than_sign_bang_dash(<<"-", html::binary>>, s) do
    comment_less_than_sign_bang_dash_dash(html, s)
  end

  defp comment_less_than_sign_bang_dash(html, s) do
    comment_end_dash(html, s)
  end

  # § tokenizer-comment-less-than-sign-bang-dash-dash-state

  defp comment_less_than_sign_bang_dash_dash(html = <<">", _rest::binary>>, s) do
    comment_end(html, s)
  end

  defp comment_less_than_sign_bang_dash_dash(html = "", s) do
    comment_end(html, s)
  end

  defp comment_less_than_sign_bang_dash_dash(html, s) do
    comment_end(html, %{s | errors: [%ParseError{line: s.line, column: s.column} | s.errors]})
  end

  # § tokenizer-comment-end-dash-state

  defp comment_end_dash(<<"-", html::binary>>, s) do
    comment_end(html, %{s | column: s.column + 1})
  end

  defp comment_end_dash("", s) do
    eof(:comment_end_dash, %{
      s
      | tokens: [s.token | s.tokens],
        token: nil,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp comment_end_dash(html, s) do
    new_comment = %Comment{s.token | data: s.token.data <> "-"}

    comment(html, %{s | token: new_comment})
  end

  # § tokenizer-comment-end-state

  defp comment_end(<<">", html::binary>>, s) do
    data(
      html,
      %{s | tokens: [s.token | s.tokens], token: nil, column: s.column + 1}
    )
  end

  defp comment_end(<<"!", html::binary>>, s) do
    comment_end_bang(html, s)
  end

  defp comment_end(<<"-", html::binary>>, s) do
    new_comment = %Comment{s.token | data: s.token.data <> "-"}

    comment_end(html, %{s | token: new_comment})
  end

  defp comment_end("", s) do
    eof(:comment_end, %{
      s
      | tokens: [s.token | s.tokens],
        token: nil,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp comment_end(html, s) do
    new_comment = %Comment{s.token | data: s.token.data <> "-"}

    comment(html, %{s | token: new_comment})
  end

  # § tokenizer-comment-end-bang-state

  defp comment_end_bang(<<"-", html::binary>>, s) do
    new_comment = %Comment{s.token | data: s.token.data <> "--!"}

    comment_end_dash(html, %{s | token: new_comment})
  end

  defp comment_end_bang(<<">", html::binary>>, s) do
    data(html, %{
      s
      | tokens: [s.token | s.tokens],
        token: nil,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp comment_end_bang("", s) do
    eof(:comment_end_bang, %{
      s
      | tokens: [s.token | s.tokens],
        token: nil,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp comment_end_bang(html, s) do
    new_comment = %Comment{s.token | data: s.token.data <> "--!"}

    comment(html, %{s | token: new_comment})
  end

  # § tokenizer-doctype-state

  defp doctype(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in @space_chars do
    line = line_number(<<c::utf8>>, s.line)
    col = column_number(line, s)
    before_doctype_name(html, %{s | column: col, line: line})
  end

  defp doctype("", s) do
    doctype_token = %Doctype{force_quirks: :on}
    eof(:doctype, %{s | tokens: [doctype_token | s.tokens], token: nil})
  end

  defp doctype(html, s) do
    before_doctype_name(html, %{
      s
      | errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  # § tokenizer-before-doctype-name-state

  defp before_doctype_name(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in @space_chars do
    line = line_number(<<c::utf8>>, s.line)
    col = column_number(line, s)
    before_doctype_name(html, %{s | column: col, line: line})
  end

  defp before_doctype_name(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in @upper_ASCII_letters do
    token = %Doctype{name: String.downcase(<<c::utf8>>), line: s.line, column: s.column}

    doctype_name(html, %{s | token: token, column: s.column + 1})
  end

  defp before_doctype_name(<<"\0", html::binary>>, s) do
    token = %Doctype{
      name: @replacement_char,
      force_quirks: :on,
      line: s.line,
      column: s.column
    }

    doctype_name(html, %{s | token: token})
  end

  defp before_doctype_name(<<">", html::binary>>, s) do
    token = %Doctype{
      force_quirks: :on,
      line: s.line,
      column: s.column
    }

    data(html, %{
      s
      | tokens: [token | s.tokens],
        token: nil,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors],
        column: s.column + 1
    })
  end

  defp before_doctype_name("", s) do
    token = %Doctype{
      force_quirks: :on,
      line: s.line,
      column: s.column
    }

    eof(:before_doctype_name, %{
      s
      | tokens: [token | s.tokens],
        token: nil,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp before_doctype_name(<<c::utf8, html::binary>>, s) do
    line = line_number(<<c::utf8>>, s.line)
    col = column_number(line, s)

    token = %Doctype{
      name: <<c::utf8>>,
      line: line,
      column: col
    }

    doctype_name(html, %{s | token: token, column: col, line: line})
  end

  # § tokenizer-doctype-name-state

  defp doctype_name(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in @space_chars do
    line = line_number(<<c::utf8>>, s.line)
    col = column_number(line, s)

    after_doctype_name(html, %{s | column: col, line: line})
  end

  defp doctype_name(<<">", html::binary>>, s) do
    col = s.column + 1
    token = %Doctype{s.token | column: col}

    data(html, %{
      s
      | tokens: [token | s.tokens],
        token: nil,
        column: col
    })
  end

  defp doctype_name(<<c::utf8, html::binary>>, s) when <<c::utf8>> in @upper_ASCII_letters do
    col = s.column + 1

    new_token = %Doctype{
      s.token
      | name: s.token.name <> String.downcase(<<c::utf8>>),
        column: col
    }

    doctype_name(html, %{s | token: new_token, column: col})
  end

  defp doctype_name(<<"\0", html::binary>>, s) do
    new_token = %Doctype{s.token | name: s.token.name <> "\uFFFD"}

    doctype_name(html, %{
      s
      | token: new_token,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp doctype_name("", s) do
    new_token = %Doctype{s.token | force_quirks: :on}

    eof(:doctype_name, %{
      s
      | tokens: [new_token | s.tokens],
        token: nil,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp doctype_name(<<c::utf8, html::binary>>, s) do
    col = s.column + 1
    new_token = %Doctype{s.token | name: s.token.name <> <<c::utf8>>, column: col}

    doctype_name(html, %{s | token: new_token, column: col})
  end

  # § tokenizer-after-doctype-name-state

  defp after_doctype_name(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in @space_chars do
    line = line_number(c, s.line)
    col = column_number(line, s)

    after_doctype_name(html, %{s | column: col, line: line})
  end

  defp after_doctype_name(<<">", html::binary>>, s) do
    col = s.column + 1
    token = %{s.token | column: col}

    data(html, %{
      s
      | tokens: [token | s.tokens],
        token: nil,
        column: col
    })
  end

  defp after_doctype_name("", s) do
    token = %Doctype{s.token | force_quirks: :on}

    eof(:after_doctype_name, %{
      s
      | tokens: [token | s.tokens],
        token: nil,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp after_doctype_name(
         <<p::utf8, u::utf8, b::utf8, l::utf8, i::utf8, c::utf8, html::binary>>,
         s
       )
       when <<p::utf8>> in ["P", "p"] and <<u::utf8>> in ["U", "u"] and <<b::utf8>> in ["B", "b"] and
              <<l::utf8>> in ["L", "l"] and <<i::utf8>> in ["I", "i"] and
              <<c::utf8>> in ["C", "c"] do
    after_doctype_public_keyword(html, %{s | column: s.column + 6})
  end

  defp after_doctype_name(
         <<s1::utf8, y::utf8, s2::utf8, t::utf8, e::utf8, m::utf8, html::binary>>,
         s
       )
       when <<s1::utf8>> in ["S", "s"] and <<y::utf8>> in ["Y", "y"] and
              <<s2::utf8>> in ["S", "s"] and <<t::utf8>> in ["T", "t"] and
              <<e::utf8>> in ["E", "e"] and <<m::utf8>> in ["M", "m"] do
    after_doctype_system_keyword(html, %{s | column: s.column + 6})
  end

  defp after_doctype_name(html, s) do
    token = %Doctype{s.token | force_quirks: :on}

    bogus_doctype(html, %{
      s
      | token: token,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  # § tokenizer-after-doctype-public-keyword-state

  defp after_doctype_public_keyword(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in @space_chars do
    before_doctype_public_identifier(html, s)
  end

  defp after_doctype_public_keyword(<<"\"", html::binary>>, s) do
    doctype = %Doctype{s.token | public_id: ""}

    doctype_public_identifier_double_quoted(html, %{
      s
      | token: doctype,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp after_doctype_public_keyword(<<"'", html::binary>>, s) do
    doctype = %Doctype{s.token | public_id: ""}

    doctype_public_identifier_single_quoted(html, %{
      s
      | token: doctype,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp after_doctype_public_keyword(<<">", html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    data(html, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp after_doctype_public_keyword("", s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    eof(:after_doctype_public_keyword, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp after_doctype_public_keyword(<<_c::utf8, html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    bogus_doctype(html, %{
      s
      | token: doctype,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  # § tokenizer-before-doctype-public-identifier-state

  defp before_doctype_public_identifier(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in @space_chars do
    before_doctype_public_identifier(html, s)
  end

  defp before_doctype_public_identifier(<<"\"", html::binary>>, s) do
    doctype = %Doctype{s.token | public_id: ""}

    doctype_public_identifier_double_quoted(html, %{
      s
      | token: doctype,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp before_doctype_public_identifier(<<"'", html::binary>>, s) do
    doctype = %Doctype{s.token | public_id: ""}

    doctype_public_identifier_single_quoted(html, %{
      s
      | token: doctype,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp before_doctype_public_identifier(<<">", html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    data(html, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp before_doctype_public_identifier("", s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    eof(:before_doctype_public_identifier, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp before_doctype_public_identifier(<<_::utf8, html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    bogus_doctype(html, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  # § tokenizer-doctype-public-identifier-double-quoted-state

  defp doctype_public_identifier_double_quoted(<<"\"", html::binary>>, s) do
    after_doctype_public_identifier(html, s)
  end

  defp doctype_public_identifier_double_quoted(<<"\0", html::binary>>, s) do
    doctype = %Doctype{s.token | public_id: s.token.public_id <> @replacement_char}

    doctype_public_identifier_double_quoted(html, %{
      s
      | token: doctype,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp doctype_public_identifier_double_quoted(<<">", html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    data(html, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp doctype_public_identifier_double_quoted("", s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    eof(:doctype_public_identifier_double_quoted, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp doctype_public_identifier_double_quoted(<<c::utf8, html::binary>>, s) do
    doctype = %Doctype{s.token | public_id: s.token.public_id <> <<c::utf8>>}

    doctype_public_identifier_double_quoted(html, %{s | token: doctype})
  end

  # § tokenizer-doctype-public-identifier-single-quoted-state

  defp doctype_public_identifier_single_quoted(<<"\'", html::binary>>, s) do
    after_doctype_public_identifier(html, s)
  end

  defp doctype_public_identifier_single_quoted(<<"\0", html::binary>>, s) do
    doctype = %Doctype{s.token | public_id: s.token.public_id <> @replacement_char}

    doctype_public_identifier_single_quoted(html, %{
      s
      | token: doctype,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp doctype_public_identifier_single_quoted(<<">", html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    data(html, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp doctype_public_identifier_single_quoted("", s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    eof(:doctype_public_identifier_single_quoted, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp doctype_public_identifier_single_quoted(<<c::utf8, html::binary>>, s) do
    doctype = %Doctype{s.token | public_id: s.token.public_id <> <<c::utf8>>}

    doctype_public_identifier_single_quoted(html, %{s | token: doctype})
  end

  # § tokenizer-after-doctype-public-identifier-state

  defp after_doctype_public_identifier(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in @space_chars do
    between_doctype_public_and_system_identifiers(html, s)
  end

  defp after_doctype_public_identifier(<<">", html::binary>>, s) do
    data(html, %{s | token: nil, tokens: [s.token | s.tokens]})
  end

  defp after_doctype_public_identifier(<<"\"", html::binary>>, s) do
    doctype = %Doctype{s.token | system_id: ""}

    doctype_system_identifier_double_quoted(html, %{
      s
      | token: doctype,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp after_doctype_public_identifier(<<"'", html::binary>>, s) do
    doctype = %Doctype{s.token | system_id: ""}

    doctype_system_identifier_single_quoted(html, %{
      s
      | token: doctype,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp after_doctype_public_identifier("", s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    eof(:after_doctype_public_identifier, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp after_doctype_public_identifier(<<_c::utf8, html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    bogus_doctype(html, %{
      s
      | token: doctype,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  # § tokenizer-between-doctype-public-and-system-identifiers-state

  defp between_doctype_public_and_system_identifiers(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in @space_chars do
    between_doctype_public_and_system_identifiers(html, s)
  end

  defp between_doctype_public_and_system_identifiers(<<">", html::binary>>, s) do
    data(html, %{s | token: nil, tokens: [s.token | s.tokens]})
  end

  defp between_doctype_public_and_system_identifiers(<<"\"", html::binary>>, s) do
    doctype = %Doctype{s.token | system_id: ""}

    doctype_system_identifier_double_quoted(html, %{s | token: doctype})
  end

  defp between_doctype_public_and_system_identifiers(<<"'", html::binary>>, s) do
    doctype = %Doctype{s.token | system_id: ""}

    doctype_system_identifier_single_quoted(html, %{s | token: doctype})
  end

  defp between_doctype_public_and_system_identifiers("", s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    eof(:between_doctype_public_and_system_identifiers, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp between_doctype_public_and_system_identifiers(<<_c::utf8, html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    bogus_doctype(html, %{
      s
      | tokens: doctype,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  # § tokenizer-after-doctype-system-keyword-state

  defp after_doctype_system_keyword(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in @space_chars do
    before_doctype_system_identifier(html, s)
  end

  defp after_doctype_system_keyword(<<"\"", html::binary>>, s) do
    doctype = %Doctype{s.token | system_id: ""}

    doctype_system_identifier_double_quoted(html, %{
      s
      | token: doctype,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp after_doctype_system_keyword(<<"'", html::binary>>, s) do
    doctype = %Doctype{s.token | system_id: ""}

    doctype_system_identifier_single_quoted(html, %{
      s
      | token: doctype,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp after_doctype_system_keyword(<<">", html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    data(html, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp after_doctype_system_keyword("", s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    eof(:after_doctype_system_keyword, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp after_doctype_system_keyword(<<_c::utf8, html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    bogus_doctype(html, %{
      s
      | token: doctype,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  # § tokenizer-before-doctype-system-identifier-state

  defp before_doctype_system_identifier(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in @space_chars do
    before_doctype_system_identifier(html, s)
  end

  defp before_doctype_system_identifier(<<"\"", html::binary>>, s) do
    doctype = %Doctype{s.token | system_id: ""}

    doctype_system_identifier_double_quoted(html, %{
      s
      | token: doctype,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp before_doctype_system_identifier(<<"'", html::binary>>, s) do
    doctype = %Doctype{s.token | system_id: ""}

    doctype_system_identifier_single_quoted(html, %{
      s
      | token: doctype,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp before_doctype_system_identifier(<<">", html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    data(html, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp before_doctype_system_identifier("", s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    eof(:before_doctype_system_identifier, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp before_doctype_system_identifier(<<_::utf8, html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    bogus_doctype(html, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  # § tokenizer-doctype-system-identifier-double-quoted-state

  defp doctype_system_identifier_double_quoted(<<"\"", html::binary>>, s) do
    after_doctype_system_identifier(html, s)
  end

  defp doctype_system_identifier_double_quoted(<<"\0", html::binary>>, s) do
    doctype = %Doctype{s.token | system_id: s.token.system_id <> @replacement_char}

    doctype_system_identifier_double_quoted(html, %{
      s
      | token: doctype,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp doctype_system_identifier_double_quoted(<<">", html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    data(html, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp doctype_system_identifier_double_quoted("", s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    eof(:doctype_system_identifier_double_quoted, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp doctype_system_identifier_double_quoted(<<c::utf8, html::binary>>, s) do
    doctype = %Doctype{s.token | system_id: s.token.system_id <> <<c::utf8>>}

    doctype_system_identifier_double_quoted(html, %{s | token: doctype})
  end

  # § tokenizer-doctype-system-identifier-single-quoted-state

  defp doctype_system_identifier_single_quoted(<<"\'", html::binary>>, s) do
    after_doctype_system_identifier(html, s)
  end

  defp doctype_system_identifier_single_quoted(<<"\0", html::binary>>, s) do
    doctype = %Doctype{s.token | system_id: s.token.system_id <> @replacement_char}

    doctype_system_identifier_single_quoted(html, %{
      s
      | token: doctype,
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp doctype_system_identifier_single_quoted(<<">", html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    data(html, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp doctype_system_identifier_single_quoted("", s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    eof(:doctype_system_identifier_single_quoted, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp doctype_system_identifier_single_quoted(<<c::utf8, html::binary>>, s) do
    doctype = %Doctype{s.token | system_id: s.token.system_id <> <<c::utf8>>}

    doctype_system_identifier_single_quoted(html, %{s | token: doctype})
  end

  # § tokenizer-after-doctype-system-identifier-state

  defp after_doctype_system_identifier(<<c::utf8, html::binary>>, s)
       when <<c::utf8>> in @space_chars do
    after_doctype_system_identifier(html, s)
  end

  defp after_doctype_system_identifier(<<">", html::binary>>, s) do
    data(html, %{s | token: nil, tokens: [s.token | s.tokens]})
  end

  defp after_doctype_system_identifier("", s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    eof(:after_doctype_system_identifier, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  defp after_doctype_system_identifier(<<_c::utf8, html::binary>>, s) do
    bogus_doctype(html, %{
      s
      | token: nil,
        tokens: [s.token | s.tokens],
        errors: [%ParseError{line: s.line, column: s.column} | s.errors]
    })
  end

  # § tokenizer-bogus-doctype-state

  defp bogus_doctype(<<">", html::binary>>, s) do
    data(html, %{s | token: nil, tokens: [s.token | s.tokens]})
  end

  defp bogus_doctype("", s) do
    eof(:bogus_doctype, %{s | token: nil, tokens: [s.token | s.tokens]})
  end

  defp bogus_doctype(<<_c::utf8, html::binary>>, s) do
    bogus_doctype(html, s)
  end

  # § tokenizer-cdata-section-state

  defp cdata_section(<<"]", html::binary>>, s) do
    cdata_section_bracket(html, s)
  end

  defp cdata_section("", s) do
    eof(:cdata_section, %{s | errors: [%ParseError{line: s.line, column: s.column} | s.errors]})
  end

  defp cdata_section(<<c::utf8, html::binary>>, s) do
    cdata_section(html, %{s | tokens: [%Char{data: <<c::utf8>>} | s.tokens]})
  end

  # § tokenizer-cdata-section-bracket-state

  defp cdata_section_bracket(<<"]", html::binary>>, s) do
    cdata_section_end(html, s)
  end

  defp cdata_section_bracket(html, s) do
    cdata_section(html, %{s | tokens: [%Char{data: "]"} | s.tokens]})
  end

  # § tokenizer-cdata-section-end-state

  defp cdata_section_end(<<"]", html::binary>>, s) do
    cdata_section_end(html, %{s | tokens: [%Char{data: "]"} | s.tokens]})
  end

  defp cdata_section_end(<<">", html::binary>>, s) do
    data(html, s)
  end

  defp cdata_section_end(html, s) do
    cdata_section(html, %{s | tokens: [%Char{data: "]]"} | s.tokens]})
  end

  # § tokenizer-character-reference-state

  defp character_reference(html, s) do
    do_char_reference(html, %{s | buffer: "&"})
  end

  defp do_char_reference(html = <<c::utf8, _rest::binary>>, s)
       when <<c::utf8>> in ["<", "&", "" | @space_chars] do
    character_reference_end(html, s)
  end

  defp do_char_reference(<<"#", html::binary>>, s) do
    numeric_character_reference(html, %{s | buffer: s.buffer <> "#"})
  end

  defp do_char_reference(html, s) do
    seek_charref(html, %{s | charref_state: %CharrefState{}})
  end

  defp seek_charref(<<c::utf8, html::binary>>, s) when <<c::utf8>> in [";" | @alphanumerics] do
    buffer = s.buffer <> <<c::utf8>>
    candidate = Map.get(@entities, buffer)

    charref_state =
      if candidate do
        %CharrefState{s.charref_state | candidate: buffer}
      else
        s.charref_state
      end

    len = charref_state.length + 1
    done_by_length? = len > 60
    done_by_semicolon? = <<c::utf8>> == ";"

    seek_charref(html, %{
      s
      | buffer: buffer,
        charref_state: %{charref_state | length: len, done: done_by_semicolon? || done_by_length?}
    })
  end

  defp seek_charref(html, s) do
    charref_state = %CharrefState{s.charref_state | done: true}

    seek_charref_end(html, %{s | charref_state: charref_state})
  end

  defp seek_charref_end(html, s) do
    candidate = s.charref_state.candidate

    ends_with_semicolon? = String.ends_with?(s.buffer, ";")

    parse_error_on_unmatch? =
      String.starts_with?(s.buffer, "&") && ends_with_semicolon? && candidate == nil

    do_nothing_when_part_of_attr? =
      candidate && part_of_attr?(s) && !ends_with_semicolon? &&
        next_input_in?(html, ["=" | @alphanumerics])

    parse_error_on_non_semicolon_ending? = !ends_with_semicolon?

    state =
      cond do
        parse_error_on_unmatch? ->
          %{s | errors: [%ParseError{line: s.line, column: s.column} | s.errors]}

        do_nothing_when_part_of_attr? ->
          s

        parse_error_on_non_semicolon_ending? ->
          %{s | errors: [%ParseError{line: s.line, column: s.column} | s.errors]}

        true ->
          chars =
            @entities
            |> Map.get(s.charref_state.candidate, %{})
            |> Map.get("characters")

          %{s | buffer: chars}
      end

    character_reference_end(html, state)
  end

  # § tokenizer-numeric-character-reference-state

  # § tokenizer-character-reference-end-state

  defp character_reference_end(html, s) do
    state =
      cond do
        part_of_attr?(s) ->
          new_tag = %Tag{
            s.token
            | current_attribute: %Attribute{
                s.token.current_attribute
                | value: s.token.current_attribute.value <> s.buffer
              }
          }

          %{s | token: new_tag}

        true ->
          %{s | tokens: [%Char{data: s.buffer} | s.tokens]}
      end

    case s.return_state do
      :data ->
        data(html, state)

      :rcdata ->
        rcdata(html, state)

      :attribute_value_unquoted ->
        attribute_value_unquoted(html, state)

      :attribute_value_single_quoted ->
        attribute_value_single_quoted(html, state)

      :attribute_value_double_quoted ->
        attribute_value_double_quoted(html, state)
    end
  end

  ##
  # TEMP
  ##
  defp numeric_character_reference(_, s), do: s

  ##
  # END TEMP
  ##

  defp part_of_attr?(state) do
    state.return_state in [
      :attribute_value_double_quoted,
      :attribute_value_single_quoted,
      :attribute_value_unquoted
    ]
  end

  defp next_input_in?(html, chars) do
    case html do
      <<c::utf8, _rest::binary>> ->
        <<c::utf8>> in chars

      _ ->
        false
    end
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
