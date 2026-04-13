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
    if get_type(attrs) in @allowed_input_types, do: get_value(attrs), else: ""
  end

  defp get_type(%{"type" => t}), do: t
  defp get_type(attrs) when is_map(attrs), do: "text"
  defp get_type([{"type", t} | _]), do: t
  defp get_type([_ | rest]), do: get_type(rest)
  defp get_type([]), do: "text"

  defp get_value(attrs) when is_map(attrs), do: Map.get(attrs, "value", "")
  defp get_value([{"value", v} | _]), do: v
  defp get_value([_ | rest]), do: get_value(rest)
  defp get_value([]), do: ""
end
