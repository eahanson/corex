defmodule Corex.CLI do
  alias Corex.Color
  alias Corex.Extra
  alias TableRex.Table

  def main(args \\ []) do
    args |> parse_args
  end

  defp parse_args(args) do
    {options, commands, _} = args |> OptionParser.parse
    commands |> Enum.join(" ") |> run_cmd(options)
  end

  defp run_cmd("", _) do
    run_cmd("help", [])
  end

  defp run_cmd("help", _) do
    running "help"

    table [
      ["help", "This message"],
      ["shipit", "Run tests and push"],
    ]
  end

  defp run_cmd("shipit", _) do
    running "shipit"
  end

  defp running(command_title), do: running(command_title, [])

  defp running(command_title, options) do
    [
      "bin/cli" |> Color.colorize(:yellow),
      command_title |> Color.colorize(:yellow, :bright),
      options |> Color.colorize(:yellow),
      ":\n" |> Color.colorize(:yellow)
    ]
    |> List.flatten
    |> Extra.Enum.compact_blank
    |> Enum.join(" ")
    |> IO.puts
  end

  defp table(rows) do
    Table.new(rows)
    |> Table.put_column_meta(0, color: :yellow)
    |> Table.render!(horizontal_style: :off, vertical_style: :off)
    |> IO.puts
  end
end
