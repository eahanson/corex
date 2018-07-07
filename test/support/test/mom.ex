defmodule Corex.Test.Mom do
  alias Corex.Accounts
  alias Corex.Test

  def admin_attrs(opts \\ []) do
    user_attrs("admin", opts |> Enum.into(%{admin: true}))
  end

  def user_attrs(tid, opts \\ []) do
    opts |> Enum.into(%{tid: tid, email: "#{tid}@example.com", password: "password123"})
  end

  def login_admin(conn) do
    {:ok, admin} = admin_attrs() |> Accounts.create_admin()
    conn = conn |> Test.Session.login(admin)
    {:ok, conn, admin}
  end
end
