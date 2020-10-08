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
              # This will be the original mode, and will be updated in case it consumes the token.
              return_to_mode: false,
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
    # a space token alone. Let's read/execute the tests to ensure it's matching
    # the specs.
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
          open_elements: [new_node | state.open_elements]
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
          open_elements: [new_node | state.open_elements]
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
          open_elements: [new_node | state.open_elements]
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
          open_elements: [new_node | state.open_elements],
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
          open_elements: [new_node | state.open_elements],
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
          open_elements: [new_node | state.open_elements],
          head_pointer: new_node.node_id
      },
      tstate
    )
  end

  # the-in-head-insertion-mode

  # Special case in order to return to mode
  defp in_head(
         state = %State{mode: insertion_mode, return_to_mode: true},
         tstate
       )
       when insertion_mode != :in_head do
    return_to_mode(state, tstate)
  end

  defp in_head(
         state = %State{},
         tstate = %TState{tokens: [%Tokenizer.Char{data: char_data} | tokens]}
       )
       when char_data in @space_chars do
    {:ok, state} = add_char(state, char_data)

    in_head(state, %{tstate | tokens: tokens})
  end

  defp in_head(
         state = %State{},
         tstate = %TState{tokens: [comment = %Tokenizer.Comment{} | tokens]}
       ) do
    {:ok, state, _new_node} = add_node(state, %HTree.Comment{content: comment.content})

    in_head(state, %{tstate | tokens: tokens})
  end

  defp in_head(
         state = %State{},
         tstate = %TState{tokens: [%Tokenizer.Doctype{} | tokens]}
       ) do
    # TODO: set parse error
    in_head(state, %{tstate | tokens: tokens})
  end

  defp in_head(state = %State{}, %TState{}) do
    {:ok, state.document}
  end

  # TODO: handle the problem of mode x defer from
  defp in_body(state = %State{}, %TState{}) do
    {:ok, state.document}
  end

  defp return_to_mode(state, tstate) do
    state = %{state | return_to_mode: false}

    case state.mode do
      :in_head ->
        in_head(state, tstate)

      :in_body ->
        in_body(state, tstate)
    end
  end

  # NOTE: you need to manually change the open elements when adding nodes.
  defp add_node(state = %State{document: doc}, element) do
    result =
      case appropriate_place(state) do
        :document_root ->
          Document.add_node(doc, element)

        parent = %HTree.HTMLNode{} ->
          Document.add_node(doc, element, parent.node_id)

        {:add_node_before, _parent, _before_node} ->
          raise "cannot add before node yet"
      end

    with {:ok, doc, new_node} <- result do
      case new_node do
        %HTree.HTMLNode{} ->
          {:ok, %{state | document: doc, adjusted_current_node: new_node}, new_node}

        _ ->
          {:ok, %{state | document: doc}, new_node}
      end
    end
  end

  defp add_char(state, char_data) do
    case appropriate_place(state) do
      :document_root ->
        # Let it untouched
        {:ok, state}

      html_node = %HTree.HTMLNode{} ->
        before_element = Document.get_node_before(state.document, html_node)

        case before_element do
          text_node = %HTree.Text{} ->
            # here we just add to the text node and update doc.
            updated_node = %{text_node | content: [text_node.content | char_data]}
            {:ok, %{state | document: Document.patch_node(state.document, updated_node)}}

          _ ->
            {:ok,
             %{
               state
               | document:
                   Document.add_node(
                     state.document,
                     %HTree.Text{content: [char_data]},
                     html_node.node_id
                   )
             }}
        end

      _ ->
        # By default, let it untouched
        {:ok, state}
    end
  end

  defp appropriate_place(%State{override_target_id: nil, open_elements: []}) do
    :document_root
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

    # TODO: consider ignoring the foster parenting because
    # we won't handle DOM mutations by scripts.
    if foster_parenting && target.type in ~w(table tbody tfoot thead tr) do
      last_template = last_element_with_index(state.open_elements, "template")
      last_table = last_element_with_index(state.open_elements, "table")

      cond do
        last_template && (!last_table || position_is_lower?(last_template, last_table)) ->
          {el, _idx} = last_template
          el

        !last_table ->
          state.open_elements
          |> Enum.reverse()
          |> List.first()

        last_table && last_table.parent_node_id ->
          {:ok, parent_node} = Document.get_node(doc, last_table.parent_node_id)
          # NOTE: we need to treat this clause
          {:add_node_before, parent_node, last_table}

        true ->
          [^current_node, previous_element | _] = state.open_elements
          previous_element
      end
    else
      target
    end
  end

  defp position_is_lower?({_element_a, pos_a}, {_element_b, pos_b}), do: pos_a < pos_b

  # Elements are HTML nodes
  defp last_element_with_index(elements, type) do
    elements
    |> Enum.with_index()
    |> Enum.find(fn {el, _idx} -> el.type == type end)
  end
end
