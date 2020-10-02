defmodule Floki.HTMLTree.Text do
  @moduledoc false

  # Represents a text node inside an HTML tree with reference to its parent node id.
  defstruct content: "", node_id: nil, parent_node_id: nil

  @type t :: %__MODULE__{
          content: String.t(),
          node_id: pos_integer(),
          parent_node_id: pos_integer()
        }
end
