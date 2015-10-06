defmodule Floki do
  alias Floki.Finder
  alias Floki.Parser

  @moduledoc """
  A HTML parser and seeker.

  This is a simple HTML parser that enables searching using CSS like selectors.

  You can search elements by class, tag name and id.

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

  You can perform the following queries:

    * Floki.find(html, "#content") : returns the section with all children;
    * Floki.find(html, ".headline") : returns a list with the `p` element;
    * Floki.find(html, "a") : returns a list with the `a` element;
    * Floki.find(html, "[data-model=user]") : returns a list with elements that match that data attribute;
    * Floki.find(html, "#content a") # returns all links inside content section;
    * Floki.find(html, ".headline, a") # returns the .headline elements and links.

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
    Parser.parse(html)
  end

  @self_closing_tags ["area", "base", "br", "col", "command", "embed", "hr", "img", "input", "keygen", "link", "mete", "param", "source", "track", "wbr"]

  @doc """
  Converts node tree to raw HTML (spaces are ignored).

  ## Examples

      iex> Floki.parse(~s(<div class="wrapper">my content</div>)) |> Floki.raw_html
      ~s(<div class="wrapper">my content</div>)

  """

  def raw_html(tuple) when is_tuple(tuple), do: raw_html([tuple])
  def raw_html([], html), do: html
  def raw_html([value|tail], html) when is_bitstring(value), do: value
  def raw_html([first_dom|tail], html \\ "") do    
    elem  = first_dom |> elem(0)
    attrs = first_dom |> elem(1) |> tag_attrs
    value = first_dom |> elem(2)
    raw_html(tail, html <> tag_for(elem, attrs, value))
  end

  def tag_attrs(attr_list) do
    attr_list
    |> Enum.reduce("", fn(c,t) -> ~s(#{t} #{elem(c,0)}="#{elem(c,1)}") end)
    |> String.strip
  end

  def tag_for(elem, attrs, value) do
    if Enum.member?(@self_closing_tags, elem) do
      if attrs != "" do
        "<#{elem} #{attrs}/>"
      else
        "<#{elem}/>"
      end
    else
      if attrs != "" do
        "<#{elem} #{attrs}>#{raw_html(value)}</#{elem}>"
      else
        "<#{elem}>#{raw_html(value)}</#{elem}>"
      end
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

  """

  @spec find(binary | html_tree, binary) :: html_tree

  def find(html, selector) when is_binary(html) do
    parse(html) |> Finder.find(selector)
  end
  def find(html_tree, selector) do
    Finder.find(html_tree, selector)
  end

  @doc """
  Returns the text nodes from a HTML tree.
  By default, it will perform a deep search through the HTML tree.
  You can disable deep search with the option `deep` assigned to false.

  ## Examples

      iex> Floki.text("<div><span>hello</span> world</div>")
      "hello world"

      iex> Floki.text("<div><span>hello</span> world</div>", deep: false)
      " world"

  """

  @spec text(html_tree | binary) :: binary

  def text(html, opts \\ [deep: true]) do
    html_tree =
      case is_binary(html) do
        true -> parse(html)
        false -> html
      end

    search_strategy =
      case opts[:deep] do
        true -> Floki.DeepText
        false -> Floki.FlatText
      end

    search_strategy.get(html_tree)
  end

  @doc """
  Returns a list with attribute values for a given selector.

  ## Examples

      iex> Floki.attribute("<a href='https://google.com'>Google</a>", "a", "href")
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
end
