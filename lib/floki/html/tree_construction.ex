defmodule Floki.HTML.TreeConstruction do
  @moduledoc false

  alias Floki.HTML.Document
  alias Floki.HTML.Doctype
  alias Floki.HTML.Tokenizer
  alias Floki.HTML.Tokenizer.State, as: TState
  alias Floki.HTMLTree, as: HTree

  @space_chars ["\t", "\n", "\f", "\s"]

  # It represents the state of tree construction.
  # The docs of this step is here: https://html.spec.whatwg.org/#tree-construction
  defmodule State do
    @moduledoc false

    defstruct mode: :initial,
              original_insertion_mode: nil,
              document: %Document{},
              open_elements: [],
              template_insertion_modes: [],
              active_formatting_elements: [],
              head_pointer: nil,
              form_pointer: nil,
              scripting_flag: false,
              frameset_ok: true,
              adjusted_current_node: nil
  end

  def build_document(tokenizer_state = %TState{}) do
    initial(%State{}, tokenizer_state)
  end

  defp initial(
         state = %State{},
         tstate = %TState{tokens: [token = %Tokenizer.Comment{} | tokens]}
       ) do
    {:ok, doc, _} = Document.add_node(state.document, %HTree.Comment{content: token.data})
    initial(%{state | document: doc}, %{tstate | tokens: tokens})
  end

  defp initial(
         state = %State{},
         tstate = %TState{tokens: [token = %Tokenizer.Char{} | tokens]}
       ) do
    if String.trim(token.data) == "" do
      initial(state, %{tstate | tokens: tokens})
    else
      before_html(state, tstate)
    end
  end

  defp initial(
         state = %State{},
         tstate = %TState{tokens: [token = %Tokenizer.Doctype{} | tokens]}
       ) do
    # TODO: check for parse errors
    doctype = %Doctype{name: token.name}
    doc = Document.set_doctype(state.document, doctype)
    initial(%{state | document: doc}, %{tstate | tokens: tokens})
  end

  defp initial(state = %State{}, tstate = %TState{}) do
    before_html(
      %{state | document: Document.set_mode(state.document, "quirks")},
      tstate
    )
  end

  # the-before-html-insertion-mode

  defp before_html(
         state = %State{},
         tstate = %TState{tokens: [%Tokenizer.Doctype{} | tokens]}
       ) do
    # TODO: set parse error
    before_html(state, %{tstate | tokens: tokens})
  end

  defp before_html(
         state = %State{},
         tstate = %TState{tokens: [token = %Tokenizer.Comment{} | tokens]}
       ) do
    {:ok, doc, _} = Document.add_node(state.document, %HTree.Comment{content: token.data})

    before_html(%{state | document: doc}, %{tstate | tokens: tokens})
  end

  defp before_html(
         state = %State{},
         tstate = %TState{tokens: [%Tokenizer.Char{data: data} | tokens]}
       )
       when data in @space_chars do
    # TODO: since we are collapsing the char tokens, we can't check if this is
    # a space token. Maybe breaking the char token into multiples is a solution.
    before_html(state, %{tstate | tokens: tokens})
  end

  defp before_html(
         state = %State{},
         tstate = %TState{tokens: [token = %Tokenizer.StartTag{name: "html"} | tokens]}
       ) do
    new_element = %HTree.HTMLNode{type: token.name, attributes: token.attributes}
    {:ok, doc, new_node} = Document.add_node(state.document, new_element)

    before_head(
      %{state | document: doc, open_elements: [new_node.node_id | state.open_elements]},
      %{tstate | tokens: tokens}
    )
  end

  defp before_html(
         state = %State{},
         tstate = %TState{tokens: [%Tokenizer.EndTag{name: name} | _tokens]}
       )
       when name in ~w(head body html br) do
    new_element = %HTree.HTMLNode{type: "html"}
    {:ok, doc, new_node} = Document.add_node(state.document, new_element)

    before_head(
      %{state | document: doc, open_elements: [new_node.node_id | state.open_elements]},
      tstate
    )
  end

  defp before_html(
         state = %State{},
         tstate = %TState{tokens: [%Tokenizer.StartTag{} | tokens]}
       ) do
    # TODO: add parse error
    before_html(state, %{tstate | tokens: tokens})
  end

  defp before_html(
         state = %State{},
         tstate = %TState{tokens: [%Tokenizer.EndTag{} | tokens]}
       ) do
    # TODO: add parse error
    before_html(state, %{tstate | tokens: tokens})
  end

  defp before_html(
         state = %State{},
         tstate = %TState{tokens: []}
       ) do
    {:ok, doc, new_node} = add_node(state, %HTree.HTMLNode{type: "html"})

    before_head(
      %{state | document: doc, open_elements: [new_node.node_id | state.open_elements]},
      tstate
    )
  end

  defp before_head(state = %State{}, %TState{}) do
    {:ok, state.document}
  end

  defp add_node(%State{document: doc, open_elements: []}, element) do
    Document.add_node(doc, element)
  end

  defp add_node(%State{document: doc, open_elements: [current_node_id | _]}, element) do
    Document.add_node(doc, element, current_node_id)
  end
end
