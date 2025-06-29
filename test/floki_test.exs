defmodule FlokiTest do
  @moduledoc false
  use ExUnit.Case, async: true

  doctest Floki

  require Floki
  alias Floki.HTMLParser.{Html5ever, Mochiweb, FastHtml}
  alias Floki.HTMLTree

  @current_parser Application.compile_env(:floki, :html_parser, Mochiweb)

  @plain_text_tags [
    "script",
    "style",
    "title",
    "textarea"
  ]

  @html """
  <html>
  <head>
  <title>Test</title>
  </head>
  <body>
    <a href="http://foo.com/blah?hi=blah&foo=&#43;Park" class="foo">test</a>
    <div class="content">
      <a href="http://google.com" class="js-google js-cool">Google</a>
      <a href="http://elixir-lang.org" class="js-elixir js-cool">Elixir lang</a>
      <a href="http://java.com" class="js-java">Java</a>
    </div>
  </body>
  </html>
  """

  @html_with_data_attributes """
  <html>
  <head>
  <title>Test</title>
  </head>
  <body>
    <div class="content">
      <a href="http://google.com" class="js-google js-cool" data-action="lolcats">Google</a>
      <a href="http://elixir-lang.org" class="js-elixir js-cool">Elixir lang</a>
      <a href="http://java.com" class="js-java">Java</a>
    </div>
  </body>
  </html>
  """

  @html_with_img """
  <html>
  <body>
  <a href="http://twitter.com">
    <img src="http://twitter.com/logo.png" class="js-twitter-logo" />
  </a>
  <!-- this is a comment -->
  <div class="logo-container">
    <img src="http://twitter.com/logo.png" class="img-without-closing-tag">
    <img src="logo.png" id="logo" />
  </div>
  </body>
  </html>
  """

  describe "parse_document/2" do
    test "parse a simple HTML" do
      html =
        html_body(
          ~s(<div><a href="https://dev.to" class="link">Dev.to</a><p>Content <b>here</b>!</p></div>)
        )

      {:ok, parsed} = Floki.parse_document(html)

      assert [
               {"html", [],
                [
                  {"head", [], []},
                  {"body", [],
                   [
                     {"div", [],
                      [
                        {"a", [{"href", "https://dev.to"}, {"class", "link"}], ["Dev.to"]},
                        {"p", [], ["Content ", {"b", [], ["here"]}, "!"]}
                      ]}
                   ]}
                ]}
             ] = parsed
    end

    test "parse a HTML with XML inside" do
      html =
        html_body(
          ~s(<P><B><U><SPAN lang="EN-AU" style='FONT-FAMILY: &quot;Times New Roman&quot;,serif; mso-ansi-language: EN-AU'>Overview<?xml:namespace prefix = "o" ns = "urn:schemas-microsoft-com:office:office" /?><o:p></o:p></SPAN></U></B></P>)
        )

      {:ok, parsed} = Floki.parse_document(html)

      assert [
               {"html", [],
                [
                  {"head", [], []},
                  {"body", [],
                   [
                     {"p", [],
                      [
                        {"b", [],
                         [
                           {"u", [],
                            [
                              {"span",
                               [
                                 {"lang", "EN-AU"},
                                 {"style",
                                  "FONT-FAMILY: \"Times New Roman\",serif; mso-ansi-language: EN-AU"}
                               ], overview_section}
                            ]}
                         ]}
                      ]}
                   ]}
                ]}
             ] = parsed

      current_parser = Application.get_env(:floki, :html_parser, Mochiweb)

      case current_parser do
        Mochiweb ->
          assert overview_section ==
                   [
                     "Overview",
                     {:pi, "xml:namespace",
                      [
                        {"prefix", "o"},
                        {"ns", "urn:schemas-microsoft-com:office:office"}
                      ]},
                     {"o:p", [], []}
                   ]

        Html5ever ->
          assert overview_section ==
                   [
                     "Overview",
                     {:comment,
                      "?xml:namespace prefix = \"o\" ns = \"urn:schemas-microsoft-com:office:office\" /?"},
                     {"o:p", [], []}
                   ]

        FastHtml ->
          assert overview_section ==
                   [
                     "Overview",
                     {:comment,
                      "?xml:namespace prefix = \"o\" ns = \"urn:schemas-microsoft-com:office:office\" /?"},
                     {"o:p", [], []}
                   ]
      end
    end

    @tag only_parser: Mochiweb
    test "parse a HTML with tags that are plain text" do
      validate_html = fn tag ->
        {:ok, parsed} =
          tag
          |> html_with_tag_that_should_not_have_children()
          |> Floki.parse_document()

        assert parsed ==
                 [
                   {"html", [],
                    [
                      {"head", [], []},
                      {"body", [],
                       [
                         {tag, [],
                          [
                            "this is not a <tag>\nthis is also </not> a tag\n and this is also not <a></a> tag"
                          ]}
                       ]}
                    ]}
                 ]
      end

      Enum.each(@plain_text_tags, validate_html)
    end

    @tag only_parser: FastHtml
    test "parses all elements as strings by default" do
      html = html_body(~s(<div><p>Content</p><custom>Custom</custom></div>))

      {:ok, parsed} = Floki.parse_document(html)

      assert [
               {
                 "html",
                 [],
                 [
                   {"head", [], []},
                   {
                     "body",
                     [],
                     [
                       {"div", [], [{"p", [], ["Content"]}, {"custom", [], ["Custom"]}]}
                     ]
                   }
                 ]
               }
             ] = parsed
    end

    @tag only_parser: FastHtml
    test "parses known elements as atoms when :html_atoms format argument is given" do
      html = html_body(~s(<div><p>Content</p><custom>Custom</custom></div>))

      {:ok, parsed} = Floki.parse_document(html, parser_args: [format: [:html_atoms]])

      assert [
               {
                 :html,
                 [],
                 [
                   {:head, [], []},
                   {
                     :body,
                     [],
                     [
                       {:div, [], [{:p, [], ["Content"]}, {"custom", [], ["Custom"]}]}
                     ]
                   }
                 ]
               }
             ] == parsed
    end
  end

  describe "parse_fragment/2" do
    @tag only_parser: FastHtml
    test "does not parse a table row with missing parent table tag by default" do
      html = "<tr><td>Column 1</td><td>Column 2</td></tr>"

      {:ok, parsed} = Floki.parse_fragment(html)

      assert ["Column 1Column 2"] == parsed
    end

    @tag only_parser: FastHtml
    test "parses a table row with missing parent table tag when table context is given" do
      html = "<tr><td>1</td><td>2</td></tr>"

      {:ok, parsed} = Floki.parse_fragment(html, parser_args: [context: "table"])

      assert [
               {
                 "tbody",
                 [],
                 [{"tr", [], [{"td", [], ["1"]}, {"td", [], ["2"]}]}]
               }
             ] == parsed
    end
  end

  # Floki.raw_html/2

  test "raw_html/1" do
    html =
      html_body(
        ~s(<div id="content"><p><a href="uol.com.br" class="bar"><span>UOL</span><img src="foo.png"/></a></p><br/></div>)
      )

    raw_html = Floki.raw_html(document!(html))

    assert raw_html == IO.chardata_to_string(html)

    html_with_doctype = [
      {:doctype, "html", "", ""},
      {
        "html",
        [],
        [
          {"head", [], [{"title", [], ["hello"]}]},
          {"body", [], [{"h1", [], ["world"]}]}
        ]
      }
    ]

    assert Floki.raw_html(html_with_doctype) ==
             "<!DOCTYPE html><html><head><title>hello</title></head><body><h1>world</h1></body></html>"

    span_with_entities = html_body("<span>&lt;video&gt; São Paulo</span>")

    parsed = document!(span_with_entities)

    assert Floki.raw_html(parsed) == IO.chardata_to_string(span_with_entities)
  end

  test "raw_html/1 with plain text" do
    assert "plain text node" = Floki.raw_html("plain text node")
  end

  test "raw_html/1 after find" do
    raw_html =
      ~s(<div id="content"><p><a href="site" class="bar"><span>lol</span><img src="foo.png"/></a></p><br/></div>)
      |> html_body()
      |> document!()
      |> Floki.find("a")
      |> Floki.raw_html()

    assert raw_html ==
             ~s(<a href="site" class="bar"><span>lol</span><img src="foo.png"/></a>)
  end

  test "raw_html (with boolean attribute)" do
    raw_html = Floki.raw_html({"div", ["hidden"], []})

    assert raw_html == "<div hidden></div>"
  end

  test "raw_html with attribute as iodata" do
    raw_html = Floki.raw_html({"div", [{"class", ["class1", " ", ["class", "2"]]}], []})
    assert raw_html == ~s(<div class="class1 class2"></div>)
  end

  test "raw_html (with self closing tag without content)" do
    raw_html = Floki.raw_html({"link", [{"href", "www.example.com"}], []})

    assert raw_html == "<link href=\"www.example.com\"/>"
  end

  test "raw_html (with self closing tag with content)" do
    raw_html = Floki.raw_html({"link", [], ["www.example.com"]})

    assert raw_html == "<link>www.example.com</link>"
  end

  test "raw_html (with custom self closing tag without content and without attributes)" do
    original_self_closing_tags = Application.get_env(:floki, :self_closing_tags)
    Application.put_env(:floki, :self_closing_tags, ["shy"])

    raw_html = Floki.raw_html({"shy", [], []})

    assert raw_html == "<shy/>"

    Application.put_env(:floki, :self_closing_tags, original_self_closing_tags)
  end

  test "raw_html (with custom self closing tag without content)" do
    original_self_closing_tags = Application.get_env(:floki, :self_closing_tags)
    Application.put_env(:floki, :self_closing_tags, ["download"])

    raw_html = Floki.raw_html({"download", [{"href", "//www.example.com/file.zip"}], []})

    assert raw_html == "<download href=\"//www.example.com/file.zip\"/>"

    Application.put_env(:floki, :self_closing_tags, original_self_closing_tags)
  end

  test "raw_html (with custom self closing tag with content and with attribute)" do
    original_self_closing_tags = Application.get_env(:floki, :self_closing_tags)
    Application.put_env(:floki, :self_closing_tags, ["download"])

    raw_html =
      Floki.raw_html(
        {"download", [{"href", "//www.example.com/file.zip"}], ["Download file.zip"]}
      )

    assert raw_html ==
             "<download href=\"//www.example.com/file.zip\">Download file.zip</download>"

    Application.put_env(:floki, :self_closing_tags, original_self_closing_tags)
  end

  test "raw_html (with custom self closing tag with content and without attribute)" do
    original_self_closing_tags = Application.get_env(:floki, :self_closing_tags)
    Application.put_env(:floki, :self_closing_tags, ["strike"])

    raw_html = Floki.raw_html({"strike", [], ["stroke text"]})

    assert raw_html == "<strike>stroke text</strike>"

    Application.put_env(:floki, :self_closing_tags, original_self_closing_tags)
  end

  test "raw_html (with default self closing tag that isn't set while custom self closing tags are set must fail)" do
    original_self_closing_tags = Application.get_env(:floki, :self_closing_tags)
    Application.put_env(:floki, :self_closing_tags, ["page"])

    raw_html = Floki.raw_html({"br", [], []})

    assert raw_html != "<br/>"

    Application.put_env(:floki, :self_closing_tags, original_self_closing_tags)
  end

  test "raw_html (with script and style tags)" do
    tree = {
      "body",
      [],
      [
        {"div", [], ["< \"test\" >"]},
        {"script", [], ["alert(\"hello\");"]},
        {"style", [], [".foo[data-attr=\"bar\"] { width: 100%; }"]}
      ]
    }

    assert Floki.raw_html(tree) ==
             "<body><div>&lt; &quot;test&quot; &gt;</div><script>alert(\"hello\");</script><style>.foo[data-attr=\"bar\"] { width: 100%; }</style></body>"
  end

  test "raw_html (with quote and double quote inside the attribute)" do
    html_with_attributes_containing_quotes = """
      <!doctype html>
      <html>
      <head>
      <title>Test</title>
      </head>
      <body>
        <div class="content">
          <span id="double_quoted" data-action="lol 'cats' lol"></span>
          <span id="single_quoted" data-action='lol "cats" lol'></span>
        </div>
      </body>
      </html>
    """

    tree = document!(html_with_attributes_containing_quotes)
    raw = Floki.raw_html(tree)
    rerendered_tree = document!(raw)

    assert Floki.attribute(rerendered_tree, "#double_quoted", "data-action") == ["lol 'cats' lol"]

    assert Floki.attribute(rerendered_tree, "#single_quoted", "data-action") == [
             "lol \"cats\" lol"
           ]

    assert rerendered_tree == tree
  end

  test "raw_html (with both quote and double quote inside the attribute)" do
    expected_html =
      "<html><head></head><body><span data-stuff=\"&quot;&#39;\"></span></body></html>"

    tree = document!(html_body("<span data-stuff=\"&quot;&#39;\"></span>"))
    assert Floki.raw_html(tree) == expected_html

    tree = document!(html_body("<span data-stuff='\"&#39;'></span>"))
    assert Floki.raw_html(tree) == expected_html

    tree = document!(html_body("<span data-stuff=\"&quot;'\"></span>"))
    assert Floki.raw_html(tree) == expected_html

    expected_html = ~S"""
    <html>
      <head>
      </head>
      <body>
        <div>
          <style data-attrs-test="{&quot;event&quot;:&quot;buggy software&quot;,&quot;properties&quot;:{&quot;_builderButtonEvent&quot;:true}}">
          </style>
          <a data-attrs-event="{&quot;event&quot;:&quot;buggy software&quot;,&quot;properties&quot;:{&quot;_builderButtonEvent&quot;:true}}">
            Next
          </a>
        </div>
      </body>
    </html>
    """

    tree =
      document!(
        html_body(~S"""
        <div>
          <style data-attrs-test="{&quot;event&quot;:&quot;buggy software&quot;,&quot;properties&quot;:{&quot;_builderButtonEvent&quot;:true}}">
          </style>
          <a data-attrs-event="{&quot;event&quot;:&quot;buggy software&quot;,&quot;properties&quot;:{&quot;_builderButtonEvent&quot;:true}}">
            Next
          </a>
        </div>
        """)
      )

    assert Floki.raw_html(tree, pretty: true) == expected_html
  end

  test "raw_html (with >)" do
    expected_html = "<html><head></head><body><span data-stuff=\"&gt;\"></span></body></html>"

    tree = document!(html_body("<span data-stuff=\">\"></span>"))
    assert Floki.raw_html(tree) == expected_html
  end

  test "raw_html (with <)" do
    expected_html = "<html><head></head><body><span data-stuff=\"&lt;\"></span></body></html>"

    tree = document!(html_body("<span data-stuff=\"<\"></span>"))
    assert Floki.raw_html(tree) == expected_html
  end

  test "raw_html can configure encoding" do
    input = "<html><head></head><body>< \"test\" ></body></html>"
    encoded_output = "<html><head></head><body>&lt; &quot;test&quot; &gt;</body></html>"
    tree = document!(input)

    assert Floki.raw_html(tree) == encoded_output
    assert Floki.raw_html(tree, encode: true) == encoded_output
    assert Floki.raw_html(tree, encode: false) == input
  end

  test "raw_html encode: false does not encode attribute values" do
    input = "<html><head></head><body class=\"1 > 0\">< \"test\" ></body></html>"
    tree = document!(input)

    assert Floki.raw_html(tree, encode: false) == input
  end

  test "raw_html pretty with doctype" do
    html = """
      <!doctype html>
      <html>
      <head>
      <title>Test</title>
      </head>
      <body>
        <div class="content">
          <span>
            <div>
              encoded content
              &
              '
              "

      <span>
                <small>

      very deep content

                </small>
              </span>
    </div>

            <img src="file.jpg" />
                    </span>
        </div>
      </body>
      </html>
    """

    pretty_html =
      html
      |> document!()
      |> Floki.raw_html(pretty: true)

    assert pretty_html == """
           <html>
             <head>
               <title>
                 Test
               </title>
             </head>
             <body>
               <div class="content">
                 <span>
                   <div>
                     encoded content
                     &amp;
                     &#39;
                     &quot;
                     <span>
                       <small>
                         very deep content
                       </small>
                     </span>
                   </div>
                   <img src="file.jpg"/>
                 </span>
               </div>
             </body>
           </html>
           """
  end

  @tag only_parser: Mochiweb
  test "raw_html when :attributes_as_maps options was used to parse (new Floki v0.35.0)" do
    html_string =
      ~s(<div id="content"><p><a href="site" class="bar"><span>lol</span><img src="foo.png"/></a></p><br/></div>)

    parsed = Floki.parse_document!(html_string, attributes_as_maps: true)

    # no guarantee of attribute order from a map
    recombined =
      case Floki.raw_html(parsed) do
        "<div id=\"content\"><p><a class=\"bar\" href=\"site\"><span>lol</span><img src=\"foo.png\"/></a></p><br/></div>" ->
          true

        "<div id=\"content\"><p><a href=\"site\" class=\"bar\"><span>lol</span><img src=\"foo.png\"/></a></p><br/></div>" ->
          true

        _other ->
          false
      end

    assert recombined
  end

  test "raw_html treats the contents of title tags as plain text" do
    html_string = ~s(<html><head><title> <b> bold </b> text </title></head><body></body></html>)
    parsed = Floki.parse_document!(html_string)
    assert ^html_string = Floki.raw_html(parsed)
  end

  # Floki.find/2 - Classes

  test "find elements with a given class" do
    assert_find(document!(@html), ".js-cool", [
      {
        "a",
        [
          {"href", "http://google.com"},
          {"class", "js-google js-cool"}
        ],
        ["Google"]
      },
      {
        "a",
        [{"href", "http://elixir-lang.org"}, {"class", "js-elixir js-cool"}],
        ["Elixir lang"]
      }
    ])
  end

  @tag except_parser: FastHtml
  test "find elements with a given class and attributes as maps" do
    assert_find(document!(@html, attributes_as_maps: true), ".js-cool", [
      {
        "a",
        %{
          "href" => "http://google.com",
          "class" => "js-google js-cool"
        },
        ["Google"]
      },
      {
        "a",
        %{"href" => "http://elixir-lang.org", "class" => "js-elixir js-cool"},
        ["Elixir lang"]
      }
    ])
  end

  test "find elements with two classes combined" do
    class_selector = ".js-cool.js-elixir"

    assert_find(document!(@html), class_selector, [
      {
        "a",
        [{"href", "http://elixir-lang.org"}, {"class", "js-elixir js-cool"}],
        ["Elixir lang"]
      }
    ])
  end

  test "find elements with anormal class spacing" do
    html =
      document!(
        html_body("""
        <div class="js-cool\t\t  js-elixir"></div>
        """)
      )

    class_selector = ".js-cool.js-elixir"

    assert_find(html, class_selector, [
      {
        "div",
        [{"class", "js-cool\t\t  js-elixir"}],
        []
      }
    ])
  end

  test "find elements with a given class in html_without_html_tag" do
    html_without_html_tag = """
    <h2 class="js-cool">One</h2>
    <p>Two</p>
    <p>Three</p>
    """

    {:ok, html} = Floki.parse_fragment(html_without_html_tag)

    assert_find(html, ".js-cool", [{"h2", [{"class", "js-cool"}], ["One"]}])
  end

  test "find element that does not have child node" do
    class_selector = ".js-twitter-logo"

    assert_find(document!(@html_with_img), class_selector, [
      {
        "img",
        [{"src", "http://twitter.com/logo.png"}, {"class", "js-twitter-logo"}],
        []
      }
    ])
  end

  test "find element that does not close the tag" do
    class_selector = ".img-without-closing-tag"

    assert_find(document!(@html_with_img), class_selector, [
      {
        "img",
        [
          {"src", "http://twitter.com/logo.png"},
          {"class", "img-without-closing-tag"}
        ],
        []
      }
    ])
  end

  test "does not find elements" do
    class_selector = ".nothing"

    assert_find(document!(@html), class_selector, [])
  end

  test "find elements with colon in class names" do
    html =
      document!(
        html_body("""
        <div class="w-56 flex justify-end astro-SCKKX6R4"></div>
        <div class="m-auto max-w-7xl px-4 pt-12 pb-20 flex flex-col xl:flex-row space-y-16
        md:space-y-20 xl:space-y-0"></div>
        <section class="flex flex-col xl:flex-row"></section>
        """)
      )

    assert_find(html, ".xl\\:flex-row.md\\:space-y-20", [
      {
        "div",
        [
          {
            "class",
            "m-auto max-w-7xl px-4 pt-12 pb-20 flex flex-col xl:flex-row space-y-16\nmd:space-y-20 xl:space-y-0"
          }
        ],
        []
      }
    ])
  end

  # Floki.find/2 - Tag name

  test "select elements by tag name" do
    html = document!(html_body(~s(<strong>Name</strong><a href="profile">Julius</a>)))

    assert_find(html, "a", [{"a", [{"href", "profile"}], ["Julius"]}])
  end

  # Floki.find/2 - ID

  test "find element by id" do
    assert_find(document!(@html_with_img), "#logo", [
      {
        "img",
        [{"src", "logo.png"}, {"id", "logo"}],
        []
      }
    ])
  end

  @tag only_parser: Mochiweb
  test "find element by id when tree has attributes as maps" do
    assert_find(document!(@html_with_img, attributes_as_maps: true), "#logo", [
      {
        "img",
        %{"src" => "logo.png", "id" => "logo"},
        []
      }
    ])
  end

  ## Floki.find/2 - Attributes

  test "find elements with a tag and a given attribute value with shorthand syntax" do
    attribute_selector = "a[data-action=lolcats]"

    assert_find(document!(@html_with_data_attributes), attribute_selector, [
      {
        "a",
        [
          {"href", "http://google.com"},
          {"class", "js-google js-cool"},
          {"data-action", "lolcats"}
        ],
        ["Google"]
      }
    ])
  end

  @tag only_parser: Mochiweb
  test "find elements with a tag and a given attribute value with tree containing attributes as maps" do
    attribute_selector = "a[data-action=lolcats]"

    assert_find(
      document!(@html_with_data_attributes, attributes_as_maps: true),
      attribute_selector,
      [
        {
          "a",
          %{
            "class" => "js-google js-cool",
            "data-action" => "lolcats",
            "href" => "http://google.com"
          },
          ["Google"]
        }
      ]
    )
  end

  test "find elements only by given attribute value with shorthand syntax" do
    attribute_selector = "[data-action=lolcats]"

    assert_find(document!(@html_with_data_attributes), attribute_selector, [
      {
        "a",
        [
          {"href", "http://google.com"},
          {"class", "js-google js-cool"},
          {"data-action", "lolcats"}
        ],
        ["Google"]
      }
    ])
  end

  test "find elements by the attribute's |= selector" do
    attribute_selector = "a[href|='http://elixir']"

    assert_find(document!(@html), attribute_selector, [
      {
        "a",
        [{"href", "http://elixir-lang.org"}, {"class", "js-elixir js-cool"}],
        ["Elixir lang"]
      }
    ])
  end

  test "find elements by the attribute's ^= selector" do
    attribute_selector = "a[href^='http://g']"

    assert_find(document!(@html), attribute_selector, [
      {
        "a",
        [{"href", "http://google.com"}, {"class", "js-google js-cool"}],
        ["Google"]
      }
    ])
  end

  @tag only_parser: Mochiweb
  test "find elements by the attribute's ^= selector against a tree with attributes as maps" do
    attribute_selector = "a[href^='http://g']"

    assert_find(document!(@html, attributes_as_maps: true), attribute_selector, [
      {
        "a",
        %{"href" => "http://google.com", "class" => "js-google js-cool"},
        ["Google"]
      }
    ])
  end

  test "find elements by the attribute's $= selector" do
    attribute_selector = "a[href$='.org']"

    assert_find(document!(@html), attribute_selector, [
      {
        "a",
        [{"href", "http://elixir-lang.org"}, {"class", "js-elixir js-cool"}],
        ["Elixir lang"]
      }
    ])
  end

  test "find elements by the attribute's *= selector" do
    attribute_selector = "a[class*='google']"

    assert_find(document!(@html), attribute_selector, [
      {
        "a",
        [{"href", "http://google.com"}, {"class", "js-google js-cool"}],
        ["Google"]
      }
    ])
  end

  test "find elements only by given case-insensitive attribute value" do
    attribute_selector = "meta[name='robots' i]"
    html = document!(html_body(~s(<meta name="ROBOTS" content="INDEX, FOLLOW, NOIMAGEINDEX"/>)))

    assert_find(html, attribute_selector, [
      {
        "meta",
        [
          {"name", "ROBOTS"},
          {"content", "INDEX, FOLLOW, NOIMAGEINDEX"}
        ],
        []
      }
    ])
  end

  test "find elements by the attribute's |= selector with case-insensitive flag" do
    attribute_selector = "a[href|='HTTP://ELIXIR' i]"

    assert_find(document!(@html), attribute_selector, [
      {
        "a",
        [{"href", "http://elixir-lang.org"}, {"class", "js-elixir js-cool"}],
        ["Elixir lang"]
      }
    ])
  end

  test "find elements by the attribute's ^= selector with case-insensitive flag" do
    attribute_selector = "a[href^='HTTP://G' i]"

    assert_find(document!(@html), attribute_selector, [
      {
        "a",
        [{"href", "http://google.com"}, {"class", "js-google js-cool"}],
        ["Google"]
      }
    ])
  end

  test "find elements by the attribute's $= selector with case-insensitive flag" do
    attribute_selector = "a[href$='.ORG' i]"

    assert_find(document!(@html), attribute_selector, [
      {
        "a",
        [{"href", "http://elixir-lang.org"}, {"class", "js-elixir js-cool"}],
        ["Elixir lang"]
      }
    ])
  end

  test "find elements by the attribute's *= selector with case-insensitive flag" do
    attribute_selector = "a[class*='GOOGLE' i]"

    assert_find(document!(@html), attribute_selector, [
      {
        "a",
        [{"href", "http://google.com"}, {"class", "js-google js-cool"}],
        ["Google"]
      }
    ])
  end

  # Floki.find/2 - Selector with descendant combinator

  test "get elements descending the parent" do
    doc =
      document!(
        html_body("""
        <div id="first-div">
          <div id="second-div">
            <span id="first-span"></span>
          </div>
          <span id="second-span"></span>
        </div>
        """)
      )

    expected = [
      {"span", [{"id", "first-span"}], []},
      {"span", [{"id", "second-span"}], []}
    ]

    assert_find(doc, "div span", expected)
  end

  # Floki.find/2 - Selector with child combinator

  test "find children elements" do
    expected = [
      {
        "img",
        [{"src", "http://twitter.com/logo.png"}, {"class", "img-without-closing-tag"}],
        []
      },
      {
        "img",
        [
          {"src", "logo.png"},
          {"id", "logo"}
        ],
        []
      }
    ]

    assert_find(document!(@html_with_img), "div.logo-container > img", expected)
    assert_find(document!(@html_with_img), "body > div.logo-container > img", expected)
    assert_find(document!(@html_with_img), "body > img", [])
  end

  test "find only immediate children elements" do
    expected = [
      {"img", [{"src", "http://facebook.com/logo.png"}], []}
    ]

    html =
      document!(
        html_body("""
        <div>
          <p>
            <span>
              <img src="http://facebook.com/logo.png" />
            </span>
          </p>
        </div>
        """)
      )

    assert_find(html, "div > p > img", [])
    assert_find(html, "div > p > span > img", expected)
  end

  test "find a sibling after immediate child chain" do
    expected = [
      {
        "img",
        [{"src", "http://twitter.com/logo.png"}, {"class", "img-without-closing-tag"}],
        []
      }
    ]

    html =
      document!(
        html_body("""
        <div>
          <p>
            <span>
              <img src="http://facebook.com/logo.png" />
              <img src="http://twitter.com/logo.png" class="img-without-closing-tag" />
            </span>
          </p>
        </div>
        """)
      )

    assert_find(html, "div > p > span > img + img", expected)
  end

  # Floki.find/2 - Adjacent sibling combinator

  test "find adjacent sibling element" do
    html = document!(html_body(~s(
              <a href="t"><img src="/l.png" class="js-l"></a>
              <!-- comment -->
              <div class="l-c"><img src="l.png" class="img"><img src="l.png" id="lg"></div>
            )))

    expected = [
      {"div", [{"class", "l-c"}],
       [
         {"img", [{"src", "l.png"}, {"class", "img"}], []},
         {"img", [{"src", "l.png"}, {"id", "lg"}], []}
       ]}
    ]

    assert_find(html, "a + div", expected)
    assert_find(html, "a + .l-c", expected)

    assert_find(html, "a + div #lg", [
      {"img", [{"src", "l.png"}, {"id", "lg"}], []}
    ])

    assert_find(html, "a + #lg", [])
  end

  # Floki.find/2 - General sibling combinator

  test "find general sibling elements" do
    expected = [
      {"a", [{"href", "http://elixir-lang.org"}, {"class", "js-elixir js-cool"}],
       ["Elixir lang"]},
      {"a", [{"href", "http://java.com"}, {"class", "js-java"}], ["Java"]}
    ]

    assert_find(document!(@html), "a.js-google ~ a", expected)
    assert_find(document!(@html), "body > div > a.js-google ~ a", expected)
    assert_find(document!(@html), "body > div ~ a", [])
    assert_find(document!(@html), "a.js-java ~ a", [])
  end

  # Floki.find/2 - Using groups with comma

  test "get multiple elements using comma" do
    expected = [
      {"img", [{"src", "http://twitter.com/logo.png"}, {"class", "js-twitter-logo"}], []},
      {"img", [{"src", "logo.png"}, {"id", "logo"}], []}
    ]

    assert_find(document!(@html_with_img), ".js-twitter-logo, #logo", expected)
    assert_find(document!(@html_with_img), "#logo, .js-twitter-logo", expected)
  end

  test "get one element when search for multiple and just one exist" do
    expected = [{"img", [{"src", "logo.png"}, {"id", "logo"}], []}]

    assert_find(document!(@html_with_img), ".js-x-logo, #logo", expected)
  end

  # Floki.find/2 - Pseudo-class

  test "get elements by nth-child and first-child pseudo-classes" do
    html = """
    <html>
    <body>
      <a href="/a">1</a>
      ignores this text
      <a href="/b">2</a>
      <a href="/c">3</a>
      <!-- also ignores this comment -->
      <a href="/d">4</a>
      <a href="/e">5</a>
      <a href="/f">6</a>
      <a href="/g">7</a>
    </html>
    """

    assert_find(document!(html), "a:nth-child(2)", [
      {"a", [{"href", "/b"}], ["2"]}
    ])

    assert_find(document!(html), "a:nth-child(even)", [
      {"a", [{"href", "/b"}], ["2"]},
      {"a", [{"href", "/d"}], ["4"]},
      {"a", [{"href", "/f"}], ["6"]}
    ])

    assert_find(document!(html), "a:nth-child(odd)", [
      {"a", [{"href", "/a"}], ["1"]},
      {"a", [{"href", "/c"}], ["3"]},
      {"a", [{"href", "/e"}], ["5"]},
      {"a", [{"href", "/g"}], ["7"]}
    ])

    assert_find(document!(html), "a:first-child", [
      {"a", [{"href", "/a"}], ["1"]}
    ])

    # same as first-child
    assert_find(document!(html), "a:nth-child(0n+1)", [
      {"a", [{"href", "/a"}], ["1"]}
    ])

    assert_find(document!(html), "a:nth-child(3n+4)", [
      {"a", [{"href", "/d"}], ["4"]},
      {"a", [{"href", "/g"}], ["7"]}
    ])
  end

  @tag except_parser: Html5ever
  test "get root elements by nth-child and first-child pseudo-classes" do
    tree = Floki.parse_fragment!("<p>A</p><p>B</p>")

    assert_find(tree, "p:nth-child(1)", [{"p", [], ["A"]}])
    assert_find(tree, "p:nth-child(2)", [{"p", [], ["B"]}])
    assert_find(tree, "p:first-child", [{"p", [], ["A"]}])
  end

  test "get elements by nth-last-child pseudo-class" do
    html = """
    <html>
    <body>
      <a href="/a">1</a>
      ignores this text
      <a href="/b">2</a>
      <a href="/c">3</a>
      <!-- also ignores this comment -->
      <a href="/d">4</a>
      <a href="/e">5</a>
      <a href="/f">6</a>
      <a href="/g">7</a>
    </html>
    """

    assert_find(document!(html), "a:nth-last-child(2)", [
      {"a", [{"href", "/f"}], ["6"]}
    ])

    assert_find(document!(html), "a:nth-last-child(even)", [
      {"a", [{"href", "/b"}], ["2"]},
      {"a", [{"href", "/d"}], ["4"]},
      {"a", [{"href", "/f"}], ["6"]}
    ])

    assert_find(document!(html), "a:nth-last-child(odd)", [
      {"a", [{"href", "/a"}], ["1"]},
      {"a", [{"href", "/c"}], ["3"]},
      {"a", [{"href", "/e"}], ["5"]},
      {"a", [{"href", "/g"}], ["7"]}
    ])

    assert_find(document!(html), "a:nth-last-child(0n+1)", [
      {"a", [{"href", "/g"}], ["7"]}
    ])

    assert_find(document!(html), "a:nth-last-child(3n+4)", [
      {"a", [{"href", "/a"}], ["1"]},
      {"a", [{"href", "/d"}], ["4"]}
    ])
  end

  test "get elements by last-child pseudo-class" do
    html = """
    <html>
    <body>
      <div>
        <p>1</p>
        <p>2</p>
      </div>
      ignores this text
      <!-- also ignores this comment -->
      <div>
        <p>3</p>
        <h2>4</h2>
      </div>
      ignores this text
      <!-- also ignores this comment -->
    </html>
    """

    assert_find(document!(html), "p:last-child", [
      {"p", [], ["2"]}
    ])

    assert_find(document!(html), "div :last-child", [
      {"p", [], ["2"]},
      {"h2", [], ["4"]}
    ])
  end

  @tag except_parser: Html5ever
  test "get root elements by last-child pseudo-class" do
    tree = Floki.parse_fragment!("<p>A</p><p>B</p>")

    assert_find(tree, "p:last-child", [{"p", [], ["B"]}])
  end

  test "get elements by nth-of-type, first-of-type, and last-of-type pseudo-classes" do
    html =
      document!("""
      <html>
      <body>
        ignores this text
        <h1>Child 1</h1>
        <!-- also ignores this comment -->
        <div>Child 2</div>
        <div>Child 3</div>
        <div>Child 4</div>
        <a href="/a">1</a>
        ignores this text
        <a href="/b">2</a>
        <a href="/c">3</a>
        <!-- also ignores this comment -->
        <a href="/d">4</a>
        <a href="/e">5</a>
      </body>
      </html>
      """)

    assert_find(html, "a:nth-of-type(2)", [
      {"a", [{"href", "/b"}], ["2"]}
    ])

    assert_find(html, "a:nth-of-type(even)", [
      {"a", [{"href", "/b"}], ["2"]},
      {"a", [{"href", "/d"}], ["4"]}
    ])

    assert_find(html, "a:nth-of-type(odd)", [
      {"a", [{"href", "/a"}], ["1"]},
      {"a", [{"href", "/c"}], ["3"]},
      {"a", [{"href", "/e"}], ["5"]}
    ])

    # same as nth-of-type(odd)
    assert_find(html, "a:nth-of-type(2n+1)", [
      {"a", [{"href", "/a"}], ["1"]},
      {"a", [{"href", "/c"}], ["3"]},
      {"a", [{"href", "/e"}], ["5"]}
    ])

    # same as first-of-type
    assert_find(html, "a:nth-of-type(0n+1)", [
      {"a", [{"href", "/a"}], ["1"]}
    ])

    assert_find(html, "a:first-of-type", [
      {"a", [{"href", "/a"}], ["1"]}
    ])

    assert_find(html, "body :first-of-type", [
      {"h1", [], ["Child 1"]},
      {"div", [], ["Child 2"]},
      {"a", [{"href", "/a"}], ["1"]}
    ])

    assert_find(html, "body :last-of-type", [
      {"h1", [], ["Child 1"]},
      {"div", [], ["Child 4"]},
      {"a", [{"href", "/e"}], ["5"]}
    ])
  end

  @tag except_parser: Html5ever
  test "get root elements by nth-of-type, first-of-type, and last-of-type pseudo-classes" do
    tree = Floki.parse_fragment!("<p>A</p><div>B</div><p>C</p><div>D</div>")

    assert_find(tree, ":nth-of-type(1)", [
      {"p", [], ["A"]},
      {"div", [], ["B"]}
    ])

    assert_find(tree, ":first-of-type", [
      {"p", [], ["A"]},
      {"div", [], ["B"]}
    ])

    assert_find(tree, ":nth-of-type(2)", [
      {"p", [], ["C"]},
      {"div", [], ["D"]}
    ])

    assert_find(tree, ":last-of-type", [
      {"p", [], ["C"]},
      {"div", [], ["D"]}
    ])
  end

  test "get elements by nth-last-of-type pseudo-classes" do
    html =
      document!("""
      <html>
      <body>
        ignores this text
        <h1>Child 1</h1>
        <!-- also ignores this comment -->
        <a href="/a">1</a>
        <div>Child 2</div>
        <div>Child 3</div>
        <div>Child 4</div>
        ignores this text
        <a href="/b">2</a>
        <a href="/c">3</a>
        <!-- also ignores this comment -->
        <a href="/d">4</a>
        <a href="/e">5</a>
      </html>
      """)

    assert_find(html, "a:nth-last-of-type(2)", [
      {"a", [{"href", "/d"}], ["4"]}
    ])

    assert_find(html, "div:nth-last-of-type(even)", [
      {"div", [], ["Child 3"]}
    ])

    assert_find(html, "a:nth-last-of-type(odd)", [
      {"a", [{"href", "/a"}], ["1"]},
      {"a", [{"href", "/c"}], ["3"]},
      {"a", [{"href", "/e"}], ["5"]}
    ])

    assert_find(html, "a:nth-last-of-type(2n+1)", [
      {"a", [{"href", "/a"}], ["1"]},
      {"a", [{"href", "/c"}], ["3"]},
      {"a", [{"href", "/e"}], ["5"]}
    ])

    assert_find(html, "a:nth-last-of-type(0n+1)", [
      {"a", [{"href", "/e"}], ["5"]}
    ])
  end

  @tag except_parser: Html5ever
  test "get root elements by nth-last-of-type pseudo-classes" do
    tree = Floki.parse_fragment!("<p>A</p><div>B</div><p>C</p><div>D</div>")

    assert_find(tree, ":nth-last-of-type(1)", [
      {"p", [], ["C"]},
      {"div", [], ["D"]}
    ])

    assert_find(tree, ":nth-last-of-type(2)", [
      {"p", [], ["A"]},
      {"div", [], ["B"]}
    ])
  end

  test "not pseudo-class" do
    html =
      document!("""
      <html>
        <body>
          <div id="links">
            <a class="link foo">A foo</a>
            <a class="link bar" style="crazyColor">A bar</a>
            <a class="link baz">A baz</a>
          </div>
        </body>
      </html>
      """)

    expected_result = [
      {"a", [{"class", "link foo"}], ["A foo"]},
      {"a", [{"class", "link baz"}], ["A baz"]}
    ]

    assert_find(html, "a.link:not(.bar)", expected_result)
    assert_find(html, "div#links > a.link:not(.bar)", expected_result)
    assert_find(html, "a.link:not(:nth-child(2))", expected_result)
    assert_find(html, "a.link:not([style*=crazy])", expected_result)
  end

  test "not pseudo-class with multiple selectors" do
    html =
      document!("""
      <html>
        <body>
          <div id="links">
            <a class="link foo">A foo</a>
            <a class="link bar" style="crazyColor">A bar</a>
            <a class="link baz">A baz</a>
            <a class="link bin">A bin</a>
          </div>
        </body>
      </html>
      """)

    foo_match = {"a", [{"class", "link foo"}], ["A foo"]}
    bin_match = {"a", [{"class", "link bin"}], ["A bin"]}

    assert_find(html, "a.link:not(.bar, .baz)", [foo_match, bin_match])
    assert_find(html, "a.link:not(.bar,.baz)", [foo_match, bin_match])
    assert_find(html, "a.link:not(.bar):not(.baz)", [foo_match, bin_match])
    assert_find(html, "a.link:not(.bar, .bin):not(.baz)", [foo_match])
    assert_find(html, "a.link:not([style*=crazy], .bin):not(.baz)", [foo_match])
  end

  test "contains pseudo-class" do
    doc = document!(html_body(~s(<p>One</p><p>Two</p><div>nothing<b>42</b></div>)))

    assert_find(doc, "p:fl-contains('Two')", [
      {"p", [], ["Two"]}
    ])
  end

  test "icontains pseudo-class" do
    doc = document!(html_body(~s(<p>One</p><p>Two</p><div>nothing<b>42</b></div>)))

    assert_find(doc, "p:fl-icontains('two')", [
      {"p", [], ["Two"]}
    ])
  end

  test "contains psuedo-class with substring" do
    html =
      document!(
        html_body(~s(<ul><li>A podcast</li><li>Another podcast</li><li>A video</li></ul>))
      )

    expected = [
      {"li", [], ["A podcast"]},
      {"li", [], ["Another podcast"]}
    ]

    assert_find(html, ":fl-contains(' podcast')", expected)
  end

  test "checked pseudo-class" do
    html =
      document!(
        html_body(~s"""
        <input type="checkbox" name="1" checked>
        <input type="checkbox" name="2" checked="checked">
        <input type="checkbox" name="3">
        <input type="radio" name="4" checked>
        <input type="radio" name="5">
        <select>
          <option id="option-6" selected>6</option>
          <option>7</option>
        </select>
        """)
      )

    html_tree = HTMLTree.build(html)

    results = Floki.find(html, ":checked")

    html_tree_results =
      Enum.map(
        Floki.Finder.find(html_tree, ":checked"),
        fn html_node -> HTMLTree.to_tuple(html_tree, html_node) end
      )

    assert [
             {"input", [{"type", "checkbox"}, {"name", "1"}, {"checked", _}], []},
             {"input", [{"type", "checkbox"}, {"name", "2"}, {"checked", _}], []},
             {"input", [{"type", "radio"}, {"name", "4"}, {"checked", _}], []},
             {"option", [{"id", "option-6"}, {"selected", _}], ["6"]}
           ] = results

    assert html_tree_results == results
  end

  test "disabled pseudo-class" do
    html =
      document!(
        html_body(~s"""
        <button id="button-1" disabled="disabled">button 1</button>
        <button id="button-2" disabled>button 2</button>
        <button id="button-3">button 3</button>

        <input type="text" name="text 1" disabled="disabled">
        <input type="text" name="text 2" disabled>
        <input type="text" name="text 3">

        <select name="select 1" disabled="disabled"><option value="option 1">Option 1</option></select>
        <select name="select 2" disabled><option value="option 2">Option 2</option></select>
        <select name="select 3"><option value="option 3">Option 3</option></select>

        <select name="select 4"><option value="option 4" disabled="disabled">Option 4</option></select>
        <select name="select 5"><option value="option 5" disabled>Option 5</option></select>
        <select name="select 6"><option value="option 6">Option 6</option></select>

        <textarea name="text area 1" disabled="disabled">Text Area 1</textarea>
        <textarea name="text area 2" disabled>Text Area 2</textarea>
        <textarea name="text area 3">Text Area 3</textarea>
        """)
      )

    html_tree = HTMLTree.build(html)

    results = Floki.find(html, ":disabled")

    html_tree_results =
      Enum.map(
        Floki.Finder.find(html_tree, ":disabled"),
        fn html_node -> HTMLTree.to_tuple(html_tree, html_node) end
      )

    assert [
             {"button", [{"id", "button-1"}, {"disabled", _}], ["button 1"]},
             {"button", [{"id", "button-2"}, {"disabled", _}], ["button 2"]},
             {"input", [{"type", "text"}, {"name", "text 1"}, {"disabled", _}], []},
             {"input", [{"type", "text"}, {"name", "text 2"}, {"disabled", _}], []},
             {"select", [{"name", "select 1"}, {"disabled", _}],
              [{"option", [{"value", "option 1"}], ["Option 1"]}]},
             {"select", [{"name", "select 2"}, {"disabled", _}],
              [{"option", [{"value", "option 2"}], ["Option 2"]}]},
             {"option", [{"value", "option 4"}, {"disabled", _}], ["Option 4"]},
             {"option", [{"value", "option 5"}, {"disabled", _}], ["Option 5"]},
             {"textarea", [{"name", "text area 1"}, {"disabled", _}], ["Text Area 1"]},
             {"textarea", [{"name", "text area 2"}, {"disabled", _}], ["Text Area 2"]}
           ] = results

    assert html_tree_results == results
  end

  test "root pseudo-class" do
    doc = document!(html_body("<div><div>a</div><div>b</div></div>"))

    assert_find(doc, ":root>body>div>div", [
      {"div", [], ["a"]},
      {"div", [], ["b"]}
    ])
  end

  test "has pseudo-class simple" do
    html =
      """
      <div>
        <h1>Header</h1>
        <p class="foo">some data</p>
      </div>
      <div>
        <h2>Header 2</h2>
        <img src="https://example.com"></img>
      </div>
      <div>
        <h3>Header 3</h3>
        <p class="bar">some data</p>
      </div>
      <div>
        <img src="picture.jpg"></img>
        <input type="checkbox" checked></input>
      </div>
      """
      |> String.replace(~r/\n|\s{2,}/, "")
      |> html_body()
      |> document!()

    assert_find(html, "div:has(h1)", [
      {"div", [],
       [
         {"h1", [], ["Header"]},
         {"p", [{"class", "foo"}], ["some data"]}
       ]}
    ])

    assert_find(html, "div:has(h2)", [
      {"div", [],
       [
         {"h2", [], ["Header 2"]},
         {"img", [{"src", "https://example.com"}], []}
       ]}
    ])

    assert_find(html, "div:has(p)", [
      {"div", [],
       [
         {"h1", [], ["Header"]},
         {"p", [{"class", "foo"}], ["some data"]}
       ]},
      {"div", [],
       [
         {"h3", [], ["Header 3"]},
         {"p", [{"class", "bar"}], ["some data"]}
       ]}
    ])

    assert_find(html, "div:has(p.foo)", [
      {"div", [],
       [
         {"h1", [], ["Header"]},
         {"p", [{"class", "foo"}], ["some data"]}
       ]}
    ])

    assert_find(html, "div:has(img[src='https://example.com'])", [
      {"div", [],
       [
         {"h2", [], ["Header 2"]},
         {"img", [{"src", "https://example.com"}], []}
       ]}
    ])

    checked_value =
      case @current_parser do
        Mochiweb -> "checked"
        _ -> ""
      end

    assert_find(html, "div:has(:checked)", [
      {"div", [],
       [
         {"img", [{"src", "picture.jpg"}], []},
         {"input", [{"type", "checkbox"}, {"checked", checked_value}], []}
       ]}
    ])
  end

  test "has pseudo-class with multiple selectors" do
    html =
      """
      <div>
        <h1>Header</h1>
        <p>some data</p>
      </div>
      <div>
        <h2>Header 2</h2>
        <img src="https://example.com"></img>
        <p>some data</p>
      </div>
      """
      |> String.replace(~r/\n|\s{2,}/, "")
      |> html_body()
      |> document!()

    assert_find(html, "div:has(h1):has(h2)", [])

    assert_find(html, "div:has(h1, h2)", [
      {"div", [],
       [
         {"h1", [], ["Header"]},
         {"p", [], ["some data"]}
       ]},
      {"div", [],
       [
         {"h2", [], ["Header 2"]},
         {"img", [{"src", "https://example.com"}], []},
         {"p", [], ["some data"]}
       ]}
    ])

    assert_find(html, "div:has(h2):has(img):has(p)", [
      {"div", [],
       [
         {"h2", [], ["Header 2"]},
         {"img", [{"src", "https://example.com"}], []},
         {"p", [], ["some data"]}
       ]}
    ])

    assert_find(html, "div:has(h2, img, p)", [
      {"div", [],
       [
         {"h1", [], ["Header"]},
         {"p", [], ["some data"]}
       ]},
      {"div", [],
       [
         {"h2", [], ["Header 2"]},
         {"img", [{"src", "https://example.com"}], []},
         {"p", [], ["some data"]}
       ]}
    ])

    assert_find(html, "div:has(h1):has(p)", [
      {"div", [],
       [
         {"h1", [], ["Header"]},
         {"p", [], ["some data"]}
       ]}
    ])

    assert_find(html, "div:has(p):has(h1)", [
      {"div", [],
       [
         {"h1", [], ["Header"]},
         {"p", [], ["some data"]}
       ]}
    ])
  end

  test "has pseudo-class with table" do
    html =
      """
      <table>
        <tbody>
          <tr>
            <td><h1>Header</h1></td>
            <td>some data</td>
          </tr>
          <tr>
            <th class="empty">No Label</th>
            <td>some data</td>
          </tr>
          <tr>
            <th><label>TEST</label></th>
            <td>fetch me pls</td>
            <td><div>ok</div></td>
          </tr>
          <tr>
            <th><div><label>NESTED</label></div></th>
            <td><div>fetch me pls</div></td>
          </tr>
        </tbody>
      </table>
      """
      |> String.replace(~r/\n|\s{2,}/, "")
      |> html_body()
      |> document!()

    assert_find(html, "tr:has(label)", [
      {"tr", [],
       [
         {"th", [], [{"label", [], ["TEST"]}]},
         {"td", [], ["fetch me pls"]},
         {"td", [], [{"div", [], ["ok"]}]}
       ]},
      {"tr", [],
       [
         {"th", [], [{"div", [], [{"label", [], ["NESTED"]}]}]},
         {"td", [], [{"div", [], ["fetch me pls"]}]}
       ]}
    ])

    assert_find(html, "tr:has(th.empty)", [
      {"tr", [],
       [
         {"th", [{"class", "empty"}], ["No Label"]},
         {"td", [], ["some data"]}
       ]}
    ])

    assert_find(html, "tr:has(h1, label)", [
      {"tr", [],
       [
         {"td", [], [{"h1", [], ["Header"]}]},
         {"td", [], ["some data"]}
       ]},
      {"tr", [],
       [
         {"th", [], [{"label", [], ["TEST"]}]},
         {"td", [], ["fetch me pls"]},
         {"td", [], [{"div", [], ["ok"]}]}
       ]},
      {"tr", [],
       [
         {"th", [], [{"div", [], [{"label", [], ["NESTED"]}]}]},
         {"td", [], [{"div", [], ["fetch me pls"]}]}
       ]}
    ])

    assert_find(html, "tr:has(label):has(div)", [
      {"tr", [],
       [
         {"th", [], [{"label", [], ["TEST"]}]},
         {"td", [], ["fetch me pls"]},
         {"td", [], [{"div", [], ["ok"]}]}
       ]},
      {"tr", [],
       [
         {"th", [], [{"div", [], [{"label", [], ["NESTED"]}]}]},
         {"td", [], [{"div", [], ["fetch me pls"]}]}
       ]}
    ])

    assert_find(html, "tr:has(*:fl-contains('TEST'))", [
      {"tr", [],
       [
         {"th", [], [{"label", [], ["TEST"]}]},
         {"td", [], ["fetch me pls"]},
         {"td", [], [{"div", [], ["ok"]}]}
       ]}
    ])

    assert_find(html, "tr:has(*:fl-contains('TEST')) th ~ td", [
      {"td", [], ["fetch me pls"]},
      {"td", [], [{"div", [], ["ok"]}]}
    ])

    ## NOTE: this parses incorrectly, parses as:
    ##   %PseudoClass{name: "has", value: [%Selector{type: "label", pseudo_classes: [%PseudoClass{name: "has", value: []}]}]}
    ## but would expect to parse as:
    ##   %PseudoClass{name: "has", value: [%Selector{type: "div", pseudo_classes: [%PseudoClass{name: "has", value: [%Selector{type: "label"}]}]}]}
    # assert_find(html, "tr:has(div:has(label))", [
    #   {"tr", [],
    #    [
    #      {"th", [], [{"div", [], [{"label", [], ["NESTED"]}]}]},
    #      {"td", [], [{"div", [], ["fetch me pls"]}]}
    #    ]}
    # ])

    ## NOTE: this does not parse, because "only simple selectors are allowed in :has() pseudo-class"
    # assert_find(html, "th:has(> label)", [
    #   {"th", [], [{"label", [], ["TEST"]}]}
    # ])

    ## NOTE: this does not parse, because "only simple selectors are allowed in :has() pseudo-class"
    # assert_find(html, "th:has(> div > label)", [
    #   {"th", [], [{"div", [], [{"label", [], ["NESTED"]}]}]}
    # ])

    ## NOTE: this parses incorrectly, because "only simple selectors are allowed in :has() pseudo-class"
    # assert_find(html, "tr:has(td + td)", [
    #   {"tr", [],
    #    [
    #      {"td", [], [{"h1", [], ["Header"]}]},
    #      {"td", [], ["some data"]}
    #    ]},
    #   {"tr", [],
    #    [
    #      {"th", [], [{"label", [], ["TEST"]}]},
    #      {"td", [], ["fetch me pls"]},
    #      {"td", [], [{"div", [], ["ok"]}]}
    #    ]}
    # ])

    ## NOTE: this parses incorrectly, parses as:
    ##  %PseudoClass{name: "not", value: [%Selector{type: "label", pseudo_classes: [%PseudoClass{name: "has", value: []}]}]}
    ## but would expect to parse as:
    ##  %PseudoClass{name: "not", value: [%Selector{type: "*", pseudo_classes: [%PseudoClass{name: "has", value: [%Selector{type: "label"}]}]}]}
    # assert_find(html, "tr:not(:has(label))", [
    #   {"tr", [], [{"th", [], ["No Label"]}, {"td", [], ["some data"]}]}
    # ])
  end

  test "has pseudo-class edge-cases" do
    html =
      """
      <div>
        <div>
          <div>foo</div>
          <div>bar</div>
        </div>
        <div>baz</div>
      </div>
      """
      |> String.replace(~r/\n|\s{2,}/, "")
      |> html_body()
      |> document!()

    # `:has` without any selector doesn't match any nodes (Enum.any? on an empty array returns false).
    # Firefox ignores this case, warning of a bad selector due to a dangling combinator.
    assert_find(html, "div:has()", [])

    # `:has` with * as the selector matches all HTML nodes with HTML nodes as children.
    # This matches the behaviour of `:has(*)` in Firefox.
    assert_find(html, "div:has(*)", [
      {"div", [],
       [
         {"div", [], [{"div", [], ["foo"]}, {"div", [], ["bar"]}]},
         {"div", [], ["baz"]}
       ]},
      {"div", [], [{"div", [], ["foo"]}, {"div", [], ["bar"]}]}
    ])

    # In this case, both the top-level div and the second-level div match the selector.
    assert_find(html, "div:has(div:fl-contains('foo'))", [
      {"div", [],
       [
         {"div", [],
          [
            {"div", [], ["foo"]},
            {"div", [], ["bar"]}
          ]},
         {"div", [], ["baz"]}
       ]},
      {"div", [],
       [
         {"div", [], ["foo"]},
         {"div", [], ["bar"]}
       ]}
    ])
  end

  # Floki.find/2 - XML and invalid HTML

  test "get elements inside a XML structure" do
    xml = [
      {:pi, "xml", [{"version", "1.0"}, {"encoding", "UTF-8"}]},
      {"rss", [{"version", "2.0"}],
       [
         {"channel", [], [{"title", [], ["A podcast"]}, {"link", [], ["www.foo.bar.com"]}]},
         {"channel", [], [{"title", [], ["Another podcast"]}, {"link", [], ["www.baz.com"]}]}
       ]}
    ]

    assert_find(xml, "title", [
      {"title", [], ["A podcast"]},
      {"title", [], ["Another podcast"]}
    ])
  end

  test "find elements inside namespaces" do
    {:ok, xml} = Floki.parse_fragment("<x:foo><x:bar>42</x:bar></x:foo>")

    assert_find(xml, "x | bar", [{"x:bar", [], ["42"]}])
  end

  @tag timeout: 100
  test "find an inexistent element inside a invalid HTML" do
    {:ok, doc} = Floki.parse_fragment("foobar<a")

    assert_find(doc, "a", [])
  end

  # Floki.find/2 - Raw selector structs

  test "find single selector structs" do
    html = document!(@html)
    html_tree = HTMLTree.build(html)

    selector_struct = %Floki.Selector{type: "a"}

    assert Floki.find(html, "a") == Floki.find(html, selector_struct)
    assert Floki.Finder.find(html_tree, "a") == Floki.Finder.find(html_tree, selector_struct)
  end

  test "find multiple selector structs" do
    html = document!(@html)
    html_tree = HTMLTree.build(html)

    selector_struct_1 = %Floki.Selector{type: "a"}
    selector_struct_2 = %Floki.Selector{type: "div"}

    assert Floki.find(html, "a,div") == Floki.find(html, [selector_struct_1, selector_struct_2])

    assert Floki.Finder.find(html_tree, "a,div") ==
             Floki.Finder.find(html_tree, [selector_struct_1, selector_struct_2])
  end

  # Floki.find/2 - Empty case

  test "find with an empty selector" do
    html = document!(@html)
    assert Floki.find(html, "") == []
  end

  # Floki.get_by_id/2

  test "get_by_id finds element with special characters" do
    html =
      document!(
        html_body(~s"""
        <div id="my-id?with_special!char:acters">Hello</div>
        """)
      )

    assert {"div", [{"id", "my-id?with_special!char:acters"}], ["Hello"]} =
             Floki.get_by_id(html, "my-id?with_special!char:acters")

    refute Floki.get_by_id(html, "doesn't exist")
  end

  # Floki.children/2

  test "returns the children elements of an element including the text" do
    html_node = {"div", [], ["a parent", {"span", [], ["a child"]}]}

    expected = [
      "a parent",
      {"span", [], ["a child"]}
    ]

    assert Floki.children(html_node) == expected
    assert Floki.children(html_node, include_text: true) == expected

    assert_raise ArgumentError, fn ->
      Floki.children(html_node, include_text: true, unknown_option: true)
    end

    assert_raise ArgumentError, fn ->
      Floki.children(html_node, unknown_option: true)
    end
  end

  test "returns the children elements of an element without the text" do
    html =
      document!(html_body("<div>a parent<span>child 1</span>some text<span>child 2</span></div>"))

    [elements | _] = Floki.find(html, "body > div")

    expected = [
      {"span", [], ["child 1"]},
      {"span", [], ["child 2"]}
    ]

    assert Floki.children(elements, include_text: false) == expected

    assert_raise ArgumentError, fn ->
      Floki.children(elements, include_text: false, unknown_option: true)
    end
  end

  test "returns nil if the given html is not a valid tuple" do
    assert Floki.children([]) == nil
    assert Floki.children([], include_text: true) == nil
    assert Floki.children([], include_text: false) == nil
  end

  # Floki.attribute/3

  test "get attribute values from elements with a given class" do
    class_selector = ".js-cool"
    expected_hrefs = ["http://google.com", "http://elixir-lang.org"]

    assert Floki.attribute(document!(@html), class_selector, "href") == expected_hrefs
  end

  test "get attributes from elements" do
    class_selector = ".js-cool"
    expected_hrefs = ["http://google.com", "http://elixir-lang.org"]
    elements = Floki.find(document!(@html), class_selector)

    assert Floki.attribute(elements, "href") == expected_hrefs
  end

  # Floki.attribute/2

  test "get attributes from an element found by id" do
    html = document!(html_body("<div id=important-el></div>"))

    elements = Floki.find(html, "#important-el")

    assert Floki.attribute(elements, "id") == ["important-el"]
  end

  test "returns an empty list when attribute does not exist" do
    class_selector = ".js-cool"
    elements = Floki.find(document!(@html), class_selector)

    assert Floki.attribute(elements, "title") == []
  end

  describe "find_and_update/3" do
    test "transforms attributes from selected nodes" do
      transformation = fn
        {"a", [{"href", href} | attrs]} ->
          {"a", [{"href", String.replace(href, "http://", "https://")} | attrs]}

        other ->
          other
      end

      html_tree =
        ~s(<div class="content"><a href="http://elixir-lang.org">Elixir</a><a href="http://github.com">GitHub</a></div>)
        |> html_body()
        |> document!()

      result = Floki.find_and_update(html_tree, ".content a", transformation)

      assert result == [
               {"html", [],
                [
                  {"head", [], []},
                  {"body", [],
                   [
                     {"div", [{"class", "content"}],
                      [
                        {"a", [{"href", "https://elixir-lang.org"}], ["Elixir"]},
                        {"a", [{"href", "https://github.com"}], ["GitHub"]}
                      ]}
                   ]}
                ]}
             ]
    end

    test "changes the type of a given tag" do
      html =
        ~s(<div><span class="strong">Hello</span><span>world</span></div>)
        |> html_body()
        |> document!()

      assert Floki.find_and_update(html, "span.strong", fn
               {"span", attrs} -> {"strong", attrs}
               other -> other
             end) == [
               {
                 "html",
                 [],
                 [
                   {"head", [], []},
                   {"body", [],
                    [
                      {"div", [],
                       [{"strong", [{"class", "strong"}], ["Hello"]}, {"span", [], ["world"]}]}
                    ]}
                 ]
               }
             ]
    end

    test "removes a node from HTML tree" do
      html =
        ~s(<div><span class="remove-me">Hello</span><span>world</span></div>)
        |> html_body()
        |> document!()

      assert Floki.find_and_update(html, "span", fn
               {"span", [{"class", "remove-me"}]} -> :delete
               other -> other
             end) == [
               {
                 "html",
                 [],
                 [
                   {"head", [], []},
                   {"body", [], [{"div", [], [{"span", [], ["world"]}]}]}
                 ]
               }
             ]
    end
  end

  test "finding leaf nodes" do
    html = """
    <html>
    <body>
    <div id="messageBox" class="legacyErrors">
      <div class="messageBox error">
        <h2 class="accessAid">Error Message</h2>
        <p>There has been an error in your account.</p>
      </div>
    </div>
    <div id="main" class="legacyErrors"><p>Separate Error Message</p></div>
    </body>
    </html>
    """

    assert_find(document!(html), ".messageBox p", [
      {"p", [], ["There has been an error in your account."]}
    ])
  end

  test "descendant matches are returned in order and without duplicates" do
    html =
      document!("""
      <!doctype html>
      <html>
        <body>
          <div class="data-view">Foo</div>
          <table summary="license-detail">
            <tbody>
              <tr>
                <th>
                  <span>Name:</span>
                </th>
                <td class="data-view"><span class="surname">Silva</span>, <span>Joana</span><span>Maria</span></td>
              </tr>
              <tr>
                <th scope="row">
                  <span>License Type:</span>
                </th>
                <td class="data-view">Naturopathic Doctor</td>
              </tr>
              <tr>
                <th scope="row">
                  <span>Expiration Date:</span>
                </th>
                <td class="data-view">06/30/2017</td>
              </tr>
            </tbody>
          </table>
          <div class="data-view">Bar</div>
        </body>
      </html>
      """)

    expected = [
      {
        "td",
        [{"class", "data-view"}],
        [
          {"span", [{"class", "surname"}], ["Silva"]},
          ", ",
          {"span", [], ["Joana"]},
          {"span", [], ["Maria"]}
        ]
      },
      {"td", [{"class", "data-view"}], ["Naturopathic Doctor"]},
      {"td", [{"class", "data-view"}], ["06/30/2017"]}
    ]

    assert_find(html, "table[summary='license-detail'] td.data-view", expected)
  end

  test "finding doesn't fail when body includes unencoded angles" do
    html_with_wrong_angles_encoding =
      document!(
        html_body(~s(<span class="method-callseq">mark # => #<Psych::Parser::Mark></span>))
      )

    assert_find(html_with_wrong_angles_encoding, "span", [
      {"span", [{"class", "method-callseq"}], ["mark # => #", {"psych::parser::mark", [], []}]}
    ])
  end

  test "html with xml definition tag in it" do
    html = """
      <!DOCTYPE html>
      <html>
      <head>
      </head>
      <body>
        <div class="text">test</div>
        <?xml version="1.0" encoding="utf-8"?>
      </div>
      </body>
      </html>
    """

    assert_find(document!(html), ".text", [{"div", [{"class", "text"}], ["test"]}])
  end

  test "finding doesn't fail when body includes xml version prefix" do
    html_with_xml_prefix = """
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
    <head>
    </head>
    <body>
      <a id="anchor" href="">useless link</a>
    </body>
    </html>
    """

    {:ok, html} = Floki.parse_document(html_with_xml_prefix)

    assert_find(html, "#anchor", [{"a", [{"id", "anchor"}, {"href", ""}], ["useless link"]}])
  end

  test "we can produce raw_html if it has an xml version prefix" do
    html_tree = [
      {:pi, "xml", [{"version", "1.0"}, {"encoding", "UTF-8"}]},
      {"html",
       [
         {"xmlns", "http://www.w3.org/1999/xhtml"},
         {"xml:lang", "en"},
         {"lang", "en"}
       ],
       [
         {"head", [], []},
         {"body", [], [{"a", [{"id", "anchor"}, {"href", ""}], ["useless link"]}]}
       ]}
    ]

    assert String.starts_with?(
             Floki.raw_html(html_tree),
             "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
           )
  end

  test "change tag attributes" do
    html =
      document!(
        html_body(
          Enum.join([
            ~s(<a class="change" href=\"http://not.url/changethis/\">link</a>),
            ~s(<a href=\"http://not.url/changethisbutnotrly/\">link</a>),
            ~s(<a class="change" href=\"http://not.url/changethis/\">link</a>)
          ])
        )
      )

    expects =
      html_body(
        Enum.join([
          ~s(<a class="change" href=\"http://not.url/changed/\">link</a>),
          ~s(<a href=\"http://not.url/changethisbutnotrly/\">link</a>),
          ~s(<a class="change" href=\"http://not.url/changed/\">link</a>)
        ])
      )

    result =
      html
      |> Floki.attr(".change", "href", fn inner_html ->
        String.replace(inner_html, "changethis", "changed")
      end)
      |> Floki.raw_html()

    assert result == IO.chardata_to_string(expects)
  end

  test "changing attribute don't change the order of nodes" do
    html =
      document!(
        html_body(
          ~s(<p>a<em>b</em>c<a href="z">d</a></p><p>e</p><p><a href="f"><strong>g</strong></a>.<em>h</em>i</p><p><strong>j</strong>k<a href="m">n</a>o</p><p><em>p</em>q<em>r</em>s<a href="t">u</a></p>)
        )
      )

    result =
      html
      |> Floki.attr("a", "href", fn href -> href end)
      |> hd()

    assert result == html
  end

  describe "is_html_node/1 guard" do
    test "returns true when html_tag is passed" do
      assert Floki.is_html_node({"div", [], []})
    end

    test "returns true when html_comment is passed" do
      assert Floki.is_html_node({:comment, "Ok"})
    end

    test "returns true when html_doctype is passed" do
      assert Floki.is_html_node({:doctype, "html", nil, nil})
    end

    test "returns true when html_declaration is passed" do
      assert Floki.is_html_node({:pi, "xml", [{"version", "1.0"}]})
    end

    test "returns true when html_text is passed" do
      assert Floki.is_html_node("I am html_text")
    end

    test "returns false when {:ok, val} / {:error, reason} is supplied" do
      refute Floki.is_html_node({:ok, 1})
      refute Floki.is_html_node({:error, :reason})
    end
  end

  @tag only_parser: Mochiweb
  test "parse document with attributes as map option enabled" do
    html =
      html_body("""
      <div class="container">
        <ul>
          <li class="link active"><a href="/">Home</a></li>
          <li class="link"><a href="/about-us">About us</a></li>
        </ul>
      </div>
      """)

    assert {:ok, html_tree} = Floki.parse_document(html, attributes_as_maps: true)

    assert html_tree == [
             {"html", %{},
              [
                {"head", %{}, []},
                {"body", %{},
                 [
                   {"div", %{"class" => "container"},
                    [
                      {"ul", %{},
                       [
                         {"li", %{"class" => "link active"}, [{"a", %{"href" => "/"}, ["Home"]}]},
                         {"li", %{"class" => "link"},
                          [{"a", %{"href" => "/about-us"}, ["About us"]}]}
                       ]}
                    ]}
                 ]}
              ]}
           ]
  end

  @tag only_parser: Mochiweb
  test "parse document with attributes as map option enabled and duplicated attributes" do
    html =
      html_body("""
      <div class="container">
        <ul>
          <li class="link active"><a href="/">Home</a></li>
          <li class="link" id="about-us" class="link company"><a href="/about-us">About us</a></li>
        </ul>
      </div>
      """)

    assert {:ok, html_tree} = Floki.parse_document(html, attributes_as_maps: true)

    # It takes the first attribute and ignores the second one.
    assert html_tree == [
             {"html", %{},
              [
                {"head", %{}, []},
                {"body", %{},
                 [
                   {"div", %{"class" => "container"},
                    [
                      {"ul", %{},
                       [
                         {"li", %{"class" => "link active"}, [{"a", %{"href" => "/"}, ["Home"]}]},
                         {"li", %{"class" => "link", "id" => "about-us"},
                          [{"a", %{"href" => "/about-us"}, ["About us"]}]}
                       ]}
                    ]}
                 ]}
              ]}
           ]
  end

  @tag only_parser: Mochiweb
  test "parse fragment containing malformed HTML with mochiweb" do
    html = "<spanclass=\"trade\">™ curl gelée<br><br><br></spanclass=\"trade\">"

    tree = Floki.parse_fragment!(html)

    assert tree == [
             {"spanclass", [{"=", "="}, {"\"trade\"", "\"trade\""}],
              ["™ curl gelée", {"br", [], []}, {"br", [], []}, {"br", [], []}]}
           ]
  end

  defp html_body(body) do
    ["<html><head></head><body>", body, "</body></html>"]
  end

  defp document!(html_string, opts \\ []) do
    case Floki.parse_document!(html_string, opts) do
      [{:doctype, "html", "", ""}, {"html", _, _} = html | _] ->
        html

      [{"html", _, _} = html | _] ->
        html
    end
  end

  defp html_with_tag_that_should_not_have_children(tag) do
    html_body(
      "<#{tag}>this is not a <tag>\nthis is also </not> a tag\n and this is also not <a></a> tag</#{tag}>"
    )
  end

  defp assert_find(document, selector, expected) do
    assert Floki.find(document, selector) == expected

    tree = HTMLTree.build(document)

    html_tree_results =
      Enum.map(
        Floki.Finder.find(tree, selector),
        fn html_node -> HTMLTree.to_tuple(tree, html_node) end
      )

    assert html_tree_results == expected
  end
end
