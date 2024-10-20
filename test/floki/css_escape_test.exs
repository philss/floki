defmodule Floki.CSSEscapeTest do
  use ExUnit.Case, async: true

  doctest Floki.CSSEscape

  test "null character" do
    assert Floki.CSSEscape.escape(<<0>>) == <<0xFFFD::utf8>>
    assert Floki.CSSEscape.escape("a\u0000") == "a\ufffd"
    assert Floki.CSSEscape.escape("\u0000b") == "\ufffdb"
    assert Floki.CSSEscape.escape("a\u0000b") == "a\ufffdb"
  end

  test "replacement character" do
    assert Floki.CSSEscape.escape(<<0xFFFD::utf8>>) == <<0xFFFD::utf8>>
    assert Floki.CSSEscape.escape("a\ufffd") == "a\ufffd"
    assert Floki.CSSEscape.escape("\ufffdb") == "\ufffdb"
    assert Floki.CSSEscape.escape("a\ufffdb") == "a\ufffdb"
  end

  test "invalid input" do
    assert_raise ArgumentError, fn -> Floki.CSSEscape.escape(nil) end
  end

  test "control characters" do
    assert Floki.CSSEscape.escape(<<0x01, 0x02, 0x1E, 0x1F>>) == "\\1 \\2 \\1E \\1F "
  end

  test "leading digit" do
    for {digit, expected} <- Enum.zip(0..9, ~w(30 31 32 33 34 35 36 37 38 39)) do
      assert Floki.CSSEscape.escape("#{digit}a") == "\\#{expected} a"
    end
  end

  test "non-leading digit" do
    for digit <- 0..9 do
      assert Floki.CSSEscape.escape("a#{digit}b") == "a#{digit}b"
    end
  end

  test "leading hyphen and digit" do
    for {digit, expected} <- Enum.zip(0..9, ~w(30 31 32 33 34 35 36 37 38 39)) do
      assert Floki.CSSEscape.escape("-#{digit}a") == "-\\#{expected} a"
    end
  end

  test "hyphens" do
    assert Floki.CSSEscape.escape("-") == "\\-"
    assert Floki.CSSEscape.escape("-a") == "-a"
    assert Floki.CSSEscape.escape("--") == "--"
    assert Floki.CSSEscape.escape("--a") == "--a"
  end

  test "non-ASCII and special characters" do
    assert Floki.CSSEscape.escape("🤷🏻‍♂️-_©") == "🤷🏻‍♂️-_©"

    assert Floki.CSSEscape.escape(
             <<0x7F,
               "\u0080\u0081\u0082\u0083\u0084\u0085\u0086\u0087\u0088\u0089\u008a\u008b\u008c\u008d\u008e\u008f\u0090\u0091\u0092\u0093\u0094\u0095\u0096\u0097\u0098\u0099\u009a\u009b\u009c\u009d\u009e\u009f">>
           ) ==
             "\\7F \u0080\u0081\u0082\u0083\u0084\u0085\u0086\u0087\u0088\u0089\u008a\u008b\u008c\u008d\u008e\u008f\u0090\u0091\u0092\u0093\u0094\u0095\u0096\u0097\u0098\u0099\u009a\u009b\u009c\u009d\u009e\u009f"

    assert Floki.CSSEscape.escape("\u00a0\u00a1\u00a2") == "\u00a0\u00a1\u00a2"
  end

  test "alphanumeric characters" do
    assert Floki.CSSEscape.escape("a0123456789b") == "a0123456789b"
    assert Floki.CSSEscape.escape("abcdefghijklmnopqrstuvwxyz") == "abcdefghijklmnopqrstuvwxyz"
    assert Floki.CSSEscape.escape("ABCDEFGHIJKLMNOPQRSTUVWXYZ") == "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  end

  test "space and exclamation mark" do
    assert Floki.CSSEscape.escape(<<0x20, 0x21, 0x78, 0x79>>) == "\\ \\!xy"
  end

  test "unicode characters" do
    # astral symbol (U+1D306 TETRAGRAM FOR CENTRE)
    assert Floki.CSSEscape.escape(<<0x1D306::utf8>>) == <<0x1D306::utf8>>
  end
end
