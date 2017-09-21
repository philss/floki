defmodule Floki.FilterOutTest do
  use ExUnit.Case, async: true

  test "filter out elements with complex selectors" do
    html = Floki.parse("<body> <div class=\"has\">one</div>  <div>two</div> </body>")

    assert Floki.FilterOut.filter_out(html, "div[class]") == {"body", [], [{"div", [], ["two"]}]}
  end

  test "filter out returns the elements in the same order they were passed in" do
    nodes = [{"p", [], ["1"]}, {"p", [], ["2"]}]
    assert Floki.FilterOut.filter_out(nodes, "script") == nodes
    assert Floki.FilterOut.filter_out(nodes, :comment) == nodes
  end

  test "filter out filters script when it is the only node" do
    assert Floki.FilterOut.filter_out({"script", [], ["wat"]}, "script") == []
  end
end
