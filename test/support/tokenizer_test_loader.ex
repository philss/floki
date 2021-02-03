defmodule TokenizerTestLoader do
  alias Floki.HTML.Tokenizer

  @moduledoc """
  It helps with tests from the tokenizer
  """

  defmacro __using__(_opts) do
    quote do
      ExUnit.Case.register_attribute(__MODULE__, :params, accumulate: true)
      import TokenizerTestLoader, only: [load_tests_from_file: 1]
    end
  end

  @doc """
  Loads tests from a file in the format of HTML5lib-tests.
  It executes the tokenization and match with the expected output.
  """
  defmacro load_tests_from_file(file_name) do
    quote bind_quoted: [file_name: file_name] do
      {:ok, content} = File.read(file_name)
      {:ok, json} = Jason.decode(content)
      tests = Map.get(json, "tests")

      Enum.reduce(tests, MapSet.new(), fn definition, map_set ->
        description = Map.get(definition, "description")

        if !match?("", description) && !MapSet.member?(map_set, description) do
          @params {:input, Map.get(definition, "input")}
          @params {:output, Map.get(definition, "output")}
          @params {:description, description}
          @tag timeout: 200
          test "tokenize/1 #{description}", context do
            result =
              Keyword.get(context.registered.params, :input)
              |> Floki.HTML.Tokenizer.tokenize()
              |> TokenizerTestLoader.tokenization_result()

            output = Keyword.get(context.registered.params, :output)

            assert result.tokens == output
          end
        end

        MapSet.put(map_set, description)
      end)
    end
  end

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
      |> Enum.map(fn error ->
        %{
          "code" => error.id,
          "col" => error.position.col,
          "line" => error.position.line
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

  defp transform_token(%Tokenizer.EOF{}), do: nil

  defp transform_token(other), do: other
end
