defmodule Floki.TraversalTest do
  use ExUnit.Case, async: true

  describe "traverse_and_update/2" do
    test "with string returns string" do
      assert Floki.traverse_and_update("hello", fn tag -> tag end) == "hello"
    end

    test "with div and identity function returns div" do
      html = {"div", [], ["hello"]}

      assert Floki.traverse_and_update(html, fn tag -> tag end) == html
    end

    test "with div and div->p function returns p" do
      html = {"div", [], ["hello"]}

      assert Floki.traverse_and_update(html, fn {"div", attrs, children} ->
               {"p", attrs, children}
             end) == {"p", [], ["hello"]}
    end

    test "with style attribute and style->src function returns src attribute" do
      html = {"div", [{"style", "display: flex"}], ["hello"]}

      assert Floki.traverse_and_update(html, fn {elem, _attrs, children} ->
               {elem, [{"src", "http://example.test"}], children}
             end) == {"div", [{"src", "http://example.test"}], ["hello"]}
    end

    test "with text child and child replacer function returns tag with new child" do
      html = {"div", [], ["hello"]}

      assert Floki.traverse_and_update(html, fn {elem, attrs, _children} ->
               {elem, attrs, ["world"]}
             end) == {"div", [], ["world"]}
    end

    test "with div->span and span deleter function returns div without span" do
      html = {"div", [], [{"span", [], ["hello"]}]}

      assert Floki.traverse_and_update(html, fn
               {"span", _attrs, _children} -> nil
               tag -> tag
             end) == {"div", [], []}
    end

    test "with div,p and identity function returns div,p" do
      html = [{"div", [], ["hello"]}, {"p", [], ["world"]}]

      assert Floki.traverse_and_update(html, fn tag -> tag end) == html
    end

    test "with comment, pi and doctype elements" do
      html = [
        {:doctype, "html", nil, nil},
        {"body", [],
         [
           {"div", [], ["hello"]},
           {:comment, "a comment"},
           {:pi, "xml", []}
         ]}
      ]

      assert Floki.traverse_and_update(html, fn
               {:comment, text} -> {"span", [], [text]}
               {:pi, "xml", _children} -> nil
               {:doctype, "html", nil, nil} -> nil
               tag -> tag
             end) == [
               {"body", [],
                [
                  {"div", [], ["hello"]},
                  {"span", [], ["a comment"]}
                ]}
             ]
    end
  end
end
