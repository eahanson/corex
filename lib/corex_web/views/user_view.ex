defmodule CorexWeb.UserView do
  use CorexWeb, :view

  alias CorexWeb.DataTableView
  alias CorexWeb.DataTableView.DataTable

  def users_table(users, conn) do
    DataTable.new(users, title: "Users")
    |> DataTable.table_action("New User", user_path(conn, :new))
    |> DataTable.column("Email", :email)
    |> DataTable.action("Show", &(user_path(conn, :show, &1)))
    |> DataTable.action("Edit", &(user_path(conn, :edit, &1)))
    |> DataTable.action("Delete", &(user_path(conn, :delete, &1)), :delete, &("Really delete user #{&1.email} ?"))
    |> DataTableView.render_data_table(conn)
  end
end
