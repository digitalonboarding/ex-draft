defmodule SpecialCharacterEdgeCasesTest do
  use ExUnit.Case
  use Draft

  describe "emoji handling" do
    test "single emoji with style" do
      input = %{
        "entityMap" => %{},
        "blocks" => [
          %{
            "text" => "test 🔴 end",
            "type" => "unstyled",
            "depth" => 0,
            "inlineStyleRanges" => [%{"style" => "BOLD", "offset" => 5, "length" => 2}],
            "entityRanges" => [],
            "data" => %{},
            "key" => "test"
          }
        ]
      }

      output = to_html(input)
      assert output == "<p>test <span style=\"font-weight: bold;\">🔴</span> end</p>"
    end

    test "emoji at start of text" do
      input = %{
        "entityMap" => %{},
        "blocks" => [
          %{
            "text" => "🔴 red",
            "type" => "unstyled",
            "depth" => 0,
            "inlineStyleRanges" => [%{"style" => "ITALIC", "offset" => 0, "length" => 2}],
            "entityRanges" => [],
            "data" => %{},
            "key" => "test"
          }
        ]
      }

      output = to_html(input)
      assert output == "<p><span style=\"font-style: italic;\">🔴</span> red</p>"
    end

    test "multiple consecutive emojis" do
      input = %{
        "entityMap" => %{},
        "blocks" => [
          %{
            "text" => "🔴🎶🔴",
            "type" => "unstyled",
            "depth" => 0,
            "inlineStyleRanges" => [%{"style" => "BOLD", "offset" => 0, "length" => 6}],
            "entityRanges" => [],
            "data" => %{},
            "key" => "test"
          }
        ]
      }

      output = to_html(input)
      assert output == "<p><span style=\"font-weight: bold;\">🔴🎶🔴</span></p>"
    end

    test "overlapping styles around emoji" do
      input = %{
        "entityMap" => %{},
        "blocks" => [
          %{
            "text" => "test 🎶 end",
            "type" => "unstyled",
            "depth" => 0,
            "inlineStyleRanges" => [
              %{"style" => "BOLD", "offset" => 4, "length" => 4},
              %{"style" => "ITALIC", "offset" => 5, "length" => 2}
            ],
            "entityRanges" => [],
            "data" => %{},
            "key" => "test"
          }
        ]
      }

      output = to_html(input)
      assert output ==
               "<p>test<span style=\"font-weight: bold;\"> </span><span style=\"font-weight: bold; font-style: italic;\">🎶</span><span style=\"font-weight: bold;\"> </span>end</p>"
    end
  end

  describe "combining marks and diacritics" do
    test "accented characters" do
      input = %{
        "entityMap" => %{},
        "blocks" => [
          %{
            "text" => "café",
            "type" => "unstyled",
            "depth" => 0,
            "inlineStyleRanges" => [%{"style" => "BOLD", "offset" => 0, "length" => 4}],
            "entityRanges" => [],
            "data" => %{},
            "key" => "test"
          }
        ]
      }

      output = to_html(input)
      assert output == "<p><span style=\"font-weight: bold;\">café</span></p>"
    end
  end

  describe "edge cases" do
    test "empty text block" do
      input = %{
        "entityMap" => %{},
        "blocks" => [
          %{
            "text" => "",
            "type" => "unstyled",
            "depth" => 0,
            "inlineStyleRanges" => [],
            "entityRanges" => [],
            "data" => %{},
            "key" => "test"
          }
        ]
      }

      output = to_html(input)
      assert output == "<br>"
    end
  end

  describe "KNOWN ISSUE: Invalid UTF-16 offsets (half surrogate pairs)" do
    test "half surrogate offset is handled gracefully (no crash)" do
      input = %{
        "entityMap" => %{},
        "blocks" => [
          %{
            "text" => "test 🔴 end",
            "type" => "unstyled",
            "depth" => 0,
            "inlineStyleRanges" => [%{"style" => "BOLD", "offset" => 5, "length" => 1}],
            "entityRanges" => [],
            "data" => %{},
            "key" => "test"
          }
        ]
      }

      # Invalid UTF-16 offset (lands in middle of surrogate pair) is now handled gracefully
      # The code no longer crashes with Protocol.UndefinedError
      # Note: Text reconstruction may be incomplete with invalid offsets, but at least it doesn't crash
      output = to_html(input)
      assert is_binary(output)
      assert String.starts_with?(output, "<p>")
      assert String.ends_with?(output, "</p>")
    end
  end
end
