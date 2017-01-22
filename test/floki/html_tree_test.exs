defmodule Floki.HTMLTreeTest do
  use ExUnit.Case, async: true

  alias Floki.HTMLTree
  alias Floki.HTMLTree.{HTMLNode, Text, Comment}

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
     node_ids: [6, 5, 4, 3, 2, 1],
     nodes: %{
       1 => %HTMLNode{type: "html",
                      children_nodes_ids: [6, 3, 2],
                      node_id: 1},
       2 => %Comment{content: "start of the stack", node_id: 2, parent_node_id: 1},
       3 => %HTMLNode{type: "a",
                      attributes: link_attrs,
                      parent_node_id: 1,
                      children_nodes_ids: [4],
                      node_id: 3},
       4 => %HTMLNode{type: "b",
                      parent_node_id: 3,
                      children_nodes_ids: [5],
                      node_id: 4},
       5 => %Text{content: "click me",
                  parent_node_id: 4,
                  node_id: 5},
       6 => %HTMLNode{type: "span",
                      parent_node_id: 1,
                      node_id: 6}
     }
    }
  end

  test "build HTML tuple list" do
    html_tuple_list = [
      {"html", [],
       [
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

  test "builds the root node ids in the right order" do
    tuples = [{"p", [], ["1"]},{"p", [], ["2"]}]
    tree = HTMLTree.build(tuples)
    assert tree == %HTMLTree{
      root_nodes_ids: [1, 3],
      node_ids: [4, 3, 2, 1],
      nodes: %{
        1 => %HTMLNode{type: "p",
                       children_nodes_ids: [2],
                       node_id: 1},
        2 => %Text{content: "1",
                   node_id: 2,
                   parent_node_id: 1},
        3 => %HTMLNode{attributes: [],
                       children_nodes_ids: [4],
                       node_id: 3,
                       parent_node_id: nil,
                       type: "p"},
        4 => %Text{content: "2",
                   node_id: 4,
                   parent_node_id: 3},
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

  test "build tuple representation of tree" do
    html_tree = %HTMLTree{
     root_nodes_ids: [1],
     node_ids: [6, 5, 4, 3, 2, 1],
     nodes: %{
       1 => %HTMLNode{type: "html",
                      children_nodes_ids: [6, 3, 2],
                      node_id: 1},
       2 => %Comment{content: "start of the stack", node_id: 2, parent_node_id: 1},
       3 => %HTMLNode{type: "a",
                      attributes: [{"class", "link"}],
                      parent_node_id: 1,
                      children_nodes_ids: [4],
                      node_id: 3},
       4 => %HTMLNode{type: "b",
                      parent_node_id: 3,
                      children_nodes_ids: [5],
                      node_id: 4},
       5 => %Text{content: "click me",
                  parent_node_id: 4,
                  node_id: 5},
       6 => %HTMLNode{type: "span",
                      parent_node_id: 1,
                      node_id: 6}
      }
    }

    expected_tuple =
      {"html", [],
       [
         {:comment, "start of the stack"},
         {"a", [{"class", "link"}],
          [{"b", [], ["click me"]}]},
         {"span", [], []}]}

    assert HTMLTree.to_tuple(html_tree, %HTMLNode{type: "html",
                                                  children_nodes_ids: [6, 3, 2],
                                                  node_id: 1}) == expected_tuple
  end
end
