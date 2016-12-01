defmodule Floki.SelectorTokenizerTest do
  use ExUnit.Case, async: true
  alias Floki.SelectorTokenizer

  test "empty selector" do
    assert SelectorTokenizer.tokenize("") == []
  end

  test "complex selector" do
    complex = """
    ns|a.link,
    .b[title=hello],
    [href~=foo] *,
    a > b
    """

    assert SelectorTokenizer.tokenize(complex) == [
      {:identifier, 1, 'ns'},
      {:namespace_pipe, 1},
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

  test "pseudo classes" do
    assert SelectorTokenizer.tokenize(":nth-child(3)") == [
      {:pseudo, 1, 'nth-child'},
      {:pseudo_int, 1, 3}
    ]

    assert SelectorTokenizer.tokenize(":nth-child(odd)") == [
      {:pseudo, 1, 'nth-child'},
      {:pseudo_odd, 1}
    ]

    assert SelectorTokenizer.tokenize(":nth-child(even)") == [
      {:pseudo, 1, 'nth-child'},
      {:pseudo_even, 1}
    ]

    assert SelectorTokenizer.tokenize(":nth-child(2n+1)") == [
      {:pseudo, 1, 'nth-child'},
      {:pseudo_exp, 1, '2n+1'}
    ]

    assert SelectorTokenizer.tokenize(":nth-child(2n-1)") == [
      {:pseudo, 1, 'nth-child'},
      {:pseudo_exp, 1, '2n-1'}
    ]

    assert SelectorTokenizer.tokenize(":nth-child(n+0)") == [
      {:pseudo, 1, 'nth-child'},
      {:pseudo_exp, 1, 'n+0'}
    ]

    assert SelectorTokenizer.tokenize(":nth-child(-n+6)") == [
      {:pseudo, 1, 'nth-child'},
      {:pseudo_exp, 1, '-n+6'}
    ]
  end
end
