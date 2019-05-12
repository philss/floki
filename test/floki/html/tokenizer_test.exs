defmodule Floki.HTML.TokenizerTest do
  use ExUnit.Case, async: true
  use TokenizerTestLoader

  load_tests_from_file("./test/html5lib-tests/tokenizer/test1.test")
end
