defmodule Floki.FilterOutTest do
  use ExUnit.Case, async: true

  test "filter out elements with complex selectors" do
    html = Floki.parse("<body> <div class=\"has\">one</div>  <div>two</div> </body>")

    assert Floki.FilterOut.filter_out(html, "div[class]") == {"body", [], [{"div", [], ["two"]}]}
  end
end
