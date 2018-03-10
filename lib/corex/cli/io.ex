defmodule Corex.CLI.IO do
  alias Corex.Color
  alias TableRex.Table

  def table(rows) do
    Table.new(rows)
    |> Table.put_column_meta(0, color: :yellow)
    |> Table.render!(horizontal_style: :off, vertical_style: :off)
    |> IO.puts
  end

  def running(description, details \\ nil) do
    "\n▶ #{description} " |> Color.write(:yellow)
    if details, do: "(#{details})" |> Color.write(:cyan)
    IO.puts ""
  end
end
