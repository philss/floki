defmodule Floki.Selector.Combinator do
  @moduledoc false

  # Represents the conjunction of a combinator with its selector.
  #
  # Combinators can have the following match types:
  #
  # - descendant;
  #   e.g.: "a b"
  # - child;
  #   e.g.: "a > b"
  # - adjacent sibling;
  #   e.g.: "a + b"
  # - general sibling;
  #   e.g.: "a ~ b"

  defstruct match_type: nil, selector: nil

  @type match_type ::
          :descendant
          | :child
          | :adjacent_sibling
          | :general_sibling

  @type t :: %__MODULE__{
          match_type: match_type(),
          selector: Floki.Selector.t()
        }

  defimpl String.Chars do
    def to_string(combinator) do
      match_type =
        case combinator.match_type do
          :descendant -> " "
          :child -> " > "
          :adjacent_sibling -> " + "
          :general_sibling -> " ~ "
          _ -> ""
        end

      "#{match_type}#{combinator.selector}"
    end
  end
end
