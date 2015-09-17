defmodule FlokiTest do
  use ExUnit.Case, assyc: true

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
  <img src="http://twitter.com/logo.png" class="img-without-closing-tag">
  <img src="logo.png" id="logo" />
  </body>
  </html>
  """

  @html_without_html_tag """
  <h2 class="js-cool">One</h2>
  <p>Two</p>
  <p>Three</p>
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

  test "parse simple HTML" do
    parsed = Floki.parse(@html)

    assert parsed == {
      "html", [],
      [{"head", [], [{"title", [], ["Test"]}]},
        {"body", [],
          [{"div", [{"class", "content"}],
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
          }]
        }
       ]
      }
  end

  # Floki.parse/1

  test "parse html_without_html_tag" do
    parsed = Floki.parse(@html_without_html_tag)
    assert parsed == [
      {"h2", [{"class", "js-cool"}], ["One"]},
      {"p", [], ["Two"]},
      {"p", [], ["Three"]}
    ]
  end

  # Floki.find/2 - Classes

  test "find elements with a given class" do
    class_selector = ".js-cool"

    assert Floki.find(@html, class_selector) == [
      {"a", [
          {"href", "http://google.com"},
          {"class", "js-google js-cool"}
        ], ["Google"]},
      {"a", [
          {"href", "http://elixir-lang.org"},
          {"class", "js-elixir js-cool"}],
        ["Elixir lang"]}
    ]
  end

  test "find elements with two classes combined" do
    class_selector = ".js-cool.js-elixir"

    assert Floki.find(@html, class_selector) == [
      {"a", [
          {"href", "http://elixir-lang.org"},
          {"class", "js-elixir js-cool"}],
        ["Elixir lang"]}
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

    assert Floki.find(@html_with_img, class_selector) == [{
      "img", [
          {"src", "http://twitter.com/logo.png"},
          {"class", "js-twitter-logo"}], []
      }]
  end

  test "find element that does not close the tag" do
    class_selector = ".img-without-closing-tag"

    assert Floki.find(@html_with_img, class_selector) == [{
        "img", [
          {"src", "http://twitter.com/logo.png"},
          {"class", "img-without-closing-tag"}
        ], []
      }]
  end

  test "does not find elements" do
    class_selector = ".nothing"

    assert Floki.find(@html, class_selector) == []
  end

  # Floki.find/2 - Tag name

  test "select elements by tag name" do
    tag_name = "a"
    elements = Floki.find(@html_with_img, tag_name)

    assert elements == [{
        "a",
        [{"href", "http://twitter.com"}],
        [{"img", [{"src", "http://twitter.com/logo.png"},
                  {"class", "js-twitter-logo"}], []}]
      }]
  end

  # Floki.find/2 - ID

  test "find element by id" do
    id = "#logo"

    assert Floki.find(@html_with_img, id) == [{
      "img",
      [{"src", "logo.png"}, {"id", "logo"}],
      []
    }]
  end

  ## Floki.find/2 - Attributes

  test "find elements with a tag and a given attribute value with shorthand syntax" do
    attribute_selector = "a[data-action=lolcats]"

    assert Floki.find(@html_with_data_attributes, attribute_selector) == [
      {
        "a", [
          {"href", "http://google.com"},
          {"class", "js-google js-cool"},
          {"data-action", "lolcats"}],
        ["Google"]
      }
    ]
  end

  test "find elements only by given attribute value with shorthand syntax" do
    attribute_selector = "[data-action=lolcats]"

    assert Floki.find(@html_with_data_attributes, attribute_selector) == [
      {
        "a", [
          {"href", "http://google.com"},
          {"class", "js-google js-cool"},
          {"data-action", "lolcats"}],
        ["Google"]
      }
    ]
  end

  test "find elements by the atributte's |= selector" do
    attribute_selector = "a[href|='http://elixir']"

    assert Floki.find(@html, attribute_selector) == [
      {
        "a", [
          {"href", "http://elixir-lang.org"},
          {"class", "js-elixir js-cool"}],
        ["Elixir lang"]
      }
    ]
  end

  test "find elements by the atributte's ^= selector" do
    attribute_selector = "a[href^='http://g']"

    assert Floki.find(@html, attribute_selector) == [
      {
        "a", [
          {"href", "http://google.com"},
          {"class", "js-google js-cool"}],
        ["Google"]
      }
    ]
  end

  test "find elements by the atributte's $= selector" do
    attribute_selector = "a[href$='.org']"

    assert Floki.find(@html, attribute_selector) == [
      {
        "a", [
          {"href", "http://elixir-lang.org"},
          {"class", "js-elixir js-cool"}],
        ["Elixir lang"]
      }
    ]
  end

  test "find elements by the atributte's *= selector" do
    attribute_selector = "a[class*='google']"

    assert Floki.find(@html, attribute_selector) == [
      {
        "a", [
          {"href", "http://google.com"},
          {"class", "js-google js-cool"}],
        ["Google"]
      }
    ]
  end

  # Floki.find/2 - Selector with descendant combinator

  test "get elements descending the parent" do
    expected = [
      {
        "img", [
          {"src", "http://twitter.com/logo.png"},
          {"class", "js-twitter-logo"}],
        []
      }
    ]

    assert Floki.find(@html_with_img, "a img") == expected
  end

  # Floki.find/2 - Using groups with comma

  test "get multiple elements using comma" do
    expected = [
      {"img", [
          {"src", "http://twitter.com/logo.png"},
          {"class", "js-twitter-logo"}], []},
      {"img", [
          {"src", "logo.png"},
          {"id", "logo"}], []}
    ]

    assert Floki.find(@html_with_img, ".js-twitter-logo, #logo") == expected
  end

  test "get one element when search for multiple and just one exist" do
    expected = [ {"img", [ {"src", "logo.png"}, {"id", "logo"}], []} ]

    assert Floki.find(@html_with_img, ".js-x-logo, #logo") == expected
  end

  # Floki.find/2 - XML and invalid HTML

  test "get elements inside a XML" do
    expected = [
      {"title", [], ["A podcast"]},
      {"title", [], ["Another podcast"]}
    ]

    assert Floki.find(@xml, "title") == expected
  end

  @tag timeout: 1000
  test "find an inexistent element inside a invalid HTML" do
    assert Floki.find("something", "a") == []
    assert Floki.find("", "a") == []
    assert Floki.find("foobar", "a") == []
    assert Floki.find("foobar<a", "a") == []
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
end
