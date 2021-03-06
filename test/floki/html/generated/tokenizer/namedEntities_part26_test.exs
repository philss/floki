defmodule Floki.HTML.Generated.Tokenizer.NamedentitiesPart26Test do
  use ExUnit.Case, async: true

  # NOTE: This file was generated by "mix generate_tokenizer_tests namedEntities.test".
  # html5lib-tests rev: e52ff68cc7113a6ef3687747fa82691079bf9cc5

  alias Floki.HTML.Tokenizer

  test "tokenize/1 Named entity: Superset; with a semi-colon" do
    input = "&Superset;"
    output = [["Character", "⊃"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: SupersetEqual; with a semi-colon" do
    input = "&SupersetEqual;"
    output = [["Character", "⊇"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Supset; with a semi-colon" do
    input = "&Supset;"
    output = [["Character", "⋑"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: THORN without a semi-colon" do
    input = "&THORN"
    output = [["Character", "Þ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: THORN; with a semi-colon" do
    input = "&THORN;"
    output = [["Character", "Þ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: TRADE; with a semi-colon" do
    input = "&TRADE;"
    output = [["Character", "™"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: TSHcy; with a semi-colon" do
    input = "&TSHcy;"
    output = [["Character", "Ћ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: TScy; with a semi-colon" do
    input = "&TScy;"
    output = [["Character", "Ц"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Tab; with a semi-colon" do
    input = "&Tab;"
    output = [["Character", "\t"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Tau; with a semi-colon" do
    input = "&Tau;"
    output = [["Character", "Τ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Tcaron; with a semi-colon" do
    input = "&Tcaron;"
    output = [["Character", "Ť"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Tcedil; with a semi-colon" do
    input = "&Tcedil;"
    output = [["Character", "Ţ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Tcy; with a semi-colon" do
    input = "&Tcy;"
    output = [["Character", "Т"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Tfr; with a semi-colon" do
    input = "&Tfr;"
    output = [["Character", "𝔗"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Therefore; with a semi-colon" do
    input = "&Therefore;"
    output = [["Character", "∴"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Theta; with a semi-colon" do
    input = "&Theta;"
    output = [["Character", "Θ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: ThickSpace; with a semi-colon" do
    input = "&ThickSpace;"
    output = [["Character", "  "]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: ThinSpace; with a semi-colon" do
    input = "&ThinSpace;"
    output = [["Character", " "]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Tilde; with a semi-colon" do
    input = "&Tilde;"
    output = [["Character", "∼"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: TildeEqual; with a semi-colon" do
    input = "&TildeEqual;"
    output = [["Character", "≃"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: TildeFullEqual; with a semi-colon" do
    input = "&TildeFullEqual;"
    output = [["Character", "≅"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: TildeTilde; with a semi-colon" do
    input = "&TildeTilde;"
    output = [["Character", "≈"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Topf; with a semi-colon" do
    input = "&Topf;"
    output = [["Character", "𝕋"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: TripleDot; with a semi-colon" do
    input = "&TripleDot;"
    output = [["Character", "⃛"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Tscr; with a semi-colon" do
    input = "&Tscr;"
    output = [["Character", "𝒯"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Tstrok; with a semi-colon" do
    input = "&Tstrok;"
    output = [["Character", "Ŧ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Uacute without a semi-colon" do
    input = "&Uacute"
    output = [["Character", "Ú"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Uacute; with a semi-colon" do
    input = "&Uacute;"
    output = [["Character", "Ú"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Uarr; with a semi-colon" do
    input = "&Uarr;"
    output = [["Character", "↟"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Uarrocir; with a semi-colon" do
    input = "&Uarrocir;"
    output = [["Character", "⥉"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Ubrcy; with a semi-colon" do
    input = "&Ubrcy;"
    output = [["Character", "Ў"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Ubreve; with a semi-colon" do
    input = "&Ubreve;"
    output = [["Character", "Ŭ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Ucirc without a semi-colon" do
    input = "&Ucirc"
    output = [["Character", "Û"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Ucirc; with a semi-colon" do
    input = "&Ucirc;"
    output = [["Character", "Û"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Ucy; with a semi-colon" do
    input = "&Ucy;"
    output = [["Character", "У"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Udblac; with a semi-colon" do
    input = "&Udblac;"
    output = [["Character", "Ű"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Ufr; with a semi-colon" do
    input = "&Ufr;"
    output = [["Character", "𝔘"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Ugrave without a semi-colon" do
    input = "&Ugrave"
    output = [["Character", "Ù"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Ugrave; with a semi-colon" do
    input = "&Ugrave;"
    output = [["Character", "Ù"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Umacr; with a semi-colon" do
    input = "&Umacr;"
    output = [["Character", "Ū"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: UnderBar; with a semi-colon" do
    input = "&UnderBar;"
    output = [["Character", "_"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: UnderBrace; with a semi-colon" do
    input = "&UnderBrace;"
    output = [["Character", "⏟"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: UnderBracket; with a semi-colon" do
    input = "&UnderBracket;"
    output = [["Character", "⎵"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: UnderParenthesis; with a semi-colon" do
    input = "&UnderParenthesis;"
    output = [["Character", "⏝"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Union; with a semi-colon" do
    input = "&Union;"
    output = [["Character", "⋃"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: UnionPlus; with a semi-colon" do
    input = "&UnionPlus;"
    output = [["Character", "⊎"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Uogon; with a semi-colon" do
    input = "&Uogon;"
    output = [["Character", "Ų"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Uopf; with a semi-colon" do
    input = "&Uopf;"
    output = [["Character", "𝕌"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: UpArrow; with a semi-colon" do
    input = "&UpArrow;"
    output = [["Character", "↑"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: UpArrowBar; with a semi-colon" do
    input = "&UpArrowBar;"
    output = [["Character", "⤒"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: UpArrowDownArrow; with a semi-colon" do
    input = "&UpArrowDownArrow;"
    output = [["Character", "⇅"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: UpDownArrow; with a semi-colon" do
    input = "&UpDownArrow;"
    output = [["Character", "↕"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: UpEquilibrium; with a semi-colon" do
    input = "&UpEquilibrium;"
    output = [["Character", "⥮"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: UpTee; with a semi-colon" do
    input = "&UpTee;"
    output = [["Character", "⊥"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: UpTeeArrow; with a semi-colon" do
    input = "&UpTeeArrow;"
    output = [["Character", "↥"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Uparrow; with a semi-colon" do
    input = "&Uparrow;"
    output = [["Character", "⇑"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Updownarrow; with a semi-colon" do
    input = "&Updownarrow;"
    output = [["Character", "⇕"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: UpperLeftArrow; with a semi-colon" do
    input = "&UpperLeftArrow;"
    output = [["Character", "↖"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: UpperRightArrow; with a semi-colon" do
    input = "&UpperRightArrow;"
    output = [["Character", "↗"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Upsi; with a semi-colon" do
    input = "&Upsi;"
    output = [["Character", "ϒ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Upsilon; with a semi-colon" do
    input = "&Upsilon;"
    output = [["Character", "Υ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Uring; with a semi-colon" do
    input = "&Uring;"
    output = [["Character", "Ů"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Uscr; with a semi-colon" do
    input = "&Uscr;"
    output = [["Character", "𝒰"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Utilde; with a semi-colon" do
    input = "&Utilde;"
    output = [["Character", "Ũ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Uuml without a semi-colon" do
    input = "&Uuml"
    output = [["Character", "Ü"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Uuml; with a semi-colon" do
    input = "&Uuml;"
    output = [["Character", "Ü"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: VDash; with a semi-colon" do
    input = "&VDash;"
    output = [["Character", "⊫"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Vbar; with a semi-colon" do
    input = "&Vbar;"
    output = [["Character", "⫫"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Vcy; with a semi-colon" do
    input = "&Vcy;"
    output = [["Character", "В"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Vdash; with a semi-colon" do
    input = "&Vdash;"
    output = [["Character", "⊩"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Vdashl; with a semi-colon" do
    input = "&Vdashl;"
    output = [["Character", "⫦"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Vee; with a semi-colon" do
    input = "&Vee;"
    output = [["Character", "⋁"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Verbar; with a semi-colon" do
    input = "&Verbar;"
    output = [["Character", "‖"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Vert; with a semi-colon" do
    input = "&Vert;"
    output = [["Character", "‖"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: VerticalBar; with a semi-colon" do
    input = "&VerticalBar;"
    output = [["Character", "∣"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: VerticalLine; with a semi-colon" do
    input = "&VerticalLine;"
    output = [["Character", "|"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: VerticalSeparator; with a semi-colon" do
    input = "&VerticalSeparator;"
    output = [["Character", "❘"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: VerticalTilde; with a semi-colon" do
    input = "&VerticalTilde;"
    output = [["Character", "≀"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: VeryThinSpace; with a semi-colon" do
    input = "&VeryThinSpace;"
    output = [["Character", " "]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Vfr; with a semi-colon" do
    input = "&Vfr;"
    output = [["Character", "𝔙"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Vopf; with a semi-colon" do
    input = "&Vopf;"
    output = [["Character", "𝕍"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Vscr; with a semi-colon" do
    input = "&Vscr;"
    output = [["Character", "𝒱"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Vvdash; with a semi-colon" do
    input = "&Vvdash;"
    output = [["Character", "⊪"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Wcirc; with a semi-colon" do
    input = "&Wcirc;"
    output = [["Character", "Ŵ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Wedge; with a semi-colon" do
    input = "&Wedge;"
    output = [["Character", "⋀"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Wfr; with a semi-colon" do
    input = "&Wfr;"
    output = [["Character", "𝔚"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Wopf; with a semi-colon" do
    input = "&Wopf;"
    output = [["Character", "𝕎"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Wscr; with a semi-colon" do
    input = "&Wscr;"
    output = [["Character", "𝒲"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Xfr; with a semi-colon" do
    input = "&Xfr;"
    output = [["Character", "𝔛"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Xi; with a semi-colon" do
    input = "&Xi;"
    output = [["Character", "Ξ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Xopf; with a semi-colon" do
    input = "&Xopf;"
    output = [["Character", "𝕏"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Xscr; with a semi-colon" do
    input = "&Xscr;"
    output = [["Character", "𝒳"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: YAcy; with a semi-colon" do
    input = "&YAcy;"
    output = [["Character", "Я"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: YIcy; with a semi-colon" do
    input = "&YIcy;"
    output = [["Character", "Ї"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: YUcy; with a semi-colon" do
    input = "&YUcy;"
    output = [["Character", "Ю"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Yacute without a semi-colon" do
    input = "&Yacute"
    output = [["Character", "Ý"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Yacute; with a semi-colon" do
    input = "&Yacute;"
    output = [["Character", "Ý"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Ycirc; with a semi-colon" do
    input = "&Ycirc;"
    output = [["Character", "Ŷ"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Ycy; with a semi-colon" do
    input = "&Ycy;"
    output = [["Character", "Ы"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Named entity: Yfr; with a semi-colon" do
    input = "&Yfr;"
    output = [["Character", "𝔜"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end
end
