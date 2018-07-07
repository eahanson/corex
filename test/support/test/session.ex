defmodule Corex.Test.Session do
  use Plug.Test

  import ExUnit.Assertions

  alias Corex.Accounts.User
  alias Corex.Test.Mom

  def login(conn, user) do
    conn
    |> init_test_session([])
    |> CorexWeb.Session.set_current_user(user)
  end

  def login_as(conn, :guest) do
    conn
  end

  def login_as(conn, :member) do
    conn |> login(struct(User, Mom.user_attrs("member", id: 1000)))
  end

  def login_as(conn, :admin) do
    conn |> login(struct(User, Mom.admin_attrs(id: 1000)))
  end
end
