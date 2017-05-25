defmodule Floki.SelectorParserTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureLog

  require Logger

  alias Floki.{Selector, Combinator, AttributeSelector, SelectorParser}
  alias Floki.Selector.PseudoClass

  setup_all do
    :ok = Logger.remove_backend(:console)
    on_exit(fn -> Logger.add_backend(:console, flush: true) end)
  end

  def tokenize(string) do
    Floki.SelectorTokenizer.tokenize(string)
  end

  def log_capturer(string) do
    fn ->
      SelectorParser.parse(string)
    end
  end

  test "multiple selectors" do
    tokens = tokenize("ol, ul")

    assert SelectorParser.parse(tokens) == [
      %Selector{type: "ol"},
      %Selector{type: "ul"}
    ]
  end

  test "type with classes" do
    tokens = tokenize("a.link.button")

    assert SelectorParser.parse(tokens) == [%Selector{type: "a", classes: ["button", "link"]}]
  end

  test "type with id" do
    tokens = tokenize("img#logo")

    assert SelectorParser.parse(tokens) == [%Selector{type: "img", id: "logo"}]
  end

  test "class with attributes" do
    tokens = tokenize("""
    .link[href='settings.html'][data-env|=test][section~=admin][page^=pass][page$=auth][title*=chan]
    """)

    assert SelectorParser.parse(tokens) == [
      %Selector{
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
        ]
      }
    ]
  end

  test "descendant selector" do
    tokens = tokenize("a b.foo c")

    assert SelectorParser.parse(tokens) == [
      %Selector{
        type: "a",
        combinator: %Combinator{
          match_type: :descendant,
          selector: %Selector{type: "b",
                              classes: ["foo"],
                              combinator: %Combinator{match_type: :descendant,
                                                      selector: %Selector{type: "c"}}}
        }
      }
    ]
  end

  test "child selector" do
    tokens = tokenize("a > b")

    assert SelectorParser.parse(tokens) == [
      %Selector{
        type: "a",
        combinator: %Combinator{
          match_type: :child,
          selector: %Selector{type: "b"}
        }
      }
    ]
  end

  test "namespace" do
    tokens = tokenize("xyz | a")

    assert SelectorParser.parse(tokens) == [
      %Selector{
        type: "a",
        namespace: "xyz"
      }
    ]
  end

  test "nth-child pseudo-class" do
    tokens = tokenize("li:nth-child(2)")

    assert SelectorParser.parse(tokens) == [
      %Selector{
        type: "li",
        pseudo_classes: [%PseudoClass{name: "nth-child", value: 2}],
      }
    ]

    tokens = tokenize("tr:nth-child(odd)")

    assert SelectorParser.parse(tokens) == [
      %Selector{
        type: "tr",
        pseudo_classes: [%PseudoClass{name: "nth-child", value: "odd"}]
      }
    ]

    tokens = tokenize("td:nth-child(even)")

    assert SelectorParser.parse(tokens) == [
      %Selector{
        type: "td",
        pseudo_classes: [%PseudoClass{name: "nth-child", value: "even"}]
      }
    ]

    tokens = tokenize("div:nth-child(-n+3)")

    assert SelectorParser.parse(tokens) == [
      %Selector{
        type: "div",
        pseudo_classes: [%PseudoClass{name: "nth-child", value: "-n+3"}]
      }
    ]
  end

  test "not pseudo-class" do
    assert SelectorParser.parse("a.foo:not(.bar)") == [
      %Selector{
        type: "a",
        classes: ["foo"],
        pseudo_classes: [%PseudoClass{name: "not", value: [%Selector{classes: ["bar"]}]}]
      }
    ]

    assert SelectorParser.parse("a.foo:not(.bar, .baz)") == [
      %Selector{
        type: "a",
        classes: ["foo"],
        pseudo_classes: [%PseudoClass{name: "not", value: [%Selector{classes: ["baz"]}, %Selector{classes: ["bar"]}]}]
      }
    ]

    assert SelectorParser.parse("a.foo:not(.bar):not(.baz)") == [
      %Selector{
        type: "a",
        classes: ["foo"],
        pseudo_classes: [
          %PseudoClass{name: "not", value: [%Selector{classes: ["baz"]}]},
          %PseudoClass{name: "not", value: [%Selector{classes: ["bar"]}]}
        ]
      }
    ]

    assert SelectorParser.parse("li:not(:nth-child(2)) a") == [
      %Selector{
        type: "li",
        pseudo_classes: [
          %PseudoClass{name: "not",
                       value: [
                         %Selector{pseudo_classes: [
                                      %PseudoClass{name: "nth-child",
                                                   value: 2}]}]}],
        combinator: %Combinator{match_type: :descendant,
                                selector: %Selector{type: "a"}}
      }
    ]

    assert SelectorParser.parse("a.foo:not(.bar > .baz)") == [
      %Selector{
        type: "a",
        classes: ["foo"],
        pseudo_classes: []
      }
    ]

    assert SelectorParser.parse("a.foo:not([style*=crazy])") == [
      %Selector{
        attributes: [],
        classes: ["foo"],
        pseudo_classes: [
          %PseudoClass{
            name: "not",
            value: [%Selector{attributes: [%Floki.AttributeSelector{attribute: "style", match_type: :substring_match, value: "crazy"}], classes: [], pseudo_classes: []}]
          }
        ],
        type: "a"
      }
    ]

    assert SelectorParser.parse("a.foo:not([style*=crazy], .bar)") == [
      %Selector{
        attributes: [],
        classes: ["foo"],
        pseudo_classes: [
          %PseudoClass{
            name: "not",
            value: [
              %Selector{attributes: [], classes: ["bar"], pseudo_classes: []},
              %Selector{attributes: [%Floki.AttributeSelector{attribute: "style", match_type: :substring_match, value: "crazy"}], classes: [], pseudo_classes: []}
            ]
          }
        ],
        type: "a"
      }
    ]

    assert capture_log(log_capturer("a.foo:not(.bar > .baz)")) =~
            "module=Floki.SelectorParser  Only simple selectors are allowed in :not() pseudo-class. Ignoring."
  end

  test "warn unknown tokens" do
    assert capture_log(log_capturer("a { b")) =~ "module=Floki.SelectorParser  Unknown token '{'. Ignoring."
    assert capture_log(log_capturer("a + b@")) =~ "module=Floki.SelectorParser  Unknown token '@'. Ignoring."
  end
end
