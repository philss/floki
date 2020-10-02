defmodule Floki.FilterOut do
  @moduledoc false

  # Helper functions for filtering out a specific element from the tree.

  @type selector :: :comment | :text | Floki.css_selector()

  def filter_out(html_tree_or_node, type) when type in [:text, :comment] do
    mapper(html_tree_or_node, type)
  end

  def filter_out(html_tree, selector) when is_list(html_tree) do
    Floki.find_and_update(html_tree, selector, fn
      {_tag, _attrs} -> :delete
      other -> other
    end)
  end

  def filter_out(html_node, selector) do
    [html_node]
    |> Floki.find_and_update(selector, fn
      {_tag, _attrs} -> :delete
      other -> other
    end)
    |> List.first() || []
  end

  defp filter({nodetext, _, _}, selector) when nodetext === selector, do: false
  defp filter({nodetext, _}, selector) when nodetext === selector, do: false
  defp filter(text, :text) when is_binary(text), do: false
  defp filter(_, _), do: true

  defp mapper(nodes, selector) when is_list(nodes) do
    nodes
    |> Stream.filter(&filter(&1, selector))
    |> Stream.map(&mapper(&1, selector))
    |> Enum.to_list()
  end

  defp mapper({nodetext, x, y}, selector) do
    {nodetext, x, mapper(y, selector)}
  end

  defp mapper(nodetext, _), do: nodetext
end
