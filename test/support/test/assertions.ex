defmodule Corex.Test.Assertions do
  import ExUnit.Assertions

  def assert_eq(nil, nil), do: true

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
    left
  end

  def assert_eq(string, %Regex{} = regex) when is_binary(string) do
    unless string =~ regex do
      ExUnit.Assertions.flunk """
        Expected string to match regex
        left (string): #{string}
        right (regex): #{regex |> inspect}
      """
    end
    string
  end

  def assert_eq(arg1, arg2) do
    assert arg1 == arg2
    arg1
  end
end
