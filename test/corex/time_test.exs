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

  describe "ago" do
    test "shows a short string representing the time difference" do
      now = Time.parse("Fri, 21 Jul 2017 10:11:12 EDT")
      assert Time.ago(now |> Timex.shift(seconds: -1), now) == "1s"
      assert Time.ago(now |> Timex.shift(seconds: -10), now) == "10s"
      assert Time.ago(now |> Timex.shift(seconds: -119), now) == "119s"
      assert Time.ago(now |> Timex.shift(minutes: -1), now) == "60s"
      assert Time.ago(now |> Timex.shift(minutes: -2), now) == "2m"
      assert Time.ago(now |> Timex.shift(minutes: -119), now) == "119m"
      assert Time.ago(now |> Timex.shift(minutes: -120), now) == "2h"
      assert Time.ago(now |> Timex.shift(hours: -2), now) == "2h"
      assert Time.ago(now |> Timex.shift(hours: -47), now) == "47h"
      assert Time.ago(now |> Timex.shift(hours: -48), now) == "2d"
      assert Time.ago(now |> Timex.shift(days: -2), now) == "2d"
      assert Time.ago(now |> Timex.shift(days: -45), now) == "45d"
      assert Time.ago(now |> Timex.shift(days: -59), now) == "59d"
      assert Time.ago(now |> Timex.shift(days: -61), now) == "2mo"
      assert Time.ago(now |> Timex.shift(months: -2), now) == "2mo"
      assert Time.ago(now |> Timex.shift(months: -23), now) == "23mo"
      assert Time.ago(now |> Timex.shift(months: -24), now) == "2yr"
      assert Time.ago(now |> Timex.shift(years: -2), now) == "2yr"
      assert Time.ago(now |> Timex.shift(years: -99), now) == "99yr"
    end
  end
end