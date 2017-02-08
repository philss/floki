defmodule Floki do
  alias Floki.{Finder, HTMLParser, FilterOut, HTMLTree}

  @moduledoc """
  Floki is a simple HTML parser that enables search for nodes using CSS selectors.

  ## Example

  Assuming that you have the following HTML:

  ```html
  <!doctype html>
  <html>
  <body>
    <section id="content">
      <p class="headline">Floki</p>
      <a href="http://github.com/philss/floki">Github page</a>
      <span data-model="user">philss</span>
    </section>
  </body>
  </html>
  ```

  Examples of queries that you can perform:

    * Floki.find(html, "#content")
    * Floki.find(html, ".headline")
    * Floki.find(html, "a")
    * Floki.find(html, "[data-model=user]")
    * Floki.find(html, "#content a")
    * Floki.find(html, ".headline, a")

  Each HTML node is represented by a tuple like:

      {tag_name, attributes, children_nodes}

  Example of node:

      {"p", [{"class", "headline"}], ["Floki"]}

  So even if the only child node is the element text, it is represented
  inside a list.

  You can write a simple HTML crawler (with support of [HTTPoison](https://github.com/edgurgel/httpoison)) with a few lines of code:

      html
      |> Floki.find(".pages a")
      |> Floki.attribute("href")
      |> Enum.map(fn(url) -> HTTPoison.get!(url) end)

  It is simple as that!
  """

  @type html_tree :: tuple | list

  @doc """
  Parses a HTML string.

  ## Examples

      iex> Floki.parse("<div class=js-action>hello world</div>")
      {"div", [{"class", "js-action"}], ["hello world"]}

      iex> Floki.parse("<div>first</div><div>second</div>")
      [{"div", [], ["first"]}, {"div", [], ["second"]}]

  """

  @spec parse(binary) :: html_tree

  def parse(html) do
    HTMLParser.parse(html)
  end

  @self_closing_tags ["area", "base", "br", "col", "command", "embed", "hr", "img", "input", "keygen", "link", "meta", "param", "source", "track", "wbr"]

  @doc """
  Converts HTML tree to raw HTML.
  Note that the resultant HTML may be different from the original one.
  Spaces after tags and doctypes are ignored.

  ## Examples

      iex> Floki.parse(~s(<div class="wrapper">my content</div>)) |> Floki.raw_html
      ~s(<div class="wrapper">my content</div>)

  """

  @spec raw_html(html_tree) :: binary

  def raw_html(html_tree), do: raw_html(html_tree, "")
  defp raw_html([], html), do: html
  defp raw_html(tuple, html) when is_tuple(tuple), do: raw_html([tuple], html)
  defp raw_html([string|tail], html) when is_binary(string), do: raw_html(tail, html <> string)
  defp raw_html([{:comment, comment}|tail], html), do: raw_html(tail, html <> "<!--#{comment}-->")
  defp raw_html([{type, attrs, children}|tail], html) do
    raw_html(tail, html <> tag_for(type, tag_attrs(attrs), children))
  end

  defp tag_attrs(attr_list) do
    attr_list
    |> Enum.reduce("", &build_attrs/2)
    |> String.strip
  end

  defp build_attrs({attr, value}, attrs), do: ~s(#{attrs} #{attr}="#{value}")
  defp build_attrs(attr, attrs), do: "#{attrs} #{attr}"

  defp tag_for(type, attrs, _children) when type in @self_closing_tags do
    case attrs do
      "" -> "<#{type}/>"
      _ -> "<#{type} #{attrs}/>"
    end
  end
  defp tag_for(type, attrs, children) do
    case attrs do
      "" -> "<#{type}>#{raw_html(children)}</#{type}>"
      _ -> "<#{type} #{attrs}>#{raw_html(children)}</#{type}>"
    end
  end

  @doc """
  Find elements inside a HTML tree or string.

  ## Examples

      iex> Floki.find("<p><span class=hint>hello</span></p>", ".hint")
      [{"span", [{"class", "hint"}], ["hello"]}]

      iex> Floki.find("<body><div id=important><div>Content</div></div></body>", "#important")
      [{"div", [{"id", "important"}], [{"div", [], ["Content"]}]}]

      iex> Floki.find("<p><a href='https://google.com'>Google</a></p>", "a")
      [{"a", [{"href", "https://google.com"}], ["Google"]}]

      iex> Floki.find([{ "div", [], [{"a", [{"href", "https://google.com"}], ["Google"]}]}], "div a")
      [{"a", [{"href", "https://google.com"}], ["Google"]}]

  """

  @spec find(binary | html_tree, binary) :: html_tree

  def find(html, selector) when is_binary(html) do
    html_as_tuple = parse(html)

    {tree, results} = Finder.find(html_as_tuple, selector)

    Enum.map(results, fn(html_node) -> HTMLTree.to_tuple(tree, html_node) end)
  end
  def find(html_tree_as_tuple, selector) do
    {tree, results} = Finder.find(html_tree_as_tuple, selector)

    Enum.map(results, fn(html_node) -> HTMLTree.to_tuple(tree, html_node) end)
  end

  def transform(html_tree_list, transformation) when is_list(html_tree_list) do
    Enum.map(html_tree_list, fn(html_tree) ->
      Finder.apply_transformation(html_tree, transformation)
    end)
  end
  def transform(html_tree, transformation) do
    Finder.apply_transformation(html_tree, transformation)
  end

  @doc """
  Returns the text nodes from a HTML tree.
  By default, it will perform a deep search through the HTML tree.
  You can disable deep search with the option `deep` assigned to false.
  You can include content of script tags with the option `js` assigned to true.
  You can specify a separator between nodes content.

  ## Examples

      iex> Floki.text("<div><span>hello</span> world</div>")
      "hello world"

      iex> Floki.text("<div><span>hello</span> world</div>", deep: false)
      " world"

      iex> Floki.text("<div><script>hello</script> world</div>")
      " world"

      iex> Floki.text("<div><script>hello</script> world</div>", js: true)
      "hello world"

      iex> Floki.text("<ul><li>hello</li><li>world</li></ul>", sep: " ")
      "hello world"

      iex> Floki.text([{"div", [], ["hello world"]}])
      "hello world"

      iex> Floki.text([{"p", [], ["1"]},{"p", [], ["2"]}])
      "12"

  """

  @spec text(html_tree | binary) :: binary

  def text(html, opts \\ [deep: true, js: false, sep: ""]) do
    html_tree =
      if is_binary(html) do
        parse(html)
      else
        html
      end

    cleaned_html_tree =
      case opts[:js] do
        true -> html_tree
        _ -> filter_out(html_tree, "script")
      end

    search_strategy =
      case opts[:deep] do
        false -> Floki.FlatText
        _ -> Floki.DeepText
      end

    case opts[:sep] do
      nil -> search_strategy.get(cleaned_html_tree)
      sep -> search_strategy.get(cleaned_html_tree, sep)
    end

  end

  @doc """
  Returns a list with attribute values for a given selector.

  ## Examples

      iex> Floki.attribute("<a href='https://google.com'>Google</a>", "a", "href")
      ["https://google.com"]

      iex> Floki.attribute([{"a", [{"href", "https://google.com"}], ["Google"]}], "a", "href")
      ["https://google.com"]

  """

  @spec attribute(binary | html_tree, binary, binary) :: list

  def attribute(html, selector, attribute_name) do
    html
    |> find(selector)
    |> attribute_values(attribute_name)
  end

  @doc """
  Returns a list with attribute values from elements.

  ## Examples

      iex> Floki.attribute("<a href=https://google.com>Google</a>", "href")
      ["https://google.com"]

      iex> Floki.attribute([{"a", [{"href", "https://google.com"}], ["Google"]}], "href")
      ["https://google.com"]

  """

  @spec attribute(binary | html_tree, binary) :: list

  def attribute(html_tree, attribute_name) when is_binary(html_tree) do
    html_tree
    |> parse
    |> attribute_values(attribute_name)
  end
  def attribute(elements, attribute_name) do
    attribute_values(elements, attribute_name)
  end

  defp attribute_values(element, attr_name) when is_tuple(element) do
    attribute_values([element], attr_name)
  end
  defp attribute_values(elements, attr_name) do
    values = Enum.reduce elements, [], fn({_, attributes, _}, acc) ->
      case attribute_match?(attributes, attr_name) do
        {_attr_name, value} ->
          [value|acc]
        _ ->
          acc
      end
    end

    Enum.reverse(values)
  end

  defp attribute_match?(attributes, attribute_name) do
    Enum.find attributes, fn({attr_name, _}) ->
      attr_name == attribute_name
    end
  end

  @doc """
  Returns the nodes from a HTML tree that don't match the filter selector.

  ## Examples

      iex> Floki.filter_out("<div><script>hello</script> world</div>", "script")
      {"div", [], [" world"]}

      iex> Floki.filter_out([{"body", [], [{"script", [], []},{"div", [], []}]}], "script")
      [{"body", [], [{"div", [], []}]}]

      iex> Floki.filter_out("<div><!-- comment --> text</div>", :comment)
      {"div", [], [" text"]}

  """

  @spec filter_out(binary | html_tree, binary) :: list

  def filter_out(html_tree, selector) when is_binary(html_tree) do
    html_tree
    |> parse
    |> FilterOut.filter_out(selector)
  end
  def filter_out(elements, selector) do
    FilterOut.filter_out(elements, selector)
  end
end
