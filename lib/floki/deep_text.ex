defmodule Floki.DeepText do
  @moduledoc false

  # DeepText is a strategy to get text nodes from a HTML tree using a deep search
  # algorithm. It will get all string nodes and concat them.

  @type html_tree :: tuple | list

  @spec get(html_tree, binary) :: binary

  def get(html_tree, sep \\ "") do
    get_text(html_tree, "", sep)
  end

  defp get_text(text, "", _sep) when is_binary(text), do: text
  defp get_text(text, acc, sep) when is_binary(text), do: Enum.join([acc, text], sep)

  defp get_text(nodes, acc, sep) when is_list(nodes) do
    Enum.reduce(nodes, acc, fn child, istr ->
      get_text(child, istr, sep)
    end)
  end

  defp get_text({:comment, _}, acc, _), do: acc
  defp get_text({"br", _, _}, acc, _), do: acc <> "\n"

  defp get_text({_, _, nodes}, acc, sep) do
    get_text(nodes, acc, sep)
  end
end
