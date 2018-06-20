defmodule CorexWeb.ViewHelpers do
  alias CorexWeb.Session

  def current_user?(conn) do
    !!Session.get_current_user_id(conn)
  end

  def current_user_tid(conn) do
    Session.get_current_user_tid(conn)
  end
end
