defmodule Floki.Matchers do
  @moduledoc false

  def attr_matcher({attr, value}, node, acc) do
    {_, attributes, _} = node
    {:ok, acc_nodes} = acc

    if attribute_match?(attributes, attr, value) do
      acc = {:ok, [node|acc_nodes]}
    end

    acc
  end

  def attr_matcher({tag_name, attr, value}, node, acc) do
    {tag, attributes, _} = node
    {:ok, acc_nodes} = acc

    if tag == tag_name and attribute_match?(attributes, attr, value) do
      acc = {:ok, [node|acc_nodes]}
    end

    acc
  end

  def class_matcher(class_name, node, acc) do
    {_, attributes, _} = node
    {:ok, acc_nodes} = acc

    if attribute_match?(attributes, "class", class_name) do
      acc = {:ok, [node|acc_nodes]}
    end

    acc
  end

  def tag_matcher(tag_name, node, acc) do
    {tag, _, _} = node
    {:ok, acc_nodes} = acc

    if tag == tag_name do
      acc = {:ok, [node|acc_nodes]}
    end

    acc
  end

  def id_matcher(id, node, acc) do
    {_, attributes, _} = node
    {:ok, acc_nodes} = acc

    if attribute_match?(attributes, "id", id) do
      acc = {:done, [node|acc_nodes]}
    end

    acc
  end

  def value_match?(attribute_value, selector_value) do
    selector_values = String.split(selector_value, ~r/[#.]/)

    if length(selector_values) == 1 do
      attribute_value
      |> String.split
      |> Enum.any?(fn(x) -> x == selector_value end)
    else
      attribute_value
      |> String.split
      |> Enum.all?(fn(x) ->
        Enum.find(selector_values, fn(y) -> y == x end)
      end)
    end
  end

  def attribute_match?(attributes, attribute_name) do
    Enum.find attributes, fn({attr_name, _}) ->
      attr_name == attribute_name
    end
  end

  def attribute_match?(attributes, attribute_name, selector_value) do
    Enum.find attributes, fn(attribute) ->
      {attr_name, attr_value} = attribute

      attr_name == attribute_name && value_match?(attr_value, selector_value)
    end
  end
end
