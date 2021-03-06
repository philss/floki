defmodule Floki.HTML.Generated.Tokenizer.NamedentitiesPart9Test do
  use ExUnit.Case, async: true

  # NOTE: This file was generated by "mix generate_tokenizer_tests namedEntities.test".
  # html5lib-tests rev: e52ff68cc7113a6ef3687747fa82691079bf9cc5

  alias Floki.HTML.Tokenizer

  test "tokenize/1 Bad named entity: cups without a semi-colon" do
    input = "&cups"
    output = [["Character", "&cups"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: curarr without a semi-colon" do
    input = "&curarr"
    output = [["Character", "&curarr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: curarrm without a semi-colon" do
    input = "&curarrm"
    output = [["Character", "&curarrm"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: curlyeqprec without a semi-colon" do
    input = "&curlyeqprec"
    output = [["Character", "&curlyeqprec"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: curlyeqsucc without a semi-colon" do
    input = "&curlyeqsucc"
    output = [["Character", "&curlyeqsucc"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: curlyvee without a semi-colon" do
    input = "&curlyvee"
    output = [["Character", "&curlyvee"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: curlywedge without a semi-colon" do
    input = "&curlywedge"
    output = [["Character", "&curlywedge"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: curvearrowleft without a semi-colon" do
    input = "&curvearrowleft"
    output = [["Character", "&curvearrowleft"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: curvearrowright without a semi-colon" do
    input = "&curvearrowright"
    output = [["Character", "&curvearrowright"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: cuvee without a semi-colon" do
    input = "&cuvee"
    output = [["Character", "&cuvee"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: cuwed without a semi-colon" do
    input = "&cuwed"
    output = [["Character", "&cuwed"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: cwconint without a semi-colon" do
    input = "&cwconint"
    output = [["Character", "&cwconint"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: cwint without a semi-colon" do
    input = "&cwint"
    output = [["Character", "&cwint"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: cylcty without a semi-colon" do
    input = "&cylcty"
    output = [["Character", "&cylcty"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dArr without a semi-colon" do
    input = "&dArr"
    output = [["Character", "&dArr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dHar without a semi-colon" do
    input = "&dHar"
    output = [["Character", "&dHar"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dagger without a semi-colon" do
    input = "&dagger"
    output = [["Character", "&dagger"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: daleth without a semi-colon" do
    input = "&daleth"
    output = [["Character", "&daleth"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: darr without a semi-colon" do
    input = "&darr"
    output = [["Character", "&darr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dash without a semi-colon" do
    input = "&dash"
    output = [["Character", "&dash"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dashv without a semi-colon" do
    input = "&dashv"
    output = [["Character", "&dashv"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dbkarow without a semi-colon" do
    input = "&dbkarow"
    output = [["Character", "&dbkarow"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dblac without a semi-colon" do
    input = "&dblac"
    output = [["Character", "&dblac"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dcaron without a semi-colon" do
    input = "&dcaron"
    output = [["Character", "&dcaron"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dcy without a semi-colon" do
    input = "&dcy"
    output = [["Character", "&dcy"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dd without a semi-colon" do
    input = "&dd"
    output = [["Character", "&dd"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: ddagger without a semi-colon" do
    input = "&ddagger"
    output = [["Character", "&ddagger"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: ddarr without a semi-colon" do
    input = "&ddarr"
    output = [["Character", "&ddarr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: ddotseq without a semi-colon" do
    input = "&ddotseq"
    output = [["Character", "&ddotseq"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: delta without a semi-colon" do
    input = "&delta"
    output = [["Character", "&delta"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: demptyv without a semi-colon" do
    input = "&demptyv"
    output = [["Character", "&demptyv"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dfisht without a semi-colon" do
    input = "&dfisht"
    output = [["Character", "&dfisht"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dfr without a semi-colon" do
    input = "&dfr"
    output = [["Character", "&dfr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dharl without a semi-colon" do
    input = "&dharl"
    output = [["Character", "&dharl"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dharr without a semi-colon" do
    input = "&dharr"
    output = [["Character", "&dharr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: diam without a semi-colon" do
    input = "&diam"
    output = [["Character", "&diam"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: diamond without a semi-colon" do
    input = "&diamond"
    output = [["Character", "&diamond"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: diamondsuit without a semi-colon" do
    input = "&diamondsuit"
    output = [["Character", "&diamondsuit"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: diams without a semi-colon" do
    input = "&diams"
    output = [["Character", "&diams"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: die without a semi-colon" do
    input = "&die"
    output = [["Character", "&die"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: digamma without a semi-colon" do
    input = "&digamma"
    output = [["Character", "&digamma"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: disin without a semi-colon" do
    input = "&disin"
    output = [["Character", "&disin"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: div without a semi-colon" do
    input = "&div"
    output = [["Character", "&div"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: divonx without a semi-colon" do
    input = "&divonx"
    output = [["Character", "&divonx"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: djcy without a semi-colon" do
    input = "&djcy"
    output = [["Character", "&djcy"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dlcorn without a semi-colon" do
    input = "&dlcorn"
    output = [["Character", "&dlcorn"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dlcrop without a semi-colon" do
    input = "&dlcrop"
    output = [["Character", "&dlcrop"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dollar without a semi-colon" do
    input = "&dollar"
    output = [["Character", "&dollar"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dopf without a semi-colon" do
    input = "&dopf"
    output = [["Character", "&dopf"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dot without a semi-colon" do
    input = "&dot"
    output = [["Character", "&dot"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: doteq without a semi-colon" do
    input = "&doteq"
    output = [["Character", "&doteq"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: doteqdot without a semi-colon" do
    input = "&doteqdot"
    output = [["Character", "&doteqdot"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dotminus without a semi-colon" do
    input = "&dotminus"
    output = [["Character", "&dotminus"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dotplus without a semi-colon" do
    input = "&dotplus"
    output = [["Character", "&dotplus"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dotsquare without a semi-colon" do
    input = "&dotsquare"
    output = [["Character", "&dotsquare"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: doublebarwedge without a semi-colon" do
    input = "&doublebarwedge"
    output = [["Character", "&doublebarwedge"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: downarrow without a semi-colon" do
    input = "&downarrow"
    output = [["Character", "&downarrow"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: downdownarrows without a semi-colon" do
    input = "&downdownarrows"
    output = [["Character", "&downdownarrows"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: downharpoonleft without a semi-colon" do
    input = "&downharpoonleft"
    output = [["Character", "&downharpoonleft"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: downharpoonright without a semi-colon" do
    input = "&downharpoonright"
    output = [["Character", "&downharpoonright"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: drbkarow without a semi-colon" do
    input = "&drbkarow"
    output = [["Character", "&drbkarow"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: drcorn without a semi-colon" do
    input = "&drcorn"
    output = [["Character", "&drcorn"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: drcrop without a semi-colon" do
    input = "&drcrop"
    output = [["Character", "&drcrop"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dscr without a semi-colon" do
    input = "&dscr"
    output = [["Character", "&dscr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dscy without a semi-colon" do
    input = "&dscy"
    output = [["Character", "&dscy"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dsol without a semi-colon" do
    input = "&dsol"
    output = [["Character", "&dsol"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dstrok without a semi-colon" do
    input = "&dstrok"
    output = [["Character", "&dstrok"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dtdot without a semi-colon" do
    input = "&dtdot"
    output = [["Character", "&dtdot"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dtri without a semi-colon" do
    input = "&dtri"
    output = [["Character", "&dtri"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dtrif without a semi-colon" do
    input = "&dtrif"
    output = [["Character", "&dtrif"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: duarr without a semi-colon" do
    input = "&duarr"
    output = [["Character", "&duarr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: duhar without a semi-colon" do
    input = "&duhar"
    output = [["Character", "&duhar"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dwangle without a semi-colon" do
    input = "&dwangle"
    output = [["Character", "&dwangle"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dzcy without a semi-colon" do
    input = "&dzcy"
    output = [["Character", "&dzcy"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: dzigrarr without a semi-colon" do
    input = "&dzigrarr"
    output = [["Character", "&dzigrarr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: eDDot without a semi-colon" do
    input = "&eDDot"
    output = [["Character", "&eDDot"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: eDot without a semi-colon" do
    input = "&eDot"
    output = [["Character", "&eDot"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: easter without a semi-colon" do
    input = "&easter"
    output = [["Character", "&easter"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: ecaron without a semi-colon" do
    input = "&ecaron"
    output = [["Character", "&ecaron"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: ecir without a semi-colon" do
    input = "&ecir"
    output = [["Character", "&ecir"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: ecolon without a semi-colon" do
    input = "&ecolon"
    output = [["Character", "&ecolon"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: ecy without a semi-colon" do
    input = "&ecy"
    output = [["Character", "&ecy"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: edot without a semi-colon" do
    input = "&edot"
    output = [["Character", "&edot"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: ee without a semi-colon" do
    input = "&ee"
    output = [["Character", "&ee"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: efDot without a semi-colon" do
    input = "&efDot"
    output = [["Character", "&efDot"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: efr without a semi-colon" do
    input = "&efr"
    output = [["Character", "&efr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: eg without a semi-colon" do
    input = "&eg"
    output = [["Character", "&eg"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: egs without a semi-colon" do
    input = "&egs"
    output = [["Character", "&egs"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: egsdot without a semi-colon" do
    input = "&egsdot"
    output = [["Character", "&egsdot"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: el without a semi-colon" do
    input = "&el"
    output = [["Character", "&el"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: elinters without a semi-colon" do
    input = "&elinters"
    output = [["Character", "&elinters"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: ell without a semi-colon" do
    input = "&ell"
    output = [["Character", "&ell"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: els without a semi-colon" do
    input = "&els"
    output = [["Character", "&els"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: elsdot without a semi-colon" do
    input = "&elsdot"
    output = [["Character", "&elsdot"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: emacr without a semi-colon" do
    input = "&emacr"
    output = [["Character", "&emacr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: empty without a semi-colon" do
    input = "&empty"
    output = [["Character", "&empty"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: emptyset without a semi-colon" do
    input = "&emptyset"
    output = [["Character", "&emptyset"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: emptyv without a semi-colon" do
    input = "&emptyv"
    output = [["Character", "&emptyv"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: emsp without a semi-colon" do
    input = "&emsp"
    output = [["Character", "&emsp"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: emsp13 without a semi-colon" do
    input = "&emsp13"
    output = [["Character", "&emsp13"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end
end
