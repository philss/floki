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
  @no_encoder &Function.identity/1

  def raw_html(html_tree, opts) do
    opts = Keyword.validate!(opts, encode: use_default_encoder?(), pretty: false)
    html_tree = List.wrap(html_tree)

    encoder =
      case opts[:encode] do
        true -> @encoder
        false -> @no_encoder
      end

    padding =
      case opts[:pretty] do
        true -> %{pad: "", pad_increase: "  ", depth: 0}
        _ -> :noop
      end

    line_ending =
      if padding == :noop do
        ""
        else
        "\n"
      end

    self_closing_tags = self_closing_tags()

    html_tree
    |> build_raw_html([], encoder, padding, self_closing_tags, line_ending)
    |> Enum.reverse()
    |> IO.iodata_to_binary()
  end

  defp build_raw_html([], acc, _encoder, _padding, _self_closing_tags, _line_ending), do: acc

  defp build_raw_html([string | tail], acc, encoder, padding, self_closing_tags, line_ending)
       when is_binary(string) do
    content = leftpad_content(padding, encoder.(string), line_ending)
    acc = [content | acc]
    build_raw_html(tail, acc, encoder, padding, self_closing_tags, line_ending)
  end

  defp build_raw_html([{:comment, comment} | tail], acc, encoder, padding, self_closing_tags, line_ending) do
    content = [leftpad(padding), "<!--", comment, "-->"]
    acc = [content | acc]
    build_raw_html(tail, acc, encoder, padding, self_closing_tags, line_ending)
  end

  defp build_raw_html([{:pi, tag, attrs} | tail], acc, encoder, padding, self_closing_tags, line_ending) do
    content = [leftpad(padding), "<?", tag, tag_attrs(attrs, encoder), "?>"]
    acc = [content | acc]
    build_raw_html(tail, acc, encoder, padding, self_closing_tags, line_ending)
  end

  defp build_raw_html(
         [{:doctype, type, public, system} | tail],
         acc,
         encoder,
         padding,
         self_closing_tags,
         line_ending
       ) do
    attr =
      case {public, system} do
        {"", ""} -> []
        {"", system} -> [" SYSTEM \"", system | "\""]
        {public, system} -> [" PUBLIC \"", public, "\" \"", system | "\""]
      end

    content = [leftpad(padding), "<!DOCTYPE ", type, attr, ">"]
    acc = [content | acc]
    build_raw_html(tail, acc, encoder, padding, self_closing_tags, line_ending)
  end

  defp build_raw_html([{type, attrs, children} | tail], acc, encoder, padding, self_closing_tags, line_ending) do
    encoder =
      case type do
        "script" -> @no_encoder
        "style" -> @no_encoder
        "title" -> @no_encoder
        _ -> encoder
      end

    open_tag_content = [
      tag_with_attrs(type, attrs, children, padding, encoder, self_closing_tags),
      line_ending
    ]

    acc = [open_tag_content | acc]

    acc =
      case children do
        [] ->
          acc

        _ ->
          children = List.wrap(children)
          build_raw_html(children, acc, encoder, pad_increase(padding), self_closing_tags, line_ending)
      end

    close_tag_content = close_end_tag(type, children, padding, self_closing_tags, line_ending)
    acc = [close_tag_content | acc]
    build_raw_html(tail, acc, encoder, padding, self_closing_tags, line_ending)
  end

  defp tag_attrs(attr_list, encoder) do
    Enum.map(attr_list, &build_attrs(&1, encoder))
  end

  defp tag_with_attrs(type, [], children, padding, _encoder, self_closing_tags),
    do: [leftpad(padding), "<", type | close_open_tag(type, children, self_closing_tags)]

  defp tag_with_attrs(type, attrs, children, padding, encoder, self_closing_tags),
    do: [
      leftpad(padding),
      "<",
      type,
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

  defp close_end_tag(type, [], padding, self_closing_tags, line_ending) do
    if type in self_closing_tags do
      []
    else
      [leftpad(padding), "</", type, ">", line_ending]
    end
  end

  defp close_end_tag(type, _children, padding, _self_closing_tags, line_ending) do
    [leftpad(padding), "</", type, ">", line_ending]
  end

  defp build_attrs({attr, value}, encoder) do
    [?\s, attr, "=\"", encoder.(value) | "\""]
  end

  defp build_attrs(attr, _encoder), do: [?\s, attr]

  defp use_default_encoder? do
    Application.get_env(:floki, :encode_raw_html, true)
  end

  # helpers
  defp leftpad(:noop), do: ""
  defp leftpad(%{pad: pad}), do: pad

  defp leftpad_content(:noop, content, _line_ending), do: content

  defp leftpad_content(padding, content, line_ending) do
    trimmed =
      content
      |> IO.iodata_to_binary()
      |> String.trim()

    if trimmed == "" do
      ""
    else
      [leftpad(padding), trimmed, line_ending]
    end
  end

  defp pad_increase(:noop), do: :noop

  defp pad_increase(padder = %{depth: depth, pad_increase: pad_increase}) do
    depth = depth + 1
    %{padder | depth: depth, pad: String.duplicate(pad_increase, depth)}
  end
end
