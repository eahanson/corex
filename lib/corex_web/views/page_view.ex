defmodule CorexWeb.PageView do
  use CorexWeb, :view

  def current_user?(conn) do
    !! Plug.Conn.get_session(conn, :current_user_id)
  end
end
