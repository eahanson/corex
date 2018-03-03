defmodule Corex.CLI do
  alias Corex.Color
  alias Corex.Extra
  alias TableRex.Table

  def main(args \\ []) do
    args |> parse_args
  end

  defp parse_args(args) do
    {options, commands, _} = args |> OptionParser.parse
    commands |> Enum.join(" ") |> command(options)
  end

  defp command("", _) do
    command("help", nil)
  end

  defp command("help", _) do
    table [
      ["help", "This message"],
      ["shipit", "Run tests and push"],
      ["test", "Run tests"],
    ]
  end

  defp command("shipit", _) do
    command("test", nil) && command("git-push", nil)
  end

  defp command("test", _) do
    exec("Running tests", "mix", ["test", "--color"])
  end

  defp command("git-push", _) do
    exec("Pushing git", "git", ["push"])
  end

  defp exec(description, command, args) do
    [
      {"\n▶ #{description} ", :yellow},
      {[command, args] |> List.flatten |> Enum.join(" ") |> Extra.String.surround("(", ")"), :cyan}
    ]
    |> Color.puts

    {_result, status} = System.cmd(command, args, into: IO.stream(:stdio, :line))
    status == 0
  end

  defp table(rows) do
    Table.new(rows)
    |> Table.put_column_meta(0, color: :yellow)
    |> Table.render!(horizontal_style: :off, vertical_style: :off)
    |> IO.puts
  end
end
