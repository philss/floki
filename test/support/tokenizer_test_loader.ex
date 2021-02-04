defmodule TokenizerTestLoader do
  alias Floki.HTML.Tokenizer

  @moduledoc """
  It helps with tests from the tokenizer
  """

  defmodule HTMLTestResult do
    defstruct errors: [], tokens: []
  end

  @doc """
  It transforms the tokens from the tokenizer state into the
  tokens from HTML5lib test file format.
  """
  def tokenization_result(state = %Tokenizer.State{}) do
    output_tokens =
      state.tokens
      |> Enum.map(&transform_token/1)
      |> Enum.reverse()
      |> Enum.reduce([], fn token, tokens ->
        if token do
          [token | tokens]
        else
          tokens
        end
      end)

    output_errors =
      state.errors
      |> Enum.map(fn {:parse_error, id} ->
        %{
          "code" => id
        }
      end)
      |> Enum.reverse()

    %HTMLTestResult{tokens: output_tokens, errors: output_errors}
  end

  defp transform_token(doctype = %Tokenizer.Doctype{}) do
    [
      "DOCTYPE",
      doctype.name && IO.chardata_to_string(doctype.name),
      doctype.public_id && IO.chardata_to_string(doctype.public_id),
      doctype.system_id && IO.chardata_to_string(doctype.system_id),
      doctype.force_quirks == :off
    ]
  end

  defp transform_token(comment = %Tokenizer.Comment{}) do
    [
      "Comment",
      IO.chardata_to_string(comment.data)
    ]
  end

  defp transform_token(tag = %Tokenizer.StartTag{}) do
    list_tag = [
      "StartTag",
      IO.chardata_to_string(tag.name),
      Enum.reduce(tag.attributes, %{}, fn attr, attributes ->
        Map.put(attributes, IO.chardata_to_string(attr.name), IO.chardata_to_string(attr.value))
      end)
    ]

    if tag.self_close do
      list_tag ++ [true]
    else
      list_tag
    end
  end

  defp transform_token(tag = %Tokenizer.EndTag{}) do
    [
      "EndTag",
      IO.chardata_to_string(tag.name)
    ]
  end

  defp transform_token({:char, chars}) do
    [
      "Character",
      IO.chardata_to_string(chars)
    ]
  end

  defp transform_token(:eof), do: nil

  defp transform_token(other), do: other
end
