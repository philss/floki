defmodule Floki.Finder do
  @moduledoc false

  import Floki.Matchers

  def find(html, selector) when is_binary(html) do
    Floki.Parser.parse(html) |> do_find(selector)
  end

  def find(html_tree, selector), do: do_find(html_tree, selector)

  def attribute_values(element, attr_name) when is_tuple(element) do
    attribute_values([element], attr_name)
  end
  def attribute_values(elements, attr_name) do
    values = Enum.reduce elements, [], fn({_, attributes, _}, acc) ->
      case attribute_match?(attributes, attr_name) do
        {_attr_name, value} ->
          [value|acc]
        _ ->
          acc
      end
    end

    Enum.reverse(values)
  end

  defp do_find(html_tree, selector) when is_tuple(selector) do
    {:ok, nodes} = find_by_selector(selector, html_tree, &attr_matcher/3, {:ok, []})
    Enum.reverse(nodes)
  end

  defp do_find(html_tree, selector) do
    tag_attr_val_regex = ~r/(?'tag'.+)\[(?'attr'.+)=(?'val'.+)\]/
    attr_val_regex = ~r/\[(?'attr'.+)=(?'val'.+)\]/

    cond do
      String.contains?(selector, ",") ->
        selectors = String.split(selector, ",")

        Enum.reduce selectors, [], fn(selector, acc) ->
          selector = String.strip(selector)

          nodes = do_find(html_tree, selector)

          unless is_list(nodes), do: nodes = [nodes]

          Enum.concat(acc, nodes)
        end
      String.contains?(selector, "\s") ->
        descendent_selector = String.split(selector)

        Enum.reduce descendent_selector, html_tree, fn(selector, tree) ->
          do_find(tree, selector)
        end
      String.starts_with?(selector, ".") ->
        "." <> class = selector
        {:ok, nodes} = find_by_selector(class, html_tree, &class_matcher/3, {:ok, []})

        Enum.reverse(nodes)
      String.starts_with?(selector, "#") ->
        "#" <> id = selector
        {_status, nodes} = find_by_selector(id, html_tree, &id_matcher/3, {:ok, []})

        List.first(nodes)
      Regex.match?(attr_val_regex, selector) ->
        %{"attr" => attr, "val" => val} = Regex.named_captures(attr_val_regex, selector)
        {:ok, nodes} = find_by_selector({attr, val}, html_tree, &attr_matcher/3, {:ok, []})

        Enum.reverse(nodes)
      Regex.match?(tag_attr_val_regex, selector) ->
        %{"tag" => tag, "attr" => attr, "val" => val} = Regex.named_captures(attr_val_regex, selector)
        {:ok, nodes} = find_by_selector({tag, attr, val}, html_tree, &attr_matcher/3, {:ok, []})

        Enum.reverse(nodes)
      true ->
        {:ok, nodes} = find_by_selector(selector, html_tree, &tag_matcher/3, {:ok, []})

        Enum.reverse(nodes)
    end
  end

  defp find_by_selector(_selector, {}, _, acc), do: acc
  defp find_by_selector(_selector, [], _, acc), do: acc
  defp find_by_selector(_selector, _, _, {:done, nodes}), do: {:done, nodes}
  defp find_by_selector(_selector, tree, _, acc) when is_binary(tree), do: acc
  defp find_by_selector(selector, [h|t], matcher, acc) do
    acc = find_by_selector(selector, h, matcher, acc)
    find_by_selector(selector, t, matcher, acc)
  end
  # Ignore comments
  defp find_by_selector(_selector, {:comment, _comment}, _, acc), do: acc
  # Ignore XML document version
  defp find_by_selector(_selector, {:pi, _xml, _xml_attrs}, _, acc), do: acc
  defp find_by_selector(selector, node, matcher, acc) do
    {_, _, child_node} = node

    acc = matcher.(selector, node, acc)

    find_by_selector(selector, child_node, matcher, acc)
  end
end
