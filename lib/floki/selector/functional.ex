defmodule Floki.Selector.Functional do
  @moduledoc false
  # Represents a functional notation for a selector

  defstruct [:stream, :a, :b]

  @regex ~r/^(?<a>[-+]?[0-9]*[n])\+?(?<b>[0-9]*)$/

  def parse(expr) when is_list(expr) do
    parse(to_string(expr))
  end
  def parse(expr) do
    expr = String.downcase(expr)
    case Regex.named_captures(@regex, expr) do
      nil -> :invalid
      %{"a" => a, "b" => b} -> {:ok, build(a, b)}
    end
  end

  defp build(a, ""), do: build(a, "0")
  defp build(a, b) do
    a = parse_a(a)
    b = String.to_integer(b)
    stream = Stream.map(0..100_000, fn x ->
      a * x + b
    end)

    %__MODULE__{stream: stream, a: a, b: b}
  end

  defp parse_a(a) do
    case String.trim(a, "n") do
      "-" -> -1
      "" -> 1
      n -> String.to_integer(n)
    end
  end

  defimpl String.Chars do
    def to_string(functional) do
      "#{functional.a}x+#{functional.b}"
    end
  end
end
