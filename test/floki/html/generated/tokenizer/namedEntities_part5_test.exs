defmodule Floki.HTML.Generated.Tokenizer.NamedentitiesPart5Test do
  use ExUnit.Case, async: true

  # NOTE: This file was generated by "mix generate_tokenizer_tests namedEntities.test".
  # html5lib-tests rev: e52ff68cc7113a6ef3687747fa82691079bf9cc5

  alias Floki.HTML.Tokenizer

  test "tokenize/1 Bad named entity: RightDoubleBracket without a semi-colon" do
    input = "&RightDoubleBracket"
    output = [["Character", "&RightDoubleBracket"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: RightDownTeeVector without a semi-colon" do
    input = "&RightDownTeeVector"
    output = [["Character", "&RightDownTeeVector"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: RightDownVector without a semi-colon" do
    input = "&RightDownVector"
    output = [["Character", "&RightDownVector"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: RightDownVectorBar without a semi-colon" do
    input = "&RightDownVectorBar"
    output = [["Character", "&RightDownVectorBar"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: RightFloor without a semi-colon" do
    input = "&RightFloor"
    output = [["Character", "&RightFloor"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: RightTee without a semi-colon" do
    input = "&RightTee"
    output = [["Character", "&RightTee"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: RightTeeArrow without a semi-colon" do
    input = "&RightTeeArrow"
    output = [["Character", "&RightTeeArrow"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: RightTeeVector without a semi-colon" do
    input = "&RightTeeVector"
    output = [["Character", "&RightTeeVector"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: RightTriangle without a semi-colon" do
    input = "&RightTriangle"
    output = [["Character", "&RightTriangle"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: RightTriangleBar without a semi-colon" do
    input = "&RightTriangleBar"
    output = [["Character", "&RightTriangleBar"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: RightTriangleEqual without a semi-colon" do
    input = "&RightTriangleEqual"
    output = [["Character", "&RightTriangleEqual"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: RightUpDownVector without a semi-colon" do
    input = "&RightUpDownVector"
    output = [["Character", "&RightUpDownVector"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: RightUpTeeVector without a semi-colon" do
    input = "&RightUpTeeVector"
    output = [["Character", "&RightUpTeeVector"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: RightUpVector without a semi-colon" do
    input = "&RightUpVector"
    output = [["Character", "&RightUpVector"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: RightUpVectorBar without a semi-colon" do
    input = "&RightUpVectorBar"
    output = [["Character", "&RightUpVectorBar"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: RightVector without a semi-colon" do
    input = "&RightVector"
    output = [["Character", "&RightVector"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: RightVectorBar without a semi-colon" do
    input = "&RightVectorBar"
    output = [["Character", "&RightVectorBar"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Rightarrow without a semi-colon" do
    input = "&Rightarrow"
    output = [["Character", "&Rightarrow"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Ropf without a semi-colon" do
    input = "&Ropf"
    output = [["Character", "&Ropf"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: RoundImplies without a semi-colon" do
    input = "&RoundImplies"
    output = [["Character", "&RoundImplies"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Rrightarrow without a semi-colon" do
    input = "&Rrightarrow"
    output = [["Character", "&Rrightarrow"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Rscr without a semi-colon" do
    input = "&Rscr"
    output = [["Character", "&Rscr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Rsh without a semi-colon" do
    input = "&Rsh"
    output = [["Character", "&Rsh"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: RuleDelayed without a semi-colon" do
    input = "&RuleDelayed"
    output = [["Character", "&RuleDelayed"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: SHCHcy without a semi-colon" do
    input = "&SHCHcy"
    output = [["Character", "&SHCHcy"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: SHcy without a semi-colon" do
    input = "&SHcy"
    output = [["Character", "&SHcy"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: SOFTcy without a semi-colon" do
    input = "&SOFTcy"
    output = [["Character", "&SOFTcy"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Sacute without a semi-colon" do
    input = "&Sacute"
    output = [["Character", "&Sacute"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Sc without a semi-colon" do
    input = "&Sc"
    output = [["Character", "&Sc"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Scaron without a semi-colon" do
    input = "&Scaron"
    output = [["Character", "&Scaron"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Scedil without a semi-colon" do
    input = "&Scedil"
    output = [["Character", "&Scedil"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Scirc without a semi-colon" do
    input = "&Scirc"
    output = [["Character", "&Scirc"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Scy without a semi-colon" do
    input = "&Scy"
    output = [["Character", "&Scy"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Sfr without a semi-colon" do
    input = "&Sfr"
    output = [["Character", "&Sfr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: ShortDownArrow without a semi-colon" do
    input = "&ShortDownArrow"
    output = [["Character", "&ShortDownArrow"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: ShortLeftArrow without a semi-colon" do
    input = "&ShortLeftArrow"
    output = [["Character", "&ShortLeftArrow"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: ShortRightArrow without a semi-colon" do
    input = "&ShortRightArrow"
    output = [["Character", "&ShortRightArrow"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: ShortUpArrow without a semi-colon" do
    input = "&ShortUpArrow"
    output = [["Character", "&ShortUpArrow"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Sigma without a semi-colon" do
    input = "&Sigma"
    output = [["Character", "&Sigma"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: SmallCircle without a semi-colon" do
    input = "&SmallCircle"
    output = [["Character", "&SmallCircle"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Sopf without a semi-colon" do
    input = "&Sopf"
    output = [["Character", "&Sopf"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Sqrt without a semi-colon" do
    input = "&Sqrt"
    output = [["Character", "&Sqrt"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Square without a semi-colon" do
    input = "&Square"
    output = [["Character", "&Square"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: SquareIntersection without a semi-colon" do
    input = "&SquareIntersection"
    output = [["Character", "&SquareIntersection"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: SquareSubset without a semi-colon" do
    input = "&SquareSubset"
    output = [["Character", "&SquareSubset"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: SquareSubsetEqual without a semi-colon" do
    input = "&SquareSubsetEqual"
    output = [["Character", "&SquareSubsetEqual"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: SquareSuperset without a semi-colon" do
    input = "&SquareSuperset"
    output = [["Character", "&SquareSuperset"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: SquareSupersetEqual without a semi-colon" do
    input = "&SquareSupersetEqual"
    output = [["Character", "&SquareSupersetEqual"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: SquareUnion without a semi-colon" do
    input = "&SquareUnion"
    output = [["Character", "&SquareUnion"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Sscr without a semi-colon" do
    input = "&Sscr"
    output = [["Character", "&Sscr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Star without a semi-colon" do
    input = "&Star"
    output = [["Character", "&Star"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Sub without a semi-colon" do
    input = "&Sub"
    output = [["Character", "&Sub"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Subset without a semi-colon" do
    input = "&Subset"
    output = [["Character", "&Subset"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: SubsetEqual without a semi-colon" do
    input = "&SubsetEqual"
    output = [["Character", "&SubsetEqual"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Succeeds without a semi-colon" do
    input = "&Succeeds"
    output = [["Character", "&Succeeds"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: SucceedsEqual without a semi-colon" do
    input = "&SucceedsEqual"
    output = [["Character", "&SucceedsEqual"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: SucceedsSlantEqual without a semi-colon" do
    input = "&SucceedsSlantEqual"
    output = [["Character", "&SucceedsSlantEqual"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: SucceedsTilde without a semi-colon" do
    input = "&SucceedsTilde"
    output = [["Character", "&SucceedsTilde"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: SuchThat without a semi-colon" do
    input = "&SuchThat"
    output = [["Character", "&SuchThat"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Sum without a semi-colon" do
    input = "&Sum"
    output = [["Character", "&Sum"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Sup without a semi-colon" do
    input = "&Sup"
    output = [["Character", "&Sup"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Superset without a semi-colon" do
    input = "&Superset"
    output = [["Character", "&Superset"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: SupersetEqual without a semi-colon" do
    input = "&SupersetEqual"
    output = [["Character", "&SupersetEqual"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Supset without a semi-colon" do
    input = "&Supset"
    output = [["Character", "&Supset"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: TRADE without a semi-colon" do
    input = "&TRADE"
    output = [["Character", "&TRADE"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: TSHcy without a semi-colon" do
    input = "&TSHcy"
    output = [["Character", "&TSHcy"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: TScy without a semi-colon" do
    input = "&TScy"
    output = [["Character", "&TScy"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Tab without a semi-colon" do
    input = "&Tab"
    output = [["Character", "&Tab"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Tau without a semi-colon" do
    input = "&Tau"
    output = [["Character", "&Tau"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Tcaron without a semi-colon" do
    input = "&Tcaron"
    output = [["Character", "&Tcaron"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Tcedil without a semi-colon" do
    input = "&Tcedil"
    output = [["Character", "&Tcedil"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Tcy without a semi-colon" do
    input = "&Tcy"
    output = [["Character", "&Tcy"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Tfr without a semi-colon" do
    input = "&Tfr"
    output = [["Character", "&Tfr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Therefore without a semi-colon" do
    input = "&Therefore"
    output = [["Character", "&Therefore"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Theta without a semi-colon" do
    input = "&Theta"
    output = [["Character", "&Theta"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: ThickSpace without a semi-colon" do
    input = "&ThickSpace"
    output = [["Character", "&ThickSpace"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: ThinSpace without a semi-colon" do
    input = "&ThinSpace"
    output = [["Character", "&ThinSpace"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Tilde without a semi-colon" do
    input = "&Tilde"
    output = [["Character", "&Tilde"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: TildeEqual without a semi-colon" do
    input = "&TildeEqual"
    output = [["Character", "&TildeEqual"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: TildeFullEqual without a semi-colon" do
    input = "&TildeFullEqual"
    output = [["Character", "&TildeFullEqual"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: TildeTilde without a semi-colon" do
    input = "&TildeTilde"
    output = [["Character", "&TildeTilde"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Topf without a semi-colon" do
    input = "&Topf"
    output = [["Character", "&Topf"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: TripleDot without a semi-colon" do
    input = "&TripleDot"
    output = [["Character", "&TripleDot"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Tscr without a semi-colon" do
    input = "&Tscr"
    output = [["Character", "&Tscr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Tstrok without a semi-colon" do
    input = "&Tstrok"
    output = [["Character", "&Tstrok"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Uarr without a semi-colon" do
    input = "&Uarr"
    output = [["Character", "&Uarr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Uarrocir without a semi-colon" do
    input = "&Uarrocir"
    output = [["Character", "&Uarrocir"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Ubrcy without a semi-colon" do
    input = "&Ubrcy"
    output = [["Character", "&Ubrcy"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Ubreve without a semi-colon" do
    input = "&Ubreve"
    output = [["Character", "&Ubreve"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Ucy without a semi-colon" do
    input = "&Ucy"
    output = [["Character", "&Ucy"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Udblac without a semi-colon" do
    input = "&Udblac"
    output = [["Character", "&Udblac"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Ufr without a semi-colon" do
    input = "&Ufr"
    output = [["Character", "&Ufr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Umacr without a semi-colon" do
    input = "&Umacr"
    output = [["Character", "&Umacr"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: UnderBar without a semi-colon" do
    input = "&UnderBar"
    output = [["Character", "&UnderBar"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: UnderBrace without a semi-colon" do
    input = "&UnderBrace"
    output = [["Character", "&UnderBrace"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: UnderBracket without a semi-colon" do
    input = "&UnderBracket"
    output = [["Character", "&UnderBracket"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: UnderParenthesis without a semi-colon" do
    input = "&UnderParenthesis"
    output = [["Character", "&UnderParenthesis"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Union without a semi-colon" do
    input = "&Union"
    output = [["Character", "&Union"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: UnionPlus without a semi-colon" do
    input = "&UnionPlus"
    output = [["Character", "&UnionPlus"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Bad named entity: Uogon without a semi-colon" do
    input = "&Uogon"
    output = [["Character", "&Uogon"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end
end
