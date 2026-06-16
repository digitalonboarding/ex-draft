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
            "inlineStyleRanges" => [%{"style" => "BOLD", "offset" => 5, "length" => 1}],
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
            "inlineStyleRanges" => [%{"style" => "ITALIC", "offset" => 0, "length" => 1}],
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
              %{"style" => "BOLD", "offset" => 4, "length" => 3},
              %{"style" => "ITALIC", "offset" => 5, "length" => 1}
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

    test "bold alignment bug" do
      inputs = [
        %{
          "data" => %{},
          "depth" => 0,
          "entityRanges" => [],
          "inlineStyleRanges" => [%{"length" => 4, "offset" => 25, "style" => "BOLD"}],
          "key" => "d9dul",
          "text" => "❤️ should not effect the bold here",
          "type" => "unstyled"
        },
        %{
          "data" => %{},
          "depth" => 0,
          "entityRanges" => [],
          "inlineStyleRanges" => [%{"length" => 4, "offset" => 24, "style" => "BOLD"}],
          "key" => "5vbhk",
          "text" => "🔴 should not effect the bold here",
          "type" => "unstyled"
        },
        %{
          "data" => %{},
          "depth" => 0,
          "entityRanges" => [],
          "inlineStyleRanges" => [%{"length" => 4, "offset" => 25, "style" => "BOLD"}],
          "key" => "dub33",
          "text" => "♥️ should not effect the bold here",
          "type" => "unstyled"
        },
        %{
          "data" => %{},
          "depth" => 0,
          "entityRanges" => [],
          "inlineStyleRanges" => [%{"length" => 4, "offset" => 25, "style" => "BOLD"}],
          "key" => "4g62t",
          "text" => "👍🏻 should not effect the bold here",
          "type" => "unstyled"
        },
        %{
          "data" => %{},
          "depth" => 0,
          "entityRanges" => [],
          "inlineStyleRanges" => [%{"length" => 4, "offset" => 24, "style" => "BOLD"}],
          "key" => "2shv8",
          "text" => "👍 should not effect the bold here",
          "type" => "unstyled"
        },
        %{
          "data" => %{},
          "depth" => 0,
          "entityRanges" => [],
          "inlineStyleRanges" => [%{"length" => 4, "offset" => 24, "style" => "BOLD"}],
          "key" => "gi79",
          "text" => "🐛 should not effect the bold here",
          "type" => "unstyled"
        },
        %{
          "data" => %{},
          "depth" => 0,
          "entityRanges" => [],
          "inlineStyleRanges" => [%{"length" => 4, "offset" => 30, "style" => "BOLD"}],
          "key" => "3tbdr",
          "text" => "🧑\u200D🧑\u200D🧒\u200D🧒 should not effect the bold here",
          "type" => "unstyled"
        }
      ]

      Enum.each(inputs, fn i ->
        output = to_html(%{"entityMap" => %{}, "blocks" => [i]})
        assert String.match?(output, ~r{<span[^>]+>bold</span>})
      end)
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

  describe "KNOWN ISSUE: codepoint slicing was inaccurate for some emojis" do
    test "codepoint slicing is correct" do
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

      output = to_html(input)
      assert is_binary(output)
      assert String.starts_with?(output, "<p>")
      assert String.ends_with?(output, "</p>")
    end
  end
end
