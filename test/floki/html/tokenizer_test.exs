defmodule Floki.HTML.TokenizerTest do
  use ExUnit.Case, async: true
  alias Floki.HTML.Tokenizer

  @json """
    {"tests": [

  {"description":"Correct Doctype lowercase",
  "input":"<!DOCTYPE html>",
  "output":[["DOCTYPE", "html", null, null, true]]},


  {"description":"Correct Doctype uppercase",
  "input":"<!DOCTYPE HTML>",
  "output":[["DOCTYPE", "html", null, null, true]]},

  {"description":"Correct Doctype mixed case",
  "input":"<!DOCTYPE HtMl>",
  "output":[["DOCTYPE", "html", null, null, true]]},

  {"description":"Correct Doctype case with EOF",
  "input":"<!DOCTYPE HtMl",
  "output":[["DOCTYPE", "html", null, null, false]],
  "errors":[
      { "code": "eof-in-doctype", "line": 1, "col": 15 }
  ]},

  {"description":"Truncated doctype start",
  "input":"<!DOC>",
  "output":[["Comment", "DOC"]],
  "errors":[
      { "code": "incorrectly-opened-comment", "line": 1, "col": 3 }
  ]},

  {"description":"Doctype in error",
  "input":"<!DOCTYPE foo>",
  "output":[["DOCTYPE", "foo", null, null, true]]},

  {"description":"Single Start Tag",
  "input":"<h>",
  "output":[["StartTag", "h", {}]]},

  {"description":"Empty end tag",
  "input":"</>",
  "output":[],
  "errors":[
      { "code": "missing-end-tag-name", "line": 1, "col": 3 }
  ]},

  {"description":"Empty start tag",
  "input":"<>",
  "output":[["Character", "<>"]],
  "errors":[
      { "code": "invalid-first-character-of-tag-name", "line": 1, "col": 2 }
  ]},

  {"description":"Start Tag w/attribute",
  "input":"<h a='b'>",
  "output":[["StartTag", "h", {"a":"b"}]]},

  {"description":"Start Tag w/attribute no quotes",
  "input":"<h a=b>",
  "output":[["StartTag", "h", {"a":"b"}]]},

  {"description":"Start/End Tag",
  "input":"<h></h>",
  "output":[["StartTag", "h", {}], ["EndTag", "h"]]},

  {"description":"Two unclosed start tags",
  "input":"<p>One<p>Two",
  "output":[["StartTag", "p", {}], ["Character", "One"], ["StartTag", "p", {}], ["Character", "Two"]]},

  {"description":"End Tag w/attribute",
  "input":"<h></h a='b'>",
  "output":[["StartTag", "h", {}], ["EndTag", "h"]],
  "errors":[
      { "code": "end-tag-with-attributes", "line": 1, "col": 13 }
  ]},

  {"description":"Multiple atts",
  "input":"<h a='b' c='d'>",
  "output":[["StartTag", "h", {"a":"b", "c":"d"}]]},

  {"description":"Multiple atts no space",
  "input":"<h a='b'c='d'>",
  "output":[["StartTag", "h", {"a":"b", "c":"d"}]],
  "errors":[
      { "code": "missing-whitespace-between-attributes", "line": 1, "col": 9 }
  ]},

  {"description":"Repeated attr",
   "input":"<h a='b' a='d'>",
   "output":[["StartTag", "h", {"a":"b"}]],
   "errors":[
      { "code": "duplicate-attribute", "line": 1, "col": 11 }
  ]},

  {"description":"Simple comment",
   "input":"<!--comment-->",
   "output":[["Comment", "comment"]]},

  {"description":"Comment, Central dash no space",
   "input":"<!----->",
   "output":[["Comment", "-"]]},

  {"description":"Comment, two central dashes",
  "input":"<!-- --comment -->",
  "output":[["Comment", " --comment "]]},

  {"description":"Unfinished comment",
  "input":"<!--comment",
  "output":[["Comment", "comment"]],
  "errors":[
      { "code": "eof-in-comment", "line": 1, "col": 12 }
  ]},

  {"description":"Start of a comment",
  "input":"<!-",
  "output":[["Comment", "-"]],
  "errors":[
      { "code": "incorrectly-opened-comment", "line": 1, "col": 3 }
  ]},

  {"description":"Short comment",
  "input":"<!-->",
  "output":[["Comment", ""]],
  "errors":[
      { "code": "abrupt-closing-of-empty-comment", "line": 1, "col": 5 }
  ]},


  {"description":"Short comment two",
  "input":"<!--->",
  "output":[["Comment", ""]],
  "errors":[
      { "code": "abrupt-closing-of-empty-comment", "line": 1, "col": 6 }
  ]},

  {"description":"Short comment three",
   "input":"<!---->",
   "output":[["Comment", ""]]},

  {"description":"Nested comment",
  "input":"<!-- <!--test-->",
  "output":[["Comment", " <!--test"]],
  "errors":[
      { "code": "nested-comment", "line": 1, "col": 10 }
  ]},

  {"description":"Ampersand EOF",
  "input":"&",
  "output":[["Character", "&"]]},

  {"description":"Ampersand ampersand EOF",
  "input":"&&",
  "output":[["Character", "&&"]]},

  {"description":"Ampersand space EOF",
  "input":"& ",
  "output":[["Character", "& "]]},

  {"description":"Unfinished entity",
  "input":"&f",
  "output":[["Character", "&f"]]},

  {"description":"Ampersand, number sign",
  "input":"&#",
  "output":[["Character", "&#"]],
  "errors":[
      { "code": "absence-of-digits-in-numeric-character-reference", "line": 1, "col": 3 }
  ]},

  {"description":"Unfinished numeric entity",
  "input":"&#x",
  "output":[["Character", "&#x"]],
  "errors":[
      { "code": "absence-of-digits-in-numeric-character-reference", "line": 1, "col": 4 }
  ]},

  {"description":"Entity with trailing semicolon (1)",
  "input":"I'm &not;it",
  "output":[["Character","I'm \u00ACit"]]},

  {"description":"Entity with trailing semicolon (2)",
  "input":"I'm &notin;",
  "output":[["Character","I'm \u2209"]]},

  {"description":"Entity without trailing semicolon (1)",
  "input":"I'm &notit",
  "output":[["Character","I'm \u00ACit"]],
  "errors": [
      {"code" : "missing-semicolon-after-character-reference", "line": 1, "col": 9 }
  ]},

  {"description":"Entity without trailing semicolon (2)",
  "input":"I'm &notin",
  "output":[["Character","I'm \u00ACin"]],
  "errors": [
      {"code" : "missing-semicolon-after-character-reference", "line": 1, "col": 9 }
  ]},

  {"description":"Partial entity match at end of file",
  "input":"I'm &no",
  "output":[["Character","I'm &no"]]},

  {"description":"Non-ASCII character reference name",
  "input":"&\u00AC;",
  "output":[["Character", "&\u00AC;"]]},

  {"description":"ASCII decimal entity",
  "input":"&#0036;",
  "output":[["Character","$"]]},

  {"description":"ASCII hexadecimal entity",
  "input":"&#x3f;",
  "output":[["Character","?"]]},

  {"description":"Hexadecimal entity in attribute",
  "input":"<h a='&#x3f;'></h>",
  "output":[["StartTag", "h", {"a":"?"}], ["EndTag", "h"]]},

  {"description":"Entity in attribute without semicolon ending in x",
  "input":"<h a='&notx'>",
  "output":[["StartTag", "h", {"a":"&notx"}]]},

  {"description":"Entity in attribute without semicolon ending in 1",
  "input":"<h a='&not1'>",
  "output":[["StartTag", "h", {"a":"&not1"}]]},

  {"description":"Entity in attribute without semicolon ending in i",
  "input":"<h a='&noti'>",
  "output":[["StartTag", "h", {"a":"&noti"}]]},

  {"description":"Entity in attribute without semicolon",
  "input":"<h a='&COPY'>",
  "output":[["StartTag", "h", {"a":"\u00A9"}]],
  "errors": [
      {"code" : "missing-semicolon-after-character-reference", "line": 1, "col": 12 }
  ]},

  {"description":"Unquoted attribute ending in ampersand",
  "input":"<s o=& t>",
  "output":[["StartTag","s",{"o":"&","t":""}]]},

  {"description":"Unquoted attribute at end of tag with final character of &, with tag followed by characters",
  "input":"<a a=a&>foo",
  "output":[["StartTag", "a", {"a":"a&"}], ["Character", "foo"]]},

  {"description":"plaintext element",
   "input":"<plaintext>foobar",
   "output":[["StartTag","plaintext",{}], ["Character","foobar"]]},

  {"description":"Open angled bracket in unquoted attribute value state",
   "input":"<a a=f<>",
   "output":[["StartTag", "a", {"a":"f<"}]],
   "errors":[
      { "code": "unexpected-character-in-unquoted-attribute-value", "line": 1, "col": 7 }
  ]}

  ]}
  """

  defmodule Result do
    defstruct errors: [], tokens: []
  end

  defmodule TestHelper do
    def tokens_for_test(state = %Tokenizer.State{}) do
      output_tokens =
        state.tokens
        |> Enum.map(&transform_token/1)
        |> Enum.reduce([], fn token, tokens ->
          if token do
            [token | tokens]
          else
            tokens
          end
        end)

      output_errors =
        state.errors
        |> Enum.map(fn error ->
          %{
            "code" => error.id,
            "col" => error.position.col,
            "line" => error.position.line
          }
        end)

      %Result{tokens: output_tokens, errors: output_errors}
    end

    defp transform_token(doctype = %Tokenizer.Doctype{}) do
      [
        "DOCTYPE",
        doctype.name,
        doctype.public_id,
        doctype.system_id,
        doctype.force_quirks == :off
      ]
    end

    defp transform_token(_), do: nil
  end

  test "tokenize/1 generate correct tokens" do
    test1 =
      Jason.decode!(@json)
      |> Map.get("tests")
      |> hd()

    output =
      Map.get(test1, "input")
      |> Tokenizer.tokenize()
      |> TestHelper.tokens_for_test()

    assert(Map.get(test1, "output") == output.tokens)

    test2 =
      Jason.decode!(@json)
      |> Map.get("tests")
      |> Enum.at(1)

    output =
      Map.get(test2, "input")
      |> Tokenizer.tokenize()
      |> TestHelper.tokens_for_test()

    assert(Map.get(test2, "output") == output.tokens)

    test3 =
      Jason.decode!(@json)
      |> Map.get("tests")
      |> Enum.at(2)

    output =
      Map.get(test3, "input")
      |> Tokenizer.tokenize()
      |> TestHelper.tokens_for_test()

    assert(Map.get(test3, "output") == output.tokens)

    test4 =
      Jason.decode!(@json)
      |> Map.get("tests")
      |> Enum.at(3)

    output =
      Map.get(test4, "input")
      |> Tokenizer.tokenize()
      |> TestHelper.tokens_for_test()

    assert(Map.get(test4, "output") == output.tokens)

    assert(Map.get(test4, "errors") == output.errors)
  end
end
