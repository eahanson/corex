defmodule CorexWeb.Session do
  alias Plug.Conn

  alias Corex.Accounts.User

  def get_current_user_id(conn) do
    conn |> Conn.get_session(:current_user_id)
  end

  def get_current_user_tid(conn) do
    conn |> Conn.get_session(:current_user_tid)
  end

  def set_current_user(conn, %User{id: id, tid: tid}) do
    conn
    |> Conn.put_session(:current_user_id, id)
    |> Conn.put_session(:current_user_tid, tid)
  end
end
