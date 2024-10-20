defmodule Floki.CSSEscape do
  @moduledoc false

  # This is a direct translation of
  # https://github.com/mathiasbynens/CSS.escape/blob/master/css.escape.js
  # into Elixir.

  @doc """
  Escapes a string for use as a CSS identifier.

  ## Examples

      iex> Floki.CSSEscape.escape("hello world")
      "hello\\\\ world"

      iex> Floki.CSSEscape.escape("-123")
      "-\\\\31 23"

  """
  @spec escape(String.t()) :: String.t()
  def escape(value) when is_binary(value) do
    value
    |> String.to_charlist()
    |> escape_chars()
    |> IO.iodata_to_binary()
  end

  def escape(_), do: raise(ArgumentError, "CSS.escape requires a string argument")

  defp escape_chars(chars) do
    case chars do
      # If the character is the first character and is a `-` (U+002D), and
      # there is no second character, […]
      [?- | []] -> ["\\-"]
      _ -> do_escape_chars(chars, 0, [])
    end
  end

  defp do_escape_chars([], _, acc), do: Enum.reverse(acc)

  defp do_escape_chars([char | rest], index, acc) do
    escaped =
      cond do
        # If the character is NULL (U+0000), then the REPLACEMENT CHARACTER
        # (U+FFFD).
        char == 0 ->
          <<0xFFFD::utf8>>

        # If the character is in the range [\1-\1F] (U+0001 to U+001F) or is
        # U+007F,
        # if the character is the first character and is in the range [0-9]
        # (U+0030 to U+0039),
        # if the character is the second character and is in the range [0-9]
        # (U+0030 to U+0039) and the first character is a `-` (U+002D),
        char in 0x0001..0x001F or char == 0x007F or
          (index == 0 and char in ?0..?9) or
            (index == 1 and char in ?0..?9 and hd(acc) == "-") ->
          # https://drafts.csswg.org/cssom/#escape-a-character-as-code-point
          ["\\", Integer.to_string(char, 16), " "]

        # If the character is not handled by one of the above rules and is
        # greater than or equal to U+0080, is `-` (U+002D) or `_` (U+005F), or
        # is in one of the ranges [0-9] (U+0030 to U+0039), [A-Z] (U+0041 to
        # U+005A), or [a-z] (U+0061 to U+007A), […]
        char >= 0x0080 or char in [?-, ?_] or char in ?0..?9 or char in ?A..?Z or char in ?a..?z ->
          # the character itself
          <<char::utf8>>

        true ->
          # Otherwise, the escaped character.
          # https://drafts.csswg.org/cssom/#escape-a-character
          ["\\", <<char::utf8>>]
      end

    do_escape_chars(rest, index + 1, [escaped | acc])
  end
end
