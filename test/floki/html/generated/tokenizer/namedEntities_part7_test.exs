defmodule Floki.HTML.Generated.Tokenizer.NamedentitiesPart7Test do
  use ExUnit.Case, async: true

  # NOTE: This file was generated by "mix generate_tokenizer_tests namedEntities.test".
  # html5lib-tests rev: e52ff68cc7113a6ef3687747fa82691079bf9cc5

  alias Floki.HTML.Tokenizer

  test "tokenize/1 Bad named entity: apE without a semi-colon" do
    input = "&apE"
    output = [["Character", "&apE"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: apacir without a semi-colon" do
    input = "&apacir"
    output = [["Character", "&apacir"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: ape without a semi-colon" do
    input = "&ape"
    output = [["Character", "&ape"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: apid without a semi-colon" do
    input = "&apid"
    output = [["Character", "&apid"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: apos without a semi-colon" do
    input = "&apos"
    output = [["Character", "&apos"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: approx without a semi-colon" do
    input = "&approx"
    output = [["Character", "&approx"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: approxeq without a semi-colon" do
    input = "&approxeq"
    output = [["Character", "&approxeq"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: ascr without a semi-colon" do
    input = "&ascr"
    output = [["Character", "&ascr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: ast without a semi-colon" do
    input = "&ast"
    output = [["Character", "&ast"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: asymp without a semi-colon" do
    input = "&asymp"
    output = [["Character", "&asymp"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: asympeq without a semi-colon" do
    input = "&asympeq"
    output = [["Character", "&asympeq"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: awconint without a semi-colon" do
    input = "&awconint"
    output = [["Character", "&awconint"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: awint without a semi-colon" do
    input = "&awint"
    output = [["Character", "&awint"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bNot without a semi-colon" do
    input = "&bNot"
    output = [["Character", "&bNot"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: backcong without a semi-colon" do
    input = "&backcong"
    output = [["Character", "&backcong"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: backepsilon without a semi-colon" do
    input = "&backepsilon"
    output = [["Character", "&backepsilon"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: backprime without a semi-colon" do
    input = "&backprime"
    output = [["Character", "&backprime"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: backsim without a semi-colon" do
    input = "&backsim"
    output = [["Character", "&backsim"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: backsimeq without a semi-colon" do
    input = "&backsimeq"
    output = [["Character", "&backsimeq"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: barvee without a semi-colon" do
    input = "&barvee"
    output = [["Character", "&barvee"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: barwed without a semi-colon" do
    input = "&barwed"
    output = [["Character", "&barwed"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: barwedge without a semi-colon" do
    input = "&barwedge"
    output = [["Character", "&barwedge"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bbrk without a semi-colon" do
    input = "&bbrk"
    output = [["Character", "&bbrk"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bbrktbrk without a semi-colon" do
    input = "&bbrktbrk"
    output = [["Character", "&bbrktbrk"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bcong without a semi-colon" do
    input = "&bcong"
    output = [["Character", "&bcong"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bcy without a semi-colon" do
    input = "&bcy"
    output = [["Character", "&bcy"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bdquo without a semi-colon" do
    input = "&bdquo"
    output = [["Character", "&bdquo"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: becaus without a semi-colon" do
    input = "&becaus"
    output = [["Character", "&becaus"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: because without a semi-colon" do
    input = "&because"
    output = [["Character", "&because"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bemptyv without a semi-colon" do
    input = "&bemptyv"
    output = [["Character", "&bemptyv"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bepsi without a semi-colon" do
    input = "&bepsi"
    output = [["Character", "&bepsi"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bernou without a semi-colon" do
    input = "&bernou"
    output = [["Character", "&bernou"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: beta without a semi-colon" do
    input = "&beta"
    output = [["Character", "&beta"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: beth without a semi-colon" do
    input = "&beth"
    output = [["Character", "&beth"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: between without a semi-colon" do
    input = "&between"
    output = [["Character", "&between"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bfr without a semi-colon" do
    input = "&bfr"
    output = [["Character", "&bfr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bigcap without a semi-colon" do
    input = "&bigcap"
    output = [["Character", "&bigcap"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bigcirc without a semi-colon" do
    input = "&bigcirc"
    output = [["Character", "&bigcirc"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bigcup without a semi-colon" do
    input = "&bigcup"
    output = [["Character", "&bigcup"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bigodot without a semi-colon" do
    input = "&bigodot"
    output = [["Character", "&bigodot"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bigoplus without a semi-colon" do
    input = "&bigoplus"
    output = [["Character", "&bigoplus"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bigotimes without a semi-colon" do
    input = "&bigotimes"
    output = [["Character", "&bigotimes"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bigsqcup without a semi-colon" do
    input = "&bigsqcup"
    output = [["Character", "&bigsqcup"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bigstar without a semi-colon" do
    input = "&bigstar"
    output = [["Character", "&bigstar"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bigtriangledown without a semi-colon" do
    input = "&bigtriangledown"
    output = [["Character", "&bigtriangledown"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bigtriangleup without a semi-colon" do
    input = "&bigtriangleup"
    output = [["Character", "&bigtriangleup"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: biguplus without a semi-colon" do
    input = "&biguplus"
    output = [["Character", "&biguplus"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bigvee without a semi-colon" do
    input = "&bigvee"
    output = [["Character", "&bigvee"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bigwedge without a semi-colon" do
    input = "&bigwedge"
    output = [["Character", "&bigwedge"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bkarow without a semi-colon" do
    input = "&bkarow"
    output = [["Character", "&bkarow"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: blacklozenge without a semi-colon" do
    input = "&blacklozenge"
    output = [["Character", "&blacklozenge"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: blacksquare without a semi-colon" do
    input = "&blacksquare"
    output = [["Character", "&blacksquare"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: blacktriangle without a semi-colon" do
    input = "&blacktriangle"
    output = [["Character", "&blacktriangle"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: blacktriangledown without a semi-colon" do
    input = "&blacktriangledown"
    output = [["Character", "&blacktriangledown"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: blacktriangleleft without a semi-colon" do
    input = "&blacktriangleleft"
    output = [["Character", "&blacktriangleleft"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: blacktriangleright without a semi-colon" do
    input = "&blacktriangleright"
    output = [["Character", "&blacktriangleright"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: blank without a semi-colon" do
    input = "&blank"
    output = [["Character", "&blank"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: blk12 without a semi-colon" do
    input = "&blk12"
    output = [["Character", "&blk12"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: blk14 without a semi-colon" do
    input = "&blk14"
    output = [["Character", "&blk14"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: blk34 without a semi-colon" do
    input = "&blk34"
    output = [["Character", "&blk34"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: block without a semi-colon" do
    input = "&block"
    output = [["Character", "&block"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bne without a semi-colon" do
    input = "&bne"
    output = [["Character", "&bne"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bnequiv without a semi-colon" do
    input = "&bnequiv"
    output = [["Character", "&bnequiv"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bnot without a semi-colon" do
    input = "&bnot"
    output = [["Character", "&bnot"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bopf without a semi-colon" do
    input = "&bopf"
    output = [["Character", "&bopf"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bot without a semi-colon" do
    input = "&bot"
    output = [["Character", "&bot"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bottom without a semi-colon" do
    input = "&bottom"
    output = [["Character", "&bottom"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: bowtie without a semi-colon" do
    input = "&bowtie"
    output = [["Character", "&bowtie"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxDL without a semi-colon" do
    input = "&boxDL"
    output = [["Character", "&boxDL"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxDR without a semi-colon" do
    input = "&boxDR"
    output = [["Character", "&boxDR"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxDl without a semi-colon" do
    input = "&boxDl"
    output = [["Character", "&boxDl"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxDr without a semi-colon" do
    input = "&boxDr"
    output = [["Character", "&boxDr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxH without a semi-colon" do
    input = "&boxH"
    output = [["Character", "&boxH"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxHD without a semi-colon" do
    input = "&boxHD"
    output = [["Character", "&boxHD"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxHU without a semi-colon" do
    input = "&boxHU"
    output = [["Character", "&boxHU"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxHd without a semi-colon" do
    input = "&boxHd"
    output = [["Character", "&boxHd"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxHu without a semi-colon" do
    input = "&boxHu"
    output = [["Character", "&boxHu"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxUL without a semi-colon" do
    input = "&boxUL"
    output = [["Character", "&boxUL"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxUR without a semi-colon" do
    input = "&boxUR"
    output = [["Character", "&boxUR"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxUl without a semi-colon" do
    input = "&boxUl"
    output = [["Character", "&boxUl"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxUr without a semi-colon" do
    input = "&boxUr"
    output = [["Character", "&boxUr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxV without a semi-colon" do
    input = "&boxV"
    output = [["Character", "&boxV"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxVH without a semi-colon" do
    input = "&boxVH"
    output = [["Character", "&boxVH"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxVL without a semi-colon" do
    input = "&boxVL"
    output = [["Character", "&boxVL"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxVR without a semi-colon" do
    input = "&boxVR"
    output = [["Character", "&boxVR"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxVh without a semi-colon" do
    input = "&boxVh"
    output = [["Character", "&boxVh"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxVl without a semi-colon" do
    input = "&boxVl"
    output = [["Character", "&boxVl"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxVr without a semi-colon" do
    input = "&boxVr"
    output = [["Character", "&boxVr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxbox without a semi-colon" do
    input = "&boxbox"
    output = [["Character", "&boxbox"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxdL without a semi-colon" do
    input = "&boxdL"
    output = [["Character", "&boxdL"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxdR without a semi-colon" do
    input = "&boxdR"
    output = [["Character", "&boxdR"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxdl without a semi-colon" do
    input = "&boxdl"
    output = [["Character", "&boxdl"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxdr without a semi-colon" do
    input = "&boxdr"
    output = [["Character", "&boxdr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxh without a semi-colon" do
    input = "&boxh"
    output = [["Character", "&boxh"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxhD without a semi-colon" do
    input = "&boxhD"
    output = [["Character", "&boxhD"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxhU without a semi-colon" do
    input = "&boxhU"
    output = [["Character", "&boxhU"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxhd without a semi-colon" do
    input = "&boxhd"
    output = [["Character", "&boxhd"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxhu without a semi-colon" do
    input = "&boxhu"
    output = [["Character", "&boxhu"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxminus without a semi-colon" do
    input = "&boxminus"
    output = [["Character", "&boxminus"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: boxplus without a semi-colon" do
    input = "&boxplus"
    output = [["Character", "&boxplus"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end
end
