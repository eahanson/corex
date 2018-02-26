defmodule Corex.Color do
  @colors %{
    black: 0,
    blue: 4,
    cyan: 6,
    green: 2,
    magenta: 5,
    red: 1,
    white: 7,
    yellow: 3,
  }

  def cinspect(value, color) do
    value |> inspect |> colorize(color)
  end

  def colorize(l, color) when is_list(l) do
    l |> Enum.map(&(colorize(&1, color)))
  end

  def colorize(s, color, bold \\ false) do
    [
      IO.ANSI.color(@colors[color]),
      (if bold, do: IO.ANSI.bright, else: nil),
      s,
      IO.ANSI.reset
    ] |> Enum.join()
  end

  def monochrome(s) do
    s |> String.replace(~r"\e[\[;0-9]+m", "")
  end

  def puts(s, color) do
    s |> colorize(color) |> IO.puts
    s
  end
end
