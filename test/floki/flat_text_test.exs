defmodule Floki.FlatTextTest do
  use ExUnit.Case, async: true

  doctest Floki.FlatText

  test "text in a simple HTML node" do
    node = {"a", [{"href", "http://elixir-lang.org"}], ["Elixir lang"]}

    assert Floki.FlatText.get(node) == "Elixir lang"
  end

  test "text in a simple HTML node with separator" do
    node = {"a", [{"href", "http://elixir-lang.org"}], ["Elixir lang"]}

    assert Floki.FlatText.get(node, " ") == "Elixir lang"
  end

  test "extracts text from text input" do
    node = {"input", [{"value", "foo"}], []}

    assert Floki.FlatText.get(node, " ", true) == "foo"
  end

  test "extracts text from textarea" do
    node = {"textarea", [{"value", "bar"}], []}

    assert Floki.FlatText.get(node, " ", true) == "bar"
  end

  test "extracts text from nested inputs" do
    node =
      {"div", [],
       [
         {"input", [{"value", "bar"}], []}
       ]}

    assert Floki.FlatText.get(node, " ", true) == "bar"
  end

  test "a blank string when the node does not have text in the same level" do
    node = {"div", [], [{"a", [], ["Something in a deeper node"]}]}

    assert Floki.FlatText.get(node) == ""
  end

  test "a blank string when the node does not have text in the same level with separator" do
    node = {"div", [], [{"a", [], ["Something in a deeper node"]}]}

    assert Floki.FlatText.get(node) == ""
  end

  test "text from a node with children nodes" do
    node = {"div", [], ["The text start", {"span", [], ["envolves"]}, " and end."]}

    assert Floki.FlatText.get(node) == "The text start and end."
  end

  test "text from a node with children nodes with separator" do
    node = {"div", [], ["The text start", {"span", [], ["envolves"]}, " and end."]}

    assert Floki.FlatText.get(node, "|") == "The text start| and end."
  end

  test "text from a list of nodes" do
    nodes = [
      {"div", [], ["The text start", {"span", [], ["envolves"]}, " and end."]},
      {"div", [], [" Another text", {"a", [], ["With a link"]}, " that ignores the link inside"]},
      "."
    ]

    expected_text = "The text start and end. Another text that ignores the link inside."

    assert Floki.FlatText.get(nodes) == expected_text
  end

  test "text from a list of nodes with separator" do
    nodes = [
      {"div", [], ["The text start", {"span", [], ["envolves"]}, " and end."]},
      {"div", [], [" Another text", {"a", [], ["With a link"]}, " that ignores the link inside"]},
      "."
    ]

    expected_text = "The text start  and end.  Another text  that ignores the link inside ."

    assert Floki.FlatText.get(nodes, " ") == expected_text
  end

  # --- Edge Cases ---

  test "does not extract text from deeply nested nodes (depth >= 1 for text nodes)" do
    node = {"div", [], [{"span", [], [{"p", [], ["Should not be here"]}]}]}
    assert Floki.FlatText.get(node) == ""
  end

  test "does not extract inputs from deeply nested nodes (depth >= 1 for inputs)" do
    node = {"div", [], [{"span", [], [{"input", [{"value", "hidden"}], []}]}]}
    assert Floki.FlatText.get(node, " ", true) == ""
  end

  test "handles multiple consecutive text nodes at root level" do
    nodes = ["one", "two", "three"]
    assert Floki.FlatText.get(nodes) == "onetwothree"
    assert Floki.FlatText.get(nodes, "-") == "one-two-three"
  end

  test "handles multiple consecutive text nodes inside a node" do
    node = {"div", [], ["one", "two", "three"]}
    assert Floki.FlatText.get(node) == "onetwothree"
    assert Floki.FlatText.get(node, "-") == "one-two-three"
  end

  test "ignores comments and doctypes" do
    nodes = [
      {:comment, "this is a comment"},
      "text",
      {:doctype, "html", "", ""}
    ]
    assert Floki.FlatText.get(nodes) == "text"
  end

  test "empty nodes return blank string" do
    assert Floki.FlatText.get([]) == ""
    assert Floki.FlatText.get({"div", [], []}) == ""
  end
end
