defmodule Floki.HTMLTree.Comment do
  @moduledoc false

  # Represents a comment inside an HTML tree with reference to its parent node id.
  # TODO: rename content to data
  defstruct content: "", node_id: nil, parent_node_id: nil

  @type t :: %__MODULE__{
          content: String.t(),
          node_id: pos_integer(),
          parent_node_id: pos_integer()
        }
end
