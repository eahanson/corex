defmodule Corex.CLI do
  alias Corex.CLI

  def main(args \\ []) do
    args |> parse_args
  end

  defp parse_args(args) do
    {options, commands, _} = args |> OptionParser.parse
    commands |> Enum.join(" ") |> CLI.Commands.command(options)
  end

  def exec(description, fun) when is_function(fun) do
    CLI.IO.running(description)
    fun.()
  end

  def exec(description, command, args) do
    CLI.IO.running(description, [command, args] |> List.flatten |> Enum.join(" "))
    {_result, status} = System.cmd(command, args, into: IO.stream(:stdio, :line))
    status == 0
  end
end
