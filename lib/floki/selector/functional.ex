defmodule Floki.Selector.Functional do
  @moduledoc false

  # Represents a functional notation for a selector

  defstruct [:stream, :a, :b]

  def parse(expr) when is_list(expr) do
    parse(to_string(expr))
  end

  def parse(expr) do
    expr = String.downcase(expr)
    regex = ~r/^\s*(?<a>[-+]?[0-9]*[n])\s*(?<b>[+-]\s*[0-9]+)?\s*$/

    case Regex.named_captures(regex, expr) do
      nil -> :invalid
      %{"a" => a, "b" => b} -> {:ok, build(a, b)}
    end
  end

  defp build(a, ""), do: build(a, "0")

  defp build(a, b) do
    a = parse_num(a)
    b = parse_num(b)

    stream =
      Stream.map(0..100_000, fn x ->
        a * x + b
      end)

    %__MODULE__{stream: stream, a: a, b: b}
  end

  defp parse_num(n_str) do
    n_str
    |> String.replace(" ", "")
    |> String.trim("n")
    |> case do
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
