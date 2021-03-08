defmodule Floki.Traversal do
  @moduledoc false

  def traverse_and_update(html_node, fun) do
    html_node
    |> traverse_and_update([], fn element, acc -> {fun.(element), acc} end)
    |> elem(0)
  end

  def traverse_and_update(html_node, acc, fun)
  def traverse_and_update([], acc, _fun), do: {[], acc}
  def traverse_and_update(text, acc, _fun) when is_binary(text), do: {text, acc}
  def traverse_and_update({:pi, _, _} = xml_tag, acc, fun), do: fun.(xml_tag, acc)
  def traverse_and_update({:comment, _children} = comment, acc, fun), do: fun.(comment, acc)
  def traverse_and_update({:doctype, _, _, _} = doctype, acc, fun), do: fun.(doctype, acc)

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
