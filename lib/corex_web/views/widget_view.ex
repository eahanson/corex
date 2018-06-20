defmodule CorexWeb.WidgetView do
  use CorexWeb, :view

  import Corex.Format

  alias CorexWeb.DataTableView.DataTable
  alias CorexWeb.DataTableView.Form

  defmodule DataTable do
    defstruct ~w{
      actions
      columns
      data
      table_actions
      title
    }a

    def new(data, title: title) do
      %DataTable{actions: [], columns: [], data: data, table_actions: [], title: title}
    end

    def column(%DataTable{} = data_table, title, contents_fun) when is_function(contents_fun) do
      %DataTable{data_table | columns: data_table.columns ++ [{title, contents_fun}]}
    end

    def column(%DataTable{} = data_table, title, contents_key) when is_atom(contents_key) do
      contents_fun = &(&1 |> Map.get(contents_key))
      %DataTable{data_table | columns: data_table.columns ++ [{title, contents_fun}]}
    end

    def column(%DataTable{} = data_table, title, contents) do
      column(data_table, title, fn _ -> contents end)
    end

    def action(%DataTable{} = data_table, title, path_fun, :delete, confirm_fun) do
      action = %{title: title, path_fun: path_fun, method: :delete, confirm_fun: confirm_fun, class: "data-table__button--delete"}
      %DataTable{data_table | actions: data_table.actions ++ [action]}
    end

    def action(%DataTable{} = data_table, title, path_fun) do
      nil_fun = fn _ -> nil end
      action = %{title: title, path_fun: path_fun, method: :get, confirm_fun: nil_fun, class: "data-table__button"}
      %DataTable{data_table | actions: data_table.actions ++ [action]}
    end

    def table_action(%DataTable{} = data_table, title, path) do
      %DataTable{data_table | table_actions: data_table.table_actions ++ [{title, path}]}
    end
  end

  defmodule DetailTable do
    defstruct ~w{
      role
      rows
      table_actions
      tid
      title
    }a

    def new(title: title, role: role, tid: tid) do
      %DetailTable{title: title, rows: [], table_actions: [], role: role, tid: tid}
    end

    def row(%DetailTable{} = detail_table, name, value) do
      %DetailTable{detail_table | rows: detail_table.rows ++ [%{name: name, value: value}]}
    end

    def table_action(%DetailTable{} = detail_table, title, path) do
      action = %{title: title, path: path, method: :get, confirm: nil, class: "detail-table__title-button"}
      %DetailTable{detail_table | table_actions: detail_table.table_actions ++ [action]}
    end

    def table_action(%DetailTable{} = detail_table, title, path, :delete, confirm) do
      action = %{title: title, path: path, method: :delete, confirm: confirm, class: "detail-table__title-button--delete"}
      %DetailTable{detail_table | table_actions: detail_table.table_actions ++ [action]}
    end
  end

  defmodule Form do
    defstruct ~w{
      action
      changeset
      fields
      title
    }a

    def new(changeset, action: action, title: title) do
      %Form{action: action, changeset: changeset, fields: [], title: title}
    end

    def text_input(%Form{} = form, name, icon \\ nil) do
      icon =
        case {name, icon} do
          {:email, nil} -> "at"
          {_, icon} -> icon
        end

      form
      |> field(%{name: name, icon: icon, input_fun: &Phoenix.HTML.Form.text_input/3, autocomplete: nil})
    end

    def password_input(%Form{} = form, name) do
      form
      |> field(%{name: name, icon: "key", input_fun: &Phoenix.HTML.Form.password_input/3, autocomplete: "new-password"})
    end

    defp field(%Form{} = form, field) do
      %Form{form | fields: form.fields ++ [field]}
    end
  end

  def widget(%DataTable{} = data_table, conn) do
    render(
      CorexWeb.WidgetView,
      "data_table.html",
      conn: conn,
      data_table: data_table
    )
  end

  def widget(%DetailTable{} = detail_table, conn) do
    render(
      CorexWeb.WidgetView,
      "detail_table.html",
      conn: conn,
      detail_table: detail_table
    )
  end

  def widget(%Form{} = form, conn) do
    render(
      CorexWeb.WidgetView,
      "form.html",
      conn: conn,
      form: form
    )
  end
end
