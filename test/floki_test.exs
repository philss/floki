defmodule FlokiTest do
  use ExUnit.Case

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

  test "parse simple html" do
    parsed = Floki.parse(@html)

    assert parsed == {"html", [],
                        [{"head", [], [{"title", [], ["Test"]}]},
                          {"body", [],
                            [{"div", [{"class", "content"}],
                                [{"a", [{"href", "http://google.com"}, {"class", "js-google js-cool"}], ["Google"]},
                                  {"a", [{"href", "http://elixir-lang.org"}, {"class", "js-elixir js-cool"}], ["Elixir lang"]},
                                  {"a", [{"href", "http://java.com"}, {"class", "js-java"}], ["Java"]}]}]}]}
  end

  test "find elements with a given class" do
    class_selector = ".js-cool"

    assert Floki.find(@html, class_selector) == [{"a", [{"href", "http://google.com"}, {"class", "js-google js-cool"}], ["Google"]},
      {"a", [{"href", "http://elixir-lang.org"}, {"class", "js-elixir js-cool"}], ["Elixir lang"]}]
  end

  test "find element that does not have child node" do
    class_selector = ".js-twitter-logo"

    assert Floki.find(@html_with_img, class_selector) == [{"img", [{"src", "http://twitter.com/logo.png"}, {"class", "js-twitter-logo"}], []}]
  end

  test "find element that does close the tag" do
    class_selector = ".img-without-closing-tag"

    assert Floki.find(@html_with_img, class_selector) == [{"img", [{"src", "http://twitter.com/logo.png"}, {"class", "img-without-closing-tag"}], []}]
  end

  test "does not find elements" do
    class_selector = ".nothing"

    assert Floki.find(@html, class_selector) == []
  end

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

  test "get attributes from an element found by id" do
    html = "<div id=important-el></div>"

    attrs = Floki.find(html, "#important-el") |> Floki.attribute("id")

    assert attrs == ["important-el"]
  end

  test "get attributes that does not exist" do
    class_selector = ".js-cool"
    elements = Floki.find(@html, class_selector)

    assert Floki.attribute(elements, "title") == []
  end

  test "select elements by tag name" do
    tag_name = "a"
    elements = Floki.find(@html_with_img, tag_name)

    assert elements == [{"a", [{"href", "http://twitter.com"}], [{"img", [{"src", "http://twitter.com/logo.png"}, {"class", "js-twitter-logo"}], []}]}]
  end

  test "find element by id" do
    id = "#logo"

    assert Floki.find(@html_with_img, id) == { "img", [{"src", "logo.png"}, {"id", "logo"}], [] }
  end

  test "get text from element" do
    class_selector = ".js-google"
    text = Floki.find(@html, class_selector) |> Floki.text

    assert text == "Google"
  end

  test "get text from elements" do
    class_selector = ".js-cool"
    text = Floki.find(@html, class_selector) |> Floki.text

    assert text == "Google Elixir lang"
  end

  test "get text from the element (id selector)" do
    id_selector = "#with-text"
    html = """
      <div><p id="with-text"><span>something else</span>the answer</p></div>
    """
    text = Floki.find(html, id_selector) |> Floki.text

    assert text == "the answer"
  end

  test "get text from a html string" do
    assert Floki.text("<p><span>something else</span>hello world</p>") == "hello world"
  end
end
