defmodule Floki.RawHTML do
  @moduledoc false

  @self_closing_tags [
    "area",
    "base",
    "br",
    "col",
    "command",
    "embed",
    "hr",
    "img",
    "input",
    "keygen",
    "link",
    "meta",
    "param",
    "source",
    "track",
    "wbr"
  ]

  def raw_html(html_tree), do: raw_html(html_tree, "")
  defp raw_html([], html), do: html
  defp raw_html(string, _html) when is_binary(string), do: HtmlEntities.encode(string)
  defp raw_html(tuple, html) when is_tuple(tuple), do: raw_html([tuple], html)

  defp raw_html([string | tail], html) when is_binary(string) do
    raw_html(tail, html <> HtmlEntities.encode(string))
  end

  defp raw_html([{:comment, comment} | tail], html),
    do: raw_html(tail, html <> "<!--#{comment}-->")

  defp raw_html([{:pi, "xml", attrs} | tail], html) do
    raw_html(tail, html <> "<?xml " <> tag_attrs(attrs) <> "?>")
  end

  defp raw_html([{:doctype, type, public, system} | tail], html) do
    attr =
      case {public, system} do
        {"", ""} -> ""
        {"", system} -> " SYSTEM \"#{system}\""
        {public, system} -> " PUBLIC \"#{public}\" \"#{system}\""
      end

    raw_html(tail, html <> "<!DOCTYPE #{type}#{attr}>")
  end

  defp raw_html([{type, attrs, children} | tail], html) do
    raw_html(tail, html <> tag_for(type, attrs, children))
  end

  defp tag_attrs(attr_list) do
    attr_list
    |> Enum.reduce("", &build_attrs/2)
    |> String.trim()
  end

  defp tag_with_attrs(type, [], children), do: "<#{type}" <> close_open_tag(type, children)

  defp tag_with_attrs(type, attrs, children) do
    "<#{type} #{tag_attrs(attrs)}" <> close_open_tag(type, children)
  end

  defp close_open_tag(type, []) when type in @self_closing_tags, do: "/>"
  defp close_open_tag(_type, _), do: ">"

  defp close_end_tag(type, []) when type in @self_closing_tags, do: ""
  defp close_end_tag(type, _), do: "</#{type}>"

  defp build_attrs({attr, value}, attrs), do: ~s(#{attrs} #{attr}="#{value}")
  defp build_attrs(attr, attrs), do: "#{attrs} #{attr}"

  defp tag_for(type, attrs, content) when type in ["script", "style"] do
    tag_with_attrs(type, attrs, []) <> Enum.join(content) <> "</#{type}>"
  end

  defp tag_for(type, attrs, children) do
    tag_with_attrs(type, attrs, children) <> raw_html(children) <> close_end_tag(type, children)
  end
end
