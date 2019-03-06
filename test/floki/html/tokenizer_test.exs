defmodule Floki.HTML.TokenizerTest do
  use ExUnit.Case, async: true
  use TokenizerTestLoader

  load_tests_from_file("./test/fixtures/test1.json")
end
