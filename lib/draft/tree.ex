defmodule DraftTree do
  defmodule Node do
    defstruct offset: 0, length: 0, children: [], styles: [], key: nil, text: ""
  end

  def build_tree(ranges, text) do
    root_node = %Node{text: text, length: utf16_length(text), styles: nil}

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
                text: slice_as_utf16(text, range["offset"], range["length"])
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
      {start, rest} = split_at_as_utf16(acc, child.offset - offset)

      {_, finish} =
        split_at_as_utf16(rest, child.offset - offset + child.length - utf16_length(start))

      start <> child_text <> finish
    end)
    |> processor.(styles, key)
  end

  # Draft.js reports `offset` and `length` in UTF-16 code units (the JavaScript
  # string indexing scheme). Elixir strings are UTF-8, and both String.slice/3
  # (graphemes) and codepoint-based slicing miscount any character outside the
  # Basic Multilingual Plane — e.g. most emoji (🔴 U+1F534, 🎶 U+1F3B6), which
  # are a single codepoint but two UTF-16 code units (a surrogate pair). To match
  # Draft's offsets we convert to UTF-16, slice on 2-byte code-unit boundaries,
  # then convert back.
  defp utf16_length(string), do: byte_size(to_utf16(string)) |> div(2)

  defp slice_as_utf16(string, offset, length) do
    <<_::binary-size(offset * 2), slice::binary-size(length * 2), _::binary>> = to_utf16(string)
    from_utf16(slice)
  end

  defp split_at_as_utf16(string, offset) do
    <<start::binary-size(offset * 2), finish::binary>> = to_utf16(string)
    {from_utf16(start), from_utf16(finish)}
  end

  defp to_utf16(string), do: :unicode.characters_to_binary(string, :utf8, {:utf16, :big})
  defp from_utf16(binary), do: :unicode.characters_to_binary(binary, {:utf16, :big}, :utf8)
end
