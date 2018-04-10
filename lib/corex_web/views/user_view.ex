defmodule CorexWeb.UserView do
  use CorexWeb, :view

  alias CorexWeb.WidgetView
  alias CorexWeb.WidgetView.DataTable
  alias CorexWeb.WidgetView.Form

  def users_table(users, conn) do
    DataTable.new(users, title: "Users")
    |> DataTable.table_action("New User", user_path(conn, :new))
    |> DataTable.column("Email", :email)
    |> DataTable.action("Show", &(user_path(conn, :show, &1)))
    |> DataTable.action("Edit", &(user_path(conn, :edit, &1)))
    |> DataTable.action("Delete", &(user_path(conn, :delete, &1)), :delete, &("Really delete user #{&1.email} ?"))
    |> WidgetView.widget(conn)
  end

  def user_form(user, conn, action: action, title: title) do
    Form.new(user, action: action, title: title)
    |> Form.text_input(:email)
    |> Form.password_input(:password)
    |> WidgetView.widget(conn)
  end
end
