defmodule FlokiTest do
  use ExUnit.Case, async: true

  doctest Floki

  @html """
  <html>
  <head>
  <title>Test</title>
  </head>
  <body>
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

  @html_without_html_tag """
  <h2 class="js-cool">One</h2>
  <p>Two</p>
  <p>Three</p>
  """

  @html_with_wrong_angles_encoding """
  <html>
  <head>
  </head>
  <body>
    <span class="method-callseq">mark # => #<Psych::Parser::Mark></span>
  </body>
  """

  @xml """
  <?xml version="1.0" encoding="UTF-8"?>
  <rss version="2.0">
    <channel>
      <title>A podcast</title>
      <link>www.foo.bar.com</link>
    </channel>
    <channel>
      <title>Another podcast</title>
      <link>www.baz.com</link>
    </channel>
  </rss>
  """

  @html_with_xml_prefix """
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

  @html_with_attributes_containing_quotes """
  <html>
  <head>
  <title>Test</title>
  </head>
  <body>
    <div class="content">
      <span id="double_quoted" data-action="lol 'cats' lol"></span>
      <span id="single_quoted" data-action='lol "cats" lol'>/span>
    </div>
  </body>
  </html>
  """

  test "parse simple HTML" do
    parsed = Floki.parse(@html)

    assert parsed == {
             "html",
             [],
             [
               {"head", [], [{"title", [], ["Test"]}]},
               {
                 "body",
                 [],
                 [
                   {
                     "div",
                     [{"class", "content"}],
                     [
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
                         [
                           {"href", "http://elixir-lang.org"},
                           {"class", "js-elixir js-cool"}
                         ],
                         ["Elixir lang"]
                       },
                       {
                         "a",
                         [
                           {"href", "http://java.com"},
                           {"class", "js-java"}
                         ],
                         ["Java"]
                       }
                     ]
                   }
                 ]
               }
             ]
           }
  end

  @basic_html """
    <div id="content">
      <p>
        <a href="uol.com.br" class="bar">
          <span>UOL</span>
          <img src="foo.png"/>
        </a>
      </p>
      <strong>ok</strong>
      <br/>
    </div>
  """

  # Floki.parse/1

  test "parse html_without_html_tag" do
    parsed = Floki.parse(@html_without_html_tag)

    assert parsed == [
             {"h2", [{"class", "js-cool"}], ["One"]},
             {"p", [], ["Two"]},
             {"p", [], ["Three"]}
           ]
  end

  # Floki.raw_html/2

  test "raw_html" do
    raw_html =
      @basic_html
      |> Floki.parse()
      |> Floki.raw_html()

    original_without_spaces =
      @basic_html
      |> String.split("\n")
      |> Enum.map(&String.trim(&1))
      |> Enum.join("")

    assert raw_html == original_without_spaces

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

    span_with_entities = "<span>&lt;video&gt; São Paulo</span>"
    assert span_with_entities |> Floki.parse() |> Floki.raw_html() == span_with_entities
  end

  test "raw_html (with plain text)" do
    raw_html =
      "plain text node"
      |> Floki.parse()
      |> Floki.raw_html()

    raw_without_spaces =
      raw_html
      |> String.split("\n")
      |> Enum.map(&String.trim(&1))
      |> Enum.join("")

    assert raw_html == raw_without_spaces
  end

  test "raw_html (html with data attributes)" do
    raw_html =
      @html_with_data_attributes
      |> Floki.parse()
      |> Floki.raw_html()

    raw_without_spaces =
      raw_html
      |> String.split("\n")
      |> Enum.map(&String.trim(&1))
      |> Enum.join("")

    assert raw_html == raw_without_spaces
  end

  test "raw_html (with comment)" do
    raw_html =
      @html_with_img
      |> Floki.parse()
      |> Floki.raw_html()

    raw_without_spaces =
      raw_html
      |> String.split("\n")
      |> Enum.map(&String.trim(&1))
      |> Enum.join("")

    assert raw_html == raw_without_spaces
  end

  test "raw_html (after find)" do
    raw_html =
      @basic_html
      |> Floki.parse()
      |> Floki.find("a")
      |> Floki.raw_html()

    assert raw_html ==
             ~s(<a href="uol.com.br" class="bar"><span>UOL</span><img src="foo.png"/></a>)
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
    tree = Floki.parse(@html_with_attributes_containing_quotes)
    raw = Floki.raw_html(tree)
    rerendered_tree = Floki.parse(raw)
    assert Floki.attribute(rerendered_tree, "#double_quoted", "data-action") == ["lol 'cats' lol"]

    assert Floki.attribute(rerendered_tree, "#single_quoted", "data-action") == [
             "lol \"cats\" lol"
           ]

    assert rerendered_tree == tree
  end

  test "raw_html (with style tag with comments" do
    html = "<style><!-- test --></style>"

    assert html |> Floki.parse() |> Floki.raw_html() == html
  end

  test "raw_html can configure encoding" do
    input = "<body>< \"test\" ></body>"
    encoded_output = "<body>&lt; &quot;test&quot; &gt;</body>"
    tree = Floki.parse(input)

    assert Floki.raw_html(tree) == encoded_output
    assert Floki.raw_html(tree, encode: true) == encoded_output
    assert Floki.raw_html(tree, encode: false) == input
  end

  # Floki.find/2 - Classes

  test "find elements with a given class" do
    class_selector = ".js-cool"

    assert Floki.find(@html, class_selector) == [
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
           ]
  end

  test "find elements with two classes combined" do
    class_selector = ".js-cool.js-elixir"

    assert Floki.find(@html, class_selector) == [
             {
               "a",
               [{"href", "http://elixir-lang.org"}, {"class", "js-elixir js-cool"}],
               ["Elixir lang"]
             }
           ]
  end

  test "find elements with a given class in html_without_html_tag" do
    class_selector = ".js-cool"

    assert Floki.find(@html_without_html_tag, class_selector) == [
             {"h2", [{"class", "js-cool"}], ["One"]}
           ]
  end

  test "find element that does not have child node" do
    class_selector = ".js-twitter-logo"

    assert Floki.find(@html_with_img, class_selector) == [
             {
               "img",
               [{"src", "http://twitter.com/logo.png"}, {"class", "js-twitter-logo"}],
               []
             }
           ]
  end

  test "find element that does not close the tag" do
    class_selector = ".img-without-closing-tag"

    assert Floki.find(@html_with_img, class_selector) == [
             {
               "img",
               [
                 {"src", "http://twitter.com/logo.png"},
                 {"class", "img-without-closing-tag"}
               ],
               []
             }
           ]
  end

  test "does not find elements" do
    class_selector = ".nothing"

    assert Floki.find(@html, class_selector) == []
  end

  # Floki.find/2 - Tag name

  test "select elements by tag name" do
    tag_name = "a"
    elements = Floki.find(@html_with_img, tag_name)

    assert elements == [
             {
               "a",
               [{"href", "http://twitter.com"}],
               [
                 {
                   "img",
                   [{"src", "http://twitter.com/logo.png"}, {"class", "js-twitter-logo"}],
                   []
                 }
               ]
             }
           ]
  end

  # Floki.find/2 - ID

  test "find element by id" do
    id = "#logo"

    assert Floki.find(@html_with_img, id) == [
             {
               "img",
               [{"src", "logo.png"}, {"id", "logo"}],
               []
             }
           ]
  end

  ## Floki.find/2 - Attributes

  test "find elements with a tag and a given attribute value with shorthand syntax" do
    attribute_selector = "a[data-action=lolcats]"

    assert Floki.find(@html_with_data_attributes, attribute_selector) == [
             {
               "a",
               [
                 {"href", "http://google.com"},
                 {"class", "js-google js-cool"},
                 {"data-action", "lolcats"}
               ],
               ["Google"]
             }
           ]
  end

  test "find elements only by given attribute value with shorthand syntax" do
    attribute_selector = "[data-action=lolcats]"

    assert Floki.find(@html_with_data_attributes, attribute_selector) == [
             {
               "a",
               [
                 {"href", "http://google.com"},
                 {"class", "js-google js-cool"},
                 {"data-action", "lolcats"}
               ],
               ["Google"]
             }
           ]
  end

  test "find elements by the atributte's |= selector" do
    attribute_selector = "a[href|='http://elixir']"

    assert Floki.find(@html, attribute_selector) == [
             {
               "a",
               [{"href", "http://elixir-lang.org"}, {"class", "js-elixir js-cool"}],
               ["Elixir lang"]
             }
           ]
  end

  test "find elements by the atributte's ^= selector" do
    attribute_selector = "a[href^='http://g']"

    assert Floki.find(@html, attribute_selector) == [
             {
               "a",
               [{"href", "http://google.com"}, {"class", "js-google js-cool"}],
               ["Google"]
             }
           ]
  end

  test "find elements by the atributte's $= selector" do
    attribute_selector = "a[href$='.org']"

    assert Floki.find(@html, attribute_selector) == [
             {
               "a",
               [{"href", "http://elixir-lang.org"}, {"class", "js-elixir js-cool"}],
               ["Elixir lang"]
             }
           ]
  end

  test "find elements by the atributte's *= selector" do
    attribute_selector = "a[class*='google']"

    assert Floki.find(@html, attribute_selector) == [
             {
               "a",
               [{"href", "http://google.com"}, {"class", "js-google js-cool"}],
               ["Google"]
             }
           ]
  end

  # Floki.find/2 - Selector with descendant combinator

  test "get elements descending the parent" do
    expected = [
      {
        "img",
        [{"src", "http://twitter.com/logo.png"}, {"class", "js-twitter-logo"}],
        []
      }
    ]

    assert Floki.find(@html_with_img, "a img") == expected
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

    assert Floki.find(@html_with_img, "div.logo-container > img") == expected
    assert Floki.find(@html_with_img, "body > div.logo-container > img") == expected
    assert Floki.find(@html_with_img, "body > img") == []
  end

  test "find only immediate children elements" do
    expected = [
      {"img", [{"src", "http://facebook.com/logo.png"}], []}
    ]

    html = """
    <div>
      <p>
        <span>
          <img src="http://facebook.com/logo.png" />
        </span>
      </p>
    </div>
    """

    assert Floki.find(html, "div > p > img") == []
    assert Floki.find(html, "div > p > span > img") == expected
  end

  test "find a sibling after immediate child chain" do
    expected = [
      {
        "img",
        [{"src", "http://twitter.com/logo.png"}, {"class", "img-without-closing-tag"}],
        []
      }
    ]

    html = """
    <div>
      <p>
        <span>
          <img src="http://facebook.com/logo.png" />
          <img src="http://twitter.com/logo.png" class="img-without-closing-tag" />
        </span>
      </p>
    </div>
    """

    assert Floki.find(html, "div > p > span > img + img") == expected
  end

  # Floki.find/2 - Sibling combinator

  test "find sibling element" do
    expected = [
      {
        "div",
        [{"class", "logo-container"}],
        [
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
      }
    ]

    assert Floki.find(@html_with_img, "a + div") == expected
    assert Floki.find(@html_with_img, "a + .logo-container") == expected

    assert Floki.find(@html_with_img, "a + div #logo") == [
             {"img", [{"src", "logo.png"}, {"id", "logo"}], []}
           ]

    assert Floki.find(@html_with_img, "a + #logo") == []
  end

  # Floki.find/2 - General sibling combinator

  test "find general sibling elements" do
    expected = [
      {"a", [{"href", "http://elixir-lang.org"}, {"class", "js-elixir js-cool"}],
       ["Elixir lang"]},
      {"a", [{"href", "http://java.com"}, {"class", "js-java"}], ["Java"]}
    ]

    assert Floki.find(@html, "a.js-google ~ a") == expected
    assert Floki.find(@html, "body > div > a.js-google ~ a") == expected
    assert Floki.find(@html, "body > div ~ a") == []
    assert Floki.find(@html, "a.js-java ~ a") == []
  end

  # Floki.find/2 - Using groups with comma

  test "get multiple elements using comma" do
    expected = [
      {"img", [{"src", "http://twitter.com/logo.png"}, {"class", "js-twitter-logo"}], []},
      {"img", [{"src", "logo.png"}, {"id", "logo"}], []}
    ]

    assert Floki.find(@html_with_img, ".js-twitter-logo, #logo") == expected
  end

  test "get one element when search for multiple and just one exist" do
    expected = [{"img", [{"src", "logo.png"}, {"id", "logo"}], []}]

    assert Floki.find(@html_with_img, ".js-x-logo, #logo") == expected
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

    assert Floki.find(html, "a:nth-child(2)") == [
             {"a", [{"href", "/b"}], ["2"]}
           ]

    assert Floki.find(html, "a:nth-child(even)") == [
             {"a", [{"href", "/b"}], ["2"]},
             {"a", [{"href", "/d"}], ["4"]},
             {"a", [{"href", "/f"}], ["6"]}
           ]

    assert Floki.find(html, "a:nth-child(odd)") == [
             {"a", [{"href", "/a"}], ["1"]},
             {"a", [{"href", "/c"}], ["3"]},
             {"a", [{"href", "/e"}], ["5"]},
             {"a", [{"href", "/g"}], ["7"]}
           ]

    assert Floki.find(html, "a:first-child") == [
             {"a", [{"href", "/a"}], ["1"]}
           ]

    # same as first-child
    assert Floki.find(html, "a:nth-child(0n+1)") == [
             {"a", [{"href", "/a"}], ["1"]}
           ]

    assert Floki.find(html, "a:nth-child(3n+4)") == [
             {"a", [{"href", "/d"}], ["4"]},
             {"a", [{"href", "/g"}], ["7"]}
           ]
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

    assert Floki.find(html, "p:last-child") == [
             {"p", [], ["2"]}
           ]

    assert Floki.find(html, "div :last-child") == [
             {"p", [], ["2"]},
             {"h2", [], ["4"]}
           ]
  end

  test "get elements by nth-of-type, first-of-type, and last-of-type pseudo-classes" do
    html = """
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
    </html>
    """

    assert Floki.find(html, "a:nth-of-type(2)") == [
             {"a", [{"href", "/b"}], ["2"]}
           ]

    assert Floki.find(html, "a:nth-of-type(even)") == [
             {"a", [{"href", "/b"}], ["2"]},
             {"a", [{"href", "/d"}], ["4"]}
           ]

    assert Floki.find(html, "a:nth-of-type(odd)") == [
             {"a", [{"href", "/a"}], ["1"]},
             {"a", [{"href", "/c"}], ["3"]},
             {"a", [{"href", "/e"}], ["5"]}
           ]

    # same as nth-of-type(odd)
    assert Floki.find(html, "a:nth-of-type(2n+1)") == [
             {"a", [{"href", "/a"}], ["1"]},
             {"a", [{"href", "/c"}], ["3"]},
             {"a", [{"href", "/e"}], ["5"]}
           ]

    # same as first-of-type
    assert Floki.find(html, "a:nth-of-type(0n+1)") == [
             {"a", [{"href", "/a"}], ["1"]}
           ]

    assert Floki.find(html, "a:first-of-type") == [
             {"a", [{"href", "/a"}], ["1"]}
           ]

    assert Floki.find(html, "body :first-of-type") == [
             {"h1", [], ["Child 1"]},
             {"div", [], ["Child 2"]},
             {"a", [{"href", "/a"}], ["1"]}
           ]

    assert Floki.find(html, "body :last-of-type") == [
             {"h1", [], ["Child 1"]},
             {"div", [], ["Child 4"]},
             {"a", [{"href", "/e"}], ["5"]}
           ]
  end

  test "not pseudo-class" do
    html = """
    <html>
      <body>
        <div id="links">
          <a class="link foo">A foo</a>
          <a class="link bar" style="crazyColor">A bar</a>
          <a class="link baz">A baz</a>
        </div>
      </body>
    </html>
    """

    first_result = Floki.find(html, "a.link:not(.bar)")
    second_result = Floki.find(html, "div#links > a.link:not(.bar)")
    third_result = Floki.find(html, "a.link:not(:nth-child(2))")
    fourth_result = Floki.find(html, "a.link:not([style*=crazy])")

    expected_result = [
      {"a", [{"class", "link foo"}], ["A foo"]},
      {"a", [{"class", "link baz"}], ["A baz"]}
    ]

    assert first_result == expected_result
    assert first_result == second_result
    assert third_result == expected_result
    assert fourth_result == expected_result
  end

  test "not pseudo-class with multiple selectors" do
    html = """
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
    """

    first_result = Floki.find(html, "a.link:not(.bar, .baz)")
    second_result = Floki.find(html, "a.link:not(.bar,.baz)")
    third_result = Floki.find(html, "a.link:not(.bar):not(.baz)")
    fourth_result = Floki.find(html, "a.link:not(.bar, .bin):not(.baz)")
    fifth_result = Floki.find(html, "a.link:not([style*=crazy], .bin):not(.baz)")

    foo_match = {"a", [{"class", "link foo"}], ["A foo"]}
    bin_match = {"a", [{"class", "link bin"}], ["A bin"]}

    assert first_result == [foo_match, bin_match]
    assert second_result == [foo_match, bin_match]
    assert third_result == [foo_match, bin_match]
    assert fourth_result == [foo_match]
    assert fifth_result == [foo_match]
  end

  test "pseudo-class selector only" do
    expected = [
      {"channel", [], [{"title", [], ["A podcast"]}, {"link", [], ["www.foo.bar.com"]}]},
      {"title", [], ["A podcast"]},
      {"title", [], ["Another podcast"]}
    ]

    assert Floki.find(@xml, ":first-child") == expected
  end

  test "contains pseudo-class" do
    expected = [
      {"p", [], ["Two"]}
    ]

    assert Floki.find(@html_without_html_tag, "p:fl-contains('Two')") == expected
  end

  test "contains psuedo-class with substring" do
    expected = [
      {"title", [], ["A podcast"]},
      {"title", [], ["Another podcast"]}
    ]

    assert Floki.find(@xml, ":fl-contains(' podcast')") == expected
  end

  # Floki.find/2 - XML and invalid HTML

  test "get elements inside a XML" do
    expected = [
      {"title", [], ["A podcast"]},
      {"title", [], ["Another podcast"]}
    ]

    assert Floki.find(@xml, "title") == expected
  end

  test "find elements inside namespaces" do
    xml = "<x:foo><x:bar>42</x:bar></x:foo>"

    assert Floki.find(xml, "x | bar") == [{"x:bar", [], ["42"]}]
  end

  @tag timeout: 50
  test "find an inexistent element inside a invalid HTML" do
    assert Floki.find("something", "a") == []
    assert Floki.find("", "a") == []
    assert Floki.find("foobar", "a") == []
    assert Floki.find("foobar<a", "a") == []
  end

  # Floki.find/2 - Raw selector structs

  test "find single selector structs" do
    selector_struct = %Floki.Selector{type: "a"}
    assert Floki.find(@html, "a") == Floki.find(@html, selector_struct)
  end

  test "find multiple selector structs" do
    selector_struct_1 = %Floki.Selector{type: "a"}
    selector_struct_2 = %Floki.Selector{type: "div"}

    assert Floki.find(@html, "a,div") == Floki.find(@html, [selector_struct_1, selector_struct_2])
  end

  # Floki.attribute/3

  test "get attribute values from elements with a given class" do
    class_selector = ".js-cool"
    expected_hrefs = ["http://google.com", "http://elixir-lang.org"]

    assert Floki.attribute(@html, class_selector, "href") == expected_hrefs
  end

  test "get attributes from elements" do
    class_selector = ".js-cool"
    expected_hrefs = ["http://google.com", "http://elixir-lang.org"]
    elements = Floki.find(@html, class_selector)

    assert Floki.attribute(elements, "href") == expected_hrefs
  end

  # Floki.attribute/2

  test "get attributes from an element found by id" do
    html = "<div id=important-el></div>"

    elements = Floki.find(html, "#important-el")

    assert Floki.attribute(elements, "id") == ["important-el"]
  end

  test "returns an empty list when attribute does not exist" do
    class_selector = ".js-cool"
    elements = Floki.find(@html, class_selector)

    assert Floki.attribute(elements, "title") == []
  end

  test "parses the HTML before search for attributes" do
    url = "https://google.com"

    assert Floki.attribute("<a href=#{url}>Google</a>", "href") == [url]
  end

  test "Floki.map/2 transforms nodes" do
    elements = Floki.find(@html, ".content")

    transformation = fn
      {"a", [{"href", x} | xs]} ->
        {"a", [{"href", String.replace(x, "http://", "https://")} | xs]}

      x ->
        x
    end

    result = Floki.map(elements, transformation)

    hrefs_after =
      result
      |> Floki.find("a")
      |> Floki.attribute("href")

    assert hrefs_after == ["https://google.com", "https://elixir-lang.org", "https://java.com"]
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

    assert Floki.find(html, ".messageBox p") == [
             {"p", [], ["There has been an error in your account."]}
           ]
  end

  test "descendant matches are returned in order and without duplicates" do
    html = """
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
              <td class="data-view"><span class="surname">Silva</span>, <span>Joana</span> <span>Maria</span></td>
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
    """

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

    assert Floki.find(html, "table[summary='license-detail'] td.data-view") == expected
  end

  test "finding doesn't fail when body includes unencoded angles" do
    [{tag_name, _, _}] = Floki.find(@html_with_wrong_angles_encoding, "span")
    assert tag_name == "span"
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

    assert Floki.find(html, ".text") == [{"div", [{"class", "text"}], ["test"]}]
  end

  test "finding doesn't fail when body includes xml version prefix" do
    [{tag_name, _, _}] = Floki.find(@html_with_xml_prefix, "#anchor")
    assert tag_name == "a"
  end

  test "we can produce raw_html if it has an xml version prefix" do
    processed_html = @html_with_xml_prefix |> Floki.parse() |> Floki.raw_html()
    assert String.starts_with?(processed_html, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
  end

  test "change tag attributes" do
    html = """
    <a class="change" href=\"http://not.url/changethis/\">link</a>
    <a href=\"http://not.url/changethisbutnotrly/\">link</a>
    <a class="change" href=\"http://not.url/changethis/\">link</a>
    """

    expects = """
    <a class="change" href=\"http://not.url/changed/\">link</a>
    <a href=\"http://not.url/changethisbutnotrly/\">link</a>
    <a class="change" href=\"http://not.url/changed/\">link</a>
    """

    result =
      html
      |> Floki.attr(".change", "href", fn inner_html ->
        String.replace(inner_html, "changethis", "changed")
      end)
      |> Floki.raw_html()

    assert result == String.replace(expects, "\n", "")
  end

  test "changing attribute don't change the order of nodes" do
    html =
      ~s(<p>a<em>b</em>c<a href="z">d</a></p><p>e</p><p><a href="f"><strong>g</strong></a>.<em>h</em>i</p><p><strong>j</strong>k<a href="m">n</a>o</p><p><em>p</em>q<em>r</em>s<a href="t">u</a></p>)

    result =
      html
      |> Floki.attr("a", "href", fn href ->
        href
      end)
      |> Floki.raw_html()

    assert result == html
  end
end
