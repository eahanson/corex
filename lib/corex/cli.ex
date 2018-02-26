defmodule Corex.CLI do
  alias Corex.Color
  alias Corex.Extra
  alias TableRex.Table

  def main(args \\ []) do
    args |> parse_args
  end

  defp parse_args(args) do
    {options, commands, _} = args |> OptionParser.parse
    commands |> Enum.join(" ") |> run(options)
  end

  def run(command) do
    run(command, nil)
  end

  def run(command, args) do
    running command
    run_cmd(command, args)
  end

  defp run_cmd("", _) do
    run "help"
  end

  defp run_cmd("help", _) do
    table [
      ["help", "This message"],
      ["shipit", "Run tests and push"],
      ["test", "Run tests"],
    ]
  end

  defp run_cmd("shipit", _) do
    run("test")
    run("git-push")
  end

  defp run_cmd("test", _) do
    exec("mix", ["test", "--color"])
  end

  defp run_cmd("git-push", _) do
    exec("git", ["push"])
  end

  defp exec(command, args \\ []) do
    [command, args] |> List.flatten |> Enum.join(" ") |> Color.puts(:cyan)
    System.cmd(command, args, into: IO.stream(:stdio, :line))
  end

  defp with_timer(function) do
    {usec, result} = :timer.tc(function)
    seconds = usec |> Kernel./(1_000_000) |> Float.ceil |> round
    {result, "#{seconds}s"}
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
