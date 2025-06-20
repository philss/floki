defmodule Floki.Selector.ParserTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureLog

  require Logger

  alias Floki.Selector
  alias Selector.{Parser, Functional, Combinator, AttributeSelector, PseudoClass}

  def tokenize(string) do
    Selector.Tokenizer.tokenize(string)
  end

  def log_capturer(string) do
    fn ->
      Parser.parse(string)
    end
  end

  test "escaped colons in class names" do
    tokens = tokenize("a.xs\\:red-500")

    assert Parser.parse(tokens) == [
             %Selector{type: "a", classes: ["xs:red-500"], pseudo_classes: []}
           ]

    tokens = tokenize("a.xs\\:red-500\\:big")

    assert Parser.parse(tokens) == [
             %Selector{type: "a", classes: ["xs:red-500:big"], pseudo_classes: []}
           ]
  end

  test "reorders classes in selector to improve matching performance" do
    tokens = tokenize(".small.longer.even-longer")

    assert Parser.parse(tokens) == [
             %Selector{classes: ["even-longer", "longer", "small"]}
           ]
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

  test "id containing periods" do
    tokens = tokenize("#my\\.example\\.com-port-filters.big.blue")

    assert Parser.parse(tokens) == [
             %Selector{id: "my.example.com-port-filters", classes: ["blue", "big"]}
           ]
  end

  test "class with attributes" do
    tokens =
      tokenize("""
      .link[href='settings.html'][data-env|=test][section~=admin][page^=pass][page$=auth][title*=chan][name='test' i]
      """)

    assert Parser.parse(tokens) == [
             %Selector{
               classes: ["link"],
               attributes: [
                 %AttributeSelector{
                   attribute: "name",
                   flag: "i",
                   match_type: :equal,
                   value: "test"
                 },
                 %AttributeSelector{
                   match_type: :substring_match,
                   attribute: "title",
                   value: "chan"
                 },
                 %AttributeSelector{match_type: :suffix_match, attribute: "page", value: "auth"},
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

  test "not pseudo-class - simple class" do
    assert Parser.parse("a.foo:not(.bar)") == [
             %Selector{
               type: "a",
               classes: ["foo"],
               pseudo_classes: [%PseudoClass{name: "not", value: [%Selector{classes: ["bar"]}]}]
             }
           ]
  end

  test "not pseudo-class - two classes" do
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
  end

  test "not pseudo-class - double not - accumulative" do
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
  end

  test "not pseudo-class - with pseudo nth-child inside and descendant outside" do
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
  end

  test "not pseudo-class - ignore combinators inside" do
    capture_log(fn ->
      assert Parser.parse("a.foo:not(.bar > .baz)") == [
               %Selector{
                 type: "a",
                 classes: ["foo"],
                 pseudo_classes: []
               }
             ]
    end)

    assert capture_log(log_capturer("a.foo:not(.bar > .baz)")) =~
             "module=Floki.Selector.Parser  Only simple selectors are allowed in :not() pseudo-class. Ignoring."
  end

  test "not pseudo-class - with attribute selector" do
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
  end

  test "not pseudo-class - with attribute selector and class" do
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
  end

  test "not pseudo-class and attr selection with another selector" do
    assert Parser.parse("a.foo:not([class]), hr") == [
             %Selector{
               type: "a",
               classes: ["foo"],
               pseudo_classes: [
                 %PseudoClass{
                   name: "not",
                   value: [%Selector{attributes: [%AttributeSelector{attribute: "class"}]}]
                 }
               ]
             },
             %Selector{
               type: "hr",
               classes: [],
               pseudo_classes: []
             }
           ]
  end

  test "has pseudo-class - simple class" do
    assert Parser.parse("a.foo:has(.bar)") == [
             %Selector{
               type: "a",
               classes: ["foo"],
               pseudo_classes: [%PseudoClass{name: "has", value: [%Selector{classes: ["bar"]}]}]
             }
           ]
  end

  test "has pseudo-class - using fl-contains pseudo class" do
    assert Parser.parse("a.foo:has(:fl-contains('test'))") == [
             %Selector{
               type: "a",
               classes: ["foo"],
               pseudo_classes: [
                 %PseudoClass{
                   name: "has",
                   value: [
                     %Selector{
                       pseudo_classes: [
                         %Floki.Selector.PseudoClass{
                           name: "fl-contains",
                           value: "test"
                         }
                       ]
                     }
                   ]
                 }
               ]
             }
           ]
  end

  test "warn unknown tokens" do
    assert capture_log(log_capturer("a { b")) =~
             ~r/module=Floki\.Selector\.Parser  Unknown token ('{'|~c"{")\. Ignoring/

    assert capture_log(log_capturer("a + b@")) =~
             ~r/module=Floki\.Selector\.Parser  Unknown token ('@'|~c"@")\. Ignoring/
  end

  test "empty selector" do
    tokens = tokenize("")

    assert Parser.parse(tokens) == []
  end
end
