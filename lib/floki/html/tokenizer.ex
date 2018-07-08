defmodule Floki.HTML.Tokenizer do
  # It represents the state of tokenization.
  defmodule State do
    defstruct current: :data,
              return_state: nil,
              token: nil,
              tokens: [],
              buffer: "",
              open_tags: [],
              line: 1,
              column: 1
  end

  def tokenize(html) do
    tokenize(html, %State{current: :tag_open})
  end

  defp tokenize(_, %State{tokens: [{:eof, _, _} | tokens]}), do: Enum.reverse(tokens)

  defp tokenize(<<"&", html::binary>>, s = %State{current: state})
       when state in [:data, :rcdata] do
    tokenize(html, %{s | return_state: state, current: :character_reference, column: s.column + 1})
  end

  defp tokenize(<<"<", html::binary>>, s = %State{current: :data}) do
    tokenize(html, %{s | current: :tag_open, column: s.column + 1})
  end

  defp tokenize(<<"\0", html::binary>>, s = %State{current: :data}) do
    tokenize(html, %{s | tokens: [{:character, "\0"} | s.tokens]})
  end

  defp tokenize(<<"", html::binary>>, s = %State{current: :data}) do
    tokenize(html, %{s | tokens: [{:eof, s.column, s.line} | s.tokens]})
  end

  defp tokenize(<<c::bytes-size(1), html::binary>>, s = %State{current: :data}) do
    tokenize(html, %{s | tokens: [{:character, c} | s.tokens]})
  end

  defp tokenize(<<"<", html::binary>>, s = %State{current: :rcdata}) do
    tokenize(html, %{s | current: :rcdata_less_than_sign, column: s.column + 1})
  end

  defp tokenize(<<"\0", html::binary>>, s = %State{current: :rcdata}) do
    tokenize(html, %{s | tokens: [{:character, "\uFFFD"} | s.tokens]})
  end

  defp tokenize(<<"", html::binary>>, s = %State{current: :rcdata}) do
    tokenize(html, %{s | tokens: [{:eof, s.column, s.line} | s.tokens]})
  end

  defp tokenize(<<"<", html::binary>>, s = %State{current: :tag_open}) do
    tokenize(html, %{s | current: :markup_declaration_open, column: s.column + 1})
  end

  defp tokenize(<<c::bytes-size(1), html::binary>>, s = %State{current: :rcdata}) do
    tokenize(html, %{s | tokens: [{:character, c} | s.tokens]})
  end

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

  defp tokenize(<<c::bytes-size(1), html::binary>>, s = %State{current: :comment_start}) do
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

  defp tokenize(<<c::bytes-size(1), html::binary>>, s = %State{current: :comment}) do
    {:comment, comment, l, cl} = s.token
    new_token = {:comment, comment <> c, l, cl}

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

  defp tokenize(<<"", html::binary>>, s = %State{current: :comment_end}) do
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

  defp tokenize(<<c::bytes-size(1), html::binary>>, s = %State{current: :doctype})
       when c in ["\t", "\n", "\f", "\s"] do
    tokenize(html, %{s | current: :before_doctype_name, column: s.column + 1})
  end

  # This is a case of error, when there is no token left. It shouldn't be executed because
  # of the base function that stops the recursion.
  # TODO: implement me, since the problem describe was solved.
  # defp tokenize("", s = %State{current: :doctype}) do
  # end

  defp tokenize(html, s = %State{current: :doctype}) do
    tokenize(html, %{s | current: :before_doctype_name})
  end

  defp tokenize(<<c::bytes-size(1), html::binary>>, s = %State{current: :before_doctype_name})
       when c in ["\t", "\n", "\f", "\s"] do
    tokenize(html, %{s | current: :before_doctype_name, column: s.column + 1})
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

  defp tokenize(<<c::bytes-size(1), html::binary>>, s = %State{current: :before_doctype_name}) do
    token = {:doctype, String.downcase(c), nil, nil, false, s.line, s.column + 1}
    tokenize(html, %{s | current: :doctype_name, token: token, column: s.column + 1})
  end

  defp tokenize(<<c::bytes-size(1), html::binary>>, s = %State{current: :doctype_name})
       when c in ["\t", "\n", "\f", "\s"] do
    tokenize(html, %{s | current: :after_doctype_name, column: s.column + 1})
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
    new_token = put_elem(s.token, 1, name <> "\uFFFD") |> put_elem(6, column + 1)
    tokenize(html, %{s | current: :doctype_name, token: new_token, column: s.column + 1})
  end

  defp tokenize(<<c::bytes-size(1), html::binary>>, s = %State{current: :doctype_name}) do
    {:doctype, name, _, _, _, _, column} = s.token
    new_token = put_elem(s.token, 1, name <> String.downcase(c)) |> put_elem(6, column + 1)
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

  defp tokenize(<<c::bytes-size(1), html::binary>>, s = %State{current: :after_doctype_name})
       when c in ["\t", "\n", "\f", "\s"] do
    tokenize(html, %{s | current: :after_doctype_name, column: s.column + 1})
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
end
