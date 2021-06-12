defmodule Floki.HTML.Generated.Tokenizer.NumericentitiesPart1Test do
  use ExUnit.Case, async: true

  # NOTE: This file was generated by "mix generate_tokenizer_tests numericEntities.test".
  # html5lib-tests rev: e52ff68cc7113a6ef3687747fa82691079bf9cc5

  alias Floki.HTML.Tokenizer

  test "tokenize/1 Invalid numeric entity character U+0000" do
    input = "&#x0000;"
    output = [["Character", "�"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+0001" do
    input = "&#x0001;"
    output = [["Character", <<1>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+0002" do
    input = "&#x0002;"
    output = [["Character", <<2>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+0003" do
    input = "&#x0003;"
    output = [["Character", <<3>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+0004" do
    input = "&#x0004;"
    output = [["Character", <<4>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+0005" do
    input = "&#x0005;"
    output = [["Character", <<5>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+0006" do
    input = "&#x0006;"
    output = [["Character", <<6>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+0007" do
    input = "&#x0007;"
    output = [["Character", "\a"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+0008" do
    input = "&#x0008;"
    output = [["Character", "\b"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+000B" do
    input = "&#x000b;"
    output = [["Character", "\v"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+000E" do
    input = "&#x000e;"
    output = [["Character", <<14>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+000F" do
    input = "&#x000f;"
    output = [["Character", <<15>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+0010" do
    input = "&#x0010;"
    output = [["Character", <<16>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+0011" do
    input = "&#x0011;"
    output = [["Character", <<17>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+0012" do
    input = "&#x0012;"
    output = [["Character", <<18>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+0013" do
    input = "&#x0013;"
    output = [["Character", <<19>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+0014" do
    input = "&#x0014;"
    output = [["Character", <<20>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+0015" do
    input = "&#x0015;"
    output = [["Character", <<21>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+0016" do
    input = "&#x0016;"
    output = [["Character", <<22>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+0017" do
    input = "&#x0017;"
    output = [["Character", <<23>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+0018" do
    input = "&#x0018;"
    output = [["Character", <<24>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+0019" do
    input = "&#x0019;"
    output = [["Character", <<25>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+001A" do
    input = "&#x001a;"
    output = [["Character", <<26>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+001B" do
    input = "&#x001b;"
    output = [["Character", "\e"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+001C" do
    input = "&#x001c;"
    output = [["Character", <<28>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+001D" do
    input = "&#x001d;"
    output = [["Character", <<29>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+001E" do
    input = "&#x001e;"
    output = [["Character", <<30>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+001F" do
    input = "&#x001f;"
    output = [["Character", <<31>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+007F" do
    input = "&#x007f;"
    output = [["Character", "\d"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+10FFFE" do
    input = "&#x10fffe;"
    output = [["Character", "􏿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+10FFFF" do
    input = "&#x10ffff;"
    output = [["Character", "􏿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+1FFFE" do
    input = "&#x1fffe;"
    output = [["Character", "🿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+1FFFF" do
    input = "&#x1ffff;"
    output = [["Character", "🿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+2FFFE" do
    input = "&#x2fffe;"
    output = [["Character", "𯿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+2FFFF" do
    input = "&#x2ffff;"
    output = [["Character", "𯿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+3FFFE" do
    input = "&#x3fffe;"
    output = [["Character", "𿿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+3FFFF" do
    input = "&#x3ffff;"
    output = [["Character", "𿿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+4FFFE" do
    input = "&#x4fffe;"
    output = [["Character", "񏿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+4FFFF" do
    input = "&#x4ffff;"
    output = [["Character", "񏿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+5FFFE" do
    input = "&#x5fffe;"
    output = [["Character", "񟿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+5FFFF" do
    input = "&#x5ffff;"
    output = [["Character", "񟿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+6FFFE" do
    input = "&#x6fffe;"
    output = [["Character", "񯿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+6FFFF" do
    input = "&#x6ffff;"
    output = [["Character", "񯿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+7FFFE" do
    input = "&#x7fffe;"
    output = [["Character", "񿿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+7FFFF" do
    input = "&#x7ffff;"
    output = [["Character", "񿿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+8FFFE" do
    input = "&#x8fffe;"
    output = [["Character", "򏿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+8FFFF" do
    input = "&#x8ffff;"
    output = [["Character", "򏿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+9FFFE" do
    input = "&#x9fffe;"
    output = [["Character", "򟿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+9FFFF" do
    input = "&#x9ffff;"
    output = [["Character", "򟿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+AFFFE" do
    input = "&#xafffe;"
    output = [["Character", "򯿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+AFFFF" do
    input = "&#xaffff;"
    output = [["Character", "򯿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+BFFFE" do
    input = "&#xbfffe;"
    output = [["Character", "򿿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+BFFFF" do
    input = "&#xbffff;"
    output = [["Character", "򿿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+CFFFE" do
    input = "&#xcfffe;"
    output = [["Character", "󏿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+CFFFF" do
    input = "&#xcffff;"
    output = [["Character", "󏿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+D800" do
    input = "&#xd800;"
    output = [["Character", "�"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+DFFF" do
    input = "&#xdfff;"
    output = [["Character", "�"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+DFFFE" do
    input = "&#xdfffe;"
    output = [["Character", "󟿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+DFFFF" do
    input = "&#xdffff;"
    output = [["Character", "󟿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+EFFFE" do
    input = "&#xefffe;"
    output = [["Character", "󯿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+EFFFF" do
    input = "&#xeffff;"
    output = [["Character", "󯿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDD0" do
    input = "&#xfdd0;"
    output = [["Character", "﷐"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDD1" do
    input = "&#xfdd1;"
    output = [["Character", "﷑"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDD2" do
    input = "&#xfdd2;"
    output = [["Character", "﷒"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDD3" do
    input = "&#xfdd3;"
    output = [["Character", "﷓"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDD4" do
    input = "&#xfdd4;"
    output = [["Character", "﷔"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDD5" do
    input = "&#xfdd5;"
    output = [["Character", "﷕"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDD6" do
    input = "&#xfdd6;"
    output = [["Character", "﷖"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDD7" do
    input = "&#xfdd7;"
    output = [["Character", "﷗"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDD8" do
    input = "&#xfdd8;"
    output = [["Character", "﷘"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDD9" do
    input = "&#xfdd9;"
    output = [["Character", "﷙"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDDA" do
    input = "&#xfdda;"
    output = [["Character", "﷚"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDDB" do
    input = "&#xfddb;"
    output = [["Character", "﷛"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDDC" do
    input = "&#xfddc;"
    output = [["Character", "﷜"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDDD" do
    input = "&#xfddd;"
    output = [["Character", "﷝"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDDE" do
    input = "&#xfdde;"
    output = [["Character", "﷞"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDDF" do
    input = "&#xfddf;"
    output = [["Character", "﷟"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDE0" do
    input = "&#xfde0;"
    output = [["Character", "﷠"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDE1" do
    input = "&#xfde1;"
    output = [["Character", "﷡"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDE2" do
    input = "&#xfde2;"
    output = [["Character", "﷢"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDE3" do
    input = "&#xfde3;"
    output = [["Character", "﷣"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDE4" do
    input = "&#xfde4;"
    output = [["Character", "﷤"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDE5" do
    input = "&#xfde5;"
    output = [["Character", "﷥"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDE6" do
    input = "&#xfde6;"
    output = [["Character", "﷦"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDE7" do
    input = "&#xfde7;"
    output = [["Character", "﷧"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDE8" do
    input = "&#xfde8;"
    output = [["Character", "﷨"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDE9" do
    input = "&#xfde9;"
    output = [["Character", "﷩"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDEA" do
    input = "&#xfdea;"
    output = [["Character", "﷪"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDEB" do
    input = "&#xfdeb;"
    output = [["Character", "﷫"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDEC" do
    input = "&#xfdec;"
    output = [["Character", "﷬"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDED" do
    input = "&#xfded;"
    output = [["Character", "﷭"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDEE" do
    input = "&#xfdee;"
    output = [["Character", "﷮"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FDEF" do
    input = "&#xfdef;"
    output = [["Character", "﷯"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FFFE" do
    input = "&#xfffe;"
    output = [["Character", <<239, 191, 190>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FFFF" do
    input = "&#xffff;"
    output = [["Character", <<239, 191, 191>>]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FFFFE" do
    input = "&#xffffe;"
    output = [["Character", "󿿾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character U+FFFFF" do
    input = "&#xfffff;"
    output = [["Character", "󿿿"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid numeric entity character overflow" do
    input = "&#11111111111;"
    output = [["Character", "�"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid unterminated numeric entity character overflow" do
    input = "&#11111111111x"
    output = [["Character", "�x"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Invalid unterminated numeric entity character overflow before EOF" do
    input = "&#11111111111"
    output = [["Character", "�"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end
end