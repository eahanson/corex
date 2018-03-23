defmodule Corex.TimeTest do
  use ExUnit.Case, async: true

  import Corex.Test.Assertions

  alias Corex.Time

  describe "parse" do
    test "with time zone name" do
      assert_eq Time.parse("Fri, 21 Jul 2017 16:54:24 EDT"), "2017-07-21T16:54:24-04:00"
    end

    test "with numeric UTC time zone" do
      assert_eq Time.parse("Tue, 01 Aug 2017 01:31:38 +0000"), "2017-08-01T01:31:38Z"
    end
  end
end