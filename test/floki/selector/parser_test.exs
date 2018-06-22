defmodule Floki.Selector.ParserTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureLog

  require Logger

  alias Floki.Selector
  alias Selector.{Parser, Functional, Combinator, AttributeSelector, PseudoClass}

  setup_all do
    :ok = Logger.remove_backend(:console)
    on_exit(fn -> Logger.add_backend(:console, flush: true) end)
  end

  def tokenize(string) do
    Selector.Tokenizer.tokenize(string)
  end

  def log_capturer(string) do
    fn ->
      Parser.parse(string)
    end
  end

  test "multiple selectors" do
    tokens = tokenize("ol, ul")

    assert Parser.parse(tokens) == [
             %Selector{type: "ol"},
             %Selector{type: "ul"}
           ]
  end

  test "type with classes" do
    tokens = tokenize("a.link.button")

    assert Parser.parse(tokens) == [%Selector{type: "a", classes: ["button", "link"]}]
  end

  test "type with id" do
    tokens = tokenize("img#logo")

    assert Parser.parse(tokens) == [%Selector{type: "img", id: "logo"}]
  end

  test "class with attributes" do
    tokens =
      tokenize("""
      .link[href='settings.html'][data-env|=test][section~=admin][page^=pass][page$=auth][title*=chan]
      """)

    assert Parser.parse(tokens) == [
             %Selector{
               classes: ["link"],
               attributes: [
                 %AttributeSelector{
                   match_type: :substring_match,
                   attribute: "title",
                   value: "chan"
                 },
                 %AttributeSelector{match_type: :sufix_match, attribute: "page", value: "auth"},
                 %AttributeSelector{match_type: :prefix_match, attribute: "page", value: "pass"},
                 %AttributeSelector{match_type: :includes, attribute: "section", value: "admin"},
                 %AttributeSelector{
                   match_type: :dash_match,
                   attribute: "data-env",
                   value: "test"
                 },
                 %AttributeSelector{match_type: :equal, attribute: "href", value: "settings.html"}
               ]
             }
           ]
  end

  test "descendant selector" do
    tokens = tokenize("a b.foo c")

    assert Parser.parse(tokens) == [
             %Selector{
               type: "a",
               combinator: %Combinator{
                 match_type: :descendant,
                 selector: %Selector{
                   type: "b",
                   classes: ["foo"],
                   combinator: %Combinator{
                     match_type: :descendant,
                     selector: %Selector{type: "c"}
                   }
                 }
               }
             }
           ]
  end

  test "multiple descendant selectors" do
    tokens = tokenize("a b.foo c, ul a[class=bar]")

    assert Parser.parse(tokens) == [
             %Selector{
               type: "a",
               combinator: %Combinator{
                 match_type: :descendant,
                 selector: %Selector{
                   type: "b",
                   classes: ["foo"],
                   combinator: %Combinator{
                     match_type: :descendant,
                     selector: %Selector{type: "c"}
                   }
                 }
               }
             },
             %Selector{
               type: "ul",
               combinator: %Combinator{
                 match_type: :descendant,
                 selector: %Selector{
                   attributes: [
                     %AttributeSelector{attribute: "class", match_type: :equal, value: "bar"}
                   ],
                   classes: [],
                   pseudo_classes: [],
                   type: "a"
                 }
               }
             }
           ]
  end

  test "child selector" do
    tokens = tokenize("a > b")

    assert Parser.parse(tokens) == [
             %Selector{
               type: "a",
               combinator: %Combinator{
                 match_type: :child,
                 selector: %Selector{type: "b"}
               }
             }
           ]
  end

  test "multiple child selectors" do
    tokens = tokenize("a > b, ol > .foo")

    assert Parser.parse(tokens) == [
             %Selector{
               type: "a",
               combinator: %Combinator{
                 match_type: :child,
                 selector: %Selector{type: "b"}
               }
             },
             %Selector{
               type: "ol",
               combinator: %Combinator{
                 match_type: :child,
                 selector: %Selector{attributes: [], classes: ["foo"], pseudo_classes: []}
               }
             }
           ]
  end

  test "namespace" do
    tokens = tokenize("xyz | a")

    assert Parser.parse(tokens) == [
             %Selector{
               type: "a",
               namespace: "xyz"
             }
           ]
  end

  test "nth-child pseudo-class" do
    tokens = tokenize("li:nth-child(2)")

    assert Parser.parse(tokens) == [
             %Selector{
               type: "li",
               pseudo_classes: [%PseudoClass{name: "nth-child", value: 2}]
             }
           ]

    tokens = tokenize("tr:nth-child(odd)")

    assert Parser.parse(tokens) == [
             %Selector{
               type: "tr",
               pseudo_classes: [%PseudoClass{name: "nth-child", value: "odd"}]
             }
           ]

    tokens = tokenize("td:nth-child(even)")

    assert Parser.parse(tokens) == [
             %Selector{
               type: "td",
               pseudo_classes: [%PseudoClass{name: "nth-child", value: "even"}]
             }
           ]

    tokens = tokenize("div:nth-child(-n+3)")

    assert [
             %Selector{
               type: "div",
               pseudo_classes: [
                 %PseudoClass{name: "nth-child", value: %Functional{a: -1, b: 3, stream: _}}
               ]
             }
           ] = Parser.parse(tokens)
  end

  test "not pseudo-class" do
    assert Parser.parse("a.foo:not(.bar)") == [
             %Selector{
               type: "a",
               classes: ["foo"],
               pseudo_classes: [%PseudoClass{name: "not", value: [%Selector{classes: ["bar"]}]}]
             }
           ]

    assert Parser.parse("a.foo:not(.bar, .baz)") == [
             %Selector{
               type: "a",
               classes: ["foo"],
               pseudo_classes: [
                 %PseudoClass{
                   name: "not",
                   value: [%Selector{classes: ["baz"]}, %Selector{classes: ["bar"]}]
                 }
               ]
             }
           ]

    assert Parser.parse("a.foo:not(.bar):not(.baz)") == [
             %Selector{
               type: "a",
               classes: ["foo"],
               pseudo_classes: [
                 %PseudoClass{name: "not", value: [%Selector{classes: ["baz"]}]},
                 %PseudoClass{name: "not", value: [%Selector{classes: ["bar"]}]}
               ]
             }
           ]

    assert Parser.parse("li:not(:nth-child(2)) a") == [
             %Selector{
               type: "li",
               pseudo_classes: [
                 %PseudoClass{
                   name: "not",
                   value: [%Selector{pseudo_classes: [%PseudoClass{name: "nth-child", value: 2}]}]
                 }
               ],
               combinator: %Combinator{match_type: :descendant, selector: %Selector{type: "a"}}
             }
           ]

    assert Parser.parse("a.foo:not(.bar > .baz)") == [
             %Selector{
               type: "a",
               classes: ["foo"],
               pseudo_classes: []
             }
           ]

    assert Parser.parse("a.foo:not([style*=crazy])") == [
             %Selector{
               attributes: [],
               classes: ["foo"],
               pseudo_classes: [
                 %PseudoClass{
                   name: "not",
                   value: [
                     %Selector{
                       attributes: [
                         %AttributeSelector{
                           attribute: "style",
                           match_type: :substring_match,
                           value: "crazy"
                         }
                       ],
                       classes: [],
                       pseudo_classes: []
                     }
                   ]
                 }
               ],
               type: "a"
             }
           ]

    assert Parser.parse("a.foo:not([style*=crazy], .bar)") == [
             %Selector{
               attributes: [],
               classes: ["foo"],
               pseudo_classes: [
                 %PseudoClass{
                   name: "not",
                   value: [
                     %Selector{attributes: [], classes: ["bar"], pseudo_classes: []},
                     %Selector{
                       attributes: [
                         %AttributeSelector{
                           attribute: "style",
                           match_type: :substring_match,
                           value: "crazy"
                         }
                       ],
                       classes: [],
                       pseudo_classes: []
                     }
                   ]
                 }
               ],
               type: "a"
             }
           ]

    assert capture_log(log_capturer("a.foo:not(.bar > .baz)")) =~
             "module=Floki.Selector.Parser  Only simple selectors are allowed in :not() pseudo-class. Ignoring."
  end

  test "warn unknown tokens" do
    assert capture_log(log_capturer("a { b")) =~
             "module=Floki.Selector.Parser  Unknown token '{'. Ignoring."

    assert capture_log(log_capturer("a + b@")) =~
             "module=Floki.Selector.Parser  Unknown token '@'. Ignoring."
  end
end
