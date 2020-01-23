defmodule Floki.Traversal do
  @moduledoc false

  def traverse_and_update(html_node, fun)
  def traverse_and_update([], _fun), do: []
  def traverse_and_update(text, _fun) when is_binary(text), do: text
  def traverse_and_update(xml_tag = {:pi, _, _}, fun), do: fun.(xml_tag)
  def traverse_and_update({:comment, children}, fun), do: fun.({:comment, children})
  def traverse_and_update(doctype = {:doctype, _, _, _}, fun), do: fun.(doctype)

  def traverse_and_update([head | tail], fun) do
    case traverse_and_update(head, fun) do
      nil -> traverse_and_update(tail, fun)
      mapped_head -> [mapped_head | traverse_and_update(tail, fun)]
    end
  end

  def traverse_and_update({elem, attrs, children}, fun) do
    mapped_children = traverse_and_update(children, fun)
    fun.({elem, attrs, mapped_children})
  end

  def traverse_and_update(html_node, acc, fun)
  def traverse_and_update([], acc, _fun), do: {[], acc}
  def traverse_and_update(text, acc, _fun) when is_binary(text), do: {text, acc}
  def traverse_and_update(xml_tag = {:pi, _, _}, acc, fun), do: fun.(xml_tag, acc)
  def traverse_and_update({:comment, children}, acc, fun), do: fun.({:comment, children}, acc)
  def traverse_and_update(doctype = {:doctype, _, _, _}, acc, fun), do: fun.(doctype, acc)

  def traverse_and_update([head | tail], acc, fun) do
    case traverse_and_update(head, acc, fun) do
      {nil, new_acc} ->
        traverse_and_update(tail, new_acc, fun)

      {mapped_head, new_acc} ->
        {mapped_tail, new_acc2} = traverse_and_update(tail, new_acc, fun)
        {[mapped_head | mapped_tail], new_acc2}
    end
  end

  def traverse_and_update({elem, attrs, children}, acc, fun) do
    {mapped_children, new_acc} = traverse_and_update(children, acc, fun)
    fun.({elem, attrs, mapped_children}, new_acc)
  end
end
