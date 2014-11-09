defmodule Floki do
  def parse(html) do
    :mochiweb_html.parse(html)
  end

  def find(html, selector) when is_binary(html) do
    parse(html)
    |> find(selector)
  end

  def find(html_tree, "." <> class) do
    find_by_selector(class, html_tree, &class_matcher/3, [])
    |> Enum.reverse
  end

  def find(html_tree, "#" <> id) do
    find_by_selector(id, html_tree, &id_matcher/3, [])
    |> List.first
  end

  def find(html_tree, tag_name) do
    find_by_selector(tag_name, html_tree, &tag_matcher/3, [])
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

  defp find_by_selector(_selector, {}, _, acc), do: acc
  defp find_by_selector(_selector, [], _, acc), do: acc
  defp find_by_selector(_selector, tree, _, acc) when is_binary(tree), do: acc
  defp find_by_selector(selector, [h|t], matcher, acc) do
    acc = find_by_selector(selector, h, matcher, acc)
    find_by_selector(selector, t, matcher, acc)
  end
  defp find_by_selector(_selector, { :comment, _comment }, _, acc), do: acc
  defp find_by_selector(selector, node, matcher, acc) when is_tuple(node) do
    { _, _, child_node } = node

    acc = matcher.(selector, node, acc)

    find_by_selector(selector, child_node, matcher, acc)
  end

  defp get_attribute_values(elements, attr_name) do
    Enum.map(elements, fn(el) ->
      { _name, attributes, _childs } = el

      attribute_match?(attributes, attr_name, "")
    end)
    |> Enum.reject(fn(x) -> is_nil(x) end)
    |> Enum.map(fn({_attr_name, value}) -> value end)
  end

  defp class_matcher(selector, node, acc) do
    { _, attributes, _ } = node

    if class_match?(attributes, selector) do
      acc = [node|acc]
    end

    acc
  end

  defp tag_matcher(tag_name, node, acc) do
    { tag, _, _ } = node

    if tag == tag_name do
     acc = [node|acc]
    end

    acc
  end

  defp id_matcher(id, node, acc) do
    { _, attributes, _ } = node

    if attribute_match?(attributes, "id", id) do
      acc = [node|acc]
    end

    acc
  end
end
