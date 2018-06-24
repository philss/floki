defmodule Floki.HTML.Tokenizer do
  defmodule Position do
    defstruct line: 1, column: 1
  end

  defmodule State do
    defstruct current: :data, token: nil, tokens: [], buffer: ""
  end

  def tokenize(html) do
    tokenize(html, %State{current: :tag_open}, %Position{})
  end

  defp tokenize("", %State{tokens: tokens}, _), do: Enum.reverse(tokens)

  defp tokenize(<<"<", html::binary>>, s = %State{current: :tag_open}, position) do
    tokenize(html, %{s | current: :markup_declaration_open}, col(position, 1))
  end

  defp tokenize(<<"!", html::binary>>, s = %State{current: :markup_declaration_open}, p) do
    case html do
      <<"--", rest::binary>> ->
        tokenize(
          rest,
          %State{current: :comment_start, token: {:comment, "", p.line, p.column}},
          col(p, 3)
        )

      _ ->
        tokenize(html, s, p)
    end
  end

  defp tokenize(<<"-", html::binary>>, s = %State{current: :comment_start}, p) do
    tokenize(html, %{s | current: :comment_start_dash}, col(p, 1))
  end

  defp tokenize(<<c::bytes-size(1), html::binary>>, s = %State{current: :comment_start}, p) do
    {:comment, comment, _, _} = s.token
    new_token = comment <> c

    tokenize(
      html,
      %{s | current: :comment, token: {:comment, new_token, p.line, p.column}},
      col(p, 1)
    )
  end

  defp tokenize(<<"-", html::binary>>, s = %State{current: :comment}, p) do
    tokenize(html, %{s | current: :comment_end_dash}, col(p, 1))
  end

  defp tokenize(<<c::bytes-size(1), html::binary>>, s = %State{current: :comment}, p) do
    {:comment, comment, l, cl} = s.token
    new_token = comment <> c

    tokenize(
      html,
      %{s | current: :comment, token: {:comment, new_token, l, cl}},
      col(p, 1)
    )
  end

  defp tokenize(<<"-", html::binary>>, s = %State{current: :comment_start_dash}, p) do
    tokenize(html, %{s | current: :comment_end}, col(p, 1))
  end

  defp tokenize(<<"-", html::binary>>, s = %State{current: :comment_end_dash}, p) do
    tokenize(html, %{s | current: :comment_end}, col(p, 1))
  end

  defp tokenize(<<">", html::binary>>, s = %State{current: :comment_end}, p) do
    tokenize(
      html,
      %{s | current: :data, tokens: [s.token | s.tokens], token: nil},
      col(p, 1)
    )
  end

  defp col(position, columns) do
    %{position | column: position.column + columns}
  end
end
