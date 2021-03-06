defmodule Floki.HTML.Generated.Tokenizer.Test1Test do
  use ExUnit.Case, async: true

  # NOTE: This file was generated by "mix generate_tokenizer_tests test1.test".
  # html5lib-tests rev: e52ff68cc7113a6ef3687747fa82691079bf9cc5

  alias Floki.HTML.Tokenizer

  test "tokenize/1 ASCII decimal entity" do
    input = "&#0036;"
    output = [["Character", "$"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 ASCII hexadecimal entity" do
    input = "&#x3f;"
    output = [["Character", "?"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Ampersand EOF" do
    input = "&"
    output = [["Character", "&"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Ampersand ampersand EOF" do
    input = "&&"
    output = [["Character", "&&"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Ampersand space EOF" do
    input = "& "
    output = [["Character", "& "]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Ampersand, number sign" do
    input = "&#"
    output = [["Character", "&#"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Comment, Central dash no space" do
    input = "<!----->"
    output = [["Comment", "-"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Comment, two central dashes" do
    input = "<!-- --comment -->"
    output = [["Comment", " --comment "]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Correct Doctype case with EOF" do
    input = "<!DOCTYPE HtMl"
    output = [["DOCTYPE", "html", nil, nil, false]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Correct Doctype lowercase" do
    input = "<!DOCTYPE html>"
    output = [["DOCTYPE", "html", nil, nil, true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Correct Doctype mixed case" do
    input = "<!DOCTYPE HtMl>"
    output = [["DOCTYPE", "html", nil, nil, true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Correct Doctype uppercase" do
    input = "<!DOCTYPE HTML>"
    output = [["DOCTYPE", "html", nil, nil, true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Doctype in error" do
    input = "<!DOCTYPE foo>"
    output = [["DOCTYPE", "foo", nil, nil, true]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Empty end tag" do
    input = "</>"
    output = []

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Empty start tag" do
    input = "<>"
    output = [["Character", "<>"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 End Tag w/attribute" do
    input = "<h></h a='b'>"
    output = [["StartTag", "h", %{}], ["EndTag", "h"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Entity in attribute without semicolon" do
    input = "<h a='&COPY'>"
    output = [["StartTag", "h", %{"a" => "©"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Entity in attribute without semicolon ending in 1" do
    input = "<h a='&not1'>"
    output = [["StartTag", "h", %{"a" => "&not1"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Entity in attribute without semicolon ending in i" do
    input = "<h a='&noti'>"
    output = [["StartTag", "h", %{"a" => "&noti"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Entity in attribute without semicolon ending in x" do
    input = "<h a='&notx'>"
    output = [["StartTag", "h", %{"a" => "&notx"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Entity with trailing semicolon (1)" do
    input = "I'm &not;it"
    output = [["Character", "I'm ¬it"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Entity with trailing semicolon (2)" do
    input = "I'm &notin;"
    output = [["Character", "I'm ∉"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Entity without trailing semicolon (1)" do
    input = "I'm &notit"
    output = [["Character", "I'm ¬it"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Entity without trailing semicolon (2)" do
    input = "I'm &notin"
    output = [["Character", "I'm ¬in"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Hexadecimal entity in attribute" do
    input = "<h a='&#x3f;'></h>"
    output = [["StartTag", "h", %{"a" => "?"}], ["EndTag", "h"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Multiple atts" do
    input = "<h a='b' c='d'>"
    output = [["StartTag", "h", %{"a" => "b", "c" => "d"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Multiple atts no space" do
    input = "<h a='b'c='d'>"
    output = [["StartTag", "h", %{"a" => "b", "c" => "d"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Nested comment" do
    input = "<!-- <!--test-->"
    output = [["Comment", " <!--test"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Non-ASCII character reference name" do
    input = "&¬;"
    output = [["Character", "&¬;"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Open angled bracket in unquoted attribute value state" do
    input = "<a a=f<>"
    output = [["StartTag", "a", %{"a" => "f<"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Partial entity match at end of file" do
    input = "I'm &no"
    output = [["Character", "I'm &no"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Repeated attr" do
    input = "<h a='b' a='d'>"
    output = [["StartTag", "h", %{"a" => "b"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Short comment" do
    input = "<!-->"
    output = [["Comment", ""]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Short comment three" do
    input = "<!---->"
    output = [["Comment", ""]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Short comment two" do
    input = "<!--->"
    output = [["Comment", ""]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Simple comment" do
    input = "<!--comment-->"
    output = [["Comment", "comment"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Single Start Tag" do
    input = "<h>"
    output = [["StartTag", "h", %{}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Start Tag w/attribute" do
    input = "<h a='b'>"
    output = [["StartTag", "h", %{"a" => "b"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Start Tag w/attribute no quotes" do
    input = "<h a=b>"
    output = [["StartTag", "h", %{"a" => "b"}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Start of a comment" do
    input = "<!-"
    output = [["Comment", "-"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Start/End Tag" do
    input = "<h></h>"
    output = [["StartTag", "h", %{}], ["EndTag", "h"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Truncated doctype start" do
    input = "<!DOC>"
    output = [["Comment", "DOC"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Two unclosed start tags" do
    input = "<p>One<p>Two"

    output = [
      ["StartTag", "p", %{}],
      ["Character", "One"],
      ["StartTag", "p", %{}],
      ["Character", "Two"]
    ]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Unfinished comment" do
    input = "<!--comment"
    output = [["Comment", "comment"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Unfinished entity" do
    input = "&f"
    output = [["Character", "&f"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Unfinished numeric entity" do
    input = "&#x"
    output = [["Character", "&#x"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Unquoted attribute at end of tag with final character of &, with tag followed by characters" do
    input = "<a a=a&>foo"
    output = [["StartTag", "a", %{"a" => "a&"}], ["Character", "foo"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 Unquoted attribute ending in ampersand" do
    input = "<s o=& t>"
    output = [["StartTag", "s", %{"o" => "&", "t" => ""}]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end

  test "tokenize/1 plaintext element" do
    input = "<plaintext>foobar"
    output = [["StartTag", "plaintext", %{}], ["Character", "foobar"]]

    result =
      input
      |> Tokenizer.tokenize()
      |> TokenizerTestLoader.tokenization_result()

    assert result.tokens == output
  end
end
