defmodule Floki.HTML.Generated.Tokenizer.Test3Part9Test do
  use ExUnit.Case, async: true

  # NOTE: This file was generated by "mix generate_tokenizer_tests test3.test".
  # html5lib-tests rev: e52ff68cc7113a6ef3687747fa82691079bf9cc5

  alias Floki.HTML.Tokenizer

  test "tokenize/1 <!DOCTYPEa PUBLICA" do
    input = "<!DOCTYPEa PUBLICA"
    output = [["DOCTYPE", "a", nil, nil, false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa PUBLICB" do
    input = "<!DOCTYPEa PUBLICB"
    output = [["DOCTYPE", "a", nil, nil, false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa PUBLICY" do
    input = "<!DOCTYPEa PUBLICY"
    output = [["DOCTYPE", "a", nil, nil, false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa PUBLICZ" do
    input = "<!DOCTYPEa PUBLICZ"
    output = [["DOCTYPE", "a", nil, nil, false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa PUBLIC\\u0000" do
    input = <<60, 33, 68, 79, 67, 84, 89, 80, 69, 97, 32, 80, 85, 66, 76, 73, 67, 0>>
    output = [["DOCTYPE", "a", nil, nil, false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa PUBLIC\\u0008" do
    input = "<!DOCTYPEa PUBLIC\b"
    output = [["DOCTYPE", "a", nil, nil, false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa PUBLIC\\u0009" do
    input = "<!DOCTYPEa PUBLIC\t"
    output = [["DOCTYPE", "a", nil, nil, false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa PUBLIC\\u000A" do
    input = "<!DOCTYPEa PUBLIC\n"
    output = [["DOCTYPE", "a", nil, nil, false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa PUBLIC\\u000B" do
    input = "<!DOCTYPEa PUBLIC\v"
    output = [["DOCTYPE", "a", nil, nil, false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa PUBLIC\\u000C" do
    input = "<!DOCTYPEa PUBLIC\f"
    output = [["DOCTYPE", "a", nil, nil, false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa PUBLIC\\u000D" do
    input = "<!DOCTYPEa PUBLIC\r"
    output = [["DOCTYPE", "a", nil, nil, false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa PUBLIC\\u001F" do
    input = <<60, 33, 68, 79, 67, 84, 89, 80, 69, 97, 32, 80, 85, 66, 76, 73, 67, 31>>
    output = [["DOCTYPE", "a", nil, nil, false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa PUBLIC\\uDBC0\\uDC00" do
    input = "<!DOCTYPEa PUBLIC􀀀"
    output = [["DOCTYPE", "a", nil, nil, false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa PUBLIC`" do
    input = "<!DOCTYPEa PUBLIC`"
    output = [["DOCTYPE", "a", nil, nil, false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa PUBLICa" do
    input = "<!DOCTYPEa PUBLICa"
    output = [["DOCTYPE", "a", nil, nil, false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa PUBLICb" do
    input = "<!DOCTYPEa PUBLICb"
    output = [["DOCTYPE", "a", nil, nil, false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa PUBLICy" do
    input = "<!DOCTYPEa PUBLICy"
    output = [["DOCTYPE", "a", nil, nil, false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa PUBLICz" do
    input = "<!DOCTYPEa PUBLICz"
    output = [["DOCTYPE", "a", nil, nil, false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa PUBLIC{" do
    input = "<!DOCTYPEa PUBLIC{"
    output = [["DOCTYPE", "a", nil, nil, false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM" do
    input = "<!DOCTYPEa SYSTEM"
    output = [["DOCTYPE", "a", nil, nil, false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM " do
    input = "<!DOCTYPEa SYSTEM "
    output = [["DOCTYPE", "a", nil, nil, false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM!" do
    input = "<!DOCTYPEa SYSTEM!"
    output = [["DOCTYPE", "a", nil, nil, false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"" do
    input = "<!DOCTYPEa SYSTEM\""
    output = [["DOCTYPE", "a", nil, "", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\" " do
    input = "<!DOCTYPEa SYSTEM\" "
    output = [["DOCTYPE", "a", nil, " ", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"!" do
    input = "<!DOCTYPEa SYSTEM\"!"
    output = [["DOCTYPE", "a", nil, "!", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"\"" do
    input = "<!DOCTYPEa SYSTEM\"\""
    output = [["DOCTYPE", "a", nil, "", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"#" do
    input = "<!DOCTYPEa SYSTEM\"#"
    output = [["DOCTYPE", "a", nil, "#", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"&" do
    input = "<!DOCTYPEa SYSTEM\"&"
    output = [["DOCTYPE", "a", nil, "&", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"'" do
    input = "<!DOCTYPEa SYSTEM\"'"
    output = [["DOCTYPE", "a", nil, "'", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"-" do
    input = "<!DOCTYPEa SYSTEM\"-"
    output = [["DOCTYPE", "a", nil, "-", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"/" do
    input = "<!DOCTYPEa SYSTEM\"/"
    output = [["DOCTYPE", "a", nil, "/", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"0" do
    input = "<!DOCTYPEa SYSTEM\"0"
    output = [["DOCTYPE", "a", nil, "0", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"1" do
    input = "<!DOCTYPEa SYSTEM\"1"
    output = [["DOCTYPE", "a", nil, "1", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"9" do
    input = "<!DOCTYPEa SYSTEM\"9"
    output = [["DOCTYPE", "a", nil, "9", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"<" do
    input = "<!DOCTYPEa SYSTEM\"<"
    output = [["DOCTYPE", "a", nil, "<", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"=" do
    input = "<!DOCTYPEa SYSTEM\"="
    output = [["DOCTYPE", "a", nil, "=", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\">" do
    input = "<!DOCTYPEa SYSTEM\">"
    output = [["DOCTYPE", "a", nil, "", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"?" do
    input = "<!DOCTYPEa SYSTEM\"?"
    output = [["DOCTYPE", "a", nil, "?", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"@" do
    input = "<!DOCTYPEa SYSTEM\"@"
    output = [["DOCTYPE", "a", nil, "@", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"A" do
    input = "<!DOCTYPEa SYSTEM\"A"
    output = [["DOCTYPE", "a", nil, "A", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"B" do
    input = "<!DOCTYPEa SYSTEM\"B"
    output = [["DOCTYPE", "a", nil, "B", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"Y" do
    input = "<!DOCTYPEa SYSTEM\"Y"
    output = [["DOCTYPE", "a", nil, "Y", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"Z" do
    input = "<!DOCTYPEa SYSTEM\"Z"
    output = [["DOCTYPE", "a", nil, "Z", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"\\u0000" do
    input = <<60, 33, 68, 79, 67, 84, 89, 80, 69, 97, 32, 83, 89, 83, 84, 69, 77, 34, 0>>
    output = [["DOCTYPE", "a", nil, "�", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"\\u0009" do
    input = "<!DOCTYPEa SYSTEM\"\t"
    output = [["DOCTYPE", "a", nil, "\t", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"\\u000A" do
    input = "<!DOCTYPEa SYSTEM\"\n"
    output = [["DOCTYPE", "a", nil, "\n", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"\\u000B" do
    input = "<!DOCTYPEa SYSTEM\"\v"
    output = [["DOCTYPE", "a", nil, "\v", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"\\u000C" do
    input = "<!DOCTYPEa SYSTEM\"\f"
    output = [["DOCTYPE", "a", nil, "\f", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"\\uDBC0\\uDC00" do
    input = "<!DOCTYPEa SYSTEM\"􀀀"
    output = [["DOCTYPE", "a", nil, "􀀀", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"`" do
    input = "<!DOCTYPEa SYSTEM\"`"
    output = [["DOCTYPE", "a", nil, "`", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"a" do
    input = "<!DOCTYPEa SYSTEM\"a"
    output = [["DOCTYPE", "a", nil, "a", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"b" do
    input = "<!DOCTYPEa SYSTEM\"b"
    output = [["DOCTYPE", "a", nil, "b", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"y" do
    input = "<!DOCTYPEa SYSTEM\"y"
    output = [["DOCTYPE", "a", nil, "y", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"z" do
    input = "<!DOCTYPEa SYSTEM\"z"
    output = [["DOCTYPE", "a", nil, "z", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM\"{" do
    input = "<!DOCTYPEa SYSTEM\"{"
    output = [["DOCTYPE", "a", nil, "{", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM#" do
    input = "<!DOCTYPEa SYSTEM#"
    output = [["DOCTYPE", "a", nil, nil, false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM&" do
    input = "<!DOCTYPEa SYSTEM&"
    output = [["DOCTYPE", "a", nil, nil, false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM'" do
    input = "<!DOCTYPEa SYSTEM'"
    output = [["DOCTYPE", "a", nil, "", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM' " do
    input = "<!DOCTYPEa SYSTEM' "
    output = [["DOCTYPE", "a", nil, " ", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM'!" do
    input = "<!DOCTYPEa SYSTEM'!"
    output = [["DOCTYPE", "a", nil, "!", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM'\"" do
    input = "<!DOCTYPEa SYSTEM'\""
    output = [["DOCTYPE", "a", nil, "\"", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM'&" do
    input = "<!DOCTYPEa SYSTEM'&"
    output = [["DOCTYPE", "a", nil, "&", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''" do
    input = "<!DOCTYPEa SYSTEM''"
    output = [["DOCTYPE", "a", nil, "", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM'' " do
    input = "<!DOCTYPEa SYSTEM'' "
    output = [["DOCTYPE", "a", nil, "", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''!" do
    input = "<!DOCTYPEa SYSTEM''!"
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''\"" do
    input = "<!DOCTYPEa SYSTEM''\""
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''&" do
    input = "<!DOCTYPEa SYSTEM''&"
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM'''" do
    input = "<!DOCTYPEa SYSTEM'''"
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''-" do
    input = "<!DOCTYPEa SYSTEM''-"
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''/" do
    input = "<!DOCTYPEa SYSTEM''/"
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''0" do
    input = "<!DOCTYPEa SYSTEM''0"
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''1" do
    input = "<!DOCTYPEa SYSTEM''1"
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''9" do
    input = "<!DOCTYPEa SYSTEM''9"
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''<" do
    input = "<!DOCTYPEa SYSTEM''<"
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''=" do
    input = "<!DOCTYPEa SYSTEM''="
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''>" do
    input = "<!DOCTYPEa SYSTEM''>"
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''?" do
    input = "<!DOCTYPEa SYSTEM''?"
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''@" do
    input = "<!DOCTYPEa SYSTEM''@"
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''A" do
    input = "<!DOCTYPEa SYSTEM''A"
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''B" do
    input = "<!DOCTYPEa SYSTEM''B"
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''Y" do
    input = "<!DOCTYPEa SYSTEM''Y"
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''Z" do
    input = "<!DOCTYPEa SYSTEM''Z"
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''\\u0000" do
    input = <<60, 33, 68, 79, 67, 84, 89, 80, 69, 97, 32, 83, 89, 83, 84, 69, 77, 39, 39, 0>>
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''\\u0008" do
    input = "<!DOCTYPEa SYSTEM''\b"
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''\\u0009" do
    input = "<!DOCTYPEa SYSTEM''\t"
    output = [["DOCTYPE", "a", nil, "", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''\\u000A" do
    input = "<!DOCTYPEa SYSTEM''\n"
    output = [["DOCTYPE", "a", nil, "", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''\\u000B" do
    input = "<!DOCTYPEa SYSTEM''\v"
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''\\u000C" do
    input = "<!DOCTYPEa SYSTEM''\f"
    output = [["DOCTYPE", "a", nil, "", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''\\u000D" do
    input = "<!DOCTYPEa SYSTEM''\r"
    output = [["DOCTYPE", "a", nil, "", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''\\u001F" do
    input = <<60, 33, 68, 79, 67, 84, 89, 80, 69, 97, 32, 83, 89, 83, 84, 69, 77, 39, 39, 31>>
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''\\uDBC0\\uDC00" do
    input = "<!DOCTYPEa SYSTEM''􀀀"
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''`" do
    input = "<!DOCTYPEa SYSTEM''`"
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''a" do
    input = "<!DOCTYPEa SYSTEM''a"
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''b" do
    input = "<!DOCTYPEa SYSTEM''b"
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''y" do
    input = "<!DOCTYPEa SYSTEM''y"
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''z" do
    input = "<!DOCTYPEa SYSTEM''z"
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM''{" do
    input = "<!DOCTYPEa SYSTEM''{"
    output = [["DOCTYPE", "a", nil, "", true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM'(" do
    input = "<!DOCTYPEa SYSTEM'("
    output = [["DOCTYPE", "a", nil, "(", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM'-" do
    input = "<!DOCTYPEa SYSTEM'-"
    output = [["DOCTYPE", "a", nil, "-", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <!DOCTYPEa SYSTEM'/" do
    input = "<!DOCTYPEa SYSTEM'/"
    output = [["DOCTYPE", "a", nil, "/", false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end
end
