defmodule Floki.HTML.TokenizerTest do
  use ExUnit.Case, async: true
  alias Floki.HTML.Tokenizer

  test "tokenize/1 commentary token" do
    assert Tokenizer.tokenize("<!-- a comment -->") == [
             {:comment, " a comment ", 1, 5}
           ]
  end

  test "tokenize/1 doctype token" do
    # TODO: review the columns sum on each token
    assert Tokenizer.tokenize("<!doctype html>") == [
             {:doctype, "html", nil, nil, false, 1, 15}
           ]
  end
end
