defmodule Floki.HTML.DocumentTest do
  use ExUnit.Case, async: true

  alias Floki.HTML.Document
  alias Floki.HTML.Document.Doctype
  alias Floki.HTMLTree
  alias Floki.HTMLTree.HTMLNode

  test "set_doctype/2 sets a proper doctype" do
    doc = %Document{}
    doctype = %Doctype{name: "html"}

    assert %Document{doctype: %Doctype{name: "html"}} == Document.set_doctype(doc, doctype)
  end

  test "add_node/3 add a node to its parent or the root of the tree" do
    doc = build_document()
    node = %HTMLNode{type: "p"}
    parent = Map.fetch!(doc.tree.nodes, 6)

    new_doc = Document.add_node(doc, node, parent)

    assert %Document{tree: %HTMLTree{node_ids: [11 | _]}} = new_doc
    inserted_node = Map.get(new_doc.tree.nodes, 11)
    assert %HTMLNode{type: "p", node_id: 11, parent_node_id: 6} = inserted_node
  end

  defp build_document do
    # <!doctype html>
    # <html>
    #   <head>
    #     <title>Hello</title>
    #   </head>
    #   <body>
    #     <article>
    #       <h1>World</h1>
    #       <!-- a trible called quest -->
    #       We The people....
    #     </article>
    #   </body>
    # </html>
    %Document{
      doctype: %Doctype{name: "html"},
      tree: %HTMLTree{
        node_ids: [10, 9, 8, 7, 6, 5, 4, 3, 2, 1],
        nodes: %{
          1 => %Floki.HTMLTree.HTMLNode{
            attributes: [],
            children_nodes_ids: [5, 2],
            node_id: 1,
            parent_node_id: nil,
            type: "html"
          },
          2 => %Floki.HTMLTree.HTMLNode{
            attributes: [],
            children_nodes_ids: [3],
            node_id: 2,
            parent_node_id: 1,
            type: "head"
          },
          3 => %Floki.HTMLTree.HTMLNode{
            attributes: [],
            children_nodes_ids: [4],
            node_id: 3,
            parent_node_id: 2,
            type: "title"
          },
          4 => %Floki.HTMLTree.Text{content: "Hello", node_id: 4, parent_node_id: 3},
          5 => %Floki.HTMLTree.HTMLNode{
            attributes: [],
            children_nodes_ids: [6],
            node_id: 5,
            parent_node_id: 1,
            type: "body"
          },
          6 => %Floki.HTMLTree.HTMLNode{
            attributes: [],
            children_nodes_ids: [10, 9, 7],
            node_id: 6,
            parent_node_id: 5,
            type: "article"
          },
          7 => %Floki.HTMLTree.HTMLNode{
            attributes: [],
            children_nodes_ids: [8],
            node_id: 7,
            parent_node_id: 6,
            type: "h1"
          },
          8 => %Floki.HTMLTree.Text{content: "World", node_id: 8, parent_node_id: 7},
          9 => %Floki.HTMLTree.Comment{
            content: " a trible called quest ",
            node_id: 9,
            parent_node_id: 6
          },
          10 => %Floki.HTMLTree.Text{
            content: "\n      We The people....\n    ",
            node_id: 10,
            parent_node_id: 6
          }
        },
        root_nodes_ids: [1]
      }
    }
  end
end
