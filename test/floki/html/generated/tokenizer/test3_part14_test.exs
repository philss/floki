defmodule Floki.HTML.Generated.Tokenizer.Test3Part14Test do
  use ExUnit.Case, async: true

  # NOTE: This file was generated by "mix generate_tokenizer_tests test3.test".
  # html5lib-tests rev: e52ff68cc7113a6ef3687747fa82691079bf9cc5

  alias Floki.HTML.Tokenizer

  test "tokenize/1 <a a=''\\uDBC0\\uDC00>" do
    input = "<a a=''􀀀>"
    output = [["StartTag", "a", %{"a" => "", "􀀀" => ""}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=''`>" do
    input = "<a a=''`>"
    output = [["StartTag", "a", %{"`" => "", "a" => ""}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=''a>" do
    input = "<a a=''a>"
    output = [["StartTag", "a", %{"a" => ""}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=''b>" do
    input = "<a a=''b>"
    output = [["StartTag", "a", %{"a" => "", "b" => ""}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=''y>" do
    input = "<a a=''y>"
    output = [["StartTag", "a", %{"a" => "", "y" => ""}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=''z>" do
    input = "<a a=''z>"
    output = [["StartTag", "a", %{"a" => "", "z" => ""}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=''{>" do
    input = "<a a=''{>"
    output = [["StartTag", "a", %{"a" => "", "{" => ""}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a='('>" do
    input = "<a a='('>"
    output = [["StartTag", "a", %{"a" => "("}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a='-'>" do
    input = "<a a='-'>"
    output = [["StartTag", "a", %{"a" => "-"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a='/'>" do
    input = "<a a='/'>"
    output = [["StartTag", "a", %{"a" => "/"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a='0'>" do
    input = "<a a='0'>"
    output = [["StartTag", "a", %{"a" => "0"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a='1'>" do
    input = "<a a='1'>"
    output = [["StartTag", "a", %{"a" => "1"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a='9'>" do
    input = "<a a='9'>"
    output = [["StartTag", "a", %{"a" => "9"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a='<'>" do
    input = "<a a='<'>"
    output = [["StartTag", "a", %{"a" => "<"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a='='>" do
    input = "<a a='='>"
    output = [["StartTag", "a", %{"a" => "="}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a='>'>" do
    input = "<a a='>'>"
    output = [["StartTag", "a", %{"a" => ">"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a='?'>" do
    input = "<a a='?'>"
    output = [["StartTag", "a", %{"a" => "?"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a='@'>" do
    input = "<a a='@'>"
    output = [["StartTag", "a", %{"a" => "@"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a='A'>" do
    input = "<a a='A'>"
    output = [["StartTag", "a", %{"a" => "A"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a='B'>" do
    input = "<a a='B'>"
    output = [["StartTag", "a", %{"a" => "B"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a='Y'>" do
    input = "<a a='Y'>"
    output = [["StartTag", "a", %{"a" => "Y"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a='Z'>" do
    input = "<a a='Z'>"
    output = [["StartTag", "a", %{"a" => "Z"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a='\\u0000'>" do
    input = <<60, 97, 32, 97, 61, 39, 0, 39, 62>>
    output = [["StartTag", "a", %{"a" => "�"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a='\\u0009'>" do
    input = "<a a='\t'>"
    output = [["StartTag", "a", %{"a" => "\t"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a='\\u000A'>" do
    input = "<a a='\n'>"
    output = [["StartTag", "a", %{"a" => "\n"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a='\\u000B'>" do
    input = "<a a='\v'>"
    output = [["StartTag", "a", %{"a" => "\v"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a='\\u000C'>" do
    input = "<a a='\f'>"
    output = [["StartTag", "a", %{"a" => "\f"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a='\\uDBC0\\uDC00'>" do
    input = "<a a='􀀀'>"
    output = [["StartTag", "a", %{"a" => "􀀀"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a='`'>" do
    input = "<a a='`'>"
    output = [["StartTag", "a", %{"a" => "`"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a='a'>" do
    input = "<a a='a'>"
    output = [["StartTag", "a", %{"a" => "a"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a='b'>" do
    input = "<a a='b'>"
    output = [["StartTag", "a", %{"a" => "b"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a='y'>" do
    input = "<a a='y'>"
    output = [["StartTag", "a", %{"a" => "y"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a='z'>" do
    input = "<a a='z'>"
    output = [["StartTag", "a", %{"a" => "z"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a='{'>" do
    input = "<a a='{'>"
    output = [["StartTag", "a", %{"a" => "{"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=(>" do
    input = "<a a=(>"
    output = [["StartTag", "a", %{"a" => "("}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=->" do
    input = "<a a=->"
    output = [["StartTag", "a", %{"a" => "-"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=/>" do
    input = "<a a=/>"
    output = [["StartTag", "a", %{"a" => "/"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=0>" do
    input = "<a a=0>"
    output = [["StartTag", "a", %{"a" => "0"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=1>" do
    input = "<a a=1>"
    output = [["StartTag", "a", %{"a" => "1"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=9>" do
    input = "<a a=9>"
    output = [["StartTag", "a", %{"a" => "9"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=<>" do
    input = "<a a=<>"
    output = [["StartTag", "a", %{"a" => "<"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a==>" do
    input = "<a a==>"
    output = [["StartTag", "a", %{"a" => "="}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=>" do
    input = "<a a=>"
    output = [["StartTag", "a", %{"a" => ""}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=?>" do
    input = "<a a=?>"
    output = [["StartTag", "a", %{"a" => "?"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=@>" do
    input = "<a a=@>"
    output = [["StartTag", "a", %{"a" => "@"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=A>" do
    input = "<a a=A>"
    output = [["StartTag", "a", %{"a" => "A"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=B>" do
    input = "<a a=B>"
    output = [["StartTag", "a", %{"a" => "B"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=Y>" do
    input = "<a a=Y>"
    output = [["StartTag", "a", %{"a" => "Y"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=Z>" do
    input = "<a a=Z>"
    output = [["StartTag", "a", %{"a" => "Z"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=\\u0000>" do
    input = <<60, 97, 32, 97, 61, 0, 62>>
    output = [["StartTag", "a", %{"a" => "�"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=\\u0008>" do
    input = "<a a=\b>"
    output = [["StartTag", "a", %{"a" => "\b"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=\\u0009>" do
    input = "<a a=\t>"
    output = [["StartTag", "a", %{"a" => ""}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=\\u000A>" do
    input = "<a a=\n>"
    output = [["StartTag", "a", %{"a" => ""}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=\\u000B>" do
    input = "<a a=\v>"
    output = [["StartTag", "a", %{"a" => "\v"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=\\u000C>" do
    input = "<a a=\f>"
    output = [["StartTag", "a", %{"a" => ""}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=\\u000D>" do
    input = "<a a=\r>"
    output = [["StartTag", "a", %{"a" => ""}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=\\u001F>" do
    input = <<60, 97, 32, 97, 61, 31, 62>>
    output = [["StartTag", "a", %{"a" => <<31>>}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=\\uDBC0\\uDC00>" do
    input = "<a a=􀀀>"
    output = [["StartTag", "a", %{"a" => "􀀀"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=`>" do
    input = "<a a=`>"
    output = [["StartTag", "a", %{"a" => "`"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a >" do
    input = "<a a=a >"
    output = [["StartTag", "a", %{"a" => "a"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a!>" do
    input = "<a a=a!>"
    output = [["StartTag", "a", %{"a" => "a!"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a\">" do
    input = "<a a=a\">"
    output = [["StartTag", "a", %{"a" => "a\""}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a#>" do
    input = "<a a=a#>"
    output = [["StartTag", "a", %{"a" => "a#"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a%>" do
    input = "<a a=a%>"
    output = [["StartTag", "a", %{"a" => "a%"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a&>" do
    input = "<a a=a&>"
    output = [["StartTag", "a", %{"a" => "a&"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a'>" do
    input = "<a a=a'>"
    output = [["StartTag", "a", %{"a" => "a'"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a(>" do
    input = "<a a=a(>"
    output = [["StartTag", "a", %{"a" => "a("}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a->" do
    input = "<a a=a->"
    output = [["StartTag", "a", %{"a" => "a-"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a/>" do
    input = "<a a=a/>"
    output = [["StartTag", "a", %{"a" => "a/"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a0>" do
    input = "<a a=a0>"
    output = [["StartTag", "a", %{"a" => "a0"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a1>" do
    input = "<a a=a1>"
    output = [["StartTag", "a", %{"a" => "a1"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a9>" do
    input = "<a a=a9>"
    output = [["StartTag", "a", %{"a" => "a9"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a<>" do
    input = "<a a=a<>"
    output = [["StartTag", "a", %{"a" => "a<"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a=>" do
    input = "<a a=a=>"
    output = [["StartTag", "a", %{"a" => "a="}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a>" do
    input = "<a a=a>"
    output = [["StartTag", "a", %{"a" => "a"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a?>" do
    input = "<a a=a?>"
    output = [["StartTag", "a", %{"a" => "a?"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a@>" do
    input = "<a a=a@>"
    output = [["StartTag", "a", %{"a" => "a@"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=aA>" do
    input = "<a a=aA>"
    output = [["StartTag", "a", %{"a" => "aA"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=aB>" do
    input = "<a a=aB>"
    output = [["StartTag", "a", %{"a" => "aB"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=aY>" do
    input = "<a a=aY>"
    output = [["StartTag", "a", %{"a" => "aY"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=aZ>" do
    input = "<a a=aZ>"
    output = [["StartTag", "a", %{"a" => "aZ"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a\\u0000>" do
    input = <<60, 97, 32, 97, 61, 97, 0, 62>>
    output = [["StartTag", "a", %{"a" => "a�"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a\\u0008>" do
    input = "<a a=a\b>"
    output = [["StartTag", "a", %{"a" => "a\b"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a\\u0009>" do
    input = "<a a=a\t>"
    output = [["StartTag", "a", %{"a" => "a"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a\\u000A>" do
    input = "<a a=a\n>"
    output = [["StartTag", "a", %{"a" => "a"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a\\u000B>" do
    input = "<a a=a\v>"
    output = [["StartTag", "a", %{"a" => "a\v"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a\\u000C>" do
    input = "<a a=a\f>"
    output = [["StartTag", "a", %{"a" => "a"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a\\u000D>" do
    input = "<a a=a\r>"
    output = [["StartTag", "a", %{"a" => "a"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a\\u001F>" do
    input = <<60, 97, 32, 97, 61, 97, 31, 62>>
    output = [["StartTag", "a", %{"a" => <<97, 31>>}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a\\uDBC0\\uDC00>" do
    input = "<a a=a􀀀>"
    output = [["StartTag", "a", %{"a" => "a􀀀"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a`>" do
    input = "<a a=a`>"
    output = [["StartTag", "a", %{"a" => "a`"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=aa>" do
    input = "<a a=aa>"
    output = [["StartTag", "a", %{"a" => "aa"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=ab>" do
    input = "<a a=ab>"
    output = [["StartTag", "a", %{"a" => "ab"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=ay>" do
    input = "<a a=ay>"
    output = [["StartTag", "a", %{"a" => "ay"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=az>" do
    input = "<a a=az>"
    output = [["StartTag", "a", %{"a" => "az"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=a{>" do
    input = "<a a=a{>"
    output = [["StartTag", "a", %{"a" => "a{"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=b>" do
    input = "<a a=b>"
    output = [["StartTag", "a", %{"a" => "b"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=y>" do
    input = "<a a=y>"
    output = [["StartTag", "a", %{"a" => "y"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a=z>" do
    input = "<a a=z>"
    output = [["StartTag", "a", %{"a" => "z"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 <a a={>" do
    input = "<a a={>"
    output = [["StartTag", "a", %{"a" => "{"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end
end
