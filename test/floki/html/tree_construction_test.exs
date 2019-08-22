defmodule Floki.HTML.TreeConstructionTest do
  use ExUnit.Case, async: true

  alias Floki.HTML.TreeConstruction
  alias Floki.HTML.Tokenizer
  alias Floki.HTML.Document
  alias Floki.HTML.DocumentType
  alias Floki.HTMLTree

  test "build_document/1 in the initial state with comment" do
    tokenizer_state = %Tokenizer.State{
      tokens: [%Tokenizer.Comment{data: "some comment"}]
    }

    {:ok, doc} = TreeConstruction.build_document(tokenizer_state)
    assert %Document{tree: %HTMLTree{nodes: %{1 => %HTMLTree.Comment{content: "some comment"}}}} = doc
  end

  test "build_document/1 in the initial state with space chars" do
    tokenizer_state = %Tokenizer.State{
      tokens: [%Tokenizer.Char{data: "\t\n  "}]
    }

    {:ok, doc} = TreeConstruction.build_document(tokenizer_state)
    assert %Document{tree: %HTMLTree{nodes: nodes = %{}}} = doc
    assert nodes == %{}
  end

  test "build_document/1 in the initial state with a doctype" do
    tokenizer_state = %Tokenizer.State{
      tokens: [%Tokenizer.Doctype{name: "html"}]
    }

    {:ok, doc} = TreeConstruction.build_document(tokenizer_state)

    assert %Document{doctype: doctype, tree: %HTMLTree{nodes: nodes = %{}}} = doc
    assert nodes == %{}
    assert %DocumentType{name: "html"} = doctype
  end
end
