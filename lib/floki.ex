defmodule Floki do
  def parse(html) do
    :mochiweb_html.parse(html)
  end

  def find(html, selector) when is_binary(html) do
    parse(html)
    |> find(selector)
  end

  def find(html_tree, "." <> class) do
    find_by_class(class, html_tree, [])
    |> Enum.reverse
  end

  def attribute(html, selector, attribute_name) do
    html
    |> find(selector)
    |> get_attribute_values(attribute_name)
  end

  def attribute(elements, attribute_name) do
    elements
    |> get_attribute_values(attribute_name)
  end

  defp class_match?(attributes, class) do
    attribute_match?(attributes, "class", class)
  end

  defp attribute_match?(attributes, attribute_name, value) do
    Enum.find(attributes, fn(attribute) ->
      { attr_name, attr_value } = attribute

      attr_name == attribute_name && String.contains?(attr_value, value)
    end)
  end

  defp find_by_class(_class, {}, acc), do: acc
  defp find_by_class(_class, [], acc), do: acc
  defp find_by_class(_class, tree, acc) when is_binary(tree), do: acc
  defp find_by_class(class, [h|t], acc) do
    acc = find_by_class(class, h, acc)
    find_by_class(class, t, acc)
  end
  defp find_by_class(_class, { :comment, _comment }, acc), do: acc
  defp find_by_class(class, { name, attributes, child_node }, acc) do
    if class_match?(attributes, class) do
      acc = [{name, attributes, child_node}|acc]
    end

    find_by_class(class, child_node, acc)
  end

  defp get_attribute_values(elements, attr_name) do
    Enum.map(elements, fn(el) ->
      { _name, attributes, _childs } = el

      attribute_match?(attributes, attr_name, "")
    end)
    |> Enum.reject(fn(x) -> is_nil(x) end)
    |> Enum.map(fn({_attr_name, value}) -> value end)
  end
end
