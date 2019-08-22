defmodule Floki.Traversal do
  @moduledoc false

  def traverse_and_update(text, _fun) when is_binary(text), do: text

  def traverse_and_update([head | tail], fun) do
    case traverse_and_update(head, fun) do
      nil -> traverse_and_update(tail, fun)
      mapped_head -> [mapped_head | traverse_and_update(tail, fun)]
    end
  end

  def traverse_and_update([], _fun), do: []

  def traverse_and_update(xml_tag = {:pi, _, _}, fun), do: fun.(xml_tag)

  def traverse_and_update({elem, attrs, children}, fun) do
    mapped_children = traverse_and_update(children, fun)
    fun.({elem, attrs, mapped_children})
  end

  def traverse_and_update({:comment, children}, fun), do: fun.({:comment, children})

  def traverse_and_update(doctype = {:doctype, _, _, _}, fun), do: fun.(doctype)
end
