defmodule Floki.HTML.Generated.Tokenizer.NamedentitiesPart38Test do
  use ExUnit.Case, async: true

  # NOTE: This file was generated by "mix generate_tokenizer_tests namedEntities.test".
  # html5lib-tests rev: e52ff68cc7113a6ef3687747fa82691079bf9cc5

  alias Floki.HTML.Tokenizer

  test "tokenize/1 Named entity: precapprox; with a semi-colon" do
    input = "&precapprox;"
    output = [["Character", "⪷"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: preccurlyeq; with a semi-colon" do
    input = "&preccurlyeq;"
    output = [["Character", "≼"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: preceq; with a semi-colon" do
    input = "&preceq;"
    output = [["Character", "⪯"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: precnapprox; with a semi-colon" do
    input = "&precnapprox;"
    output = [["Character", "⪹"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: precneqq; with a semi-colon" do
    input = "&precneqq;"
    output = [["Character", "⪵"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: precnsim; with a semi-colon" do
    input = "&precnsim;"
    output = [["Character", "⋨"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: precsim; with a semi-colon" do
    input = "&precsim;"
    output = [["Character", "≾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: prime; with a semi-colon" do
    input = "&prime;"
    output = [["Character", "′"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: primes; with a semi-colon" do
    input = "&primes;"
    output = [["Character", "ℙ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: prnE; with a semi-colon" do
    input = "&prnE;"
    output = [["Character", "⪵"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: prnap; with a semi-colon" do
    input = "&prnap;"
    output = [["Character", "⪹"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: prnsim; with a semi-colon" do
    input = "&prnsim;"
    output = [["Character", "⋨"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: prod; with a semi-colon" do
    input = "&prod;"
    output = [["Character", "∏"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: profalar; with a semi-colon" do
    input = "&profalar;"
    output = [["Character", "⌮"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: profline; with a semi-colon" do
    input = "&profline;"
    output = [["Character", "⌒"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: profsurf; with a semi-colon" do
    input = "&profsurf;"
    output = [["Character", "⌓"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: prop; with a semi-colon" do
    input = "&prop;"
    output = [["Character", "∝"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: propto; with a semi-colon" do
    input = "&propto;"
    output = [["Character", "∝"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: prsim; with a semi-colon" do
    input = "&prsim;"
    output = [["Character", "≾"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: prurel; with a semi-colon" do
    input = "&prurel;"
    output = [["Character", "⊰"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: pscr; with a semi-colon" do
    input = "&pscr;"
    output = [["Character", "𝓅"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: psi; with a semi-colon" do
    input = "&psi;"
    output = [["Character", "ψ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: puncsp; with a semi-colon" do
    input = "&puncsp;"
    output = [["Character", " "]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: qfr; with a semi-colon" do
    input = "&qfr;"
    output = [["Character", "𝔮"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: qint; with a semi-colon" do
    input = "&qint;"
    output = [["Character", "⨌"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: qopf; with a semi-colon" do
    input = "&qopf;"
    output = [["Character", "𝕢"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: qprime; with a semi-colon" do
    input = "&qprime;"
    output = [["Character", "⁗"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: qscr; with a semi-colon" do
    input = "&qscr;"
    output = [["Character", "𝓆"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: quaternions; with a semi-colon" do
    input = "&quaternions;"
    output = [["Character", "ℍ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: quatint; with a semi-colon" do
    input = "&quatint;"
    output = [["Character", "⨖"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: quest; with a semi-colon" do
    input = "&quest;"
    output = [["Character", "?"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: questeq; with a semi-colon" do
    input = "&questeq;"
    output = [["Character", "≟"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: quot without a semi-colon" do
    input = "&quot"
    output = [["Character", "\""]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: quot; with a semi-colon" do
    input = "&quot;"
    output = [["Character", "\""]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rAarr; with a semi-colon" do
    input = "&rAarr;"
    output = [["Character", "⇛"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rArr; with a semi-colon" do
    input = "&rArr;"
    output = [["Character", "⇒"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rAtail; with a semi-colon" do
    input = "&rAtail;"
    output = [["Character", "⤜"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rBarr; with a semi-colon" do
    input = "&rBarr;"
    output = [["Character", "⤏"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rHar; with a semi-colon" do
    input = "&rHar;"
    output = [["Character", "⥤"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: race; with a semi-colon" do
    input = "&race;"
    output = [["Character", "∽̱"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: racute; with a semi-colon" do
    input = "&racute;"
    output = [["Character", "ŕ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: radic; with a semi-colon" do
    input = "&radic;"
    output = [["Character", "√"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: raemptyv; with a semi-colon" do
    input = "&raemptyv;"
    output = [["Character", "⦳"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rang; with a semi-colon" do
    input = "&rang;"
    output = [["Character", "⟩"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rangd; with a semi-colon" do
    input = "&rangd;"
    output = [["Character", "⦒"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: range; with a semi-colon" do
    input = "&range;"
    output = [["Character", "⦥"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rangle; with a semi-colon" do
    input = "&rangle;"
    output = [["Character", "⟩"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: raquo without a semi-colon" do
    input = "&raquo"
    output = [["Character", "»"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: raquo; with a semi-colon" do
    input = "&raquo;"
    output = [["Character", "»"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rarr; with a semi-colon" do
    input = "&rarr;"
    output = [["Character", "→"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rarrap; with a semi-colon" do
    input = "&rarrap;"
    output = [["Character", "⥵"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rarrb; with a semi-colon" do
    input = "&rarrb;"
    output = [["Character", "⇥"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rarrbfs; with a semi-colon" do
    input = "&rarrbfs;"
    output = [["Character", "⤠"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rarrc; with a semi-colon" do
    input = "&rarrc;"
    output = [["Character", "⤳"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rarrfs; with a semi-colon" do
    input = "&rarrfs;"
    output = [["Character", "⤞"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rarrhk; with a semi-colon" do
    input = "&rarrhk;"
    output = [["Character", "↪"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rarrlp; with a semi-colon" do
    input = "&rarrlp;"
    output = [["Character", "↬"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rarrpl; with a semi-colon" do
    input = "&rarrpl;"
    output = [["Character", "⥅"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rarrsim; with a semi-colon" do
    input = "&rarrsim;"
    output = [["Character", "⥴"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rarrtl; with a semi-colon" do
    input = "&rarrtl;"
    output = [["Character", "↣"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rarrw; with a semi-colon" do
    input = "&rarrw;"
    output = [["Character", "↝"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: ratail; with a semi-colon" do
    input = "&ratail;"
    output = [["Character", "⤚"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: ratio; with a semi-colon" do
    input = "&ratio;"
    output = [["Character", "∶"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rationals; with a semi-colon" do
    input = "&rationals;"
    output = [["Character", "ℚ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rbarr; with a semi-colon" do
    input = "&rbarr;"
    output = [["Character", "⤍"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rbbrk; with a semi-colon" do
    input = "&rbbrk;"
    output = [["Character", "❳"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rbrace; with a semi-colon" do
    input = "&rbrace;"
    output = [["Character", "}"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rbrack; with a semi-colon" do
    input = "&rbrack;"
    output = [["Character", "]"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rbrke; with a semi-colon" do
    input = "&rbrke;"
    output = [["Character", "⦌"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rbrksld; with a semi-colon" do
    input = "&rbrksld;"
    output = [["Character", "⦎"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rbrkslu; with a semi-colon" do
    input = "&rbrkslu;"
    output = [["Character", "⦐"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rcaron; with a semi-colon" do
    input = "&rcaron;"
    output = [["Character", "ř"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rcedil; with a semi-colon" do
    input = "&rcedil;"
    output = [["Character", "ŗ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rceil; with a semi-colon" do
    input = "&rceil;"
    output = [["Character", "⌉"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rcub; with a semi-colon" do
    input = "&rcub;"
    output = [["Character", "}"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rcy; with a semi-colon" do
    input = "&rcy;"
    output = [["Character", "р"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rdca; with a semi-colon" do
    input = "&rdca;"
    output = [["Character", "⤷"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rdldhar; with a semi-colon" do
    input = "&rdldhar;"
    output = [["Character", "⥩"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rdquo; with a semi-colon" do
    input = "&rdquo;"
    output = [["Character", "”"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rdquor; with a semi-colon" do
    input = "&rdquor;"
    output = [["Character", "”"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rdsh; with a semi-colon" do
    input = "&rdsh;"
    output = [["Character", "↳"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: real; with a semi-colon" do
    input = "&real;"
    output = [["Character", "ℜ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: realine; with a semi-colon" do
    input = "&realine;"
    output = [["Character", "ℛ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: realpart; with a semi-colon" do
    input = "&realpart;"
    output = [["Character", "ℜ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: reals; with a semi-colon" do
    input = "&reals;"
    output = [["Character", "ℝ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rect; with a semi-colon" do
    input = "&rect;"
    output = [["Character", "▭"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: reg without a semi-colon" do
    input = "&reg"
    output = [["Character", "®"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: reg; with a semi-colon" do
    input = "&reg;"
    output = [["Character", "®"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rfisht; with a semi-colon" do
    input = "&rfisht;"
    output = [["Character", "⥽"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rfloor; with a semi-colon" do
    input = "&rfloor;"
    output = [["Character", "⌋"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rfr; with a semi-colon" do
    input = "&rfr;"
    output = [["Character", "𝔯"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rhard; with a semi-colon" do
    input = "&rhard;"
    output = [["Character", "⇁"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rharu; with a semi-colon" do
    input = "&rharu;"
    output = [["Character", "⇀"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rharul; with a semi-colon" do
    input = "&rharul;"
    output = [["Character", "⥬"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rho; with a semi-colon" do
    input = "&rho;"
    output = [["Character", "ρ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rhov; with a semi-colon" do
    input = "&rhov;"
    output = [["Character", "ϱ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rightarrow; with a semi-colon" do
    input = "&rightarrow;"
    output = [["Character", "→"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rightarrowtail; with a semi-colon" do
    input = "&rightarrowtail;"
    output = [["Character", "↣"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rightharpoondown; with a semi-colon" do
    input = "&rightharpoondown;"
    output = [["Character", "⇁"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: rightharpoonup; with a semi-colon" do
    input = "&rightharpoonup;"
    output = [["Character", "⇀"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end
end