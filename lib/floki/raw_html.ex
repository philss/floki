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
  @noop ~c""
  @pad_increase 2

  def raw_html(html_tree, opts) do
    opts = Keyword.validate!(opts, encode: use_default_encoder?(), pretty: false)
    html_tree = List.wrap(html_tree)

    encoder =
      case opts[:encode] do
        true -> @encoder
        false -> @no_encoder
      end

    pretty? = opts[:pretty] == true

    pad =
      if pretty? do
        ""
      else
        @noop
      end

    line_ending =
      if pretty? do
        "\n"
      else
        @noop
      end

    self_closing_tags = self_closing_tags()

    html_tree
    |> build_raw_html([], encoder, pad, self_closing_tags, line_ending)
    |> Enum.reverse()
    |> IO.iodata_to_binary()
  end

  defp build_raw_html([], acc, _encoder, _pad, _self_closing_tags, _line_ending), do: acc

  defp build_raw_html([string | tail], acc, encoder, pad, self_closing_tags, line_ending)
       when is_binary(string) do
    content = leftpad_content(pad, encoder.(string), line_ending)
    acc = [content | acc]
    build_raw_html(tail, acc, encoder, pad, self_closing_tags, line_ending)
  end

  defp build_raw_html(
         [{:comment, comment} | tail],
         acc,
         encoder,
         pad,
         self_closing_tags,
         line_ending
       ) do
    content = [pad, "<!--", comment, "-->"]
    acc = [content | acc]
    build_raw_html(tail, acc, encoder, pad, self_closing_tags, line_ending)
  end

  defp build_raw_html(
         [{:pi, tag, attrs} | tail],
         acc,
         encoder,
         pad,
         self_closing_tags,
         line_ending
       ) do
    content = [pad, "<?", tag, tag_attrs(attrs, encoder), "?>"]
    acc = [content | acc]
    build_raw_html(tail, acc, encoder, pad, self_closing_tags, line_ending)
  end

  defp build_raw_html(
         [{:doctype, type, public, system} | tail],
         acc,
         encoder,
         pad,
         self_closing_tags,
         line_ending
       ) do
    attr =
      case {public, system} do
        {"", ""} -> []
        {"", system} -> [" SYSTEM \"", system | "\""]
        {public, system} -> [" PUBLIC \"", public, "\" \"", system | "\""]
      end

    content = [pad, "<!DOCTYPE ", type, attr, ">"]
    acc = [content | acc]
    build_raw_html(tail, acc, encoder, pad, self_closing_tags, line_ending)
  end

  defp build_raw_html(
         [{type, attrs, children} | tail],
         acc,
         encoder,
         pad,
         self_closing_tags,
         line_ending
       ) do
    open_tag_content = [
      tag_with_attrs(type, attrs, children, pad, encoder, self_closing_tags),
      line_ending
    ]

    acc = [open_tag_content | acc]

    acc =
      case children do
        [] ->
          acc

        _ ->
          children = List.wrap(children)

          curr_encoder =
            case type do
              "script" -> @no_encoder
              "style" -> @no_encoder
              "title" -> @no_encoder
              _ -> encoder
            end

          build_raw_html(
            children,
            acc,
            # Need to make sure to pass the encoder for the current node
            curr_encoder,
            pad_increase(pad),
            self_closing_tags,
            line_ending
          )
      end

    close_tag_content = close_end_tag(type, children, pad, self_closing_tags, line_ending)
    acc = [close_tag_content | acc]
    # Return the original encoder here, we don't want to propagate that
    build_raw_html(tail, acc, encoder, pad, self_closing_tags, line_ending)
  end

  defp tag_attrs(attr_list, encoder) do
    Enum.map(attr_list, &build_attrs(&1, encoder))
  end

  defp tag_with_attrs(type, [], children, pad, _encoder, self_closing_tags),
    do: [pad, "<", type | close_open_tag(type, children, self_closing_tags)]

  defp tag_with_attrs(type, attrs, children, pad, encoder, self_closing_tags),
    do: [
      pad,
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

  defp close_end_tag(type, [], pad, self_closing_tags, line_ending) do
    if type in self_closing_tags do
      []
    else
      [pad, "</", type, ">", line_ending]
    end
  end

  defp close_end_tag(type, _children, pad, _self_closing_tags, line_ending) do
    [pad, "</", type, ">", line_ending]
  end

  defp build_attrs({attr, value}, encoder) do
    [?\s, attr, "=\"", encoder.(value) | "\""]
  end

  defp build_attrs(attr, _encoder), do: [?\s, attr]

  defp use_default_encoder? do
    Application.get_env(:floki, :encode_raw_html, true)
  end

  # helpers
  defp leftpad_content(@noop, content, _line_ending), do: content

  defp leftpad_content(pad, content, line_ending) do
    trimmed =
      content
      |> IO.iodata_to_binary()
      |> String.trim()

    if trimmed == "" do
      ""
    else
      [pad, trimmed, line_ending]
    end
  end

  defp pad_increase(@noop), do: @noop

  for depth <- 0..100 do
    @current_pad String.duplicate(" ", depth * @pad_increase)
    @next_pad String.duplicate(" ", depth * @pad_increase + @pad_increase)
    defp pad_increase(@current_pad), do: @next_pad
  end

  defp pad_increase(pad) do
    String.duplicate(" ", byte_size(pad) + @pad_increase)
  end
end
