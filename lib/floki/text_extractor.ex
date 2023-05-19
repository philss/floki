defmodule Floki.TextExtractor do
  @moduledoc false

  @allowed_input_types [
    nil,
    "color",
    "date",
    "datetime-local",
    "email",
    "month",
    "number",
    "search",
    "tel",
    "text",
    "time",
    "url",
    "week"
  ]

  def extract_input_value(attrs) do
    type = Enum.find(attrs, &match?({"type", _}, &1))

    case type do
      {"type", t} ->
        if t in @allowed_input_types do
          extract_value(attrs)
        else
          ""
        end

      nil ->
        extract_value(attrs)
    end
  end

  defp extract_value(attrs) do
    Enum.find_value(attrs, "", fn
      {"value", v} -> v
      _ -> nil
    end)
  end
end
