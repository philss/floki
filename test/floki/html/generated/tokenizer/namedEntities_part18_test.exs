defmodule Floki.HTML.Generated.Tokenizer.NamedentitiesPart18Test do
  use ExUnit.Case, async: true

  # NOTE: This file was generated by "mix generate_tokenizer_tests namedEntities.test".
  # html5lib-tests rev: e52ff68cc7113a6ef3687747fa82691079bf9cc5

  alias Floki.HTML.Tokenizer

  test "tokenize/1 Bad named entity: softcy without a semi-colon" do
    input = "&softcy"
    output = [["Character", "&softcy"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: sol without a semi-colon" do
    input = "&sol"
    output = [["Character", "&sol"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: solb without a semi-colon" do
    input = "&solb"
    output = [["Character", "&solb"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: solbar without a semi-colon" do
    input = "&solbar"
    output = [["Character", "&solbar"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: sopf without a semi-colon" do
    input = "&sopf"
    output = [["Character", "&sopf"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: spades without a semi-colon" do
    input = "&spades"
    output = [["Character", "&spades"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: spadesuit without a semi-colon" do
    input = "&spadesuit"
    output = [["Character", "&spadesuit"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: spar without a semi-colon" do
    input = "&spar"
    output = [["Character", "&spar"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: sqcap without a semi-colon" do
    input = "&sqcap"
    output = [["Character", "&sqcap"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: sqcaps without a semi-colon" do
    input = "&sqcaps"
    output = [["Character", "&sqcaps"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: sqcup without a semi-colon" do
    input = "&sqcup"
    output = [["Character", "&sqcup"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: sqcups without a semi-colon" do
    input = "&sqcups"
    output = [["Character", "&sqcups"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: sqsub without a semi-colon" do
    input = "&sqsub"
    output = [["Character", "&sqsub"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: sqsube without a semi-colon" do
    input = "&sqsube"
    output = [["Character", "&sqsube"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: sqsubset without a semi-colon" do
    input = "&sqsubset"
    output = [["Character", "&sqsubset"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: sqsubseteq without a semi-colon" do
    input = "&sqsubseteq"
    output = [["Character", "&sqsubseteq"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: sqsup without a semi-colon" do
    input = "&sqsup"
    output = [["Character", "&sqsup"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: sqsupe without a semi-colon" do
    input = "&sqsupe"
    output = [["Character", "&sqsupe"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: sqsupset without a semi-colon" do
    input = "&sqsupset"
    output = [["Character", "&sqsupset"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: sqsupseteq without a semi-colon" do
    input = "&sqsupseteq"
    output = [["Character", "&sqsupseteq"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: squ without a semi-colon" do
    input = "&squ"
    output = [["Character", "&squ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: square without a semi-colon" do
    input = "&square"
    output = [["Character", "&square"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: squarf without a semi-colon" do
    input = "&squarf"
    output = [["Character", "&squarf"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: squf without a semi-colon" do
    input = "&squf"
    output = [["Character", "&squf"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: srarr without a semi-colon" do
    input = "&srarr"
    output = [["Character", "&srarr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: sscr without a semi-colon" do
    input = "&sscr"
    output = [["Character", "&sscr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: ssetmn without a semi-colon" do
    input = "&ssetmn"
    output = [["Character", "&ssetmn"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: ssmile without a semi-colon" do
    input = "&ssmile"
    output = [["Character", "&ssmile"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: sstarf without a semi-colon" do
    input = "&sstarf"
    output = [["Character", "&sstarf"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: star without a semi-colon" do
    input = "&star"
    output = [["Character", "&star"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: starf without a semi-colon" do
    input = "&starf"
    output = [["Character", "&starf"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: straightepsilon without a semi-colon" do
    input = "&straightepsilon"
    output = [["Character", "&straightepsilon"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: straightphi without a semi-colon" do
    input = "&straightphi"
    output = [["Character", "&straightphi"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: strns without a semi-colon" do
    input = "&strns"
    output = [["Character", "&strns"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: sub without a semi-colon" do
    input = "&sub"
    output = [["Character", "&sub"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: subE without a semi-colon" do
    input = "&subE"
    output = [["Character", "&subE"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: subdot without a semi-colon" do
    input = "&subdot"
    output = [["Character", "&subdot"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: sube without a semi-colon" do
    input = "&sube"
    output = [["Character", "&sube"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: subedot without a semi-colon" do
    input = "&subedot"
    output = [["Character", "&subedot"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: submult without a semi-colon" do
    input = "&submult"
    output = [["Character", "&submult"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: subnE without a semi-colon" do
    input = "&subnE"
    output = [["Character", "&subnE"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: subne without a semi-colon" do
    input = "&subne"
    output = [["Character", "&subne"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: subplus without a semi-colon" do
    input = "&subplus"
    output = [["Character", "&subplus"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: subrarr without a semi-colon" do
    input = "&subrarr"
    output = [["Character", "&subrarr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: subset without a semi-colon" do
    input = "&subset"
    output = [["Character", "&subset"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: subseteq without a semi-colon" do
    input = "&subseteq"
    output = [["Character", "&subseteq"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: subseteqq without a semi-colon" do
    input = "&subseteqq"
    output = [["Character", "&subseteqq"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: subsetneq without a semi-colon" do
    input = "&subsetneq"
    output = [["Character", "&subsetneq"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: subsetneqq without a semi-colon" do
    input = "&subsetneqq"
    output = [["Character", "&subsetneqq"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: subsim without a semi-colon" do
    input = "&subsim"
    output = [["Character", "&subsim"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: subsub without a semi-colon" do
    input = "&subsub"
    output = [["Character", "&subsub"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: subsup without a semi-colon" do
    input = "&subsup"
    output = [["Character", "&subsup"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: succ without a semi-colon" do
    input = "&succ"
    output = [["Character", "&succ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: succapprox without a semi-colon" do
    input = "&succapprox"
    output = [["Character", "&succapprox"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: succcurlyeq without a semi-colon" do
    input = "&succcurlyeq"
    output = [["Character", "&succcurlyeq"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: succeq without a semi-colon" do
    input = "&succeq"
    output = [["Character", "&succeq"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: succnapprox without a semi-colon" do
    input = "&succnapprox"
    output = [["Character", "&succnapprox"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: succneqq without a semi-colon" do
    input = "&succneqq"
    output = [["Character", "&succneqq"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: succnsim without a semi-colon" do
    input = "&succnsim"
    output = [["Character", "&succnsim"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: succsim without a semi-colon" do
    input = "&succsim"
    output = [["Character", "&succsim"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: sum without a semi-colon" do
    input = "&sum"
    output = [["Character", "&sum"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: sung without a semi-colon" do
    input = "&sung"
    output = [["Character", "&sung"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: sup without a semi-colon" do
    input = "&sup"
    output = [["Character", "&sup"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: supE without a semi-colon" do
    input = "&supE"
    output = [["Character", "&supE"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: supdot without a semi-colon" do
    input = "&supdot"
    output = [["Character", "&supdot"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: supdsub without a semi-colon" do
    input = "&supdsub"
    output = [["Character", "&supdsub"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: supe without a semi-colon" do
    input = "&supe"
    output = [["Character", "&supe"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: supedot without a semi-colon" do
    input = "&supedot"
    output = [["Character", "&supedot"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: suphsol without a semi-colon" do
    input = "&suphsol"
    output = [["Character", "&suphsol"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: suphsub without a semi-colon" do
    input = "&suphsub"
    output = [["Character", "&suphsub"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: suplarr without a semi-colon" do
    input = "&suplarr"
    output = [["Character", "&suplarr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: supmult without a semi-colon" do
    input = "&supmult"
    output = [["Character", "&supmult"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: supnE without a semi-colon" do
    input = "&supnE"
    output = [["Character", "&supnE"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: supne without a semi-colon" do
    input = "&supne"
    output = [["Character", "&supne"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: supplus without a semi-colon" do
    input = "&supplus"
    output = [["Character", "&supplus"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: supset without a semi-colon" do
    input = "&supset"
    output = [["Character", "&supset"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: supseteq without a semi-colon" do
    input = "&supseteq"
    output = [["Character", "&supseteq"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: supseteqq without a semi-colon" do
    input = "&supseteqq"
    output = [["Character", "&supseteqq"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: supsetneq without a semi-colon" do
    input = "&supsetneq"
    output = [["Character", "&supsetneq"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: supsetneqq without a semi-colon" do
    input = "&supsetneqq"
    output = [["Character", "&supsetneqq"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: supsim without a semi-colon" do
    input = "&supsim"
    output = [["Character", "&supsim"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: supsub without a semi-colon" do
    input = "&supsub"
    output = [["Character", "&supsub"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: supsup without a semi-colon" do
    input = "&supsup"
    output = [["Character", "&supsup"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: swArr without a semi-colon" do
    input = "&swArr"
    output = [["Character", "&swArr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: swarhk without a semi-colon" do
    input = "&swarhk"
    output = [["Character", "&swarhk"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: swarr without a semi-colon" do
    input = "&swarr"
    output = [["Character", "&swarr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: swarrow without a semi-colon" do
    input = "&swarrow"
    output = [["Character", "&swarrow"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: swnwar without a semi-colon" do
    input = "&swnwar"
    output = [["Character", "&swnwar"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: target without a semi-colon" do
    input = "&target"
    output = [["Character", "&target"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: tau without a semi-colon" do
    input = "&tau"
    output = [["Character", "&tau"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: tbrk without a semi-colon" do
    input = "&tbrk"
    output = [["Character", "&tbrk"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: tcaron without a semi-colon" do
    input = "&tcaron"
    output = [["Character", "&tcaron"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: tcedil without a semi-colon" do
    input = "&tcedil"
    output = [["Character", "&tcedil"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: tcy without a semi-colon" do
    input = "&tcy"
    output = [["Character", "&tcy"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: tdot without a semi-colon" do
    input = "&tdot"
    output = [["Character", "&tdot"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: telrec without a semi-colon" do
    input = "&telrec"
    output = [["Character", "&telrec"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: tfr without a semi-colon" do
    input = "&tfr"
    output = [["Character", "&tfr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: there4 without a semi-colon" do
    input = "&there4"
    output = [["Character", "&there4"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: therefore without a semi-colon" do
    input = "&therefore"
    output = [["Character", "&therefore"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: theta without a semi-colon" do
    input = "&theta"
    output = [["Character", "&theta"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end
end
