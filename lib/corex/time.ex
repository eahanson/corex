defmodule Corex.Time do
  def parse(string) do
    formats = [
      "%a, %d %b %Y %H:%M:%S %Z",
      "%a, %d %b %Y %H:%M:%S %z",
    ]

    Enum.find_value formats, fn(format) ->
      { ret, time } = Timex.parse(string, format, :strftime)
      case ret do
        :ok -> time
        _ -> nil
      end
    end
  end

  def with_timer(function) do
    {usec, result} = :timer.tc(function)
    seconds = usec |> Kernel./(1_000_000) |> Float.ceil |> round
    {result, "#{seconds}s"}
  end

  def benchmark(label, function) do
    {usec, result} = :timer.tc(function)
    msec = usec |> Kernel./(1_000)
    IO.puts "#{label}: #{msec}ms"
    result
  end

  def format(time, :date) do
    Timex.format!(time, "%Y %b %d", :strftime)
  end

  def ago(older, newer) do
    ago(older, newer, [{:years, "yr"}, {:months, "mo"}, {:days, "d"}, {:hours, "h"}, {:minutes, "m"}, {:seconds, "s"}])
  end

  defp ago(older, newer, [{unit, suffix} | tail] = _units) do
    diff = Timex.Comparable.diff(newer, older, unit)

    if diff >= 2 or length(tail) == 0 do
      "#{diff}#{suffix}"
    else
      ago(older, newer, tail)
    end
  end
end
