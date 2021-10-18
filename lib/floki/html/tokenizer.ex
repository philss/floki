defmodule Floki.HTML.Tokenizer do
  @moduledoc false

  # HTML tokenizer built according to the specs of WHATWG/W3C.
  # https://html.spec.whatwg.org/multipage/#toc-syntax
  #
  # In order to find the docs of a given state, add it as an anchor to the link above.
  # Example: https://html.spec.whatwg.org/multipage/parsing.html#data-state
  #
  # The tests for this module can be found in test/floki/html/generated/tokenizer.
  # They were generated based on test files from https://github.com/html5lib/html5lib-tests
  # In order to update those test files you first need to run the task:
  #
  #     mix generate_tokenizer_tests filename.tests
  #
  # Where "filename.tests" is a file present in "test/html5lib-tests/tokenizer" directory.
  #
  # This tokenizer depends on an entities list that is generated with another mix task.
  # That file shouldn't change much, but if needed, it can be updated with:
  #
  #     mix generate_entities
  #
  # This tokenizer does not work with streams yet.

  defmodule Doctype do
    @moduledoc false

    defstruct name: nil,
              public_id: nil,
              system_id: nil,
              force_quirks: :off

    @type t :: %__MODULE__{
            name: iodata(),
            public_id: iodata() | nil,
            system_id: iodata() | nil,
            force_quirks: :on | :off
          }
  end

  defmodule Attribute do
    @moduledoc false

    defstruct name: "", value: ""

    @type t :: %__MODULE__{
            name: iodata(),
            value: iodata()
          }
  end

  defmodule StartTag do
    @moduledoc false

    defstruct name: "",
              self_close: nil,
              attributes: []

    @type t :: %__MODULE__{
            name: iodata(),
            self_close: boolean() | nil,
            attributes: list(Attribute.t())
          }
  end

  defmodule EndTag do
    @moduledoc false

    defstruct name: "",
              self_close: nil,
              attributes: []

    @type t :: %__MODULE__{
            name: iodata(),
            self_close: boolean() | nil,
            attributes: list(Attribute.t())
          }
  end

  defmodule Comment do
    @moduledoc false

    defstruct data: ""

    @type t :: %__MODULE__{
            data: iodata()
          }
  end

  defmodule CharrefState do
    @moduledoc false

    defstruct candidate: nil, done: false, length: 0

    @type t :: %__MODULE__{
            candidate: binary(),
            done: boolean(),
            length: integer()
          }
  end

  # It represents the state of tokenization.
  defmodule State do
    @moduledoc false

    defstruct return_state: nil,
              eof_last_state: nil,
              adjusted_current_node: nil,
              token: nil,
              tokens: [],
              buffer: "",
              last_start_tag: nil,
              errors: [],
              emit: nil,
              charref_state: nil,
              charref_code: nil

    @type token :: Doctype.t() | Comment.t() | StartTag.t() | EndTag.t() | {:char, iodata()}

    @type t :: %__MODULE__{
            return_state:
              :data
              | :rcdata
              | :attribute_value_double_quoted
              | :attribute_value_single_quoted
              | :attribute_value_unquoted,
            eof_last_state: atom(),
            buffer: iodata(),
            token: token() | nil,
            tokens: list(token()),
            errors: [{:parse_error, binary() | nil}],
            last_start_tag: StartTag.t(),
            charref_state: CharrefState.t(),
            charref_code: integer(),
            emit: (token() -> token())
          }
  end

  @lower_ASCII_letters ?a..?z
  @upper_ASCII_letters ?A..?Z
  @ascii_digits ?0..?9
  @space_chars [?\t, ?\n, ?\f, ?\s]

  defguardp is_lower_letter(c) when c in @lower_ASCII_letters
  defguardp is_upper_letter(c) when c in @upper_ASCII_letters
  defguardp is_digit(c) when c in @ascii_digits
  defguardp is_letter(c) when c in @upper_ASCII_letters or c in @lower_ASCII_letters
  defguardp is_space(c) when c in @space_chars

  @less_than_sign ?<
  @greater_than_sign ?>
  @exclamation_mark ?!
  @solidus ?/
  @hyphen_minus ?-
  @replacement_char 0xFFFD

  @spec tokenize(binary()) :: State.t()
  def tokenize(html) do
    pattern = :binary.compile_pattern(["\r\n", "\r"])

    html
    |> String.replace(pattern, "\n")
    |> data(%State{emit: fn token -> token end})
  end

  # It assumes that the parser stops at the end of file.
  # If we need to work with streams, this can't reverse here.
  defp eof(last_state, s) do
    %{
      s
      | eof_last_state: last_state,
        tokens: Enum.reverse([:eof | s.tokens]),
        errors: Enum.reverse(s.errors)
    }
  end

  # § tokenizer-data-state

  defp data(<<?&, html::binary>>, s) do
    character_reference(html, %{s | return_state: :data})
  end

  defp data(<<?<, html::binary>>, s) do
    tag_open(html, s)
  end

  defp data(<<0, html::binary>>, s) do
    data(html, %{s | tokens: append_char_token(s, 0)})
  end

  defp data("", s) do
    eof(:data, s)
  end

  defp data(<<c::utf8, html::binary>>, s) do
    data(html, %{s | tokens: append_char_token(s, c)})
  end

  # § tokenizer-rcdata-state: re-entrant

  @spec rcdata(binary(), %State{}) :: %State{}
  def rcdata(<<?&, html::binary>>, s) do
    character_reference(html, %{s | return_state: :rcdata})
  end

  def rcdata(<<?<, html::binary>>, s) do
    rcdata_less_than_sign(html, s)
  end

  def rcdata(<<0, html::binary>>, s) do
    rcdata(html, %{s | tokens: append_char_token(s, @replacement_char)})
  end

  def rcdata("", s) do
    eof(:rcdata, s)
  end

  def rcdata(<<c::utf8, html::binary>>, s) do
    rcdata(html, %{s | tokens: append_char_token(s, c)})
  end

  # § tokenizer-rawtext-state: re-entrant

  @spec rawtext(binary(), State.t()) :: State.t()
  def rawtext(<<?<, html::binary>>, s) do
    rawtext_less_than_sign(html, s)
  end

  def rawtext(<<0, html::binary>>, s) do
    rawtext(html, %{s | tokens: append_char_token(s, @replacement_char)})
  end

  def rawtext("", s) do
    eof(:rawtext, s)
  end

  def rawtext(<<c::utf8, html::binary>>, s) do
    rawtext(html, %{s | tokens: append_char_token(s, c)})
  end

  # § tokenizer-script-data-state: re-entrant

  @spec script_data(binary(), State.t()) :: State.t()
  def script_data(<<?<, html::binary>>, s) do
    script_data_less_than_sign(html, s)
  end

  def script_data(<<0, html::binary>>, s) do
    script_data(html, %{s | tokens: append_char_token(s, @replacement_char)})
  end

  def script_data("", s) do
    eof(:script_data, s)
  end

  def script_data(<<c::utf8, html::binary>>, s) do
    script_data(html, %{
      s
      | tokens: append_char_token(s, c)
    })
  end

  # § tokenizer-plaintext-state: re-entrant

  @spec plaintext(binary(), State.t()) :: State.t()
  def plaintext(<<0, html::binary>>, s) do
    plaintext(html, %{s | tokens: append_char_token(s, @replacement_char)})
  end

  def plaintext("", s) do
    eof(:plaintext, s)
  end

  def plaintext(<<c::utf8, html::binary>>, s) do
    plaintext(html, %{s | tokens: append_char_token(s, c)})
  end

  # § tokenizer-tag-open-state

  defp tag_open(<<?!, html::binary>>, s) do
    markup_declaration_open(html, s)
  end

  defp tag_open(<<?/, html::binary>>, s) do
    end_tag_open(html, s)
  end

  defp tag_open(html = <<c, _rest::binary>>, s)
       when is_letter(c) do
    token = %StartTag{name: ""}

    tag_name(html, %{s | token: token})
  end

  defp tag_open(html = <<??, _rest::binary>>, s) do
    token = %Comment{data: ""}

    bogus_comment(html, %{s | token: token})
  end

  defp tag_open(html, s) do
    data(html, %{
      s
      | token: nil,
        tokens: append_char_token(s, @less_than_sign)
    })
  end

  # § tokenizer-end-tag-open-state

  defp end_tag_open(html = <<c, _rest::binary>>, s)
       when is_letter(c) do
    token = %EndTag{name: ""}

    tag_name(html, %{s | token: token})
  end

  defp end_tag_open(<<?>, html::binary>>, s) do
    data(html, %{s | token: nil})
  end

  defp end_tag_open("", s) do
    eof(:data, %{
      s
      | token: nil,
        tokens: append_char_token(s, [@less_than_sign, @solidus]),
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp end_tag_open(html, s) do
    token = %Comment{data: ""}

    bogus_comment(html, %{s | token: token})
  end

  # § tokenizer-tag-name-state

  defp tag_name(<<c, html::binary>>, s)
       when is_space(c) do
    before_attribute_name(html, s)
  end

  defp tag_name(<<?/, html::binary>>, s) do
    self_closing_start_tag(html, s)
  end

  defp tag_name(<<?>, html::binary>>, s) do
    data(html, %{
      s
      | last_start_tag: s.token,
        tokens: [s.emit.(s.token) | s.tokens],
        token: nil
    })
  end

  defp tag_name(<<c, html::binary>>, s)
       when is_upper_letter(c) do
    new_token = %{s.token | name: [s.token.name | [c + 32]]}

    tag_name(html, %{s | token: new_token})
  end

  defp tag_name(<<0, html::binary>>, s) do
    tag_name(html, %{
      s
      | token: %{s.token | name: [s.token.name | [@replacement_char]]},
        errors: [
          {:parse_error, "unexpected-null-character"}
          | s.errors
        ]
    })
  end

  defp tag_name("", s) do
    eof(:tag_name, %{
      s
      | errors: [{:parse_error, "eof-in-tag"} | s.errors]
    })
  end

  defp tag_name(<<c::utf8, html::binary>>, s) do
    new_token = %{s.token | name: [s.token.name | [c]]}

    tag_name(html, %{s | token: new_token})
  end

  # § tokenizer-rcdata-less-than-sign-state

  defp rcdata_less_than_sign(<<?/, html::binary>>, s) do
    rcdata_end_tag_open(html, %{s | buffer: ""})
  end

  defp rcdata_less_than_sign(html, s) do
    rcdata(html, %{
      s
      | token: nil,
        tokens: append_char_token(s, @less_than_sign)
    })
  end

  # § tokenizer-rcdata-end-tag-open-state

  defp rcdata_end_tag_open(
         html = <<c, _rest::binary>>,
         s
       )
       when is_letter(c) do
    token = %EndTag{name: ""}
    rcdata_end_tag_name(html, %{s | token: token})
  end

  defp rcdata_end_tag_open(html, s) do
    rcdata(html, %{s | tokens: append_char_token(s, [@less_than_sign, @solidus])})
  end

  # § tokenizer-rcdata-end-tag-name-state

  defp rcdata_end_tag_name(html = <<c, rest::binary>>, s)
       when is_space(c) do
    if appropriate_tag?(s) do
      before_attribute_name(rest, s)
    else
      rcdata(html, %{
        s
        | tokens: tokens_for_inappropriate_end_tag(s),
          buffer: ""
      })
    end
  end

  defp rcdata_end_tag_name(html = <<?/, rest::binary>>, s) do
    if appropriate_tag?(s) do
      self_closing_start_tag(rest, s)
    else
      rcdata(html, %{
        s
        | tokens: tokens_for_inappropriate_end_tag(s),
          buffer: ""
      })
    end
  end

  defp rcdata_end_tag_name(html = <<?>, rest::binary>>, s) do
    if appropriate_tag?(s) do
      data(rest, %{
        s
        | token: nil,
          tokens: [s.emit.(s.token) | s.tokens]
      })
    else
      rcdata(html, %{
        s
        | tokens: tokens_for_inappropriate_end_tag(s),
          buffer: ""
      })
    end
  end

  # TODO: should we always declare %State{}?
  defp rcdata_end_tag_name(<<c, html::binary>>, %State{} = s)
       when is_upper_letter(c) do
    c_downcased = c + 32
    new_token = %{s.token | name: [s.token.name | [c_downcased]]}

    rcdata(html, %{s | token: new_token, buffer: [s.buffer | [c_downcased]]})
  end

  defp rcdata_end_tag_name(<<c, html::binary>>, s)
       when is_lower_letter(c) do
    col = s.col + 1
    new_token = %{s.token | name: [s.name | [c]]}

    rcdata_end_tag_name(html, %{s | token: new_token, buffer: [s.buffer | [c]], col: col})
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
       when is_space(c) do
    if appropriate_tag?(s) do
      before_attribute_name(rest, s)
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
      self_closing_start_tag(rest, s)
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
          tokens: [s.emit.(s.token) | s.tokens]
      })
    else
      rawtext(html, %{
        s
        | tokens: tokens_for_inappropriate_end_tag(s),
          buffer: ""
      })
    end
  end

  defp rawtext_end_tag_name(<<c, html::binary>>, s)
       when is_upper_letter(c) do
    new_token = %{s.token | name: [s.token.name | [c + 32]]}

    rawtext(html, %{s | token: new_token, buffer: [s.buffer | [c]]})
  end

  defp rawtext_end_tag_name(<<c, html::binary>>, s)
       when is_lower_letter(c) do
    col = s.col + 1
    new_token = %{s.token | name: [s.name | [c]]}

    rawtext_end_tag_name(html, %{s | token: new_token, buffer: [s.buffer | [c]], col: col})
  end

  defp rawtext_end_tag_name(html, s) do
    rawtext(html, %{
      s
      | tokens: tokens_for_inappropriate_end_tag(s),
        buffer: ""
    })
  end

  # § tokenizer-script-data-end-tag-name-state

  defp script_data_end_tag_name(html = <<c, rest::binary>>, s)
       when is_space(c) do
    if appropriate_tag?(s) do
      before_attribute_name(rest, s)
    else
      script_data(html, %{
        s
        | tokens: tokens_for_inappropriate_end_tag(s),
          buffer: ""
      })
    end
  end

  defp script_data_end_tag_name(html = <<?/, rest::binary>>, s) do
    if appropriate_tag?(s) do
      self_closing_start_tag(rest, s)
    else
      script_data(html, %{
        s
        | tokens: tokens_for_inappropriate_end_tag(s),
          buffer: ""
      })
    end
  end

  defp script_data_end_tag_name(html = <<?>, rest::binary>>, s) do
    if appropriate_tag?(s) do
      data(rest, %{
        s
        | token: nil,
          tokens: [s.emit.(s.token) | s.tokens]
      })
    else
      script_data(html, %{
        s
        | tokens: tokens_for_inappropriate_end_tag(s),
          buffer: ""
      })
    end
  end

  defp script_data_end_tag_name(<<c, html::binary>>, s)
       when is_upper_letter(c) do
    c_downcased = c + 32
    new_token = %{s.token | name: [s.token.name | [c_downcased]]}

    script_data(html, %{s | token: new_token, buffer: [s.buffer | [c_downcased]]})
  end

  defp script_data_end_tag_name(<<c, html::binary>>, s)
       when is_lower_letter(c) do
    new_token = %{s.token | name: [s.name | [c]]}

    script_data_end_tag_name(html, %{s | token: new_token, buffer: [s.buffer | [c]]})
  end

  defp script_data_end_tag_name(html, s) do
    script_data(html, %{
      s
      | tokens: tokens_for_inappropriate_end_tag(s),
        buffer: ""
    })
  end

  # § tokenizer-script-data-escaped-end-tag-name-state: re-entrant

  @spec script_data_escaped_end_tag_name(binary(), State.t()) :: State.t()
  def script_data_escaped_end_tag_name(html = <<c, rest::binary>>, s)
      when is_space(c) do
    if appropriate_tag?(s) do
      before_attribute_name(rest, s)
    else
      script_data_escaped(html, %{
        s
        | tokens: tokens_for_inappropriate_end_tag(s),
          buffer: ""
      })
    end
  end

  def script_data_escaped_end_tag_name(html = <<?/, rest::binary>>, s) do
    if appropriate_tag?(s) do
      self_closing_start_tag(rest, s)
    else
      script_data_escaped(html, %{
        s
        | tokens: tokens_for_inappropriate_end_tag(s),
          buffer: ""
      })
    end
  end

  def script_data_escaped_end_tag_name(html = <<?>, rest::binary>>, s) do
    if appropriate_tag?(s) do
      data(rest, %{
        s
        | token: nil,
          tokens: [s.emit.(s.token) | s.tokens]
      })
    else
      script_data_escaped(html, %{
        s
        | tokens: tokens_for_inappropriate_end_tag(s),
          buffer: ""
      })
    end
  end

  def script_data_escaped_end_tag_name(<<c, html::binary>>, s)
      when is_upper_letter(c) do
    new_token = %{s.token | name: [s.name | [c + 32]]}

    script_data_escaped(html, %{s | token: new_token, buffer: [s.buffer | [c]]})
  end

  def script_data_escaped_end_tag_name(<<c, html::binary>>, s)
      when is_lower_letter(c) do
    new_token = %{s.token | name: [s.token.name | [c]]}

    script_data_escaped_end_tag_name(html, %{
      s
      | token: new_token,
        buffer: [s.buffer | [c]]
    })
  end

  def script_data_escaped_end_tag_name(html, s) do
    script_data_escaped(html, %{
      s
      | tokens: tokens_for_inappropriate_end_tag(s),
        buffer: ""
    })
  end

  # § tokenizer-rawtext-less-than-sign-state

  defp rawtext_less_than_sign(<<?/, html::binary>>, s) do
    rawtext_end_tag_open(html, %{s | buffer: ""})
  end

  defp rawtext_less_than_sign(html, s) do
    rawtext(html, %{s | tokens: append_char_token(s, 0x003C)})
  end

  # § tokenizer-rawtext-end-tag-open-state

  defp rawtext_end_tag_open(
         html = <<c, _rest::binary>>,
         s
       )
       when is_letter(c) do
    token = %EndTag{name: ""}
    rawtext_end_tag_name(html, %{s | token: token})
  end

  defp rawtext_end_tag_open(html, s) do
    rawtext(html, %{s | tokens: append_char_token(s, [@less_than_sign, @solidus])})
  end

  # § tokenizer-script-data-less-than-sign-state

  defp script_data_less_than_sign(<<?/, html::binary>>, s) do
    script_data_end_tag_open(html, %{s | buffer: ""})
  end

  defp script_data_less_than_sign(<<?!, html::binary>>, s) do
    script_data_less_than_sign(html, %{
      s
      | tokens: append_char_token(s, [@less_than_sign, @exclamation_mark])
    })
  end

  defp script_data_less_than_sign(html, s) do
    script_data(html, %{s | tokens: append_char_token(s, @less_than_sign)})
  end

  # § tokenizer-script-data-end-tag-open-state

  defp script_data_end_tag_open(
         html = <<c, _rest::binary>>,
         s
       )
       when is_letter(c) do
    end_tag = %EndTag{name: ""}
    script_data_end_tag_name(html, %{s | token: end_tag})
  end

  defp script_data_end_tag_open(html, s) do
    script_data(html, %{
      s
      | tokens: append_char_token(s, [@less_than_sign, @solidus])
    })
  end

  # § tokenizer-script-data-escape-start-state: re-entrant

  @spec script_data_escape_start(binary(), State.t()) :: State.t()
  def script_data_escape_start(<<?-, html::binary>>, s) do
    script_data_escape_start_dash(
      html,
      %{
        s
        | tokens: append_char_token(s, @hyphen_minus)
      }
    )
  end

  def script_data_escape_start(html, s) do
    script_data(html, s)
  end

  # § tokenizer-script-data-escape-start-dash-state

  defp script_data_escape_start_dash(<<?-, html::binary>>, s) do
    script_data_escaped_dash_dash(
      html,
      %{
        s
        | tokens: append_char_token(s, @hyphen_minus)
      }
    )
  end

  defp script_data_escape_start_dash(html, s) do
    script_data(html, s)
  end

  # § tokenizer-script-data-escaped-state

  defp script_data_escaped(<<?-, html::binary>>, s) do
    script_data_escaped_dash(
      html,
      %{s | tokens: append_char_token(s, @hyphen_minus)}
    )
  end

  defp script_data_escaped(<<?<, html::binary>>, s) do
    script_data_escaped_less_than_sign(html, s)
  end

  defp script_data_escaped(<<0, html::binary>>, s) do
    script_data_escaped(html, %{s | tokens: append_char_token(s, @replacement_char)})
  end

  defp script_data_escaped("", s) do
    eof(:script_data_escaped, s)
  end

  defp script_data_escaped(<<c::utf8, html::binary>>, s) do
    script_data_escaped(html, %{s | tokens: append_char_token(s, c)})
  end

  # § tokenizer-script-data-escaped-dash-state

  defp script_data_escaped_dash(<<?-, html::binary>>, s) do
    script_data_escaped_dash_dash(
      html,
      %{
        s
        | tokens: append_char_token(s, @hyphen_minus)
      }
    )
  end

  defp script_data_escaped_dash(<<?<, html::binary>>, s) do
    script_data_escaped_less_than_sign(html, s)
  end

  defp script_data_escaped_dash(<<0, html::binary>>, s) do
    script_data_escaped(html, %{
      s
      | tokens: append_char_token(s, @replacement_char)
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
      | tokens: append_char_token(s, c)
    })
  end

  # § tokenizer-script-data-escaped-dash-dash-state

  defp script_data_escaped_dash_dash(<<?-, html::binary>>, s) do
    script_data_escaped_dash_dash(
      html,
      %{s | tokens: append_char_token(s, @hyphen_minus)}
    )
  end

  defp script_data_escaped_dash_dash(<<?<, html::binary>>, s) do
    script_data_escaped_less_than_sign(html, s)
  end

  defp script_data_escaped_dash_dash(<<?>, html::binary>>, s) do
    script_data(html, %{
      s
      | tokens: append_char_token(s, @greater_than_sign)
    })
  end

  defp script_data_escaped_dash_dash(<<0, html::binary>>, s) do
    script_data_escaped(html, %{
      s
      | tokens: append_char_token(s, @replacement_char)
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
      | tokens: append_char_token(s, <<c::utf8>>)
    })
  end

  # § tokenizer-script-data-escaped-less-than-sign-state

  defp script_data_escaped_less_than_sign(<<?/, html::binary>>, s) do
    script_data_escaped_end_tag_open(html, %{s | buffer: ""})
  end

  defp script_data_escaped_less_than_sign(
         html = <<c, _rest::binary>>,
         s
       )
       when is_lower_letter(c) or is_upper_letter(c) do
    # TODO: revert this after implement the script_data_double_scape_start state
    # script_data_double_escape_start(
    data(
      html,
      %{
        s
        | buffer: "",
          tokens: append_char_token(s, @less_than_sign)
      }
    )
  end

  defp script_data_escaped_less_than_sign(html, s) do
    script_data_escaped(html, %{
      s
      | tokens: append_char_token(s, @less_than_sign)
    })
  end

  # § tokenizer-script-data-escaped-end-tag-open-state

  defp script_data_escaped_end_tag_open(
         html = <<c, _rest::binary>>,
         s
       )
       when is_lower_letter(c) or is_upper_letter(c) do
    script_data_escaped_end_tag_name(
      html,
      %{
        s
        | token: %EndTag{name: ""}
      }
    )
  end

  defp script_data_escaped_end_tag_open(html, s) do
    script_data_escaped(html, %{
      s
      | tokens: append_char_token(s, [@less_than_sign, @solidus])
    })
  end

  # § tokenizer-script-data-double-escape-start-state: re-entrant

  @spec script_data_double_escaped_end_tag_open(binary(), State.t()) :: State.t()
  def script_data_double_escaped_end_tag_open(
        <<c, html::binary>>,
        s
      )
      when c in [@solidus, @greater_than_sign | @space_chars] do
    s = %{s | tokens: append_char_token(s, <<c::utf8>>)}

    if s.buffer && IO.chardata_to_string(s.buffer) == "script" do
      script_data_double_escaped(html, s)
    else
      script_data_escaped(html, s)
    end
  end

  def script_data_double_escaped_end_tag_open(
        <<c, html::binary>>,
        s
      )
      when is_upper_letter(c) do
    script_data_double_escaped_end_tag_open(html, %{
      s
      | buffer: [s.buffer, c + 32],
        tokens: append_char_token(s, c)
    })
  end

  def script_data_double_escaped_end_tag_open(
        <<c, html::binary>>,
        s
      )
      when is_lower_letter(c) do
    script_data_double_escaped_end_tag_open(html, %{
      s
      | buffer: [s.buffer, c],
        tokens: append_char_token(s, c)
    })
  end

  def script_data_double_escaped_end_tag_open(html, s) do
    script_data_escaped(html, s)
  end

  # § tokenizer-script-data-double-escaped-state: re-entrant

  @spec script_data_double_escaped(binary(), State.t()) :: State.t()
  def script_data_double_escaped(<<?-, html::binary>>, s) do
    script_data_double_escaped_dash(html, %{
      s
      | tokens: append_char_token(s, @hyphen_minus)
    })
  end

  def script_data_double_escaped(<<?<, html::binary>>, s) do
    script_data_double_escaped_less_than_sign(html, %{
      s
      | tokens: append_char_token(s, @less_than_sign)
    })
  end

  def script_data_double_escaped(<<0, html::binary>>, s) do
    script_data_double_escaped(html, %{s | tokens: append_char_token(s, @replacement_char)})
  end

  def script_data_double_escaped("", s) do
    eof(:script_data_double_escaped, s)
  end

  def script_data_double_escaped(<<c::utf8, html::binary>>, s) do
    script_data_double_escaped(html, %{s | tokens: append_char_token(s, c)})
  end

  # § tokenizer-script-data-double-escaped-dash-state

  defp script_data_double_escaped_dash(<<?-, html::binary>>, s) do
    script_data_double_escaped_dash_dash(html, %{
      s
      | tokens: append_char_token(s, @hyphen_minus)
    })
  end

  defp script_data_double_escaped_dash(<<?<, html::binary>>, s) do
    script_data_double_escaped_less_than_sign(html, %{
      s
      | tokens: append_char_token(s, @less_than_sign)
    })
  end

  defp script_data_double_escaped_dash(<<0, html::binary>>, s) do
    script_data_double_escaped(html, %{
      s
      | tokens: append_char_token(s, @replacement_char)
    })
  end

  defp script_data_double_escaped_dash("", s) do
    eof(:script_data_double_escaped_dash, s)
  end

  defp script_data_double_escaped_dash(<<c::utf8, html::binary>>, s) do
    script_data_double_escaped(html, %{
      s
      | tokens: append_char_token(s, c)
    })
  end

  # § tokenizer-script-data-double-escaped-dash-dash-state

  defp script_data_double_escaped_dash_dash(<<?-, html::binary>>, s) do
    script_data_double_escaped_dash_dash(html, %{
      s
      | tokens: append_char_token(s, @hyphen_minus)
    })
  end

  defp script_data_double_escaped_dash_dash(<<?<, html::binary>>, s) do
    script_data_double_escaped_less_than_sign(html, %{
      s
      | tokens: append_char_token(s, @less_than_sign)
    })
  end

  defp script_data_double_escaped_dash_dash(<<?>, html::binary>>, s) do
    script_data(html, %{
      s
      | tokens: append_char_token(s, @greater_than_sign)
    })
  end

  defp script_data_double_escaped_dash_dash(
         <<0, html::binary>>,
         s
       ) do
    script_data_double_escaped(html, %{
      s
      | tokens: append_char_token(s, @replacement_char)
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
      | tokens: append_char_token(s, c)
    })
  end

  # § tokenizer-script-data-double-escaped-less-than-sign-state

  defp script_data_double_escaped_less_than_sign(
         <<?/, html::binary>>,
         s
       ) do
    script_data_double_escape_end(html, %{
      s
      | buffer: "",
        tokens: append_char_token(s, @solidus)
    })
  end

  defp script_data_double_escaped_less_than_sign(html, s) do
    script_data_double_escaped(html, s)
  end

  # § tokenizer-script-data-double-escape-end-state

  defp script_data_double_escape_end(
         <<c, html::binary>>,
         s
       )
       when c in [?/, ?> | @space_chars] do
    if IO.chardata_to_string(s.buffer) == "script" do
      script_data_escaped(html, %{s | tokens: append_char_token(s, c)})
    else
      script_data_double_escaped(html, %{s | tokens: append_char_token(s, c)})
    end
  end

  defp script_data_double_escape_end(
         <<c, html::binary>>,
         s
       )
       when is_upper_letter(c) do
    script_data_double_escape_end(html, %{
      s
      | buffer: [s.buffer | [c + 32]],
        tokens: append_char_token(s, c)
    })
  end

  defp script_data_double_escape_end(
         <<c, html::binary>>,
         s
       )
       when is_lower_letter(c) do
    script_data_double_escape_end(html, %{
      s
      | buffer: [s.buffer | [c]],
        tokens: append_char_token(s, c)
    })
  end

  defp script_data_double_escape_end(html, s) do
    script_data_double_escaped(html, s)
  end

  # § tokenizer-before-attribute-name-state

  defp before_attribute_name(<<c, html::binary>>, s)
       when is_space(c) do
    before_attribute_name(html, s)
  end

  defp before_attribute_name(html = <<c, _rest::binary>>, s)
       when c in [?/, ?>] do
    after_attribute_name(html, s)
  end

  defp before_attribute_name("", s) do
    after_attribute_name("", s)
  end

  defp before_attribute_name(<<?=, html::binary>>, s) do
    new_token = %StartTag{
      s.token
      | attributes: [
          %Attribute{name: "=", value: ""} | s.token.attributes
        ]
    }

    attribute_name(html, %{
      s
      | errors: [{:parse_error, nil} | s.errors],
        token: new_token
    })
  end

  defp before_attribute_name(html, s) do
    # NOTE: token here can be a StartTag or EndTag. Attributes on end tags will be ignored.
    new_token = %{
      s.token
      | attributes: [
          %Attribute{name: "", value: ""} | s.token.attributes
        ]
    }

    attribute_name(html, %{
      s
      | token: new_token
    })
  end

  # § tokenizer-attribute-name-state

  defp attribute_name(html = <<c, _rest::binary>>, s)
       when c in [@solidus, @greater_than_sign | @space_chars] do
    # FIXME: before changing the state, verify if same attr already exists.
    after_attribute_name(html, s)
  end

  defp attribute_name("", s) do
    # FIXME: before changing the state, verify if same attr already exists.
    after_attribute_name("", s)
  end

  defp attribute_name(<<?=, html::binary>>, s) do
    # FIXME: before changing the state, verify if same attr already exists.
    before_attribute_value(html, s)
  end

  defp attribute_name(<<c, html::binary>>, s)
       when is_upper_letter(c) do
    [attr | attrs] = s.token.attributes
    new_attr = %Attribute{attr | name: [attr.name | [c + 32]]}
    new_token = %StartTag{s.token | attributes: [new_attr | attrs]}

    attribute_name(html, %{s | token: new_token})
  end

  defp attribute_name(<<0, html::binary>>, s) do
    [attr | attrs] = s.token.attributes
    new_attr = %Attribute{attr | name: [attr.name | [@replacement_char]]}
    new_token = %StartTag{s.token | attributes: [new_attr | attrs]}

    attribute_name(html, %{s | token: new_token})
  end

  defp attribute_name(<<c, html::binary>>, s)
       when c in [?", ?', ?<] do
    [attr | attrs] = s.token.attributes
    new_attr = %Attribute{attr | name: [attr.name | [c]]}
    new_token = %StartTag{s.token | attributes: [new_attr | attrs]}

    attribute_name(html, %{
      s
      | errors: [{:parse_error, nil} | s.errors],
        token: new_token
    })
  end

  defp attribute_name(<<c::utf8, html::binary>>, s) do
    [attr | attrs] = s.token.attributes
    new_attr = %Attribute{attr | name: [attr.name | [c]]}

    # NOTE: token here can be a StartTag or EndTag. Attributes on end tags will be ignored.
    new_token = %{s.token | attributes: [new_attr | attrs]}

    attribute_name(html, %{s | token: new_token})
  end

  # § tokenizer-after-attribute-name-state

  defp after_attribute_name(<<c, html::binary>>, s)
       when is_space(c) do
    after_attribute_name(html, s)
  end

  defp after_attribute_name(<<?/, html::binary>>, s) do
    self_closing_start_tag(html, s)
  end

  defp after_attribute_name(<<?=, html::binary>>, s) do
    before_attribute_value(html, s)
  end

  defp after_attribute_name(<<?>, html::binary>>, s) do
    data(html, %{
      s
      | tokens: [s.emit.(s.token) | s.tokens],
        token: nil
    })
  end

  defp after_attribute_name("", s) do
    eof(:data, %{
      s
      | errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp after_attribute_name(html, s) do
    attribute = %Attribute{name: "", value: ""}
    new_token = %StartTag{s.token | attributes: [attribute | s.token.attributes]}

    attribute_name(html, %{s | token: new_token})
  end

  # § tokenizer-before-attribute-value-state

  defp before_attribute_value(<<c, html::binary>>, s)
       when is_space(c) do
    before_attribute_value(html, s)
  end

  defp before_attribute_value(<<?", html::binary>>, s) do
    attribute_value_double_quoted(html, s)
  end

  defp before_attribute_value(<<?', html::binary>>, s) do
    attribute_value_single_quoted(html, s)
  end

  defp before_attribute_value(html = <<?>, _rest::binary>>, s) do
    attribute_value_unquoted(html, %{
      s
      | errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp before_attribute_value(html, s) do
    attribute_value_unquoted(html, s)
  end

  # § tokenizer-attribute-value-double-quoted-state

  defp attribute_value_double_quoted(<<?", html::binary>>, s) do
    after_attribute_value_quoted(html, s)
  end

  defp attribute_value_double_quoted(<<?&, html::binary>>, s) do
    character_reference(html, %{s | return_state: :attribute_value_double_quoted})
  end

  defp attribute_value_double_quoted(<<0, html::binary>>, s) do
    [attr | attrs] = s.token.attributes
    new_attr = %Attribute{attr | value: [attr.value | [@replacement_char]]}

    attribute_value_double_quoted(html, %{
      s
      | errors: [{:parse_error, nil} | s.errors],
        token: %StartTag{s.token | attributes: [new_attr | attrs]}
    })
  end

  defp attribute_value_double_quoted("", s) do
    eof(:attribute_value_double_quoted, %{
      s
      | errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp attribute_value_double_quoted(<<c::utf8, html::binary>>, s) do
    [attr | attrs] = s.token.attributes
    new_attr = %Attribute{attr | value: [attr.value | [c]]}

    attribute_value_double_quoted(html, %{
      s
      | token: %StartTag{s.token | attributes: [new_attr | attrs]}
    })
  end

  # § tokenizer-attribute-value-single-quoted-state

  defp attribute_value_single_quoted(<<?', html::binary>>, s) do
    after_attribute_value_quoted(html, s)
  end

  defp attribute_value_single_quoted(<<?&, html::binary>>, s) do
    character_reference(html, %{s | return_state: :attribute_value_single_quoted})
  end

  defp attribute_value_single_quoted(<<0, html::binary>>, s) do
    [attr | attrs] = s.token.attributes
    new_attr = %Attribute{attr | value: [attr.value | [@replacement_char]]}

    attribute_value_single_quoted(html, %{
      s
      | errors: [{:parse_error, nil} | s.errors],
        token: %StartTag{s.token | attributes: [new_attr | attrs]}
    })
  end

  defp attribute_value_single_quoted("", s) do
    eof(:attribute_value_single_quoted, %{
      s
      | errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp attribute_value_single_quoted(<<c::utf8, html::binary>>, s) do
    [attr | attrs] = s.token.attributes
    new_attr = %Attribute{attr | value: [attr.value | [c]]}

    # NOTE: token here can be a StartTag or EndTag. Attributes on end tags will be ignored.
    attribute_value_single_quoted(html, %{
      s
      | token: %{s.token | attributes: [new_attr | attrs]}
    })
  end

  # § tokenizer-attribute-value-unquoted-state

  defp attribute_value_unquoted(<<c, html::binary>>, s) when is_space(c) do
    before_attribute_name(html, s)
  end

  defp attribute_value_unquoted(<<?&, html::binary>>, s) do
    character_reference(html, %{s | return_state: :attribute_value_unquoted})
  end

  defp attribute_value_unquoted(<<?>, html::binary>>, s) do
    data(html, %{s | tokens: [s.emit.(s.token) | s.tokens], token: nil})
  end

  defp attribute_value_unquoted(<<0, html::binary>>, s) do
    [attr | attrs] = s.token.attributes
    new_attr = %Attribute{attr | value: [attr.value | [@replacement_char]]}

    attribute_value_unquoted(html, %{
      s
      | errors: [{:parse_error, nil} | s.errors],
        token: %{s.token | attributes: [new_attr | attrs]}
    })
  end

  defp attribute_value_unquoted(<<c, html::binary>>, s)
       when c in [?", ?', ?<, ?=, ?`] do
    [attr | attrs] = s.token.attributes
    new_attr = %Attribute{attr | value: [attr.value | [c]]}

    attribute_value_unquoted(html, %{
      s
      | errors: [{:parse_error, nil} | s.errors],
        token: %{s.token | attributes: [new_attr | attrs]}
    })
  end

  defp attribute_value_unquoted("", s) do
    eof(:attribute_value_unquoted, %{
      s
      | errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp attribute_value_unquoted(<<c::utf8, html::binary>>, s) do
    [attr | attrs] = s.token.attributes
    new_attr = %Attribute{attr | value: [attr.value | [c]]}

    attribute_value_unquoted(html, %{
      s
      | token: %{s.token | attributes: [new_attr | attrs]}
    })
  end

  # § tokenizer-after-attribute-value-quoted-state

  defp after_attribute_value_quoted(<<c, html::binary>>, s)
       when is_space(c) do
    before_attribute_name(html, s)
  end

  defp after_attribute_value_quoted(<<?/, html::binary>>, s) do
    self_closing_start_tag(html, s)
  end

  defp after_attribute_value_quoted(<<?>, html::binary>>, s) do
    data(html, %{s | tokens: [s.emit.(s.token) | s.tokens], token: nil})
  end

  defp after_attribute_value_quoted("", s) do
    eof(:after_attribute_value_quoted, %{
      s
      | errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp after_attribute_value_quoted(html, s) do
    before_attribute_name(html, s)
  end

  # § tokenizer-self-closing-start-tag-state

  defp self_closing_start_tag(<<?>, html::binary>>, s) do
    tag = %StartTag{s.token | self_close: true}
    data(html, %{s | tokens: [tag | s.tokens], token: nil})
  end

  defp self_closing_start_tag("", s) do
    eof(:self_closing_start_tag, %{
      s
      | errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp self_closing_start_tag(html, s) do
    before_attribute_name(html, %{
      s
      | errors: [{:parse_error, nil} | s.errors]
    })
  end

  # § tokenizer-bogus-comment-state

  defp bogus_comment(<<?>, html::binary>>, s) do
    data(html, %{s | tokens: [s.emit.(s.token) | s.tokens], token: nil})
  end

  defp bogus_comment("", s) do
    eof(:bogus_comment, %{s | tokens: [s.emit.(s.token) | s.tokens], token: nil})
  end

  defp bogus_comment(<<0, html::binary>>, s) do
    comment = %Comment{s.token | data: [s.token.data | [@replacement_char]]}

    bogus_comment(html, %{s | token: comment})
  end

  defp bogus_comment(<<c::utf8, html::binary>>, s) do
    comment = %Comment{s.token | data: [s.token.data | [c]]}

    bogus_comment(html, %{s | token: comment})
  end

  # § tokenizer-markup-declaration-open-state

  defp markup_declaration_open(<<"--", html::binary>>, s) do
    token = %Comment{data: ""}

    comment_start(
      html,
      %{s | token: token}
    )
  end

  defp markup_declaration_open(
         <<d, o, c, t, y, p, e, html::binary>>,
         s
       )
       when d in [?D, ?d] and o in [?O, ?o] and c in [?C, ?c] and
              t in [?T, ?t] and y in [?Y, ?y] and
              p in [?P, ?p] and e in [?E, ?e] do
    doctype(html, s)
  end

  # TODO: fix the check for adjusted current node in HTML namespace
  defp markup_declaration_open(<<"[CDATA[", html::binary>>, s = %State{adjusted_current_node: n})
       when not is_nil(n) do
    cdata_section(html, s)
  end

  defp markup_declaration_open(html, s) do
    bogus_comment(html, %{
      s
      | token: %Comment{},
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  # § tokenizer-comment-start-state

  defp comment_start(<<?-, html::binary>>, s) do
    comment_start_dash(html, s)
  end

  defp comment_start(<<?>, html::binary>>, s) do
    data(html, %{
      s
      | tokens: [s.emit.(s.token) | s.tokens],
        token: nil,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp comment_start(html, s) do
    comment(html, s)
  end

  # § tokenizer-comment-start-dash-state

  defp comment_start_dash(<<?-, html::binary>>, s) do
    comment_end(html, s)
  end

  defp comment_start_dash(<<?>, html::binary>>, s) do
    data(html, %{
      s
      | tokens: [s.emit.(s.token) | s.tokens],
        token: nil,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp comment_start_dash("", s) do
    eof(:comment_start_dash, %{
      s
      | errors: [{:parse_error, nil} | s.errors],
        tokens: [s.emit.(s.token) | s.tokens],
        token: nil
    })
  end

  defp comment_start_dash(html, s) do
    new_comment = %Comment{s.token | data: [s.token.data | [@hyphen_minus]]}

    comment(html, %{s | token: new_comment})
  end

  # § tokenizer-comment-state

  defp comment(<<?<, html::binary>>, s) do
    new_comment = %Comment{s.token | data: [s.token.data | [@less_than_sign]]}

    comment_less_than_sign(html, %{s | token: new_comment})
  end

  defp comment(<<?-, html::binary>>, s) do
    comment_end_dash(html, s)
  end

  defp comment(<<0, html::binary>>, s) do
    new_comment = %Comment{s.token | data: [s.token.data | [@replacement_char]]}

    comment(html, %{
      s
      | token: new_comment,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp comment("", s) do
    eof(:comment, %{
      s
      | errors: [{:parse_error, nil} | s.errors],
        tokens: [s.emit.(s.token) | s.tokens],
        token: nil
    })
  end

  defp comment(<<c::utf8, html::binary>>, s) do
    new_token = %Comment{s.token | data: [s.token.data | [c]]}

    comment(
      html,
      %{s | token: new_token}
    )
  end

  # § tokenizer-comment-less-than-sign-state

  defp comment_less_than_sign(<<?!, html::binary>>, s) do
    new_comment = %Comment{s.token | data: [s.token.data | [@exclamation_mark]]}

    comment_less_than_sign_bang(html, %{s | token: new_comment})
  end

  defp comment_less_than_sign(<<?<, html::binary>>, s) do
    new_comment = %Comment{s.token | data: [s.token.data | [@less_than_sign]]}

    comment_less_than_sign(html, %{s | token: new_comment})
  end

  defp comment_less_than_sign(html, s) do
    comment(html, s)
  end

  # § tokenizer-comment-less-than-sign-bang-state

  defp comment_less_than_sign_bang(<<?-, html::binary>>, s) do
    comment_less_than_sign_bang_dash(html, s)
  end

  defp comment_less_than_sign_bang(html, s) do
    comment(html, s)
  end

  # § tokenizer-comment-less-than-sign-bang-dash-state

  defp comment_less_than_sign_bang_dash(<<?-, html::binary>>, s) do
    comment_less_than_sign_bang_dash_dash(html, s)
  end

  defp comment_less_than_sign_bang_dash(html, s) do
    comment_end_dash(html, s)
  end

  # § tokenizer-comment-less-than-sign-bang-dash-dash-state

  defp comment_less_than_sign_bang_dash_dash(html = <<?>, _rest::binary>>, s) do
    comment_end(html, s)
  end

  defp comment_less_than_sign_bang_dash_dash(html = "", s) do
    comment_end(html, s)
  end

  defp comment_less_than_sign_bang_dash_dash(html, s) do
    comment_end(html, %{s | errors: [{:parse_error, nil} | s.errors]})
  end

  # § tokenizer-comment-end-dash-state

  defp comment_end_dash(<<?-, html::binary>>, s) do
    comment_end(html, s)
  end

  defp comment_end_dash("", s) do
    eof(:comment_end_dash, %{
      s
      | tokens: [s.emit.(s.token) | s.tokens],
        token: nil,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp comment_end_dash(html, s) do
    new_comment = %Comment{s.token | data: [s.token.data | [@hyphen_minus]]}

    comment(html, %{s | token: new_comment})
  end

  # § tokenizer-comment-end-state

  defp comment_end(<<?>, html::binary>>, s) do
    data(
      html,
      %{s | tokens: [s.emit.(s.token) | s.tokens], token: nil}
    )
  end

  defp comment_end(<<?!, html::binary>>, s) do
    comment_end_bang(html, s)
  end

  defp comment_end(<<?-, html::binary>>, s) do
    new_comment = %Comment{s.token | data: [s.token.data | [@hyphen_minus]]}

    comment_end(html, %{s | token: new_comment})
  end

  defp comment_end("", s) do
    eof(:comment_end, %{
      s
      | tokens: [s.emit.(s.token) | s.tokens],
        token: nil,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp comment_end(html, s) do
    new_comment = %Comment{s.token | data: [s.token.data | "--"]}

    comment(html, %{s | token: new_comment})
  end

  # § tokenizer-comment-end-bang-state

  defp comment_end_bang(<<?-, html::binary>>, s) do
    new_comment = %Comment{s.token | data: [s.token.data | "--!"]}

    comment_end_dash(html, %{s | token: new_comment})
  end

  defp comment_end_bang(<<?>, html::binary>>, s) do
    data(html, %{
      s
      | tokens: [s.emit.(s.token) | s.tokens],
        token: nil,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp comment_end_bang("", s) do
    eof(:comment_end_bang, %{
      s
      | tokens: [s.emit.(s.token) | s.tokens],
        token: nil,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp comment_end_bang(html, s) do
    new_comment = %Comment{s.token | data: [s.token.data | "--!"]}

    comment(html, %{s | token: new_comment})
  end

  # § tokenizer-doctype-state

  defp doctype(<<c, html::binary>>, s)
       when is_space(c) do
    before_doctype_name(html, s)
  end

  defp doctype("", s) do
    doctype_token = %Doctype{force_quirks: :on}
    eof(:doctype, %{s | tokens: [doctype_token | s.tokens], token: nil})
  end

  defp doctype(html, s) do
    before_doctype_name(html, %{
      s
      | errors: [{:parse_error, nil} | s.errors]
    })
  end

  # § tokenizer-before-doctype-name-state

  defp before_doctype_name(<<c, html::binary>>, s)
       when is_space(c) do
    before_doctype_name(html, s)
  end

  defp before_doctype_name(<<c, html::binary>>, s)
       when is_upper_letter(c) do
    token = %Doctype{name: [c + 32]}

    doctype_name(html, %{s | token: token})
  end

  defp before_doctype_name(<<0, html::binary>>, s) do
    token = %Doctype{
      name: [@replacement_char],
      force_quirks: :on
    }

    doctype_name(html, %{s | token: token})
  end

  defp before_doctype_name(<<?>, html::binary>>, s) do
    token = %Doctype{
      force_quirks: :on
    }

    data(html, %{
      s
      | tokens: [token | s.tokens],
        token: nil,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp before_doctype_name("", s) do
    token = %Doctype{
      force_quirks: :on
    }

    eof(:before_doctype_name, %{
      s
      | tokens: [token | s.tokens],
        token: nil,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp before_doctype_name(<<c::utf8, html::binary>>, s) do
    token = %Doctype{
      name: [c]
    }

    doctype_name(html, %{s | token: token})
  end

  # § tokenizer-doctype-name-state

  defp doctype_name(<<c, html::binary>>, s)
       when is_space(c) do
    after_doctype_name(html, s)
  end

  defp doctype_name(<<?>, html::binary>>, s) do
    data(html, %{
      s
      | tokens: [s.emit.(s.token) | s.tokens],
        token: nil
    })
  end

  defp doctype_name(<<c, html::binary>>, s) when is_upper_letter(c) do
    new_token = %Doctype{
      s.token
      | name: [s.token.name | [c + 32]]
    }

    doctype_name(html, %{s | token: new_token})
  end

  defp doctype_name(<<0, html::binary>>, s) do
    new_token = %Doctype{s.token | name: [s.token.name | [@replacement_char]]}

    doctype_name(html, %{
      s
      | token: new_token,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp doctype_name("", s) do
    new_token = %Doctype{s.token | force_quirks: :on}

    eof(:doctype_name, %{
      s
      | tokens: [new_token | s.tokens],
        token: nil,
        errors: [{:parse_error, "eof-in-doctype"} | s.errors]
    })
  end

  defp doctype_name(<<c::utf8, html::binary>>, s) do
    new_token = %Doctype{s.token | name: [s.token.name | [c]]}

    doctype_name(html, %{s | token: new_token})
  end

  # § tokenizer-after-doctype-name-state

  defp after_doctype_name(<<c, html::binary>>, s)
       when is_space(c) do
    after_doctype_name(html, s)
  end

  defp after_doctype_name(<<?>, html::binary>>, s) do
    data(html, %{
      s
      | tokens: [s.emit.(s.token) | s.tokens],
        token: nil
    })
  end

  defp after_doctype_name("", s) do
    token = %Doctype{s.token | force_quirks: :on}

    eof(:after_doctype_name, %{
      s
      | tokens: [token | s.tokens],
        token: nil,
        errors: [{:parse_error, "eof-in-doctype"} | s.errors]
    })
  end

  defp after_doctype_name(
         <<p, u, b, l, i, c, html::binary>>,
         s
       )
       when p in [?P, ?p] and u in [?U, ?u] and b in [?B, ?b] and
              l in [?L, ?l] and i in [?I, ?i] and
              c in [?C, ?c] do
    after_doctype_public_keyword(html, s)
  end

  defp after_doctype_name(
         <<s1, y, s2, t, e, m, html::binary>>,
         state
       )
       when s1 in [?S, ?s] and y in [?Y, ?y] and
              s2 in [?S, ?s] and t in [?T, ?t] and
              e in [?E, ?e] and m in [?M, ?m] do
    after_doctype_system_keyword(html, state)
  end

  defp after_doctype_name(html, s) do
    token = %Doctype{s.token | force_quirks: :on}

    bogus_doctype(html, %{
      s
      | token: token,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  # § tokenizer-after-doctype-public-keyword-state

  defp after_doctype_public_keyword(<<c, html::binary>>, s)
       when is_space(c) do
    before_doctype_public_identifier(html, s)
  end

  defp after_doctype_public_keyword(<<?", html::binary>>, s) do
    doctype = %Doctype{s.token | public_id: ""}

    doctype_public_identifier_double_quoted(html, %{
      s
      | token: doctype,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp after_doctype_public_keyword(<<?', html::binary>>, s) do
    doctype = %Doctype{s.token | public_id: ""}

    doctype_public_identifier_single_quoted(html, %{
      s
      | token: doctype,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp after_doctype_public_keyword(<<?>, html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    data(html, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp after_doctype_public_keyword("", s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    eof(:after_doctype_public_keyword, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp after_doctype_public_keyword(<<_c::utf8, html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    bogus_doctype(html, %{
      s
      | token: doctype,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  # § tokenizer-before-doctype-public-identifier-state

  defp before_doctype_public_identifier(<<c, html::binary>>, s)
       when is_space(c) do
    before_doctype_public_identifier(html, s)
  end

  defp before_doctype_public_identifier(<<?", html::binary>>, s) do
    doctype = %Doctype{s.token | public_id: ""}

    doctype_public_identifier_double_quoted(html, %{
      s
      | token: doctype,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp before_doctype_public_identifier(<<?', html::binary>>, s) do
    doctype = %Doctype{s.token | public_id: ""}

    doctype_public_identifier_single_quoted(html, %{
      s
      | token: doctype,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp before_doctype_public_identifier(<<?>, html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    data(html, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp before_doctype_public_identifier("", s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    eof(:before_doctype_public_identifier, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp before_doctype_public_identifier(<<_::utf8, html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    bogus_doctype(html, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  # § tokenizer-doctype-public-identifier-double-quoted-state

  defp doctype_public_identifier_double_quoted(<<?", html::binary>>, s) do
    after_doctype_public_identifier(html, s)
  end

  defp doctype_public_identifier_double_quoted(<<0, html::binary>>, s) do
    doctype = %Doctype{s.token | public_id: [s.token.public_id | [@replacement_char]]}

    doctype_public_identifier_double_quoted(html, %{
      s
      | token: doctype,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp doctype_public_identifier_double_quoted(<<?>, html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    data(html, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp doctype_public_identifier_double_quoted("", s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    eof(:doctype_public_identifier_double_quoted, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp doctype_public_identifier_double_quoted(<<c::utf8, html::binary>>, s) do
    doctype = %Doctype{s.token | public_id: [s.token.public_id | [c]]}

    doctype_public_identifier_double_quoted(html, %{s | token: doctype})
  end

  # § tokenizer-doctype-public-identifier-single-quoted-state

  defp doctype_public_identifier_single_quoted(<<?', html::binary>>, s) do
    after_doctype_public_identifier(html, s)
  end

  defp doctype_public_identifier_single_quoted(<<0, html::binary>>, s) do
    doctype = %Doctype{s.token | public_id: [s.token.public_id | [@replacement_char]]}

    doctype_public_identifier_single_quoted(html, %{
      s
      | token: doctype,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp doctype_public_identifier_single_quoted(<<?>, html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    data(html, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp doctype_public_identifier_single_quoted("", s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    eof(:doctype_public_identifier_single_quoted, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp doctype_public_identifier_single_quoted(<<c::utf8, html::binary>>, s) do
    doctype = %Doctype{s.token | public_id: [s.token.public_id | [c]]}

    doctype_public_identifier_single_quoted(html, %{s | token: doctype})
  end

  # § tokenizer-after-doctype-public-identifier-state

  defp after_doctype_public_identifier(<<c, html::binary>>, s) when is_space(c) do
    between_doctype_public_and_system_identifiers(html, s)
  end

  defp after_doctype_public_identifier(<<?>, html::binary>>, s) do
    data(html, %{s | token: nil, tokens: [s.emit.(s.token) | s.tokens]})
  end

  defp after_doctype_public_identifier(<<?", html::binary>>, s) do
    doctype = %Doctype{s.token | system_id: ""}

    doctype_system_identifier_double_quoted(html, %{
      s
      | token: doctype,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp after_doctype_public_identifier(<<?', html::binary>>, s) do
    doctype = %Doctype{s.token | system_id: ""}

    doctype_system_identifier_single_quoted(html, %{
      s
      | token: doctype,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp after_doctype_public_identifier("", s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    eof(:after_doctype_public_identifier, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp after_doctype_public_identifier(<<_c::utf8, html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    bogus_doctype(html, %{
      s
      | token: doctype,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  # § tokenizer-between-doctype-public-and-system-identifiers-state

  defp between_doctype_public_and_system_identifiers(<<c, html::binary>>, s) when is_space(c) do
    between_doctype_public_and_system_identifiers(html, s)
  end

  defp between_doctype_public_and_system_identifiers(<<?>, html::binary>>, s) do
    data(html, %{s | token: nil, tokens: [s.emit.(s.token) | s.tokens]})
  end

  defp between_doctype_public_and_system_identifiers(<<?", html::binary>>, s) do
    doctype = %Doctype{s.token | system_id: ""}

    doctype_system_identifier_double_quoted(html, %{s | token: doctype})
  end

  defp between_doctype_public_and_system_identifiers(<<?', html::binary>>, s) do
    doctype = %Doctype{s.token | system_id: ""}

    doctype_system_identifier_single_quoted(html, %{s | token: doctype})
  end

  defp between_doctype_public_and_system_identifiers("", s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    eof(:between_doctype_public_and_system_identifiers, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp between_doctype_public_and_system_identifiers(<<_c::utf8, html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    bogus_doctype(html, %{
      s
      | token: doctype,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  # § tokenizer-after-doctype-system-keyword-state

  defp after_doctype_system_keyword(<<c, html::binary>>, s) when is_space(c) do
    before_doctype_system_identifier(html, s)
  end

  defp after_doctype_system_keyword(<<?", html::binary>>, s) do
    doctype = %Doctype{s.token | system_id: ""}

    doctype_system_identifier_double_quoted(html, %{
      s
      | token: doctype,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp after_doctype_system_keyword(<<?', html::binary>>, s) do
    doctype = %Doctype{s.token | system_id: ""}

    doctype_system_identifier_single_quoted(html, %{
      s
      | token: doctype,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp after_doctype_system_keyword(<<?>, html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    data(html, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp after_doctype_system_keyword("", s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    eof(:after_doctype_system_keyword, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp after_doctype_system_keyword(<<_c::utf8, html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    bogus_doctype(html, %{
      s
      | token: doctype,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  # § tokenizer-before-doctype-system-identifier-state

  defp before_doctype_system_identifier(<<c, html::binary>>, s) when is_space(c) do
    before_doctype_system_identifier(html, s)
  end

  defp before_doctype_system_identifier(<<?", html::binary>>, s) do
    doctype = %Doctype{s.token | system_id: ""}

    doctype_system_identifier_double_quoted(html, %{
      s
      | token: doctype,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp before_doctype_system_identifier(<<?', html::binary>>, s) do
    doctype = %Doctype{s.token | system_id: ""}

    doctype_system_identifier_single_quoted(html, %{
      s
      | token: doctype,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp before_doctype_system_identifier(<<?>, html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    data(html, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp before_doctype_system_identifier("", s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    eof(:before_doctype_system_identifier, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp before_doctype_system_identifier(<<_::utf8, html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    bogus_doctype(html, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  # § tokenizer-doctype-system-identifier-double-quoted-state

  defp doctype_system_identifier_double_quoted(<<?", html::binary>>, s) do
    after_doctype_system_identifier(html, s)
  end

  defp doctype_system_identifier_double_quoted(<<0, html::binary>>, s) do
    doctype = %Doctype{s.token | system_id: [s.token.system_id | [@replacement_char]]}

    doctype_system_identifier_double_quoted(html, %{
      s
      | token: doctype,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp doctype_system_identifier_double_quoted(<<?>, html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    data(html, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp doctype_system_identifier_double_quoted("", s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    eof(:doctype_system_identifier_double_quoted, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp doctype_system_identifier_double_quoted(<<c::utf8, html::binary>>, s) do
    doctype = %Doctype{s.token | system_id: [s.token.system_id | [c]]}

    doctype_system_identifier_double_quoted(html, %{s | token: doctype})
  end

  # § tokenizer-doctype-system-identifier-single-quoted-state

  defp doctype_system_identifier_single_quoted(<<?', html::binary>>, s) do
    after_doctype_system_identifier(html, s)
  end

  defp doctype_system_identifier_single_quoted(<<0, html::binary>>, s) do
    doctype = %Doctype{s.token | system_id: [s.token.system_id | [@replacement_char]]}

    doctype_system_identifier_single_quoted(html, %{
      s
      | token: doctype,
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp doctype_system_identifier_single_quoted(<<?>, html::binary>>, s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    data(html, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp doctype_system_identifier_single_quoted("", s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    eof(:doctype_system_identifier_single_quoted, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp doctype_system_identifier_single_quoted(<<c::utf8, html::binary>>, s) do
    doctype = %Doctype{s.token | system_id: [s.token.system_id | [c]]}

    doctype_system_identifier_single_quoted(html, %{s | token: doctype})
  end

  # § tokenizer-after-doctype-system-identifier-state

  defp after_doctype_system_identifier(<<c, html::binary>>, s) when is_space(c) do
    after_doctype_system_identifier(html, s)
  end

  defp after_doctype_system_identifier(<<?>, html::binary>>, s) do
    data(html, %{s | token: nil, tokens: [s.emit.(s.token) | s.tokens]})
  end

  defp after_doctype_system_identifier("", s) do
    doctype = %Doctype{s.token | force_quirks: :on}

    eof(:after_doctype_system_identifier, %{
      s
      | token: nil,
        tokens: [doctype | s.tokens],
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  defp after_doctype_system_identifier(<<_c::utf8, html::binary>>, s) do
    bogus_doctype(html, %{
      s
      | token: nil,
        tokens: [s.emit.(s.token) | s.tokens],
        errors: [{:parse_error, nil} | s.errors]
    })
  end

  # § tokenizer-bogus-doctype-state

  defp bogus_doctype(<<?>, html::binary>>, s) do
    data(html, %{s | token: nil, tokens: [s.emit.(s.token) | s.tokens]})
  end

  defp bogus_doctype(<<0, html::binary>>, s) do
    # TODO: set error
    bogus_doctype(html, s)
  end

  defp bogus_doctype("", s) do
    eof(:bogus_doctype, %{s | token: nil, tokens: [s.emit.(s.token) | s.tokens]})
  end

  defp bogus_doctype(<<_c::utf8, html::binary>>, s) do
    bogus_doctype(html, s)
  end

  # § tokenizer-cdata-section-state

  defp cdata_section(<<?], html::binary>>, s) do
    cdata_section_bracket(html, s)
  end

  defp cdata_section("", s) do
    eof(:cdata_section, %{s | errors: [{:parse_error, nil} | s.errors]})
  end

  defp cdata_section(<<c::utf8, html::binary>>, s) do
    cdata_section(html, %{s | tokens: append_char_token(s, c)})
  end

  # § tokenizer-cdata-section-bracket-state

  defp cdata_section_bracket(<<?], html::binary>>, s) do
    cdata_section_end(html, s)
  end

  defp cdata_section_bracket(html, s) do
    cdata_section(html, %{s | tokens: append_char_token(s, ?])})
  end

  # § tokenizer-cdata-section-end-state

  defp cdata_section_end(<<?], html::binary>>, s) do
    cdata_section_end(html, %{s | tokens: append_char_token(s, ?])})
  end

  defp cdata_section_end(<<?>, html::binary>>, s) do
    data(html, s)
  end

  defp cdata_section_end(html, s) do
    cdata_section(html, %{s | tokens: append_char_token(s, [?], ?]])})
  end

  # § tokenizer-character-reference-state

  defp character_reference(<<c, _rest::binary>> = html, s)
       when c in [?<, ?& | @space_chars] do
    character_reference_end(html, %{s | buffer: "&"})
  end

  defp character_reference(<<?#, html::binary>>, s) do
    numeric_character_reference(html, %{s | buffer: ["&" | [?#]]})
  end

  defp character_reference(html, s) do
    seek_charref(html, %{s | buffer: "&", charref_state: %CharrefState{done: false}})
  end

  defp seek_charref(
         <<c, html::binary>>,
         s = %State{charref_state: %CharrefState{done: false}}
       )
       when c == ?; or is_letter(c) or
              is_digit(c) do
    buffer = IO.chardata_to_string([s.buffer | [c]])
    candidate = Floki.Entities.get(buffer)

    charref_state =
      if candidate != [] do
        %CharrefState{s.charref_state | candidate: buffer}
      else
        s.charref_state
      end

    len = charref_state.length + 1
    done_by_length? = len > 60
    done_by_semicolon? = c == ?;

    seek_charref(html, %{
      s
      | buffer: buffer,
        charref_state: %{
          charref_state
          | length: len,
            done: done_by_semicolon? || done_by_length?
        }
    })
  end

  defp seek_charref(html, s) do
    charref_state = %CharrefState{s.charref_state | done: true}

    seek_charref_end(html, %{s | charref_state: charref_state})
  end

  defp seek_charref_end(html, s = %State{return_state: return_state})
       when return_state in [
              :attribute_value_double_quoted,
              :attribute_value_single_quoted,
              :attribute_value_unquoted
            ] do
    last_char =
      s.buffer
      |> IO.chardata_to_string()
      |> String.codepoints()
      |> List.last()

    with true <- last_char != ";",
         <<c, _html::binary>>
         when c == ?= or is_letter(c) or
                is_digit(c) <- html do
      character_reference_end(html, s)
    else
      _ ->
        buffer =
          if s.buffer == s.charref_state.candidate do
            character_buffer(s)
          else
            s.buffer
          end

        character_reference_end(html, %{s | buffer: buffer})
    end
  end

  defp seek_charref_end(html, s) do
    candidate = s.charref_state.candidate

    ends_with_semicolon? = String.ends_with?(s.buffer, ";")

    parse_error_on_unmatch? =
      String.starts_with?(s.buffer, "&") && ends_with_semicolon? && candidate == nil

    parse_error_on_non_semicolon_ending? = !ends_with_semicolon?

    state =
      cond do
        parse_error_on_unmatch? ->
          %{s | errors: [{:parse_error, nil} | s.errors]}

        parse_error_on_non_semicolon_ending? ->
          %{
            s
            | errors: [
                {
                  :parse_error,
                  "missing-semicolon-after-character-reference"
                }
                | s.errors
              ]
          }

        true ->
          s
      end

    buffer = character_buffer(s)
    html = charref_html_after_buffer(html, s)

    character_reference_end(html, %{state | buffer: buffer})
  end

  defp character_buffer(%State{charref_state: %CharrefState{candidate: candidate}, buffer: buffer}) do
    if candidate do
      Floki.Entities.get(candidate)
    else
      buffer
    end
  end

  ## Helper functions that modifies the HTML string.
  # OPTIMIZE: avoid concatenation of string.
  defp charref_html_after_buffer(html, %State{
         charref_state: %CharrefState{candidate: candidate},
         buffer: buffer
       })
       when is_binary(buffer) and is_binary(candidate) do
    String.replace_prefix(buffer, candidate, "") <> html
  end

  defp charref_html_after_buffer(
         html,
         s = %State{
           charref_state: %CharrefState{candidate: candidate}
         }
       )
       when is_binary(candidate) do
    String.replace_prefix(IO.chardata_to_string(s.buffer), candidate, "") <> html
  end

  defp charref_html_after_buffer(html, _), do: html

  # § tokenizer-numeric-character-reference-state

  defp numeric_character_reference(html, s) do
    do_numeric_character_reference(html, %{s | charref_code: 0})
  end

  defp do_numeric_character_reference(<<c, html::binary>>, s)
       when c in [?x, ?X] do
    hexadecimal_character_reference_start(html, %{s | buffer: [s.buffer | [c]]})
  end

  defp do_numeric_character_reference(html, s) do
    decimal_character_reference_start(html, s)
  end

  # § tokenizer-hexadecimal-character-reference-start-state

  defp hexadecimal_character_reference_start(html = <<c, _rest::binary>>, s)
       when is_letter(c) or is_digit(c) do
    hexadecimal_character_reference(html, s)
  end

  defp hexadecimal_character_reference_start(html, s) do
    # set parse error

    character_reference_end(html, s)
  end

  # § tokenizer-decimal-character-reference-start-state

  defp decimal_character_reference_start(html = <<c, _rest::binary>>, s) when is_digit(c) do
    decimal_character_reference(html, s)
  end

  defp decimal_character_reference_start(html, s) do
    # set parse error
    character_reference_end(html, s)
  end

  # § tokenizer-hexadecimal-character-reference-state

  defp hexadecimal_character_reference(<<c, html::binary>>, s) when is_digit(c) do
    hexadecimal_character_reference(html, %{s | charref_code: s.charref_code * 16 + c - 0x30})
  end

  defp hexadecimal_character_reference(<<c, html::binary>>, s) when c in ?A..?F do
    hexadecimal_character_reference(html, %{s | charref_code: s.charref_code * 16 + c - 0x37})
  end

  defp hexadecimal_character_reference(<<c, html::binary>>, s) when c in ?a..?f do
    hexadecimal_character_reference(html, %{s | charref_code: s.charref_code * 16 + c - 0x57})
  end

  defp hexadecimal_character_reference(<<?;, html::binary>>, s) do
    numeric_character_reference_end(html, s)
  end

  defp hexadecimal_character_reference(html, s) do
    # set parse error
    numeric_character_reference_end(html, s)
  end

  # § tokenizer-decimal-character-reference-state

  defp decimal_character_reference(<<c, html::binary>>, s) when is_digit(c) do
    decimal_character_reference(html, %{s | charref_code: s.charref_code * 10 + c - 0x30})
  end

  defp decimal_character_reference(<<?;, html::binary>>, s) do
    numeric_character_reference_end(html, s)
  end

  defp decimal_character_reference(html, s) do
    # set parse error

    numeric_character_reference_end(html, s)
  end

  # § tokenizer-decimal-character-reference-state

  defp numeric_character_reference_end(html, s) do
    # set parse errors
    {:ok, {_, numeric_char}} = Floki.HTML.NumericCharref.to_unicode_number(s.charref_code)

    character_reference_end(html, %{s | buffer: [numeric_char]})
  end

  # § tokenizer-character-reference-end-state

  @spec character_reference_end(binary(), State.t()) :: State.t()
  defp character_reference_end(html, s) do
    state =
      if part_of_attr?(s) do
        [attr | attrs] = s.token.attributes
        new_attr = %Attribute{attr | value: [attr.value | s.buffer]}
        new_tag = %StartTag{s.token | attributes: [new_attr | attrs]}

        %{s | token: new_tag}
      else
        %{s | tokens: append_char_token(s, s.buffer)}
      end

    case state.return_state do
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

  defp part_of_attr?(state) do
    state.return_state in [
      :attribute_value_double_quoted,
      :attribute_value_single_quoted,
      :attribute_value_unquoted
    ]
  end

  defp append_char_token(state, char) do
    case state.tokens do
      [{:char, data} | rest] ->
        if is_binary(char) do
          [state.emit.({:char, [data | char]}) | rest]
        else
          [state.emit.({:char, [data | [char]]}) | rest]
        end

      other_tokens ->
        if is_list(char) || is_binary(char) do
          [state.emit.({:char, char}) | other_tokens]
        else
          [state.emit.({:char, [char]}) | other_tokens]
        end
    end
  end

  defp appropriate_tag?(state) do
    with %StartTag{name: start_tag_name} <- state.last_start_tag,
         %EndTag{name: end_tag_name} <- state.token do
      IO.chardata_to_string(start_tag_name) == IO.chardata_to_string(end_tag_name)
    else
      _ -> false
    end
  end

  defp tokens_for_inappropriate_end_tag(state) do
    [
      state.emit.({:char, state.buffer}),
      state.emit.({:char, [@solidus]}),
      state.emit.({:char, [@less_than_sign]}) | state.tokens
    ]
  end
end
