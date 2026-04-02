defmodule DraftTest do
  use ExUnit.Case
  use Draft

  test "generate a <p>" do
    input = %{
      "entityMap" => %{},
      "blocks" => [
        %{
          "key" => "9d21d",
          "text" => "Hello",
          "type" => "unstyled",
          "depth" => 0,
          "inlineStyleRanges" => [],
          "entityRanges" => [],
          "data" => %{}
        }
      ]
    }

    output = "<p>Hello</p>"
    assert to_html(input) == output
  end

  test "generate a <h1>" do
    input = %{
      "entityMap" => %{},
      "blocks" => [
        %{
          "key" => "9d21d",
          "text" => "Hello",
          "type" => "header-one",
          "depth" => 0,
          "inlineStyleRanges" => [],
          "entityRanges" => [],
          "data" => %{}
        }
      ]
    }

    output = "<h1>Hello</h1>"
    assert to_html(input) == output
  end

  test "generate a <h2>" do
    input = %{
      "entityMap" => %{},
      "blocks" => [
        %{
          "key" => "9d21d",
          "text" => "Hello",
          "type" => "header-two",
          "depth" => 0,
          "inlineStyleRanges" => [],
          "entityRanges" => [],
          "data" => %{}
        }
      ]
    }

    output = "<h2>Hello</h2>"
    assert to_html(input) == output
  end

  test "generate a <h3>" do
    input = %{
      "entityMap" => %{},
      "blocks" => [
        %{
          "key" => "9d21d",
          "text" => "Hello",
          "type" => "header-three",
          "depth" => 0,
          "inlineStyleRanges" => [],
          "entityRanges" => [],
          "data" => %{}
        }
      ]
    }

    output = "<h3>Hello</h3>"
    assert to_html(input) == output
  end

  test "generate a <h4>" do
    input = %{
      "entityMap" => %{},
      "blocks" => [
        %{
          "key" => "9d21d",
          "text" => "Hello",
          "type" => "header-four",
          "depth" => 0,
          "inlineStyleRanges" => [],
          "entityRanges" => [],
          "data" => %{}
        }
      ]
    }

    output = "<h4>Hello</h4>"
    assert to_html(input) == output
  end

  test "generate a <h5>" do
    input = %{
      "entityMap" => %{},
      "blocks" => [
        %{
          "key" => "9d21d",
          "text" => "Hello",
          "type" => "header-five",
          "depth" => 0,
          "inlineStyleRanges" => [],
          "entityRanges" => [],
          "data" => %{}
        }
      ]
    }

    output = "<h5>Hello</h5>"
    assert to_html(input) == output
  end

  test "generate a <h6>" do
    input = %{
      "entityMap" => %{},
      "blocks" => [
        %{
          "key" => "9d21d",
          "text" => "Hello",
          "type" => "header-six",
          "depth" => 0,
          "inlineStyleRanges" => [],
          "entityRanges" => [],
          "data" => %{}
        }
      ]
    }

    output = "<h6>Hello</h6>"
    assert to_html(input) == output
  end

  test "generate a <blockquote>" do
    input = %{
      "entityMap" => %{},
      "blocks" => [
        %{
          "key" => "9d21d",
          "text" => "Hello",
          "type" => "blockquote",
          "depth" => 0,
          "inlineStyleRanges" => [],
          "entityRanges" => [],
          "data" => %{}
        }
      ]
    }

    output = "<blockquote>Hello</blockquote>"
    assert to_html(input) == output
  end

  test "generate a <br>" do
    input = %{
      "entityMap" => %{},
      "blocks" => [
        %{
          "key" => "9d21d",
          "text" => "",
          "type" => "unstyled",
          "depth" => 0,
          "inlineStyleRanges" => [],
          "entityRanges" => [],
          "data" => %{}
        }
      ]
    }

    output = "<br>"
    assert to_html(input) == output
  end

  test "wraps single inline style" do
    input = %{
      "entityMap" => %{},
      "blocks" => [
        %{
          "text" => "Hello",
          "inlineStyleRanges" => [%{"style" => "BOLD", "offset" => 2, "length" => 2}],
          "type" => "unstyled",
          "depth" => 0,
          "entityRanges" => [],
          "data" => %{},
          "key" => "9d21d"
        }
      ]
    }

    output = "<p>He<span style=\"font-weight: bold;\">ll</span>o</p>"
    assert to_html(input) == output
  end

  test "wraps multiple inline styles" do
    input = %{
      "entityMap" => %{},
      "blocks" => [
        %{
          "text" => "Hello World!",
          "inlineStyleRanges" => [
            %{"style" => "ITALIC", "offset" => 8, "length" => 3},
            %{"style" => "BOLD", "offset" => 2, "length" => 2},
            %{"style" => "UNDERLINE", "offset" => 4, "length" => 4}
          ],
          "type" => "unstyled",
          "depth" => 0,
          "entityRanges" => [],
          "data" => %{},
          "key" => "9d21d"
        }
      ]
    }

    output =
      "<p>He<span style=\"font-weight: bold;\">ll</span><span style=\"text-decoration: underline;\">o Wo</span><span style=\"font-style: italic;\">rld</span>!</p>"

    assert to_html(input) == output
  end

  test "wraps nested inline styles" do
    input = %{
      "entityMap" => %{},
      "blocks" => [
        %{
          "text" => "Hello World!",
          "inlineStyleRanges" => [
            %{"style" => "ITALIC", "offset" => 2, "length" => 5},
            %{"style" => "BOLD", "offset" => 2, "length" => 2}
          ],
          "type" => "unstyled",
          "depth" => 0,
          "entityRanges" => [],
          "data" => %{},
          "key" => "9d21d"
        }
      ]
    }

    output =
      "<p>He<span style=\"font-style: italic; font-weight: bold;\">ll</span><span style=\"font-style: italic;\">o W</span>orld!</p>"

    assert to_html(input) == output
  end

  test "wraps overlapping inline styles" do
    input = %{
      "entityMap" => %{},
      "blocks" => [
        %{
          "text" => "Hello World!",
          "inlineStyleRanges" => [
            %{"style" => "ITALIC", "offset" => 2, "length" => 5},
            %{"style" => "BOLD", "offset" => 4, "length" => 5}
          ],
          "type" => "unstyled",
          "depth" => 0,
          "entityRanges" => [],
          "data" => %{},
          "key" => "9d21d"
        }
      ]
    }

    output =
      "<p>He<span style=\"font-style: italic;\">ll</span><span style=\"font-style: italic; font-weight: bold;\">o W</span><span style=\"font-weight: bold;\">or</span>ld!</p>"

    assert to_html(input) == output
  end

  test "wraps anchor entities" do
    input = %{
      "entityMap" => %{
        "0" => %{
          "type" => "LINK",
          "mutability" => "MUTABLE",
          "data" => %{"url" => "http://google.com"}
        }
      },
      "blocks" => [
        %{
          "text" => "Hello World!",
          "inlineStyleRanges" => [],
          "type" => "unstyled",
          "depth" => 0,
          "entityRanges" => [
            %{"offset" => 2, "length" => 3, "key" => 0}
          ],
          "data" => %{},
          "key" => "9d21d"
        }
      ]
    }

    output = "<p>He<a href=\"http://google.com\">llo</a> World!</p>"
    assert to_html(input) == output
  end

  test "handles offsets correctly with unicode characters" do
    input = %{
      "blocks" => [
        %{
          "data" => %{},
          "depth" => 0,
          "entityRanges" => [%{"key" => 0, "length" => 3, "offset" => 3}],
          "inlineStyleRanges" => [],
          "key" => "df1r3",
          "text" => "1️⃣Foo",
          "type" => "unstyled"
        }
      ],
      "entityMap" => %{
        "0" => %{
          "data" => %{"target" => "_blank", "url" => "https://google.com"},
          "mutability" => "MUTABLE",
          "type" => "LINK"
        }
      }
    }

    output = "<p>1️⃣<a href=\"https://google.com\">Foo</a></p>"
    assert to_html(input) == output
  end

  test "wraps overlapping entities and inline styles" do
    input = %{
      "entityMap" => %{
        "0" => %{
          "type" => "LINK",
          "mutability" => "MUTABLE",
          "data" => %{"url" => "http://google.com"}
        }
      },
      "blocks" => [
        %{
          "text" => "Hello World!",
          "inlineStyleRanges" => [
            %{"style" => "ITALIC", "offset" => 0, "length" => 4},
            %{"style" => "BOLD", "offset" => 4, "length" => 4}
          ],
          "entityRanges" => [
            %{"offset" => 2, "length" => 3, "key" => 0}
          ],
          "type" => "unstyled",
          "depth" => 0,
          "data" => %{},
          "key" => "9d21d"
        }
      ]
    }

    output =
      "<p><span style=\"font-style: italic;\">He</span><a href=\"http://google.com\"><span style=\"font-style: italic;\">ll</span><span style=\"font-weight: bold;\">o</span></a><span style=\"font-weight: bold;\"> Wo</span>rld!</p>"

    assert to_html(input) == output
  end

  test "anchor entities text is wrapped by an inline style span tag" do
    input = %{
      "blocks" => [
        %{
          "depth" => 0,
          "entityRanges" => [
            %{
              "key" => 0,
              "offset" => 0,
              "length" => 6
            }
          ],
          "inlineStyleRanges" => [
            %{
              "style" => "BOLD",
              "offset" => 0,
              "length" => 6
            }
          ],
          "data" => %{},
          "text" => "Google",
          "key" => "c2jk5",
          "type" => "unstyled"
        }
      ],
      "entityMap" => %{
        "0" => %{
          "type" => "LINK",
          "data" => %{
            "url" => "https=>\/\/www.google.com",
            "target" => "_blank"
          },
          "mutability" => "MUTABLE"
        }
      }
    }

    output =
      "<p><a href=\"https=>//www.google.com\"><span style=\"font-weight: bold;\">Google</span></a></p>"

    assert to_html(input) == output
  end

  test "wraps ordered lists in <ol>" do
    input = %{
      "entityMap" => %{},
      "blocks" => [
        %{
          "key" => "9d21d",
          "text" => "one",
          "type" => "ordered-list-item",
          "depth" => 0,
          "inlineStyleRanges" => [],
          "entityRanges" => [],
          "data" => %{}
        }
      ]
    }

    output = "<ol><li style=\"mso-special-format:numbullet;\">one</li></ol>"
    assert to_html(input) == output
  end

  test "wraps unordered lists in <ul>" do
    input = %{
      "entityMap" => %{},
      "blocks" => [
        %{
          "key" => "9d21d",
          "text" => "one",
          "type" => "unordered-list-item",
          "depth" => 0,
          "inlineStyleRanges" => [],
          "entityRanges" => [],
          "data" => %{}
        }
      ]
    }

    output = "<ul><li style=\"mso-special-format:bullet;\">one</li></ul>"
    assert to_html(input) == output
  end

  test "wraps multiple unordered list items in the same <ul>" do
    input = %{
      "entityMap" => %{},
      "blocks" => [
        %{
          "key" => "9d21d",
          "text" => "one",
          "type" => "unordered-list-item",
          "depth" => 0,
          "inlineStyleRanges" => [],
          "entityRanges" => [],
          "data" => %{}
        },
        %{
          "key" => "9d21e",
          "text" => "two",
          "type" => "unordered-list-item",
          "depth" => 0,
          "inlineStyleRanges" => [],
          "entityRanges" => [],
          "data" => %{}
        }
      ]
    }

    output =
      "<ul><li style=\"mso-special-format:bullet;\">one</li><li style=\"mso-special-format:bullet;\">two</li></ul>"

    assert to_html(input) == output
  end

  test "wraps multiple complex lists" do
    input = %{
      "entityMap" => %{},
      "blocks" => [
        %{
          "key" => "9d21c",
          "text" => "one",
          "type" => "unordered-list-item",
          "depth" => 0,
          "inlineStyleRanges" => [],
          "entityRanges" => [],
          "data" => %{}
        },
        %{
          "key" => "9d21e",
          "text" => "whoops",
          "type" => "ordered-list-item",
          "depth" => 0,
          "inlineStyleRanges" => [],
          "entityRanges" => [],
          "data" => %{}
        },
        %{
          "key" => "9d21d",
          "text" => "two",
          "type" => "unordered-list-item",
          "depth" => 0,
          "inlineStyleRanges" => [],
          "entityRanges" => [],
          "data" => %{}
        },
        %{
          "key" => "9d21f",
          "text" => "Hello",
          "type" => "unstyled",
          "depth" => 0,
          "inlineStyleRanges" => [],
          "entityRanges" => [],
          "data" => %{}
        },
        %{
          "key" => "9d21g",
          "text" => "and another",
          "type" => "ordered-list-item",
          "depth" => 0,
          "inlineStyleRanges" => [],
          "entityRanges" => [],
          "data" => %{}
        }
      ]
    }

    output =
      "<ul><li style=\"mso-special-format:bullet;\">one</li></ul><ol><li style=\"mso-special-format:numbullet;\">whoops</li></ol><ul><li style=\"mso-special-format:bullet;\">two</li></ul><p>Hello</p><ol><li style=\"mso-special-format:numbullet;\">and another</li></ol>"

    assert to_html(input) == output
  end
end
