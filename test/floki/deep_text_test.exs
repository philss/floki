defmodule Floki.DeepTextTest do
  use ExUnit.Case, async: true

  doctest Floki.DeepText

  test "text from simple node" do
    node = {"a", [], ["Google"]}

    assert Floki.DeepText.get(node) == "Google"
  end

  test "text from simple node with separator" do
    node = {"a", [], ["Google"]}

    assert Floki.DeepText.get(node, " ") == "Google"
  end

  test "extracts text from text input" do
    html = "<input value='foo' />"
    {:ok, node} = Floki.parse_document(html)

    assert Floki.DeepText.get(node, " ", true) == "foo"
  end

  test "extracts text from textarea" do
    html = "<textarea value='bar' />"
    {:ok, node} = Floki.parse_document(html)

    assert Floki.DeepText.get(node, " ", true) == "bar"
  end

  test "extracts text from nested inputs" do
    node =
      {"div", [],
       [
         {"input", [{"value", "bar"}], []}
       ]}

    assert Floki.DeepText.get(node, " ", true) == "bar"
  end

  test "text from a list of deep nodes" do
    nodes = [
      {
        "div",
        [],
        [
          "This is a text",
          {
            "p",
            [],
            [" that is ", {"strong", [], ["divided into ", {"small", [], ["tiny"]}, " pieces"]}]
          },
          "."
        ]
      },
      {"div", [], [" It keeps growing... ", {"span", [], ["And ends."]}]}
    ]

    assert Floki.DeepText.get(nodes) ==
             "This is a text that is divided into tiny pieces. It keeps growing... And ends."
  end

  test "text from a list of deep nodes with a separator" do
    nodes = [
      {
        "div",
        [],
        [
          "This is a text",
          {
            "p",
            [],
            [" that is ", {"strong", [], ["divided into ", {"small", [], ["tiny"]}, " pieces"]}]
          },
          "."
        ]
      },
      {"div", [], [" It keeps growing... ", {"span", [], ["And ends."]}]}
    ]

    assert Floki.DeepText.get(nodes, "|") ==
             "This is a text| that is |divided into |tiny| pieces|.| It keeps growing... |And ends."
  end

  test "text when there is a comment inside the tree" do
    nodes = [{"a", [], ["foo"]}, {:comment, "bar"}, {"b", [], ["baz"]}]

    assert Floki.DeepText.get(nodes) == "foobaz"
  end

  test "text when there is a comment inside the tree with a separator" do
    nodes = [{"a", [], ["foo"]}, {:comment, "bar"}, {"b", [], ["baz"]}]

    assert Floki.DeepText.get(nodes, " ") == "foo baz"
  end

  test "text that includes a br node inside the tree" do
    nodes = [{"a", [], ["foo"]}, {"br", [], []}, {"b", [], ["baz"]}]

    assert Floki.DeepText.get(nodes) == "foo\nbaz"
  end

  test "text that includes a br node inside the tree with separator" do
    nodes = [{"a", [], ["foo"]}, {"br", [], []}, {"b", [], ["baz"]}]

    assert Floki.DeepText.get(nodes) == "foo\nbaz"
  end
end
