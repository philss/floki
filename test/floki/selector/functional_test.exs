defmodule Floki.Selector.FunctionalTest do
  use ExUnit.Case, async: true
  alias Floki.Selector.Functional

  test "no match" do
    assert :invalid == Functional.parse("")
    assert :invalid == Functional.parse("not a fn")
    assert :invalid == Functional.parse("odden")
    assert :invalid == Functional.parse("2n-")
    assert :invalid == Functional.parse("10n+-1")
    assert :invalid == Functional.parse("10n-+1")
    assert :invalid == Functional.parse("3 n")
    assert :invalid == Functional.parse("+ 2n")
    assert :invalid == Functional.parse("+ 2")
  end

  test "An" do
    assert {:ok, f} = Functional.parse("5n")
    assert %Functional{a: 5, b: 0} = f

    for n <- [5, 10, 15, 20] do
      assert n in f.stream
    end
  end

  test "A is implicit" do
    assert {:ok, f} = Functional.parse("-n+3")
    assert %Functional{a: -1, b: 3} = f

    for n <- [1, 2, 3] do
      assert n in f.stream
    end
  end

  test "n is all" do
    assert {:ok, f} = Functional.parse("n")
    assert %Functional{a: 1, b: 0} = f

    for n <- 0..1000 do
      assert n in f.stream
    end
  end

  test "negative complement" do
    assert {:ok, f} = Functional.parse("4n-1")
    assert %Functional{a: 4, b: -1} = f

    for n <- [3, 7, 11, 15] do
      assert n in f.stream
    end
  end

  test "complete function" do
    assert {:ok, f} = Functional.parse("3n+4")
    assert %Functional{a: 3, b: 4} = f

    for n <- [4, 7, 10, 13] do
      assert n in f.stream
    end
  end

  test "whitespace" do
    assert {:ok, f} = Functional.parse("  3n + 4  ")
    assert %Functional{a: 3, b: 4} = f

    assert {:ok, f} = Functional.parse(" 3n + 1 ")
    assert %Functional{a: 3, b: 1} = f

    assert {:ok, f} = Functional.parse(" +3n - 2 ")
    assert %Functional{a: 3, b: -2} = f

    assert {:ok, f} = Functional.parse(" -n+ 6")
    assert %Functional{a: -1, b: 6} = f
  end
end
