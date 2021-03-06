defmodule Floki.HTML.Generated.Tokenizer.UnicodecharsPart1Test do
  use ExUnit.Case, async: true

  # NOTE: This file was generated by "mix generate_tokenizer_tests unicodeChars.test".
  # html5lib-tests rev: e52ff68cc7113a6ef3687747fa82691079bf9cc5

  alias Floki.HTML.Tokenizer

  test "tokenize/1 Invalid Unicode character U+0001" do
    input = <<1>>
    output = [["Character", <<1>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+0002" do
    input = <<2>>
    output = [["Character", <<2>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+0003" do
    input = <<3>>
    output = [["Character", <<3>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+0004" do
    input = <<4>>
    output = [["Character", <<4>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+0005" do
    input = <<5>>
    output = [["Character", <<5>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+0006" do
    input = <<6>>
    output = [["Character", <<6>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+0007" do
    input = "\a"
    output = [["Character", "\a"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+0008" do
    input = "\b"
    output = [["Character", "\b"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+000B" do
    input = "\v"
    output = [["Character", "\v"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+000E" do
    input = <<14>>
    output = [["Character", <<14>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+000F" do
    input = <<15>>
    output = [["Character", <<15>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+0010" do
    input = <<16>>
    output = [["Character", <<16>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+0011" do
    input = <<17>>
    output = [["Character", <<17>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+0012" do
    input = <<18>>
    output = [["Character", <<18>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+0013" do
    input = <<19>>
    output = [["Character", <<19>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+0014" do
    input = <<20>>
    output = [["Character", <<20>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+0015" do
    input = <<21>>
    output = [["Character", <<21>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+0016" do
    input = <<22>>
    output = [["Character", <<22>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+0017" do
    input = <<23>>
    output = [["Character", <<23>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+0018" do
    input = <<24>>
    output = [["Character", <<24>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+0019" do
    input = <<25>>
    output = [["Character", <<25>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+001A" do
    input = <<26>>
    output = [["Character", <<26>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+001B" do
    input = "\e"
    output = [["Character", "\e"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+001C" do
    input = <<28>>
    output = [["Character", <<28>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+001D" do
    input = <<29>>
    output = [["Character", <<29>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+001E" do
    input = <<30>>
    output = [["Character", <<30>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+001F" do
    input = <<31>>
    output = [["Character", <<31>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+007F" do
    input = "\d"
    output = [["Character", "\d"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+10FFFE" do
    input = "􏿾"
    output = [["Character", "􏿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+10FFFF" do
    input = "􏿿"
    output = [["Character", "􏿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+1FFFE" do
    input = "🿾"
    output = [["Character", "🿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+1FFFF" do
    input = "🿿"
    output = [["Character", "🿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+2FFFE" do
    input = "𯿾"
    output = [["Character", "𯿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+2FFFF" do
    input = "𯿿"
    output = [["Character", "𯿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+3FFFE" do
    input = "𿿾"
    output = [["Character", "𿿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+3FFFF" do
    input = "𿿿"
    output = [["Character", "𿿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+4FFFE" do
    input = "񏿾"
    output = [["Character", "񏿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+4FFFF" do
    input = "񏿿"
    output = [["Character", "񏿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+5FFFE" do
    input = "񟿾"
    output = [["Character", "񟿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+5FFFF" do
    input = "񟿿"
    output = [["Character", "񟿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+6FFFE" do
    input = "񯿾"
    output = [["Character", "񯿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+6FFFF" do
    input = "񯿿"
    output = [["Character", "񯿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+7FFFE" do
    input = "񿿾"
    output = [["Character", "񿿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+7FFFF" do
    input = "񿿿"
    output = [["Character", "񿿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+8FFFE" do
    input = "򏿾"
    output = [["Character", "򏿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+8FFFF" do
    input = "򏿿"
    output = [["Character", "򏿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+9FFFE" do
    input = "򟿾"
    output = [["Character", "򟿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+9FFFF" do
    input = "򟿿"
    output = [["Character", "򟿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+AFFFE" do
    input = "򯿾"
    output = [["Character", "򯿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+AFFFF" do
    input = "򯿿"
    output = [["Character", "򯿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+BFFFE" do
    input = "򿿾"
    output = [["Character", "򿿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+BFFFF" do
    input = "򿿿"
    output = [["Character", "򿿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+CFFFE" do
    input = "󏿾"
    output = [["Character", "󏿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+CFFFF" do
    input = "󏿿"
    output = [["Character", "󏿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+DFFFE" do
    input = "󟿾"
    output = [["Character", "󟿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+DFFFF" do
    input = "󟿿"
    output = [["Character", "󟿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+EFFFE" do
    input = "󯿾"
    output = [["Character", "󯿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+EFFFF" do
    input = "󯿿"
    output = [["Character", "󯿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDD0" do
    input = "﷐"
    output = [["Character", "﷐"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDD1" do
    input = "﷑"
    output = [["Character", "﷑"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDD2" do
    input = "﷒"
    output = [["Character", "﷒"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDD3" do
    input = "﷓"
    output = [["Character", "﷓"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDD4" do
    input = "﷔"
    output = [["Character", "﷔"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDD5" do
    input = "﷕"
    output = [["Character", "﷕"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDD6" do
    input = "﷖"
    output = [["Character", "﷖"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDD7" do
    input = "﷗"
    output = [["Character", "﷗"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDD8" do
    input = "﷘"
    output = [["Character", "﷘"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDD9" do
    input = "﷙"
    output = [["Character", "﷙"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDDA" do
    input = "﷚"
    output = [["Character", "﷚"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDDB" do
    input = "﷛"
    output = [["Character", "﷛"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDDC" do
    input = "﷜"
    output = [["Character", "﷜"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDDD" do
    input = "﷝"
    output = [["Character", "﷝"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDDE" do
    input = "﷞"
    output = [["Character", "﷞"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDDF" do
    input = "﷟"
    output = [["Character", "﷟"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDE0" do
    input = "﷠"
    output = [["Character", "﷠"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDE1" do
    input = "﷡"
    output = [["Character", "﷡"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDE2" do
    input = "﷢"
    output = [["Character", "﷢"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDE3" do
    input = "﷣"
    output = [["Character", "﷣"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDE4" do
    input = "﷤"
    output = [["Character", "﷤"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDE5" do
    input = "﷥"
    output = [["Character", "﷥"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDE6" do
    input = "﷦"
    output = [["Character", "﷦"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDE7" do
    input = "﷧"
    output = [["Character", "﷧"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDE8" do
    input = "﷨"
    output = [["Character", "﷨"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDE9" do
    input = "﷩"
    output = [["Character", "﷩"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDEA" do
    input = "﷪"
    output = [["Character", "﷪"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDEB" do
    input = "﷫"
    output = [["Character", "﷫"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDEC" do
    input = "﷬"
    output = [["Character", "﷬"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDED" do
    input = "﷭"
    output = [["Character", "﷭"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDEE" do
    input = "﷮"
    output = [["Character", "﷮"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FDEF" do
    input = "﷯"
    output = [["Character", "﷯"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FFFE" do
    input = <<239, 191, 190>>
    output = [["Character", <<239, 191, 190>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FFFF" do
    input = <<239, 191, 191>>
    output = [["Character", <<239, 191, 191>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FFFFE" do
    input = "󿿾"
    output = [["Character", "󿿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid Unicode character U+FFFFF" do
    input = "󿿿"
    output = [["Character", "󿿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Valid Unicode character U+0009" do
    input = "\t"
    output = [["Character", "\t"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Valid Unicode character U+000A" do
    input = "\n"
    output = [["Character", "\n"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Valid Unicode character U+0020" do
    input = " "
    output = [["Character", " "]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Valid Unicode character U+0021" do
    input = "!"
    output = [["Character", "!"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Valid Unicode character U+0022" do
    input = "\""
    output = [["Character", "\""]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Valid Unicode character U+0023" do
    input = "#"
    output = [["Character", "#"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end
end
