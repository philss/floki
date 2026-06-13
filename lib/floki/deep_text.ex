defmodule Floki.DeepText do
  @moduledoc false

  # DeepText is a strategy to get text nodes from a HTML tree using a deep search
  # algorithm. It will get all string nodes and concat them.

  @type html_tree :: tuple | list

  @spec get(html_tree, binary, boolean) :: binary

  def get(html_tree, sep_or_opts \\ "", include_inputs? \\ false)

  def get(html_tree, opts, _) when is_list(opts) do
    sep = Keyword.get(opts, :sep, "")
    include_inputs? = Keyword.get(opts, :include_inputs, false)
    js? = Keyword.get(opts, :js, false)
    style? = Keyword.get(opts, :style, true)

    html_tree
    |> get_text([], sep, include_inputs?, js?, style?)
    |> IO.iodata_to_binary()
  end

  def get(html_tree, sep, include_inputs?) do
    html_tree
    |> get_text([], sep, include_inputs?, true, true)
    |> IO.iodata_to_binary()
  end

  defp get_text(text, [], _sep, _, _, _) when is_binary(text), do: text
  defp get_text(text, acc, "", _, _, _) when is_binary(text), do: [acc, text]
  defp get_text(text, acc, sep, _, _, _) when is_binary(text), do: [acc, sep, text]

  defp get_text([], acc, _sep, _, _, _), do: acc

  defp get_text([child | rest], acc, sep, include_inputs?, js?, style?) do
    acc = get_text(child, acc, sep, include_inputs?, js?, style?)
    get_text(rest, acc, sep, include_inputs?, js?, style?)
  end

  defp get_text({:comment, _}, acc, _, _, _, _), do: acc
  defp get_text({"br", _, _}, acc, _, _, _, _), do: [acc, "\n"]

  defp get_text({"script", _, _}, acc, _, _, false, _), do: acc
  defp get_text({"style", _, _}, acc, _, _, _, false), do: acc
  defp get_text({:pi, _, _}, acc, _, _, _, _), do: acc
  defp get_text({:doctype, _, _, _}, acc, _, _, _, _), do: acc

  defp get_text({"input", attrs, _}, acc, _, true, _, _) do
    [acc, Floki.TextExtractor.extract_input_value(attrs)]
  end

  defp get_text({"textarea", attrs, _}, acc, _, true, _, _) do
    [acc, Floki.TextExtractor.extract_input_value(attrs)]
  end

  defp get_text({_, _, nodes}, acc, sep, include_inputs?, js?, style?) do
    get_text(nodes, acc, sep, include_inputs?, js?, style?)
  end
end
