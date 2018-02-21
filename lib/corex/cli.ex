defmodule Corex.CLI do
  alias Corex.Color
  alias TableRex.Table

  def main(args \\ []) do
    args |> parse_args
  end

  defp parse_args(args) do
    args |> OptionParser.parse |> run_cmd
  end

  defp run_cmd({_, ["help"], _}) do
    "\nbin/cli usage:\n" |> Color.puts(:yellow)

    table [
      ["help", "This message"]
    ]
  end

  defp run_cmd({_, [], _}) do
    run_cmd({[], ["help"], []})
  end

  defp table(rows) do
    Table.new(rows)
    |> Table.put_column_meta(0, color: :yellow)
    |> Table.render!(horizontal_style: :off, vertical_style: :off)
    |> IO.puts
  end
end
