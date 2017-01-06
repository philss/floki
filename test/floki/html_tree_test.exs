defmodule Floki.HTMLTreeTest do
  use ExUnit.Case, async: true

  alias Floki.HTMLTree
  alias Floki.HTMLTree.{HTMLNode, Text}

  test "build the tuple tree into HTML tree" do
    link_attrs = [{"href", "/home"}]
    html_tuple =
      {"html", [],
       [
         {:comment, "start of the stack"},
         {"a", link_attrs,
          [{"b", [], ["click me"]}]},
         {"span", [], []}]}

    assert HTMLTree.build(html_tuple) == %HTMLTree{
     root_nodes_ids: [1],
     node_ids: [5, 4, 3, 2, 1],
     nodes: %{
       1 => %HTMLNode{type: "html",
                      children_nodes_ids: [5, 2],
                      node_id: 1},
       2 => %HTMLNode{type: "a",
                      attributes: link_attrs,
                      parent_node_id: 1,
                      children_nodes_ids: [3],
                      node_id: 2},
       3 => %HTMLNode{type: "b",
                      parent_node_id: 2,
                      children_nodes_ids: [4],
                      node_id: 3},
       4 => %Text{content: "click me",
                  parent_node_id: 3,
                  node_id: 4},
       5 => %HTMLNode{type: "span",
                      parent_node_id: 1,
                      node_id: 5}
     }
    }
  end

  test "build HTML tuple list" do
    html_tuple_list = [
      {"html", [],
       [
         {:comment, "start of the stack"},
         {"a", [{"href", "/home"}],
          [{"b", [], ["click me"]}]},
         {"span", [], []}]}
    ]

    assert HTMLTree.build(html_tuple_list) == %HTMLTree{
     root_nodes_ids: [1],
     node_ids: [5, 4, 3, 2, 1],
     nodes: %{
       1 => %HTMLNode{type: "html",
                      children_nodes_ids: [5, 2],
                      node_id: 1},
       2 => %HTMLNode{type: "a",
                     attributes: [{"href", "/home"}],
                     parent_node_id: 1,
                     children_nodes_ids: [3],
                     node_id: 2},
       3 => %HTMLNode{type: "b",
                      parent_node_id: 2,
                      children_nodes_ids: [4],
                      node_id: 3},
       4 => %Text{content: "click me",
                  parent_node_id: 3,
                  node_id: 4},
       5 => %HTMLNode{type: "span",
                      parent_node_id: 1,
                      node_id: 5}
     }
    }
  end

  test "delete HTML node from tree" do
    tree = %HTMLTree{
     root_nodes_ids: [1],
     node_ids: [5, 4, 3, 2, 1],
     nodes: %{
       1 => %HTMLNode{type: "html",
                      children_nodes_ids: [5, 2],
                      node_id: 1},
       2 => %HTMLNode{type: "a",
                     parent_node_id: 1,
                     children_nodes_ids: [3],
                     node_id: 2},
       3 => %HTMLNode{type: "b",
                      parent_node_id: 2,
                      children_nodes_ids: [4],
                      node_id: 3},
       4 => %Text{content: "click me",
                  parent_node_id: 3,
                  node_id: 4},
       5 => %HTMLNode{type: "span",
                      parent_node_id: 1,
                      node_id: 5}
     }
    }

    html_node = %HTMLNode{type: "a",
                          parent_node_id: 1,
                          children_nodes_ids: [3],
                          node_id: 2}

    assert HTMLTree.delete_node(tree, html_node) == %HTMLTree{
     root_nodes_ids: [1],
     node_ids: [5, 1],
     nodes: %{
       1 => %HTMLNode{type: "html",
                      children_nodes_ids: [5],
                      node_id: 1},
       5 => %HTMLNode{type: "span",
                      parent_node_id: 1,
                      node_id: 5}
     }
    }

    html_node = %HTMLNode{type: "html",
                          children_nodes_ids: [5, 2],
                          node_id: 1}

    assert HTMLTree.delete_node(tree, html_node) == %HTMLTree{
      root_nodes_ids: [],
      node_ids: [],
      nodes: %{}
    }
  end
end
