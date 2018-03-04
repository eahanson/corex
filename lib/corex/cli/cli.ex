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
      ["doctor", "Check that everything is working"],
      ["update", "Pull, migrate, and run doctor"],
      ["shipit", "Update, run tests and push"],
      ["test", "Run tests"],
    ]
  end

  defp command("doctor", _) do
    Corex.CLI.Doctor.run
  end

  defp command("git", ["pull"]) do
    exec("Pulling git", "git", ["pull", "--rebase"])
  end

  defp command("git", ["push"]) do
    exec("Pushing git", "git", ["push"])
  end

  defp command("migrate", _) do
    exec("Migrating", "mix", ["ecto.migrate", "ecto.dump"])
  end

  defp command("shipit", _) do
    command("update", nil) and
    command("test", nil) and
    command("git", ["push"])
  end

  defp command("test", _) do
    exec("Running tests", "mix", ["test", "--color"])
  end

  defp command("update", _) do
    command("git", ["pull"]) and
    command("migrate", nil) and
    command("doctor", nil)
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
