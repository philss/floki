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
        {:ok, true} -> %{pad: "", pad_increase: "  ", line_ending: "\n", depth: 0}
        _ -> :noop
      end

    self_closing_tags = self_closing_tags()

    IO.iodata_to_binary(build_raw_html(html_tree, [], encoder, padding, self_closing_tags))
  end

  defp build_raw_html([], html, _encoder, _padding, _self_closing_tags), do: html

  defp build_raw_html(string, _html, encoder, padding, _self_closing_tags)
       when is_binary(string) do
    leftpad_content(padding, encoder.(string))
  end

  defp build_raw_html(tuple, html, encoder, padding, self_closing_tags) when is_tuple(tuple),
    do: build_raw_html([tuple], html, encoder, padding, self_closing_tags)

  defp build_raw_html([string | tail], html, encoder, padding, self_closing_tags)
       when is_binary(string) do
    build_raw_html(
      tail,
      [html, leftpad_content(padding, encoder.(string))],
      encoder,
      padding,
      self_closing_tags
    )
  end

  defp build_raw_html([{:comment, comment} | tail], html, encoder, padding, self_closing_tags),
    do:
      build_raw_html(
        tail,
        [html, leftpad(padding), "<!--", comment, "-->"],
        encoder,
        padding,
        self_closing_tags
      )

  defp build_raw_html([{:pi, tag, attrs} | tail], html, encoder, padding, self_closing_tags) do
    build_raw_html(
      tail,
      [html, leftpad(padding), "<?", tag, " ", tag_attrs(attrs, encoder), "?>"],
      encoder,
      padding,
      self_closing_tags
    )
  end

  defp build_raw_html(
         [{:doctype, type, public, system} | tail],
         html,
         encoder,
         padding,
         self_closing_tags
       ) do
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
      padding,
      self_closing_tags
    )
  end

  defp build_raw_html([{type, attrs, children} | tail], html, encoder, padding, self_closing_tags) do
    build_raw_html(
      tail,
      [html | tag_for(type, attrs, children, encoder, padding, self_closing_tags)],
      encoder,
      padding,
      self_closing_tags
    )
  end

  defp tag_attrs(attr_list, encoder) do
    map_intersperse(attr_list, ?\s, &build_attrs(&1, encoder))
  end

  defp tag_with_attrs(type, [], children, padding, _encoder, self_closing_tags),
    do: [leftpad(padding), "<", type | close_open_tag(type, children, self_closing_tags)]

  defp tag_with_attrs(type, attrs, children, padding, encoder, self_closing_tags),
    do: [
      leftpad(padding),
      "<",
      type,
      ?\s,
      tag_attrs(attrs, encoder) | close_open_tag(type, children, self_closing_tags)
    ]

  defp close_open_tag(type, [], self_closing_tags) do
    if type in self_closing_tags do
      "/>"
    else
      ">"
    end
  end

  defp close_open_tag(_type, _children, _self_closing_tags), do: ">"

  defp close_end_tag(type, [], padding, self_closing_tags) do
    if type in self_closing_tags do
      []
    else
      [leftpad(padding), "</", type, ">", line_ending(padding)]
    end
  end

  defp close_end_tag(type, _children, padding, _self_closing_tags) do
    [leftpad(padding), "</", type, ">", line_ending(padding)]
  end

  defp build_attrs({attr, value}, encoder) do
    [attr, "=\"", encoder.(value) | "\""]
  end

  defp build_attrs(attr, _encoder), do: attr

  defp tag_for(type, attrs, children, encoder, padding, self_closing_tags) do
    encoder =
      case type do
        "script" -> & &1
        "style" -> & &1
        _ -> encoder
      end

    children_content =
      case children do
        [] -> ""
        _ -> build_raw_html(children, "", encoder, pad_increase(padding), self_closing_tags)
      end

    [
      tag_with_attrs(type, attrs, children, padding, encoder, self_closing_tags),
      line_ending(padding),
      children_content,
      close_end_tag(type, children, padding, self_closing_tags)
    ]
  end

  defp default_encoder do
    if Application.get_env(:floki, :encode_raw_html, true) do
      @encoder
    else
      & &1
    end
  end

  # helpers

  # TODO: Use Enum.map_intersperse/3 when we require Elixir v1.10+

  defp map_intersperse([], _, _),
    do: []

  defp map_intersperse([last], _, mapper),
    do: [mapper.(last)]

  defp map_intersperse([head | rest], separator, mapper),
    do: [mapper.(head), separator | map_intersperse(rest, separator, mapper)]

  defp map_intersperse(%{} = attrs, separator, mapper),
    do: map_intersperse(Map.to_list(attrs), separator, mapper)

  defp leftpad(:noop), do: ""
  defp leftpad(%{pad: pad}), do: pad

  defp leftpad_content(:noop, content), do: content

  defp leftpad_content(padding, content) do
    trimmed =
      content
      |> IO.iodata_to_binary()
      |> String.trim()

    if trimmed == "" do
      ""
    else
      [leftpad(padding), trimmed, line_ending(padding)]
    end
  end

  defp pad_increase(:noop), do: :noop

  defp pad_increase(padder = %{depth: depth, pad_increase: pad_increase}) do
    depth = depth + 1
    %{padder | depth: depth, pad: String.duplicate(pad_increase, depth)}
  end

  defp line_ending(:noop), do: ""
  defp line_ending(%{line_ending: line_ending}), do: line_ending
end
