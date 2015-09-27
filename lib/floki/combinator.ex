defmodule Floki.Combinator do
  @moduledoc """
  Represents the conjunction of a combinator with its selector.

  Combinators can have the following match types:

  - descendant;
    e.g.: "a b"
  - child;
    e.g.: "a > b"
  - adjacent sibling;
    e.g.: "a + b"
  - general sibling;
    e.g.: "a ~ b"

  """

  defstruct match_type: nil, selector: nil
end
