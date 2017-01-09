defmodule Floki.HTMLTree.Comment do
  @moduledoc false

  # Represents a comment inside an HTML tree with reference to its parent node id.
  defstruct content: "", node_id: nil, parent_node_id: nil
end
