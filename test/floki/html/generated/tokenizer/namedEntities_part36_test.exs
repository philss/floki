defmodule Floki.HTML.Generated.Tokenizer.NamedentitiesPart36Test do
  use ExUnit.Case, async: true

  # NOTE: This file was generated by "mix generate_tokenizer_tests namedEntities.test".
  # html5lib-tests rev: e52ff68cc7113a6ef3687747fa82691079bf9cc5

  alias Floki.HTML.Tokenizer

  test "tokenize/1 Named entity: nlsim; with a semi-colon" do
    input = "&nlsim;"
    output = [["Character", "≴"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nlt; with a semi-colon" do
    input = "&nlt;"
    output = [["Character", "≮"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nltri; with a semi-colon" do
    input = "&nltri;"
    output = [["Character", "⋪"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nltrie; with a semi-colon" do
    input = "&nltrie;"
    output = [["Character", "⋬"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nmid; with a semi-colon" do
    input = "&nmid;"
    output = [["Character", "∤"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nopf; with a semi-colon" do
    input = "&nopf;"
    output = [["Character", "𝕟"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: not without a semi-colon" do
    input = "&not"
    output = [["Character", "¬"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: not; with a semi-colon" do
    input = "&not;"
    output = [["Character", "¬"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: notin; with a semi-colon" do
    input = "&notin;"
    output = [["Character", "∉"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: notinE; with a semi-colon" do
    input = "&notinE;"
    output = [["Character", "⋹̸"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: notindot; with a semi-colon" do
    input = "&notindot;"
    output = [["Character", "⋵̸"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: notinva; with a semi-colon" do
    input = "&notinva;"
    output = [["Character", "∉"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: notinvb; with a semi-colon" do
    input = "&notinvb;"
    output = [["Character", "⋷"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: notinvc; with a semi-colon" do
    input = "&notinvc;"
    output = [["Character", "⋶"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: notni; with a semi-colon" do
    input = "&notni;"
    output = [["Character", "∌"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: notniva; with a semi-colon" do
    input = "&notniva;"
    output = [["Character", "∌"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: notnivb; with a semi-colon" do
    input = "&notnivb;"
    output = [["Character", "⋾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: notnivc; with a semi-colon" do
    input = "&notnivc;"
    output = [["Character", "⋽"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: npar; with a semi-colon" do
    input = "&npar;"
    output = [["Character", "∦"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nparallel; with a semi-colon" do
    input = "&nparallel;"
    output = [["Character", "∦"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nparsl; with a semi-colon" do
    input = "&nparsl;"
    output = [["Character", "⫽⃥"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: npart; with a semi-colon" do
    input = "&npart;"
    output = [["Character", "∂̸"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: npolint; with a semi-colon" do
    input = "&npolint;"
    output = [["Character", "⨔"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: npr; with a semi-colon" do
    input = "&npr;"
    output = [["Character", "⊀"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nprcue; with a semi-colon" do
    input = "&nprcue;"
    output = [["Character", "⋠"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: npre; with a semi-colon" do
    input = "&npre;"
    output = [["Character", "⪯̸"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nprec; with a semi-colon" do
    input = "&nprec;"
    output = [["Character", "⊀"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: npreceq; with a semi-colon" do
    input = "&npreceq;"
    output = [["Character", "⪯̸"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nrArr; with a semi-colon" do
    input = "&nrArr;"
    output = [["Character", "⇏"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nrarr; with a semi-colon" do
    input = "&nrarr;"
    output = [["Character", "↛"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nrarrc; with a semi-colon" do
    input = "&nrarrc;"
    output = [["Character", "⤳̸"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nrarrw; with a semi-colon" do
    input = "&nrarrw;"
    output = [["Character", "↝̸"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nrightarrow; with a semi-colon" do
    input = "&nrightarrow;"
    output = [["Character", "↛"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nrtri; with a semi-colon" do
    input = "&nrtri;"
    output = [["Character", "⋫"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nrtrie; with a semi-colon" do
    input = "&nrtrie;"
    output = [["Character", "⋭"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nsc; with a semi-colon" do
    input = "&nsc;"
    output = [["Character", "⊁"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nsccue; with a semi-colon" do
    input = "&nsccue;"
    output = [["Character", "⋡"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nsce; with a semi-colon" do
    input = "&nsce;"
    output = [["Character", "⪰̸"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nscr; with a semi-colon" do
    input = "&nscr;"
    output = [["Character", "𝓃"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nshortmid; with a semi-colon" do
    input = "&nshortmid;"
    output = [["Character", "∤"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nshortparallel; with a semi-colon" do
    input = "&nshortparallel;"
    output = [["Character", "∦"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nsim; with a semi-colon" do
    input = "&nsim;"
    output = [["Character", "≁"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nsime; with a semi-colon" do
    input = "&nsime;"
    output = [["Character", "≄"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nsimeq; with a semi-colon" do
    input = "&nsimeq;"
    output = [["Character", "≄"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nsmid; with a semi-colon" do
    input = "&nsmid;"
    output = [["Character", "∤"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nspar; with a semi-colon" do
    input = "&nspar;"
    output = [["Character", "∦"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nsqsube; with a semi-colon" do
    input = "&nsqsube;"
    output = [["Character", "⋢"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nsqsupe; with a semi-colon" do
    input = "&nsqsupe;"
    output = [["Character", "⋣"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nsub; with a semi-colon" do
    input = "&nsub;"
    output = [["Character", "⊄"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nsubE; with a semi-colon" do
    input = "&nsubE;"
    output = [["Character", "⫅̸"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nsube; with a semi-colon" do
    input = "&nsube;"
    output = [["Character", "⊈"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nsubset; with a semi-colon" do
    input = "&nsubset;"
    output = [["Character", "⊂⃒"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nsubseteq; with a semi-colon" do
    input = "&nsubseteq;"
    output = [["Character", "⊈"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nsubseteqq; with a semi-colon" do
    input = "&nsubseteqq;"
    output = [["Character", "⫅̸"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nsucc; with a semi-colon" do
    input = "&nsucc;"
    output = [["Character", "⊁"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nsucceq; with a semi-colon" do
    input = "&nsucceq;"
    output = [["Character", "⪰̸"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nsup; with a semi-colon" do
    input = "&nsup;"
    output = [["Character", "⊅"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nsupE; with a semi-colon" do
    input = "&nsupE;"
    output = [["Character", "⫆̸"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nsupe; with a semi-colon" do
    input = "&nsupe;"
    output = [["Character", "⊉"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nsupset; with a semi-colon" do
    input = "&nsupset;"
    output = [["Character", "⊃⃒"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nsupseteq; with a semi-colon" do
    input = "&nsupseteq;"
    output = [["Character", "⊉"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nsupseteqq; with a semi-colon" do
    input = "&nsupseteqq;"
    output = [["Character", "⫆̸"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: ntgl; with a semi-colon" do
    input = "&ntgl;"
    output = [["Character", "≹"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: ntilde without a semi-colon" do
    input = "&ntilde"
    output = [["Character", "ñ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: ntilde; with a semi-colon" do
    input = "&ntilde;"
    output = [["Character", "ñ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: ntlg; with a semi-colon" do
    input = "&ntlg;"
    output = [["Character", "≸"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: ntriangleleft; with a semi-colon" do
    input = "&ntriangleleft;"
    output = [["Character", "⋪"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: ntrianglelefteq; with a semi-colon" do
    input = "&ntrianglelefteq;"
    output = [["Character", "⋬"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: ntriangleright; with a semi-colon" do
    input = "&ntriangleright;"
    output = [["Character", "⋫"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: ntrianglerighteq; with a semi-colon" do
    input = "&ntrianglerighteq;"
    output = [["Character", "⋭"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nu; with a semi-colon" do
    input = "&nu;"
    output = [["Character", "ν"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: num; with a semi-colon" do
    input = "&num;"
    output = [["Character", "#"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: numero; with a semi-colon" do
    input = "&numero;"
    output = [["Character", "№"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: numsp; with a semi-colon" do
    input = "&numsp;"
    output = [["Character", " "]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nvDash; with a semi-colon" do
    input = "&nvDash;"
    output = [["Character", "⊭"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nvHarr; with a semi-colon" do
    input = "&nvHarr;"
    output = [["Character", "⤄"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nvap; with a semi-colon" do
    input = "&nvap;"
    output = [["Character", "≍⃒"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nvdash; with a semi-colon" do
    input = "&nvdash;"
    output = [["Character", "⊬"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nvge; with a semi-colon" do
    input = "&nvge;"
    output = [["Character", "≥⃒"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nvgt; with a semi-colon" do
    input = "&nvgt;"
    output = [["Character", ">⃒"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nvinfin; with a semi-colon" do
    input = "&nvinfin;"
    output = [["Character", "⧞"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nvlArr; with a semi-colon" do
    input = "&nvlArr;"
    output = [["Character", "⤂"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nvle; with a semi-colon" do
    input = "&nvle;"
    output = [["Character", "≤⃒"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nvlt; with a semi-colon" do
    input = "&nvlt;"
    output = [["Character", "<⃒"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nvltrie; with a semi-colon" do
    input = "&nvltrie;"
    output = [["Character", "⊴⃒"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nvrArr; with a semi-colon" do
    input = "&nvrArr;"
    output = [["Character", "⤃"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nvrtrie; with a semi-colon" do
    input = "&nvrtrie;"
    output = [["Character", "⊵⃒"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nvsim; with a semi-colon" do
    input = "&nvsim;"
    output = [["Character", "∼⃒"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nwArr; with a semi-colon" do
    input = "&nwArr;"
    output = [["Character", "⇖"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nwarhk; with a semi-colon" do
    input = "&nwarhk;"
    output = [["Character", "⤣"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nwarr; with a semi-colon" do
    input = "&nwarr;"
    output = [["Character", "↖"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nwarrow; with a semi-colon" do
    input = "&nwarrow;"
    output = [["Character", "↖"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: nwnear; with a semi-colon" do
    input = "&nwnear;"
    output = [["Character", "⤧"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: oS; with a semi-colon" do
    input = "&oS;"
    output = [["Character", "Ⓢ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: oacute without a semi-colon" do
    input = "&oacute"
    output = [["Character", "ó"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: oacute; with a semi-colon" do
    input = "&oacute;"
    output = [["Character", "ó"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: oast; with a semi-colon" do
    input = "&oast;"
    output = [["Character", "⊛"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: ocir; with a semi-colon" do
    input = "&ocir;"
    output = [["Character", "⊚"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: ocirc without a semi-colon" do
    input = "&ocirc"
    output = [["Character", "ô"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: ocirc; with a semi-colon" do
    input = "&ocirc;"
    output = [["Character", "ô"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end
end
