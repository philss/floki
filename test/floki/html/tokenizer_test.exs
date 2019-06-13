defmodule Floki.HTML.TokenizerTest do
  use ExUnit.Case, async: true
  use TokenizerTestLoader

  load_tests_from_file("./test/html5lib-tests/tokenizer/test1.test")
  load_tests_from_file("./test/html5lib-tests/tokenizer/test2.test")
  load_tests_from_file("./test/html5lib-tests/tokenizer/test3.test")
  load_tests_from_file("./test/html5lib-tests/tokenizer/test4.test")
end
