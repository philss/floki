defmodule FlokiTest do
  use ExUnit.Case

  @html """
  <html>
  <head>
  <title>Test</title>
  </head>
  <body>
    <div class='content'>
      <a href='http://google.com' class='js-google js-cool'>Google</a>
      <a href='http://elixir-lang.org' class='js-elixir js-cool'>Elixir lang</a>
      <a href='http://java.com' class='js-java'>Java</a>
    </div>
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

  test "does not find elements" do
    class_selector = ".nothing"

    assert Floki.find(@html, class_selector) == []
  end

  test "matching a class by a given name" do
    class_name = "a-class"
    attributes = [{"class", class_name}, {"title", "a title"}]

    assert Floki.class_match?(attributes, class_name)
  end

  test "does not match by class name" do
    class_name = "a-class"
    attributes = [{"class", "another-class"}, {"title", "a title"}]

    refute Floki.class_match?(attributes, class_name)
  end

  test "does not match when attributes list is empty" do
    class_name = "a-class"
    attributes = []

    refute Floki.class_match?(attributes, class_name)
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

  test "get attributes that does not exist" do
    class_selector = ".js-cool"
    elements = Floki.find(@html, class_selector)

    assert Floki.attribute(elements, "title") == []
  end
end
