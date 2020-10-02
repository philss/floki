defmodule Floki.HTMLTree.HTMLNode do
  @moduledoc false

  # Represents a HTML node with "references" to its children nodes ids and parent node id.
  defstruct type: "", attributes: [], children_nodes_ids: [], node_id: nil, parent_node_id: nil

  @type t :: %__MODULE__{
          type: String.t(),
          attributes: [{String.t(), String.t()}],
          node_id: pos_integer(),
          parent_node_id: pos_integer()
        }
end
