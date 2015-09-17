defmodule Floki.SelectorParserTest do
  use ExUnit.Case

  alias Floki.Selector
  alias Floki.Combinator
  alias Floki.AttributeSelector
  alias Floki.SelectorParser

  def tokenize(string) do
    Floki.SelectorTokenizer.tokenize(string)
  end

  test "type with classes" do
    tokens = tokenize("a.link.button")

    assert SelectorParser.parse(tokens) == %Selector{type: "a",
      classes: ["button", "link"]}
  end

  test "type with id" do
    tokens = tokenize("img#logo")

    assert SelectorParser.parse(tokens) == %Selector{type: "img", id: "logo"}
  end

  test "class with attributes" do
    tokens = tokenize("""
    .link[href='settings.html'][data-env|=test][section~=admin][page^=pass][page$=auth][title*=chan]
    """)

    assert SelectorParser.parse(tokens) == %Selector{
      classes: ["link"],
      attributes: [
        %AttributeSelector{match_type: :substring_match,
                           attribute: "title",
                           value: "chan"},
        %AttributeSelector{match_type: :sufix_match,
                           attribute: "page",
                           value: "auth"},
        %AttributeSelector{match_type: :prefix_match,
                           attribute: "page",
                           value: "pass"},
        %AttributeSelector{match_type: :includes,
                           attribute: "section",
                           value: "admin"},
        %AttributeSelector{match_type: :dash_match,
                           attribute: "data-env",
                           value: "test"},
        %AttributeSelector{match_type: :equal,
                           attribute: "href",
                           value: "settings.html"}
      ]}
  end

  test "descendant selector" do
    tokens = tokenize("a b.foo c")

    assert SelectorParser.parse(tokens) == %Selector{
      type: "a",
      combinator: %Combinator{
        match_type: :descendant,
        selector: %Selector{type: "b",
                            classes: ["foo"],
                            combinator: %Combinator{match_type: :descendant,
                                                    selector: %Selector{type: "c"}}}
      }
    }
  end

  test "child selector" do
    tokens = tokenize("a > b")

    assert SelectorParser.parse(tokens) == %Selector{
      type: "a",
      combinator: %Combinator{
        match_type: :child,
        selector: %Selector{type: "b"}
      }
    }
  end
end
