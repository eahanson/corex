defmodule Corex.PresenceTest do
  use Corex.SimpleCase, async: true

  import Corex.Presence, only: [is_blank?: 1]

  describe "is_blank?" do
    test "nil" do
      assert is_blank?(nil) == true
    end

    test "strings" do
      assert is_blank?("") == true
      assert is_blank?("hi") == false
    end

    test "lists" do
      assert is_blank?([]) == true
      assert is_blank?([1]) == false
    end

    test "maps" do
      assert is_blank?(%{}) == true
      assert is_blank?(%{a: 1}) == false
    end
  end
end