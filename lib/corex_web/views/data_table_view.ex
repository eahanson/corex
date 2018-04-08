defmodule CorexWeb.DataTableView do
  use CorexWeb, :view

  alias CorexWeb.DataTableView.DataTable

  defmodule DataTable do
    defstruct ~w{
      actions
      columns
      data
      table_actions
      title
    }a

    def new(data, title: title) do
      %DataTable{ actions: [], columns: [], data: data, table_actions: [], title: title }
    end

    def column(%DataTable{} = data_table, title, contents_fun) when is_function(contents_fun) do
      %DataTable{ data_table | columns: data_table.columns ++ [{title, contents_fun}]}
    end

    def column(%DataTable{} = data_table, title, contents_key) when is_atom(contents_key) do
      contents_fun = &(&1 |> Map.get(contents_key))
      %DataTable{ data_table | columns: data_table.columns ++ [{title, contents_fun}]}
    end

    def column(%DataTable{} = data_table, title, contents) do
      column(data_table, title, fn _ -> contents end)
    end

    def action(%DataTable{} = data_table, title, path_fun, :delete, confirm_fun) do
      action = %{title: title, path_fun: path_fun, method: :delete, confirm_fun: confirm_fun, class: "data-table__button--delete"}
      %DataTable{ data_table | actions: data_table.actions ++ [action]}
    end

    def action(%DataTable{} = data_table, title, path_fun) do
      nil_fun = fn _ -> nil end
      action = %{title: title, path_fun: path_fun, method: :get, confirm_fun: nil_fun, class: "data-table__button"}
      %DataTable{ data_table | actions: data_table.actions ++ [action]}
    end

    def table_action(%DataTable{} = data_table, title, path) do
      %DataTable{ data_table | table_actions: data_table.table_actions ++ [{title, path}]}
    end
  end

  def render_data_table(%DataTable{} = data_table, conn) do
    render(
      CorexWeb.DataTableView,
      "data_table.html",
      conn: conn,
      data_table: data_table
    )
  end
end
