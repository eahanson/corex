defmodule Corex.Test.Dump do
  alias Corex.Accounts
  alias TableRex.Table

  def users() do
    Accounts.list_users() |> dump([:email, :tid], "All users")
  end

  def dump(enumerable, keys, title) do
    enumerable |> extract_headers_and_rows(keys) |> puts_table(title)
  end

  def extract_headers_and_rows(enumerable, keys) do
    [keys | enumerable |> Enum.map(fn map -> keys |> Enum.map(&Map.get(map, &1)) end)]
  end

  def puts_table([header | rows], title) do
    Table.new(rows, header)
    |> Table.put_title(title)
    |> Table.render!()
    |> IO.puts()
  end
end
