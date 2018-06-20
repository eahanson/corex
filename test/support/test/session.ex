defmodule Corex.Test.Session do
  use Plug.Test

  import ExUnit.Assertions

  def login(conn, user) do
    conn = init_test_session(conn, current_user_id: user.id, current_user_tid: user.tid)
    assert conn |> CorexWeb.Session.get_current_user_id() == user.id
    assert conn |> CorexWeb.Session.get_current_user_tid() == user.tid
    conn
  end
end
