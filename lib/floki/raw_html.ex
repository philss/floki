defmodule Floki.RawHTML do
  @moduledoc false

  @default_self_closing_tags [
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
    "menuitem",
    "meta",
    "param",
    "source",
    "track",
    "wbr"
  ]

  def default_self_closing_tags(), do: @default_self_closing_tags

  def self_closing_tags do
    custom_self_closing_tags = Application.get_env(:floki, :self_closing_tags)

    if is_list(custom_self_closing_tags),
      do: custom_self_closing_tags,
      else: @default_self_closing_tags
  end

  @encoder &Floki.Entities.encode/1

  def raw_html(html_tree, options) do
    encoder =
      case Keyword.fetch(options, :encode) do
        {:ok, true} -> @encoder
        {:ok, false} -> &Function.identity/1
        :error -> default_encoder()
      end

    padding =
      case Keyword.fetch(options, :pretty) do
        {:ok, true} -> %{pad: "  ", line_ending: "\n", depth: 0}
        _ -> :noop
      end

    IO.iodata_to_binary(build_raw_html(html_tree, [], encoder, padding))
  end

  defp build_raw_html([], html, _encoder, _padding), do: html

  defp build_raw_html(string, _html, encoder, padding) when is_binary(string) do
    leftpad_content(padding, encoder.(string))
  end

  defp build_raw_html(tuple, html, encoder, padding) when is_tuple(tuple),
    do: build_raw_html([tuple], html, encoder, padding)

  defp build_raw_html([string | tail], html, encoder, padding) when is_binary(string) do
    build_raw_html(tail, [html, leftpad_content(padding, encoder.(string))], encoder, padding)
  end

  defp build_raw_html([{:comment, comment} | tail], html, encoder, padding),
    do: build_raw_html(tail, [html, leftpad(padding), "<!--", comment, "-->"], encoder, padding)

  defp build_raw_html([{:pi, tag, attrs} | tail], html, encoder, padding) do
    build_raw_html(
      tail,
      [html, leftpad(padding), "<?", tag, " ", tag_attrs(attrs, encoder), "?>"],
      encoder,
      padding
    )
  end

  defp build_raw_html([{:doctype, type, public, system} | tail], html, encoder, padding) do
    attr =
      case {public, system} do
        {"", ""} -> []
        {"", system} -> [" SYSTEM \"", system | "\""]
        {public, system} -> [" PUBLIC \"", public, "\" \"", system | "\""]
      end

    build_raw_html(
      tail,
      [html, leftpad(padding), "<!DOCTYPE ", type, attr | ">"],
      encoder,
      padding
    )
  end

  defp build_raw_html([{type, attrs, children} | tail], html, encoder, padding) do
    build_raw_html(
      tail,
      [html | tag_for(type, attrs, children, encoder, padding)],
      encoder,
      padding
    )
  end

  defp tag_attrs(attr_list, encoder) do
    map_intersperse(attr_list, ?\s, &build_attrs(&1, encoder))
  end

  defp tag_with_attrs(type, [], children, padding, _encoder),
    do: [leftpad(padding), "<", type | close_open_tag(type, children)]

  defp tag_with_attrs(type, attrs, children, padding, encoder),
    do: [
      leftpad(padding),
      "<",
      type,
      ?\s,
      tag_attrs(attrs, encoder) | close_open_tag(type, children)
    ]

  defp close_open_tag(type, children) do
    case {type in self_closing_tags(), children} do
      {true, []} -> "/>"
      _ -> ">"
    end
  end

  defp close_end_tag(type, children, padding) do
    case {type in self_closing_tags(), children} do
      {true, []} -> []
      _ -> [leftpad(padding), "</", type, ">", line_ending(padding)]
    end
  end

  defp build_attrs({attr, value}, encoder) do
    if Function.info(encoder) == Function.info(&Function.identity/1) do
      [attr, "=\"", value | "\""]
    else
      [attr, "=\"", html_escape(value) | "\""]
    end
  end

  defp build_attrs(attr, _encoder), do: attr

  defp tag_for(type, attrs, children, encoder, padding) do
    encoder =
      case type do
        "script" -> & &1
        "style" -> & &1
        _ -> encoder
      end

    [
      tag_with_attrs(type, attrs, children, padding, encoder),
      line_ending(padding),
      build_raw_html(children, "", encoder, pad_increase(padding)),
      close_end_tag(type, children, padding)
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

  defp leftpad(:noop), do: ""
  defp leftpad(%{pad: pad, depth: depth}), do: String.duplicate(pad, depth)

  defp leftpad_content(:noop, string), do: string

  defp leftpad_content(padding, string) do
    trimmed = String.trim(string)

    if trimmed == "" do
      ""
    else
      [leftpad(padding), trimmed, line_ending(padding)]
    end
  end

  defp pad_increase(:noop), do: :noop
  defp pad_increase(padder = %{depth: depth}), do: %{padder | depth: depth + 1}

  defp line_ending(:noop), do: ""
  defp line_ending(%{line_ending: line_ending}), do: line_ending
end
