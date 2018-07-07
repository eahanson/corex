defmodule CorexWeb.Session do
  alias Plug.Conn

  alias Corex.Accounts.User

  def get_current_user_id(conn), do: conn |> Conn.get_session(:current_user_id)
  def get_current_user_role(conn), do: conn |> Conn.get_session(:current_user_role)
  def get_current_user_tid(conn), do: conn |> Conn.get_session(:current_user_tid)

  def set_current_user(conn, nil), do: set_current_user(conn, id: nil, tid: nil, role: nil)
  def set_current_user(conn, %User{id: id, tid: tid} = user), do: set_current_user(conn, id: id, tid: tid, role: User.role(user))

  def set_current_user(conn, id: id, tid: tid, role: role) do
    conn
    |> Conn.put_session(:current_user_id, id)
    |> Conn.put_session(:current_user_role, role)
    |> Conn.put_session(:current_user_tid, tid)
  end
end
