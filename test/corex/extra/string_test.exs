defmodule Corex.Extra.StringTest do
  use Corex.SimpleCase, async: true

  alias Corex.Extra

  describe "inner_truncate" do
    test "truncates from the middle of the string" do
      assert Extra.String.inner_truncate("http://short.jpg", 20) == "http://short.jpg"
      assert Extra.String.inner_truncate("http://www.example.com/apple/banana/cherry/donut/eclair.jpg", 20) == "http://www…eclair.jpg"
    end
  end

  describe "surround" do
    test "surrounds with some characters" do
      assert Extra.String.surround("abc", "12") == "12abc12"
    end

    test "surrounds with prefix and suffix characters" do
      assert Extra.String.surround("abc", "12", "34") == "12abc34"
    end
  end
end
