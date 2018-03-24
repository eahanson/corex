defmodule Corex.FormatTest do
  use ExUnit.Case, async: true

  import Corex.Format

  alias Corex.Time

  test "format date" do
    assert format(:date, nil) == ""
    assert format(:date, Time.parse("Fri, 21 Jul 2017 16:54:24 EDT")) == "2017 Jul 21"
  end

  test "format relative datetime" do
    now = Time.parse("Fri, 21 Jul 2017 10:11:12 EDT")
    assert format(:relative_datetime, nil, now) == ""
    assert format(:relative_datetime, now |> Timex.shift(hours: -47), now) == "47h"
  end

  test "format integer" do
    assert format(:integer, nil) == ""
    assert format(:integer, 39) == "39"
  end

  test "format string" do
    assert format(:string, nil) == ""
    assert format(:string, "hello there") == "hello there"
  end

  test "format url" do
    assert format(:url, nil) == ""
    assert format(:url, "http://short.jpg") == "http://short.jpg"
    assert format(:url, "http://www.example.com/apple/banana/cherry/donut/eclair.jpg") == "http://www…eclair.jpg"
  end

  test "format presence" do
    assert format(:presence, nil) == ""
    assert format(:presence, 1) == "•"
    assert format(:presence, "foo") == "•"
  end
end