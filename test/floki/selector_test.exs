defmodule Floki.SelectorTest do
  use ExUnit.Case, async: true

  alias Floki.Selector
  alias Selector.{AttributeSelector, PseudoClass, Combinator}

  test "to_string/1 (String.Chars protocol)" do
    attribute1 = %AttributeSelector{match_type: :equal, attribute: "href", value: "#home"}
    pseudo_class1 = %PseudoClass{name: "nth-child", value: 7}

    selector = %Selector{
      namespace: "ns",
      id: "main",
      type: "div",
      classes: ["foo", "bar"],
      attributes: [attribute1],
      pseudo_classes: [pseudo_class1],
      combinator: %Combinator{
        match_type: :adjacent_sibling,
        selector: %Selector{type: "a"}
      }
    }

    assert to_string(selector) == "ns | div#main.foo.bar[href='#home']:nth-child(7) + a"

    pseudo_class2 = %PseudoClass{name: "first"}
    assert to_string(%Selector{type: "li", pseudo_classes: [pseudo_class2]}) == "li:first"
  end
end
