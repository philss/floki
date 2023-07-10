defmodule Floki.Selector.TokenizerTest do
  use ExUnit.Case, async: true
  alias Floki.Selector.Tokenizer

  test "empty selector" do
    assert Tokenizer.tokenize("") == []
  end

  test "complex selector" do
    complex = """
    ns|a.link,
    .b[title=hello],
    [href~=foo] *,
    a > b
    """

    assert Tokenizer.tokenize(complex) == [
             {:identifier, 1, ~c"ns"},
             {:namespace_pipe, 1},
             {:identifier, 1, ~c"a"},
             {:class, 1, ~c"link"},
             {:comma, 1},
             {:class, 2, ~c"b"},
             {~c"[", 2},
             {:identifier, 2, ~c"title"},
             {:equal, 2},
             {:identifier, 2, ~c"hello"},
             {~c"]", 2},
             {:comma, 2},
             {~c"[", 3},
             {:identifier, 3, ~c"href"},
             {:includes, 3},
             {:identifier, 3, ~c"foo"},
             {~c"]", 3},
             {:space, 3},
             {~c"*", 3},
             {:comma, 3},
             {:identifier, 4, ~c"a"},
             {:greater, 4},
             {:identifier, 4, ~c"b"}
           ]
  end

  test "prefix match with quoted val" do
    assert Tokenizer.tokenize("#about-us[href^='contact']") == [
             {:hash, 1, ~c"about-us"},
             {~c"[", 1},
             {:identifier, 1, ~c"href"},
             {:prefix_match, 1},
             {:quoted, 1, ~c"contact"},
             {~c"]", 1}
           ]
  end

  test "an unknown token" do
    assert Tokenizer.tokenize("&") == [
             {:unknown, 1, ~c"&"}
           ]
  end

  test "pseudo classes" do
    assert Tokenizer.tokenize(":nth-child(3)") == [
             {:pseudo, 1, ~c"nth-child"},
             {:pseudo_class_int, 1, 3}
           ]

    assert Tokenizer.tokenize(":nth-child(odd)") == [
             {:pseudo, 1, ~c"nth-child"},
             {:pseudo_class_odd, 1}
           ]

    assert Tokenizer.tokenize(":nth-child(even)") == [
             {:pseudo, 1, ~c"nth-child"},
             {:pseudo_class_even, 1}
           ]

    assert Tokenizer.tokenize(":nth-child(2n+1)") == [
             {:pseudo, 1, ~c"nth-child"},
             {:pseudo_class_pattern, 1, ~c"2n+1"}
           ]

    assert Tokenizer.tokenize(":nth-child(2n-1)") == [
             {:pseudo, 1, ~c"nth-child"},
             {:pseudo_class_pattern, 1, ~c"2n-1"}
           ]

    assert Tokenizer.tokenize(":nth-child(n+0)") == [
             {:pseudo, 1, ~c"nth-child"},
             {:pseudo_class_pattern, 1, ~c"n+0"}
           ]

    assert Tokenizer.tokenize(":nth-child(-n+6)") == [
             {:pseudo, 1, ~c"nth-child"},
             {:pseudo_class_pattern, 1, ~c"-n+6"}
           ]

    assert Tokenizer.tokenize(":fl-contains('foo')") == [
             {:pseudo, 1, ~c"fl-contains"},
             {:pseudo_class_quoted, 1, ~c"foo"}
           ]
  end
end
