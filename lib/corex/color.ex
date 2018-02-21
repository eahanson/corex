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

  def colorize(s, color) do
    IO.ANSI.color(@colors[color]) <> s <> IO.ANSI.reset
  end

  def monochrome(s) do
    s |> String.replace(~r"\e[\[;0-9]+m", "")
  end

  def puts(s, color) do
    s |> colorize(color) |> IO.puts
  end
end
