defmodule Floki.HTML.NumericCharref do
  @moduledoc false

  # REPLACEMENT CHARACTER
  def to_unicode_number(0x00), do: {:ok, {:table, 0xFFFD}}
  # EURO SIGN (€)
  def to_unicode_number(0x80), do: {:ok, {:table, 0x20AC}}
  # SINGLE LOW-9 QUOTATION MARK (‚)
  def to_unicode_number(0x82), do: {:ok, {:table, 0x201A}}
  # LATIN SMALL LETTER F WITH HOOK (ƒ)
  def to_unicode_number(0x83), do: {:ok, {:table, 0x0192}}
  # DOUBLE LOW-9 QUOTATION MARK („)
  def to_unicode_number(0x84), do: {:ok, {:table, 0x201E}}
  # HORIZONTAL ELLIPSIS (…)
  def to_unicode_number(0x85), do: {:ok, {:table, 0x2026}}
  # DAGGER (†)
  def to_unicode_number(0x86), do: {:ok, {:table, 0x2020}}
  # DOUBLE DAGGER (‡)
  def to_unicode_number(0x87), do: {:ok, {:table, 0x2021}}
  # MODIFIER LETTER CIRCUMFLEX ACCENT (ˆ)
  def to_unicode_number(0x88), do: {:ok, {:table, 0x02C6}}
  # PER MILLE SIGN (‰)
  def to_unicode_number(0x89), do: {:ok, {:table, 0x2030}}
  # LATIN CAPITAL LETTER S WITH CARON (Š)
  def to_unicode_number(0x8A), do: {:ok, {:table, 0x0160}}
  # SINGLE LEFT-POINTING ANGLE QUOTATION MARK (‹)
  def to_unicode_number(0x8B), do: {:ok, {:table, 0x2039}}
  # LATIN CAPITAL LIGATURE OE (Œ)
  def to_unicode_number(0x8C), do: {:ok, {:table, 0x0152}}
  # LATIN CAPITAL LETTER Z WITH CARON (Ž)
  def to_unicode_number(0x8E), do: {:ok, {:table, 0x017D}}
  # LEFT SINGLE QUOTATION MARK (‘)
  def to_unicode_number(0x91), do: {:ok, {:table, 0x2018}}
  # RIGHT SINGLE QUOTATION MARK (’)
  def to_unicode_number(0x92), do: {:ok, {:table, 0x2019}}
  # LEFT DOUBLE QUOTATION MARK (“)
  def to_unicode_number(0x93), do: {:ok, {:table, 0x201C}}
  # RIGHT DOUBLE QUOTATION MARK (”)
  def to_unicode_number(0x94), do: {:ok, {:table, 0x201D}}
  # BULLET (•)
  def to_unicode_number(0x95), do: {:ok, {:table, 0x2022}}
  # EN DASH (–)
  def to_unicode_number(0x96), do: {:ok, {:table, 0x2013}}
  # EM DASH (—)
  def to_unicode_number(0x97), do: {:ok, {:table, 0x2014}}
  # SMALL TILDE (˜)
  def to_unicode_number(0x98), do: {:ok, {:table, 0x02DC}}
  # TRADE MARK SIGN (™)
  def to_unicode_number(0x99), do: {:ok, {:table, 0x2122}}
  # LATIN SMALL LETTER S WITH CARON (š)
  def to_unicode_number(0x9A), do: {:ok, {:table, 0x0161}}
  # SINGLE RIGHT-POINTING ANGLE QUOTATION MARK (›)
  def to_unicode_number(0x9B), do: {:ok, {:table, 0x203A}}
  # LATIN SMALL LIGATURE OE (œ)
  def to_unicode_number(0x9C), do: {:ok, {:table, 0x0153}}
  # LATIN SMALL LETTER Z WITH CARON (ž)
  def to_unicode_number(0x9E), do: {:ok, {:table, 0x017E}}
  # LATIN CAPITAL LETTER Y WITH DIAERESIS (Ÿ)
  def to_unicode_number(0x9F), do: {:ok, {:table, 0x0178}}

  def to_unicode_number(number) when number in 0xD800..0xDFFF or number > 0x10FFFF,
    do: {:ok, {:range_one, 0xFFFD}}

  def to_unicode_number(number)
      when number in 0x0001..0x0008 or number in 0x000D..0x001F or number in 0x007F..0x009F or
             number in 0xFDD0..0xFDEF or
             number in [
               0x000B,
               0xFFFE,
               0xFFFF,
               0x1FFFE,
               0x1FFFF,
               0x2FFFE,
               0x2FFFF,
               0x3FFFE,
               0x3FFFF,
               0x4FFFE,
               0x4FFFF,
               0x5FFFE,
               0x5FFFF,
               0x6FFFE,
               0x6FFFF,
               0x7FFFE,
               0x7FFFF,
               0x8FFFE,
               0x8FFFF,
               0x9FFFE,
               0x9FFFF,
               0xAFFFE,
               0xAFFFF,
               0xBFFFE,
               0xBFFFF,
               0xCFFFE,
               0xCFFFF,
               0xDFFFE,
               0xDFFFF,
               0xEFFFE,
               0xEFFFF,
               0xFFFFE,
               0xFFFFF,
               0x10FFFE,
               0x10FFFF
             ] do
    {:ok, {:list_of_errors, number}}
  end

  def to_unicode_number(number) when is_integer(number) and number >= 0,
    do: {:ok, {:unicode, number}}

  def to_unicode_number(number), do: {:error, {:negative_number, number}}
end
