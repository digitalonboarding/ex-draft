defmodule DraftTree do
  defmodule Node do
    defstruct offset: 0, length: 0, children: [], styles: [], key: nil, text: ""
  end

  def build_tree(ranges, text) do
    root_node = %Node{text: text, length: String.length(text), styles: nil}

    Enum.reduce(ranges, root_node, fn range, tree -> insert_node(tree, range, text) end)
  end

  defp insert_node(tree, range, text) do
    first_included_child =
      Enum.find(tree.children, fn child ->
        range["offset"] >= child.offset &&
          range["length"] + range["offset"] <= child.length + child.offset
      end)

    case first_included_child do
      nil ->
        Map.put(
          tree,
          :children,
          tree.children ++
            [
              %Node{
                length: range["length"],
                offset: range["offset"],
                styles: range["styles"],
                key: range["key"],
                text: slice_as_codepoints(text, range["offset"], range["length"])
              }
            ]
        )

      child ->
        {all_but_last_item, _} = Enum.split(tree.children, length(tree.children) - 1)

        Map.put(
          tree,
          :children,
          all_but_last_item ++
            [
              insert_node(child, range, text)
            ]
        )
    end
  end

  def process_tree(%{children: [], key: key, styles: styles, text: text}, processor) do
    processor.(text, styles, key)
  end

  def process_tree(
        %{
          children: children,
          key: key,
          styles: styles,
          offset: offset,
          text: text
        },
        processor
      ) do
    Enum.map(children, fn child -> {child, process_tree(child, processor)} end)
    |> Enum.reverse()
    |> Enum.reduce(text, fn {child, child_text}, acc ->
      {start, rest} = split_at_as_codepoints(acc, child.offset - offset)

      {_, finish} =
        split_at_as_codepoints(rest, child.offset - offset + child.length - String.length(start))

      start <> child_text <> finish
    end)
    |> processor.(styles, key)
  end

  defp slice_as_codepoints(string, offset, length) do
    string
    |> String.codepoints()
    |> Enum.slice(offset, length)
    |> List.to_string()
  end

  defp split_at_as_codepoints(string, offset) do
    {start, finish} =
      string
      |> String.codepoints()
      |> Enum.split(offset)
      |> then(fn {start, finish} -> {List.to_string(start), List.to_string(finish)} end)

    {start, finish}
  end
end
