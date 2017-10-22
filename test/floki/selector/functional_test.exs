defmodule Floki.Selector.FunctionalTest do
  use ExUnit.Case, async: true
  alias Floki.Selector.Functional

  test "no match" do
    assert :invalid == Functional.parse("")
    assert :invalid == Functional.parse("not a fn")
    assert :invalid == Functional.parse("odden")
    assert :invalid == Functional.parse("2n-3")
  end

  # :nth-child(5n)
  # Represents elements 5, 10, 15, etc.

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

    for n <- 0..1_000 do
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
end
