defmodule CorexWeb.UserControllerTest do
  use CorexWeb.ConnCase

  import Corex.Test.Auth, only: [assert_auth: 3]

  alias Corex.Accounts
  alias Corex.Test

  describe "index" do
    test "lists all users", %{conn: conn} do
      {:ok, admin} = Test.Mom.admin_attrs() |> Accounts.create_admin()
      conn = conn |> Test.Session.login(admin)
      conn = get(conn, user_path(conn, :index))
      assert html_response(conn, 200) =~ "Users"
    end

    test "requires admin", %{conn: conn} do
      conn |> assert_auth(:admin, fn conn -> get(conn, user_path(conn, :index)) end)
    end
  end

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, user_path(conn, :new))
      assert html_response(conn, 200) =~ "Create User"
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, user_path(conn, :create), user: Mom.user_attrs("user"))

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == user_path(conn, :show, id)

      conn = get(conn, user_path(conn, :show, id))
      assert html_response(conn, 200) =~ ~r|User \d+|
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, user_path(conn, :create), user: Mom.user_attrs("user") |> Map.put(:email, "bad"))
      assert html_response(conn, 200) =~ "Create User"
    end
  end

  describe "edit user" do
    setup [:create_user]

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get(conn, user_path(conn, :edit, user))
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update user" do
    setup [:create_user]

    test "redirects when data is valid", %{conn: conn, user: user} do
      conn = put(conn, user_path(conn, :update, user), user: Mom.user_attrs("user") |> Map.put(:email, "new@example.com"))
      assert redirected_to(conn) == user_path(conn, :show, user)

      conn = get(conn, user_path(conn, :show, user))
      assert html_response(conn, 200) =~ "new@example.com"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, user_path(conn, :update, user), user: Mom.user_attrs("user") |> Map.put(:email, "bad"))
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, user_path(conn, :delete, user))
      assert redirected_to(conn) == user_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, user_path(conn, :show, user))
      end)
    end
  end

  defp create_user(_) do
    {:ok, user} = Mom.user_attrs("user") |> Accounts.create_user()
    {:ok, user: user}
  end
end
