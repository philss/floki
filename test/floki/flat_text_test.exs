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
end
