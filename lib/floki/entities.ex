defmodule Floki.Entities do
  @moduledoc false

  @doc """
  Decode charrefs and numeric charrefs.

  This is useful if you want to decode any charref. The tokenizer will
  use a different algorithm, so this may not be necessary.
  """
  def decode(charref) when is_binary(charref) do
    case charref do
      <<"&#", numeric::binary>> ->
        case extract_byte_from_num_charref(numeric) do
          {:ok, number} ->
            case Floki.HTML.NumericCharref.to_unicode_number(number) do
              {:ok, {_, unicode_number}} ->
                {:ok, <<unicode_number::utf8>>}

              {:error, {:negative_number, _}} ->
                {:error, :not_found}
            end

          :error ->
            {:error, :not_found}
        end

      <<"&", _::binary>> = binary ->
        case Floki.Entities.Codepoints.get(binary) do
          [] ->
            {:error, :not_found}

          codepoints ->
            {:ok, IO.chardata_to_string(codepoints)}
        end

      _other ->
        {:error, :not_found}
    end
  end

  defp extract_byte_from_num_charref(<<maybe_x, rest::binary>>) when maybe_x in [?x, ?X] do
    with {number, _} <- Integer.parse(rest, 16) do
      {:ok, number}
    end
  end

  defp extract_byte_from_num_charref(binary) when is_binary(binary) do
    with {number, _} <- Integer.parse(binary, 10) do
      {:ok, number}
    end
  end

  @doc """
  Encode HTML entities in a string.

  Currently only encodes the main HTML entities:

  * single quote - ' - is replaced by "&#39;".
  * double quote - " - is replaced by "&quot;".
  * ampersand - & - is replaced by "&amp;".
  * less-than sign - < - is replaced by "&lt;".
  * greater-than sign - > - is replaced by "&gt;".

  All other symbols are going to remain the same.

  Optimized IO data implementation from Plug.HTML
  """
  @spec encode(iodata()) :: iodata()
  def encode(string) when is_binary(string), do: encode(string, 0, string, [])
  def encode(data), do: encode(IO.iodata_to_binary(data))

  escapes = [
    {?<, "&lt;"},
    {?>, "&gt;"},
    {?&, "&amp;"},
    {?", "&quot;"},
    {?', "&#39;"}
  ]

  for {match, insert} <- escapes do
    defp encode(<<unquote(match), rest::bits>>, skip, original, acc) do
      encode(rest, skip + 1, original, [acc | unquote(insert)])
    end
  end

  defp encode(<<_char, rest::bits>>, skip, original, acc) do
    encode(rest, skip, original, acc, 1)
  end

  defp encode(<<>>, _skip, _original, acc) do
    acc
  end

  for {match, insert} <- escapes do
    defp encode(<<unquote(match), rest::bits>>, skip, original, acc, len) do
      part = binary_part(original, skip, len)
      encode(rest, skip + len + 1, original, [acc, part | unquote(insert)])
    end
  end

  defp encode(<<_char, rest::bits>>, skip, original, acc, len) do
    encode(rest, skip, original, acc, len + 1)
  end

  defp encode(<<>>, 0, original, _acc, _len) do
    original
  end

  defp encode(<<>>, skip, original, acc, len) do
    [acc | binary_part(original, skip, len)]
  end
end
