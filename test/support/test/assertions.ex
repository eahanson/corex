defmodule Corex.Test.Assertions do
  @doc "compares a DateTime and an ISO date string like 2016-02-29T22:25:00-06:00"
  def assert_eq(%DateTime{} = left, date_time_string) do
    right = Timex.parse!(date_time_string, "{ISO:Extended}")
    unless DateTime.compare(left, right) == :eq do
      ExUnit.Assertions.flunk """
        Expected date/times to match
        left:  #{Timex.format!(left, "{ISO:Extended}")} (#{DateTime.to_unix(left)})
        right: #{Timex.format!(right, "{ISO:Extended}")} (#{DateTime.to_unix(right)})
      """
    end
  end
end
