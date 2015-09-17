defmodule Floki.SelectorTokenizerTest do
  use ExUnit.Case
  alias Floki.SelectorTokenizer

  test "empty selector" do
    assert SelectorTokenizer.tokenize("") == []
  end

  test "complex selector" do
    complex = """
    a.link,
    .b[title=hello],
    [href~=foo] *,
    a > b
    """

    assert SelectorTokenizer.tokenize(complex) == [
      {:identifier, 1, 'a'},
      {:class, 1, 'link'},
      {:comma, 1},
      {:space, 1},
      {:class, 2, 'b'},
      {'[', 2},
        {:identifier, 2, 'title'},
        {:equal, 2},
        {:identifier, 2, 'hello'},
        {']', 2},
      {:comma, 2},
      {:space, 2},
      {'[', 3},
        {:identifier, 3, 'href'},
        {:includes, 3},
        {:identifier, 3, 'foo'},
        {']', 3},
      {:space, 3},
      {'*', 3},
      {:comma, 3},
      {:space, 3},
      {:identifier, 4, 'a'},
      {:greater, 4},
      {:identifier, 4, 'b'}
    ]
  end

  test "prefix match with quoted val" do
    assert SelectorTokenizer.tokenize("#about-us[href^='contact']") == [
      {:hash, 1, 'about-us'},
      {'[', 1},
        {:identifier, 1, 'href'},
        {:prefix_match, 1},
        {:quoted, 1, 'contact'},
        {']', 1}
    ]
  end

  test "an unknown token" do
    assert SelectorTokenizer.tokenize("&") == [
      {:unknown, 1, '&'}
    ]
  end
end
