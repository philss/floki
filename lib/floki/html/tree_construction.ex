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
              foster_parenting: nil,
              override_target_id: nil,
              last_template: nil,
              last_table: nil,
              adjusted_current_node: nil
  end

  @spec build_document(%TState{}) :: {:ok, %Document{}} | {:error, atom()}
  def build_document(tokenizer_state = %TState{}) do
    initial(%State{}, tokenizer_state)
  end

  defp initial(
         state = %State{},
         tstate = %TState{tokens: [token = %Tokenizer.Comment{} | tokens]}
       ) do
    {:ok, document, _} = Document.add_node(state.document, %HTree.Comment{content: token.data})

    initial(%{state | document: document}, %{tstate | tokens: tokens})
  end

  defp initial(
         state = %State{},
         tstate = %TState{tokens: [token = %Tokenizer.Char{} | tokens]}
       ) do
    if String.trim(token.data) == "" do
      initial(state, %{tstate | tokens: tokens})
    else
      before_html(%{state | mode: :before_html}, tstate)
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
      %{state | mode: :before_html, document: Document.set_mode(state.document, "quirks")},
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
    {:ok, state, _} = Document.add_node(state.document, %HTree.Comment{content: token.data})

    before_html(state, %{tstate | tokens: tokens})
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
    {:ok, state, new_node} = Document.add_node(state.document, new_element)

    before_head(
      %{
        state
        | mode: :before_head,
          open_elements: [new_node.node_id | state.open_elements]
      },
      %{tstate | tokens: tokens}
    )
  end

  defp before_html(
         state = %State{},
         tstate = %TState{tokens: [%Tokenizer.EndTag{name: name} | _tokens]}
       )
       when name in ~w(head body html br) do
    new_element = %HTree.HTMLNode{type: "html"}
    {:ok, state, new_node} = Document.add_node(state.document, new_element)

    before_head(
      %{
        state
        | mode: :before_head,
          open_elements: [new_node.node_id | state.open_elements]
      },
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
    {:ok, state, new_node} = add_node(state, %HTree.HTMLNode{type: "html"})

    before_head(
      %{
        state
        | mode: :before_head,
          open_elements: [new_node.node_id | state.open_elements]
      },
      tstate
    )
  end

  # the-before-head-insertion-mode

  defp before_head(
         state = %State{},
         tstate = %TState{tokens: [%Tokenizer.Char{data: data} | tokens]}
       )
       when data in @space_chars do
    before_head(state, %{tstate | tokens: tokens})
  end

  defp before_head(
         state = %State{},
         tstate = %TState{tokens: [%Tokenizer.Doctype{} | tokens]}
       ) do
    # TODO: set parse error
    before_head(state, %{tstate | tokens: tokens})
  end

  defp before_head(
         state = %State{},
         tstate = %TState{tokens: [%Tokenizer.StartTag{name: "html"} | _tokens]}
       ) do
    in_body(%{state | mode: :before_head}, tstate)
  end

  defp before_head(
         state = %State{},
         tstate = %TState{tokens: [%Tokenizer.StartTag{name: "head"} | tokens]}
       ) do
    {:ok, state, new_node} = add_node(state, %HTree.HTMLNode{type: "head"})

    in_head(
      %{
        state
        | mode: :in_head,
          open_elements: [new_node.node_id | state.open_elements],
          head_pointer: new_node.node_id
      },
      %{tstate | tokens: tokens}
    )
  end

  defp before_head(
         state = %State{},
         tstate = %TState{tokens: [%Tokenizer.EndTag{name: name} | _tokens]}
       )
       when name in ~w(head body html br) do
    {:ok, state, new_node} = add_node(state, %HTree.HTMLNode{type: "head"})

    in_head(
      %{
        state
        | mode: :in_head,
          open_elements: [new_node.node_id | state.open_elements],
          head_pointer: new_node.node_id
      },
      tstate
    )
  end

  defp before_head(
         state = %State{},
         tstate = %TState{tokens: [%Tokenizer.EndTag{} | tokens]}
       ) do
    # TODO: set parse error
    before_head(state, %{tstate | tokens: tokens})
  end

  defp before_head(
         state = %State{},
         tstate = %TState{}
       ) do
    {:ok, state, new_node} = add_node(state, %HTree.HTMLNode{type: "head"})

    in_head(
      %{
        state
        | mode: :in_head,
          open_elements: [new_node.node_id | state.open_elements],
          head_pointer: new_node.node_id
      },
      tstate
    )
  end

  # the-in-head-insertion-mode

  defp in_head(
         state = %State{},
         tstate = %TState{tokens: [%Tokenizer.Char{data: char} | _tokens]}
       )
       when char in @space_chars do
    # TODO: we need to fix the tokenizer to not collapse the space chars
    #
  end

  defp in_head(state = %State{}, %TState{}) do
    {:ok, state.document}
  end

  defp in_body(state = %State{}, %TState{}) do
    {:ok, state.document}
  end

  defp add_node(state = %State{document: doc, open_elements: open_elements}, element) do
    result =
      case open_elements do
        [] ->
          Document.add_node(doc, element)

        [current_node_id | _] ->
          Document.add_node(doc, element, current_node_id)
      end

    with {:ok, doc, new_node} <- result do
      {:ok, %{state | document: doc}, new_node}
    end
  end

  defp add_char(state, char_data) do
    # {:ok, doc, char_node} = Document.add_char(doc, char_data)

    with {:ok, place} <- appropriate_place(state) do
      case place do
        :document_root ->
          # Let it untouched
          {:ok, state}

        _ ->
          # By default, let it untouched
          {:ok, state}
      end
    end
  end

  defp appropriate_place(%State{override_target_id: nil, open_elements: []}) do
    {:ok, :document_root}
  end

  defp appropriate_place(
         state = %State{
           override_target_id: override_target_id,
           open_elements: [current_node | _],
           document: doc,
           foster_parenting: foster_parenting
         }
       ) do
    target =
      if override_target_id do
        case Document.get_node(doc, override_target_id) do
          {:ok, override_target} ->
            override_target

          _ ->
            current_node
        end
      else
        current_node
      end

    adjusted_insertion =
      cond do
        foster_parenting && target.type in ~w(table tbody tfoot thead tr) ->
          last_template = last_element_with_index(state.open_elements, "template")
          last_table = last_element_with_index(state.open_elements, "table")

          # TODO: step 2.3 of appropriate_place
      end
  end

  defp last_element_with_index(elements, type) do
    elements
    |> Enum.with_index()
    |> Enum.find(fn {el, idx} -> el.type == type end)
  end
end
