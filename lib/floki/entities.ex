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

  All other simbols are going to remain the same.
  """
  @spec encode(String.t()) :: String.t()
  def encode(string) when is_binary(string) do
    String.replace(string, ["'", "\"", "&", "<", ">"], fn
      "'" -> "&#39;"
      "\"" -> "&quot;"
      "&" -> "&amp;"
      "<" -> "&lt;"
      ">" -> "&gt;"
    end)
  end
end
