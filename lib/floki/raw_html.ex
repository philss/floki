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

  @encoder &HtmlEntities.encode/1

  def raw_html(html_tree, options) do
    encoder =
      case Keyword.fetch(options, :encode) do
        {:ok, true} -> @encoder
        {:ok, false} -> & &1
        :error -> default_encoder()
      end

    IO.iodata_to_binary(build_raw_html(html_tree, [], encoder))
  end

  defp build_raw_html([], html, _encoder), do: html

  defp build_raw_html(string, _html, encoder) when is_binary(string), do: encoder.(string)

  defp build_raw_html(tuple, html, encoder) when is_tuple(tuple),
    do: build_raw_html([tuple], html, encoder)

  defp build_raw_html([string | tail], html, encoder) when is_binary(string) do
    build_raw_html(tail, [html | encoder.(string)], encoder)
  end

  defp build_raw_html([{:comment, comment} | tail], html, encoder),
    do: build_raw_html(tail, [html, "<!--", comment | "-->"], encoder)

  defp build_raw_html([{:pi, tag, attrs} | tail], html, encoder) do
    build_raw_html(tail, [html, "<?", tag, " ", tag_attrs(attrs) | "?>"], encoder)
  end

  defp build_raw_html([{:doctype, type, public, system} | tail], html, encoder) do
    attr =
      case {public, system} do
        {"", ""} -> []
        {"", system} -> [" SYSTEM \"", system | "\""]
        {public, system} -> [" PUBLIC \"", public, "\" \"", system | "\""]
      end

    build_raw_html(tail, [html, "<!DOCTYPE ", type, attr | ">"], encoder)
  end

  defp build_raw_html([{type, attrs, children} | tail], html, encoder) do
    build_raw_html(tail, [html | tag_for(type, attrs, children, encoder)], encoder)
  end

  defp tag_attrs(attr_list) do
    map_intersperse(attr_list, ?\s, &build_attrs/1)
  end

  defp tag_with_attrs(type, [], children),
    do: ["<", type | close_open_tag(type, children)]

  defp tag_with_attrs(type, attrs, children),
    do: ["<", type, ?\s, tag_attrs(attrs) | close_open_tag(type, children)]

  defp close_open_tag(type, []) when type in @self_closing_tags, do: "/>"
  defp close_open_tag(_type, _), do: ">"

  defp close_end_tag(type, []) when type in @self_closing_tags, do: ""
  defp close_end_tag(type, _), do: ["</", type, ">"]

  defp build_attrs({attr, value}), do: [attr, "=\"", html_escape(value) | "\""]
  defp build_attrs(attr), do: attr

  defp tag_for(type, attrs, children, encoder) do
    encoder =
      case type do
        "script" -> & &1
        "style" -> & &1
        _ -> encoder
      end

    [
      tag_with_attrs(type, attrs, children),
      build_raw_html(children, "", encoder)
      | close_end_tag(type, children)
    ]
  end

  defp default_encoder do
    if Application.get_env(:floki, :encode_raw_html, true) do
      @encoder
    else
      & &1
    end
  end

  # html_escape
  # Optimized IO data implementation from Plug.HTML

  defp html_escape(data) when is_binary(data), do: html_escape(data, 0, data, [])
  defp html_escape(data), do: html_escape(IO.iodata_to_binary(data))

  escapes = [
    {?<, "&lt;"},
    {?>, "&gt;"},
    {?&, "&amp;"},
    {?", "&quot;"},
    {?', "&#39;"}
  ]

  for {match, insert} <- escapes do
    defp html_escape(<<unquote(match), rest::bits>>, skip, original, acc) do
      html_escape(rest, skip + 1, original, [acc | unquote(insert)])
    end
  end

  defp html_escape(<<_char, rest::bits>>, skip, original, acc) do
    html_escape(rest, skip, original, acc, 1)
  end

  defp html_escape(<<>>, _skip, _original, acc) do
    acc
  end

  for {match, insert} <- escapes do
    defp html_escape(<<unquote(match), rest::bits>>, skip, original, acc, len) do
      part = binary_part(original, skip, len)
      html_escape(rest, skip + len + 1, original, [acc, part | unquote(insert)])
    end
  end

  defp html_escape(<<_char, rest::bits>>, skip, original, acc, len) do
    html_escape(rest, skip, original, acc, len + 1)
  end

  defp html_escape(<<>>, 0, original, _acc, _len) do
    original
  end

  defp html_escape(<<>>, skip, original, acc, len) do
    [acc | binary_part(original, skip, len)]
  end

  # helpers

  # TODO: Use Enum.map_intersperse/3 when we require Elixir v1.10+

  defp map_intersperse([], _, _),
    do: []

  defp map_intersperse([last], _, mapper),
    do: [mapper.(last)]

  defp map_intersperse([head | rest], separator, mapper),
    do: [mapper.(head), separator | map_intersperse(rest, separator, mapper)]
end
