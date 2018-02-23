defmodule Corex.Extra.EnumTest do
  use Corex.SimpleCase, async: true

  import Corex.Extra.Enum, only: [compact: 1, compact_blank: 1]

  describe "compact" do
    test "removes nils" do
      assert compact([1, nil, 2]) == [1, 2]
    end
  end

  describe "compact_blank" do
    test "removes nils and blanks" do
      assert compact_blank([1, nil, 2, "", 3, [], 4, %{}, 5]) == [1, 2, 3, 4, 5]
    end
  end
end
