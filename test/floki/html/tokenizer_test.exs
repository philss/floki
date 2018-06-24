defmodule Floki.HTML.TokenizerTest do
  use ExUnit.Case, async: true
  alias Floki.HTML.Tokenizer

  test "tokenize/1 commentary tokens" do
    assert Tokenizer.tokenize("<!-- a comment -->") == [
             {:comment, " a comment ", 1, 5}
           ]
  end
end
