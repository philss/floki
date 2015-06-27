defmodule Floki.DeepTextTest do
  use ExUnit.Case, assync: true

  doctest Floki.DeepText

  test "text from simple node" do
    node = {"a", [], ["Google"]}

    assert Floki.DeepText.get(node) == "Google"
  end

  test "text from an array of deep nodes" do
    nodes =
      [{"div", [],
          ["This is a text",
            {"p", [],
              [" that is ",
                {"strong", [], ["divided into ", {"small", [], ["tiny"]}, " pieces"]}]},
            "."]},
        {"div", [], [" It keeps growing... ", {"span", [], ["And ends."]}]}]

     assert Floki.DeepText.get(nodes) == "This is a text that is divided into tiny pieces. It keeps growing... And ends."
  end

  test "text when there is a comment inside the tree" do
    nodes = [{"a", [], ["foo"]}, {:comment, "bar"}, {"b", [], ["baz"]}]

    assert Floki.DeepText.get(nodes) == "foobaz"
  end
end
