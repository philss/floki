defmodule Floki.HTMLTree.HTMLNode do
  @moduledoc false

  # Represents a HTML node with "references" to its children nodes ids and parent node id.
  defstruct type: "", attributes: [], children_nodes_ids: [], node_id: nil, parent_node_id: nil
end
