defmodule Corex.Test.Session do
  use Plug.Test

  alias Corex.Accounts
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
    {:ok, member} = Mom.user_attrs("member") |> Accounts.create_user()
    conn |> login(member)
  end

  def login_as(conn, :admin) do
    {:ok, admin} = Mom.admin_attrs() |> Accounts.create_admin()
    conn |> login(admin)
  end
end
