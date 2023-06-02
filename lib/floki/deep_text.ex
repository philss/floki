defmodule Floki.DeepText do
  @moduledoc false

  # DeepText is a strategy to get text nodes from a HTML tree using a deep search
  # algorithm. It will get all string nodes and concat them.

  @type html_tree :: tuple | list

  @spec get(html_tree, binary, boolean) :: binary

  def get(html_tree, sep \\ "", include_inputs? \\ false)

  def get(html_tree, sep, include_inputs?) do
    html_tree
    |> get_text([], sep, include_inputs?)
    |> IO.iodata_to_binary()
  end

  defp get_text(text, [], _sep, _) when is_binary(text), do: text
  defp get_text(text, acc, sep, _) when is_binary(text), do: [acc, sep, text]

  defp get_text(nodes, acc, sep, include_inputs?) when is_list(nodes) do
    Enum.reduce(nodes, acc, fn child, istr ->
      get_text(child, istr, sep, include_inputs?)
    end)
  end

  defp get_text({:comment, _}, acc, _, _), do: acc
  defp get_text({"br", _, _}, acc, _, _), do: [acc, "\n"]

  defp get_text({"input", attrs, _}, acc, _, true) do
    [acc, Floki.TextExtractor.extract_input_value(attrs)]
  end

  defp get_text({"textarea", attrs, _}, acc, _, true) do
    [acc, Floki.TextExtractor.extract_input_value(attrs)]
  end

  defp get_text({_, _, nodes}, acc, sep, include_inputs?) do
    get_text(nodes, acc, sep, include_inputs?)
  end
end
