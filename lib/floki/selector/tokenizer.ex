defmodule Floki.Selector.Tokenizer do
  @moduledoc false

  # It decodes a given selector and returns the tokens that represents it.
  # Check the rules in "src/floki_selector_lexer.xrl"
  def tokenize(selector) do
    char_list =
      selector
      |> String.trim()
      |> String.to_charlist()

    {:ok, token_list, _} = :floki_selector_lexer.string(char_list)

    token_list
  end
end
