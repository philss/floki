defmodule Floki do
  alias Floki.{Finder, FilterOut, HTMLTree}

  require Logger

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

  To parse this, you can use the function `Floki.parse_document/1`:

  ```elixir
  {:ok, html} = Floki.parse_document(doc)
  # =>
  # [{"html", [],
  #   [
  #     {"body", [],
  #      [
  #        {"section", [{"id", "content"}],
  #         [
  #           {"p", [{"class", "headline"}], ["Floki"]},
  #           {"a", [{"href", "http://github.com/philss/floki"}], ["Github page"]},
  #           {"span", [{"data-model", "user"}], ["philss"]}
  #         ]}
  #      ]}
  #   ]}]
  ```

  With this document you can perform queries such as:

    * `Floki.find(html, "#content")`
    * `Floki.find(html, ".headline")`
    * `Floki.find(html, "a")`
    * `Floki.find(html, "[data-model=user]")`
    * `Floki.find(html, "#content a")`
    * `Floki.find(html, ".headline, a")`

  Each HTML node is represented by a tuple like:

      {tag_name, attributes, children_nodes}

  Example of node:

      {"p", [{"class", "headline"}], ["Floki"]}

  So even if the only child node is the element text, it is represented
  inside a list.
  """

  @type html_attribute :: {String.t(), String.t()}
  @type html_attributes :: [html_attribute()] | html_attributes_map()
  @type html_attributes_map :: %{String.t() => String.t()}
  @type html_declaration :: {:pi, String.t(), html_attributes()}
  @type html_comment :: {:comment, String.t()}
  @type html_doctype :: {:doctype, String.t(), String.t(), String.t()}
  @type html_text :: String.t()
  @type html_tag :: {String.t(), html_attributes(), [html_node()]}
  @type html_node ::
          html_tag() | html_comment() | html_doctype() | html_declaration() | html_text()
  @type html_tree :: [html_node()]

  @type css_selector :: String.t() | %Floki.Selector{} | [%Floki.Selector{}]

  defguard is_html_node(value)
           when is_binary(value) or tuple_size(value) == 3 or
                  (tuple_size(value) == 2 and elem(value, 0) in [:pi, :comment]) or
                  (tuple_size(value) == 4 and elem(value, 0) == :doctype)

  @doc """
  Parses a HTML Document from a String.

  The expect string is a valid HTML, but the parser will try
  to parse even with errors.
  """

  @spec parse(binary()) :: html_tag() | html_tree() | String.t()

  @deprecated "Use `parse_document/1` or `parse_fragment/1` instead."
  def parse(html) do
    with {:ok, document} <- Floki.HTMLParser.parse_document(html) do
      if length(document) == 1 do
        hd(document)
      else
        document
      end
    end
  end

  @doc """
  Parses an HTML document from a string.

  This is the main function to get a tree from an HTML string.

  ## Options

    * `:attributes_as_maps` - Change the behaviour of the parser to return the attributes
      as maps, instead of a list of `{"key", "value"}`. Default to `false`.

    * `:html_parser` - The module of the backend that is responsible for parsing
      the HTML string. By default it is set to the built-in parser, and the module
      name is equal to `Floki.HTMLParser.Mochiweb`, or from the value of the
      application env of the same name.

      See https://github.com/philss/floki#alternative-html-parsers for more details.

    * `:parser_args` - A list of options to the parser. This can be used to pass options
      that are specific for a given parser. Defaults to an empty list.

  ## Examples

      iex> Floki.parse_document("<html><head></head><body>hello</body></html>")
      {:ok, [{"html", [], [{"head", [], []}, {"body", [], ["hello"]}]}]}

      iex> Floki.parse_document("<html><head></head><body>hello</body></html>", html_parser: Floki.HTMLParser.Mochiweb)
      {:ok, [{"html", [], [{"head", [], []}, {"body", [], ["hello"]}]}]}

      iex> Floki.parse_document(
      ...>   "<html><head></head><body class=main>hello</body></html>",
      ...>   attributes_as_maps: true,
      ...>   html_parser: Floki.HTMLParser.Mochiweb
      ...>)
      {:ok, [{"html", %{}, [{"head", %{}, []}, {"body", %{"class" => "main"}, ["hello"]}]}]}

  """

  @spec parse_document(binary(), Keyword.t()) :: {:ok, html_tree()} | {:error, String.t()}

  defdelegate parse_document(document, opts \\ []), to: Floki.HTMLParser

  @doc """
  Parses a HTML Document from a string.

  Similar to `Floki.parse_document/1`, but raises `Floki.ParseError` if there was an
  error parsing the document.

  ## Example

      iex> Floki.parse_document!("<html><head></head><body>hello</body></html>")
      [{"html", [], [{"head", [], []}, {"body", [], ["hello"]}]}]

  """

  @spec parse_document!(binary(), Keyword.t()) :: html_tree()

  def parse_document!(document, opts \\ []) do
    case parse_document(document, opts) do
      {:ok, parsed_document} -> parsed_document
      {:error, message} -> raise Floki.ParseError, message: message
    end
  end

  @doc """
  Parses an HTML fragment from a string.

  This is mostly for parsing sections of an HTML document.

  ## Options

    * `:attributes_as_maps` - Change the behaviour of the parser to return the attributes
      as maps, instead of a list of `{"key", "value"}`. Remember that maps are no longer
      ordered since OTP 26. Default to `false`.

    * `:html_parser` - The module of the backend that is responsible for parsing
      the HTML string. By default it is set to the built-in parser, and the module
      name is equal to `Floki.HTMLParser.Mochiweb`, or from the value of the
      application env of the same name.

      See https://github.com/philss/floki#alternative-html-parsers for more details.

    * `:parser_args` - A list of options to the parser. This can be used to pass options
      that are specific for a given parser. Defaults to an empty list.

  """

  @spec parse_fragment(binary(), Keyword.t()) :: {:ok, html_tree()} | {:error, String.t()}

  defdelegate parse_fragment(fragment, opts \\ []), to: Floki.HTMLParser

  @doc """
  Parses a HTML fragment from a string.

  Similar to `Floki.parse_fragment/1`, but raises `Floki.ParseError` if there was an
  error parsing the fragment.
  """

  @spec parse_fragment!(binary(), Keyword.t()) :: html_tree()

  def parse_fragment!(fragment, opts \\ []) do
    case parse_fragment(fragment, opts) do
      {:ok, parsed_fragment} -> parsed_fragment
      {:error, message} -> raise Floki.ParseError, message: message
    end
  end

  @doc """
  Converts HTML tree to raw HTML.

  Note that the resultant HTML may be different from the original one.
  Spaces after tags and doctypes are ignored.

  ## Options

    * `:encode` - A boolean option to control if special HTML characters
    should be encoded as HTML entities. Defaults to `true`.

    You can also control the encoding behaviour at the application level via
    `config :floki, :encode_raw_html, false`

    * `:pretty` - Controls if the output should be formatted, ignoring
    breaklines and spaces from the input and putting new ones in order
    to pretty format the html. Defaults to `false`.

  ## Examples

      iex> Floki.raw_html({"div", [{"class", "wrapper"}], ["my content"]})
      ~s(<div class="wrapper">my content</div>)

      iex> Floki.raw_html({"div", [{"class", "wrapper"}], ["10 > 5"]})
      ~s(<div class="wrapper">10 &gt; 5</div>)

      iex> Floki.raw_html({"div", [{"class", "wrapper"}], ["10 > 5"]}, encode: false)
      ~s(<div class="wrapper">10 > 5</div>)

      iex> Floki.raw_html({"div", [], ["\\n   ", {"span", [], "Fully indented"}, "    \\n"]}, pretty: true)
      \"\"\"
      <div>
        <span>
          Fully indented
        </span>
      </div>
      \"\"\"
  """

  @spec raw_html(html_tree | binary, keyword) :: binary

  defdelegate raw_html(html_tree, options \\ []), to: Floki.RawHTML

  @doc """
  Find elements inside an HTML tree or string.

  ## Examples

      iex> {:ok, html} = Floki.parse_fragment("<p><span class=hint>hello</span></p>")
      iex> Floki.find(html, ".hint")
      [{"span", [{"class", "hint"}], ["hello"]}]

      iex> {:ok, html} = Floki.parse_fragment("<div id=important><div>Content</div></div>")
      iex> Floki.find(html, "#important")
      [{"div", [{"id", "important"}], [{"div", [], ["Content"]}]}]

      iex> {:ok, html} = Floki.parse_fragment("<p><a href='https://google.com'>Google</a></p>")
      iex> Floki.find(html, "a")
      [{"a", [{"href", "https://google.com"}], ["Google"]}]

      iex> Floki.find([{ "div", [], [{"a", [{"href", "https://google.com"}], ["Google"]}]}], "div a")
      [{"a", [{"href", "https://google.com"}], ["Google"]}]

  """

  @spec find(binary() | html_tree() | html_node(), css_selector()) :: html_tree
  def find(html, selector) when is_binary(html) do
    Logger.info(
      "deprecation: parse the HTML with parse_document or parse_fragment before using find/2"
    )

    with {:ok, document} <- Floki.parse_document(html) do
      Finder.find(document, selector)
    end
  end

  def find(html_tree_as_tuple, selector)
      when is_list(html_tree_as_tuple) or is_html_node(html_tree_as_tuple) do
    Finder.find(html_tree_as_tuple, selector)
  end

  @doc """
  Finds the first element in an HTML tree by id.

  Returns `nil` if no element is found.

  This is useful when there are IDs that contain special characters that
  are invalid when passed as is as a CSS selector.
  It is similar to the `getElementById` method in the browser.

  ## Examples

      iex> {:ok, html} = Floki.parse_fragment(~s[<p><span class="hint" id="id?foo_special:chars">hello</span></p>])
      iex> Floki.get_by_id(html, "id?foo_special:chars")
      {"span", [{"class", "hint"}, {"id", "id?foo_special:chars"}], ["hello"]}
      iex> Floki.get_by_id(html, "does-not-exist")
      nil

  """
  @spec get_by_id(html_tree() | html_node(), String.t()) :: html_node() | nil
  def get_by_id(html_tree_as_tuple, id)
      when is_list(html_tree_as_tuple) or is_html_node(html_tree_as_tuple) do
    html_tree_as_tuple
    |> Finder.find(%Floki.Selector{id: id})
    |> List.first()
  end

  @doc """
  Changes the attribute values of the elements matched by `selector`
  with the function `mutation` and returns the whole element tree.

  ## Examples

      iex> Floki.attr([{"div", [{"id", "a"}], []}], "#a", "id", fn(id) -> String.replace(id, "a", "b") end)
      [{"div", [{"id", "b"}], []}]

      iex> Floki.attr([{"div", [{"class", "name"}], []}], "div", "id", fn _ -> "b" end)
      [{"div", [{"id", "b"}, {"class", "name"}], []}]

  """
  @spec attr(binary | html_tree | html_node, css_selector(), binary, (binary -> binary)) ::
          html_tree

  def attr(html_elem_tuple, selector, attribute_name, mutation) when is_tuple(html_elem_tuple) do
    attr([html_elem_tuple], selector, attribute_name, mutation)
  end

  def attr(html, selector, attribute_name, mutation) when is_binary(html) do
    Logger.info(
      "deprecation: parse the HTML with parse_document or parse_fragment before using attr/4"
    )

    with {:ok, document} <- Floki.parse_document(html) do
      attr(document, selector, attribute_name, mutation)
    end
  end

  def attr(html_tree_list, selector, attribute_name, mutation) when is_list(html_tree_list) do
    find_and_update(html_tree_list, selector, fn
      {tag, attrs} ->
        modified_attrs =
          if Enum.any?(attrs, &match?({^attribute_name, _}, &1)) do
            Enum.map(
              attrs,
              fn attribute ->
                with {^attribute_name, attribute_value} <- attribute do
                  {attribute_name, mutation.(attribute_value)}
                end
              end
            )
          else
            [{attribute_name, mutation.(nil)} | attrs]
          end

        {tag, modified_attrs}

      other ->
        other
    end)
  end

  @deprecated """
  Use `find_and_update/3` or `Enum.map/2` instead.
  """
  def map(_html_tree_or_list, _fun)

  def map(html_tree_list, fun) when is_list(html_tree_list) do
    Enum.map(html_tree_list, &Finder.map(&1, fun))
  end

  def map(html_tree, fun), do: Finder.map(html_tree, fun)

  @doc """
  Searches for elements inside the HTML tree and update those that matches the selector.

  It will return the updated HTML tree.

  This function works in a way similar to `traverse_and_update`, but instead of updating
  the children nodes, it will only updates the `tag` and `attributes` of the matching nodes.

  If `fun` returns `:delete`, the HTML node will be removed from the tree.

  ## Examples

      iex> Floki.find_and_update([{"a", [{"href", "http://elixir-lang.com"}], ["Elixir"]}], "a", fn
      iex>   {"a", [{"href", href}]} ->
      iex>     {"a", [{"href", String.replace(href, "http://", "https://")}]}
      iex>   other ->
      iex>     other
      iex> end)
      [{"a", [{"href", "https://elixir-lang.com"}], ["Elixir"]}]
  """

  @spec find_and_update(
          html_tree(),
          css_selector(),
          ({String.t(), html_attributes()} -> {String.t(), html_attributes()} | :delete)
        ) :: html_tree()
  def find_and_update(html_tree, selector, fun) do
    tree = HTMLTree.build(html_tree)
    results = Finder.find(tree, selector)

    operations_with_nodes =
      Enum.map(results, fn
        html_node = %Floki.HTMLTree.HTMLNode{} ->
          case fun.({html_node.type, html_node.attributes}) do
            {updated_tag, updated_attrs} ->
              {:update, %{html_node | type: updated_tag, attributes: updated_attrs}}

            :delete ->
              {:delete, html_node}
          end

        other ->
          {:no_op, other}
      end)

    tree
    |> HTMLTree.patch_nodes(operations_with_nodes)
    |> HTMLTree.to_tuple_list()
  end

  @doc """
  Traverses and updates a HTML tree structure.

  This function returns a new tree structure that is the result of applying the
  given `fun` on all nodes except text nodes.
  The tree is traversed in a post-walk fashion, where the children are traversed
  before the parent.

  When the function `fun` encounters HTML tag, it receives a tuple with `{name,
  attributes, children}`, and should either return a similar tuple, a list of
  tuples to split current node or `nil` to delete it.

  The function `fun` can also encounter HTML doctype, comment or declaration and
  will receive, and should return, different tuple for these types. See the
  documentation for `t:html_comment/0`, `t:html_doctype/0` and
  `t:html_declaration/0` for details.

  **Note**: this won't update text nodes, but you can transform them when working
  with children nodes.

  ## Examples

      iex> html = [{"div", [], ["hello"]}]
      iex> Floki.traverse_and_update(html, fn
      ...>   {"div", attrs, children} -> {"p", attrs, children}
      ...>   other -> other
      ...> end)
      [{"p", [], ["hello"]}]

      iex> html = [{"div", [], [{:comment, "I am comment"}, {"span", [], ["hello"]}]}]
      iex> Floki.traverse_and_update(html, fn
      ...>   {"span", _attrs, _children} -> nil
      ...>   {:comment, text} -> {"span", [], text}
      ...>   other -> other
      ...> end)
      [{"div", [], [{"span", [], "I am comment"}]}]
  """

  @spec traverse_and_update(
          html_node() | html_tree(),
          (html_node() -> html_node() | [html_node()] | nil)
        ) :: html_node() | html_tree()

  defdelegate traverse_and_update(html_tree, fun), to: Floki.Traversal

  @doc """
  Traverses and updates a HTML tree structure with an accumulator.

  This function returns a new tree structure and the final value of accumulator
  which are the result of applying the given `fun` on all nodes except text nodes.
  The tree is traversed in a post-walk fashion, where the children are traversed
  before the parent.

  When the function `fun` encounters HTML tag, it receives a tuple with
  `{name, attributes, children}` and an accumulator. It and should return a
  2-tuple like `{new_node, new_acc}`, where `new_node` is either a similar tuple
  or `nil` to delete the current node, and `new_acc` is an updated value for the
  accumulator.

  The function `fun` can also encounter HTML doctype, comment or declaration and
  will receive, and should return, different tuple for these types. See the
  documentation for `t:html_comment/0`, `t:html_doctype/0` and
  `t:html_declaration/0` for details.

  **Note**: this won't update text nodes, but you can transform them when working
  with children nodes.

  ## Examples

      iex> html = [{"div", [], [{:comment, "I am a comment"}, "hello"]}, {"div", [], ["world"]}]
      iex> Floki.traverse_and_update(html, 0, fn
      ...>   {"div", attrs, children}, acc ->
      ...>     {{"p", [{"data-count", to_string(acc)} | attrs], children}, acc + 1}
      ...>   other, acc -> {other, acc}
      ...> end)
      {[
         {"p", [{"data-count", "0"}], [{:comment, "I am a comment"}, "hello"]},
         {"p", [{"data-count", "1"}], ["world"]}
       ], 2}

      iex> html = {"div", [], [{"span", [], ["hello"]}]}
      iex> Floki.traverse_and_update(html, [deleted: 0], fn
      ...>   {"span", _attrs, _children}, acc ->
      ...>     {nil, Keyword.put(acc, :deleted, acc[:deleted] + 1)}
      ...>   tag, acc ->
      ...>     {tag, acc}
      ...> end)
      {{"div", [], []}, [deleted: 1]}
  """

  @spec traverse_and_update(
          html_node() | html_tree(),
          traverse_acc,
          (html_node(), traverse_acc ->
             {html_node() | [html_node()] | nil, traverse_acc})
        ) :: {html_node() | html_tree(), traverse_acc}
        when traverse_acc: any()
  defdelegate traverse_and_update(html_tree, acc, fun), to: Floki.Traversal

  @doc """
  Returns the text nodes from a HTML tree.

  By default, it will perform a deep search through the HTML tree.
  You can disable deep search with the option `deep` assigned to false.
  You can include content of script tags with the option `js` assigned to true.
  You can specify a separator between nodes content.

  ## Options

    * `:deep` - A boolean option to control how deep the search for
      text is going to be. If `false`, only the level of the HTML node
      or the first level of the HTML document is going to be considered.
      Defaults to `true`.

    * `:js` - A boolean option to control if the contents of script tags
      should be considered as text. Defaults to `false`.

    * `:sep` - A separator string that is added between text nodes.
      Defaults to `""`.

    * `:include_inputs` - A boolean to control if `<input>` or `<textarea>`
      values should be included in the resultant string.
      Defaults to `false`.

    * `:html_parser` - The module of the backend that is responsible for parsing
      the HTML string. By default it is set to `Floki.HTMLParser.Mochiweb`.

  ## Examples

      iex> Floki.text({"div", [], [{"span", [], ["hello"]}, " world"]})
      "hello world"

      iex> Floki.text({"div", [], [{"span", [], ["hello"]}, " world"]}, deep: false)
      " world"

      iex> Floki.text({"div", [], [{"script", [], ["hello"]}, " world"]})
      " world"

      iex> Floki.text([{"input", [{"type", "date"}, {"value", "2017-06-01"}], []}], include_inputs: true)
      "2017-06-01"

      iex> Floki.text({"div", [], [{"script", [], ["hello"]}, " world"]}, js: true)
      "hello world"

      iex> Floki.text({"ul", [], [{"li", [], ["hello"]}, {"li", [], ["world"]}]}, sep: "-")
      "hello-world"

      iex> Floki.text([{"div", [], ["hello world"]}])
      "hello world"

      iex> Floki.text([{"p", [], ["1"]},{"p", [], ["2"]}])
      "12"

      iex> Floki.text({"div", [], [{"style", [], ["hello"]}, " world"]}, style: false)
      " world"

      iex> Floki.text({"div", [], [{"style", [], ["hello"]}, " world"]}, style: true)
      "hello world"

  """

  @spec text(html_tree | html_node | binary, Keyword.t()) :: binary

  def text(html, opts \\ []) do
    defaults = [deep: true, js: false, style: true, sep: "", include_inputs: false]

    opts = Keyword.validate!(opts, defaults)

    cleaned_html_tree =
      html
      |> maybe_parse_it()
      |> clean_html_tree(:js, opts[:js])
      |> clean_html_tree(:style, opts[:style])

    search_strategy = if opts[:deep], do: Floki.DeepText, else: Floki.FlatText

    search_strategy.get(cleaned_html_tree, opts[:sep], opts[:include_inputs])
  end

  @doc """
  Returns the direct child nodes of a HTML node.

  By default, it will also include all texts. You can disable
  this behaviour by using the option `include_text` to `false`.

  If the given node is not an HTML tag, then it returns nil.

  ## Examples

      iex> Floki.children({"div", [], ["text", {"span", [], []}]})
      ["text", {"span", [], []}]

      iex> Floki.children({"div", [], ["text", {"span", [], []}]}, include_text: false)
      [{"span", [], []}]

      iex> Floki.children({:comment, "comment"})
      nil

  """

  @spec children(html_node(), Keyword.t()) :: html_tree() | nil
  def children(html_node, opts \\ [include_text: true])

  def children({_, _, subtree}, include_text: false) do
    Enum.filter(subtree, &is_tuple/1)
  end

  def children({_, _, subtree}, include_text: _) do
    subtree
  end

  def children({_, _, _} = html_node, opts) do
    opts = Keyword.validate!(opts, include_text: true)

    children(html_node, include_text: opts[:include_text])
  end

  def children(_html_node, _opts), do: nil

  @doc """
  Returns a list with attribute values for a given selector.

  ## Examples

      iex> Floki.attribute([{"a", [{"href", "https://google.com"}], ["Google"]}], "a", "href")
      ["https://google.com"]

      iex> Floki.attribute(
      iex>   [{"a", [{"class", "foo"}, {"href", "https://google.com"}], ["Google"]}],
      iex>   "a",
      iex>   "class"
      iex> )
      ["foo"]

      iex> Floki.attribute(
      iex>   [{"a", [{"href", "https://e.corp.com"}, {"data-name", "e.corp"}], ["E.Corp"]}],
      iex>   "a[data-name]",
      iex>   "data-name"
      iex> )
      ["e.corp"]
  """

  @spec attribute(binary | html_tree | html_node, binary, binary) :: list

  def attribute(html, selector, attribute_name) do
    html
    |> find(selector)
    |> attribute_values(attribute_name)
  end

  @doc """
  Returns a list with attribute values from elements.

  ## Examples

      iex> Floki.attribute([{"a", [{"href", "https://google.com"}], ["Google"]}], "href")
      ["https://google.com"]

      iex> Floki.attribute([{"a", [{"href", "https://google.com"}, {"data-name", "google"}], ["Google"]}], "data-name")
      ["google"]
  """

  @spec attribute(binary | html_tree | html_node, binary) :: list
  def attribute(html, attribute_name) when is_binary(html) do
    Logger.info(
      "deprecation: parse the HTML with parse_document or parse_fragment before using attribute/2"
    )

    with {:ok, document} <- Floki.parse_document(html) do
      attribute_values(document, attribute_name)
    end
  end

  def attribute(elements, attribute_name) do
    attribute_values(elements, attribute_name)
  end

  defp attribute_values(element, attr_name) when is_tuple(element) do
    attribute_values([element], attr_name)
  end

  defp attribute_values(elements, attr_name) do
    values =
      Enum.reduce(
        elements,
        [],
        fn
          {_, attributes, _}, acc ->
            case attribute_match?(attributes, attr_name) do
              {_attr_name, value} ->
                [value | acc]

              _ ->
                acc
            end

          _, acc ->
            acc
        end
      )

    Enum.reverse(values)
  end

  defp attribute_match?(attributes, attribute_name) do
    Enum.find(
      attributes,
      fn {attr_name, _} ->
        attr_name == attribute_name
      end
    )
  end

  defp maybe_parse_it(html) when is_binary(html) do
    Logger.info(
      "deprecation: parse the HTML with parse_document or parse_fragment before using text/2"
    )

    {:ok, document} = Floki.parse_document(html)
    document
  end

  defp maybe_parse_it(html), do: html

  defp clean_html_tree(html_tree, :js, true), do: html_tree
  defp clean_html_tree(html_tree, :js, _), do: filter_out(html_tree, "script")

  defp clean_html_tree(html_tree, :style, true), do: html_tree
  defp clean_html_tree(html_tree, :style, _), do: filter_out(html_tree, "style")

  @doc """
  Returns the nodes from a HTML tree that don't match the filter selector.

  ## Examples

      iex> Floki.filter_out({"div", [], [{"script", [], ["hello"]}, " world"]}, "script")
      {"div", [], [" world"]}

      iex> Floki.filter_out([{"body", [], [{"script", [], []}, {"div", [], []}]}], "script")
      [{"body", [], [{"div", [], []}]}]

      iex> Floki.filter_out({"div", [], [{:comment, "comment"}, " text"]}, :comment)
      {"div", [], [" text"]}

      iex> Floki.filter_out({"div", [], ["text"]}, :text)
      {"div", [], []}

  """

  @spec filter_out(html_node() | html_tree() | binary(), :comment | :text | css_selector()) ::
          html_node() | html_tree()

  def filter_out(html, selector) when is_binary(html) do
    Logger.info(
      "deprecation: parse the HTML with parse_document or parse_fragment before using filter_out/2"
    )

    with {:ok, document} <- Floki.parse_document(html) do
      FilterOut.filter_out(document, selector)
    end
  end

  def filter_out(elements, selector) do
    FilterOut.filter_out(elements, selector)
  end
end
