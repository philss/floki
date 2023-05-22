defmodule Floki.TextExtractor do
  @moduledoc false

  @allowed_input_types [
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
    {"type", t} = Enum.find(attrs, {"type", "text"}, &match?({"type", _}, &1))

    if t in @allowed_input_types do
      extract_value(attrs)
    else
      ""
    end
  end

  defp extract_value(attrs) do
    Enum.find_value(attrs, "", fn
      {"value", v} -> v
      _ -> nil
    end)
  end
end
