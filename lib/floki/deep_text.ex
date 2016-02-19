defmodule Floki.DeepText do
  @moduledoc """
  DeepText is a strategy to get text nodes from a HTML tree using a deep search
  algorithm. It will get all string nodes and concat them.
  """

  @type html_tree :: tuple | list

  @spec get(html_tree) :: binary

  @doc """
  Get text nodes from a deep tree of HTML nodes.


  ## Examples

      iex> Floki.DeepText.get([{"a", [], ["The meaning of life is...", {"strong", [], ["something else"]}] }])
      "The meaning of life is...something else"

  """
  def get(html_tree) do
    get_text(html_tree, "")
  end

  defp get_text(text, acc) when is_binary(text), do: acc <> text
  defp get_text(nodes, acc) when is_list(nodes) do
    Enum.reduce nodes, acc, fn(child, istr) ->
      get_text(child, istr)
    end
  end
  defp get_text({:comment, _}, acc), do: acc
  defp get_text({"br", _, _}, acc), do: acc <> "\n"
  defp get_text({_, _, nodes}, acc) do
    get_text(nodes, acc)
  end
end
