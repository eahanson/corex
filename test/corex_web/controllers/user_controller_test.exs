defmodule CorexWeb.UserControllerTest do
  use CorexWeb.ConnCase

  import Corex.Test.Auth, only: [assert_auth: 3]

  alias Corex.Accounts
  alias Corex.Test

  describe "index" do
    defp get_index(conn) do
      get(conn, user_path(conn, :index))
    end

    test "lists all users", %{conn: conn} do
      {:ok, conn, _admin} = Test.Mom.login_admin(conn)

      conn = get_index(conn)
      assert html_response(conn, 200) =~ "Users"
    end

    test "requires admin", %{conn: conn} do
      conn |> assert_auth(:admin, fn conn -> get_index(conn) end)
    end
  end

  describe "new user" do
    defp get_new(conn) do
      get(conn, user_path(conn, :new))
    end

    test "renders form", %{conn: conn} do
      {:ok, conn, _admin} = Test.Mom.login_admin(conn)

      conn = get_new(conn)
      assert html_response(conn, 200) =~ "Create User"
    end

    test "requires admin", %{conn: conn} do
      conn |> assert_auth(:admin, fn conn -> get_new(conn) end)
    end
  end

  describe "create user" do
    defp post_create(conn, opts \\ []) do
      post(conn, user_path(conn, :create), user: Mom.user_attrs("user", opts))
    end

    test "redirects to show when data is valid", %{conn: conn} do
      {:ok, conn, _admin} = Test.Mom.login_admin(conn)

      conn = post_create(conn)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == user_path(conn, :show, id)

      conn = get(conn, user_path(conn, :show, id))
      assert html_response(conn, 200) =~ ~r|User \d+|
    end

    test "renders errors when data is invalid", %{conn: conn} do
      {:ok, conn, _admin} = Test.Mom.login_admin(conn)

      conn = post_create(conn, email: "bad")
      assert html_response(conn, 200) =~ "Create User"
    end

    test "requires admin", %{conn: conn} do
      conn |> assert_auth(:admin, fn conn -> post_create(conn) end)
    end
  end

  describe "edit user" do
    setup [:create_user]

    defp get_edit(conn, user) do
      get(conn, user_path(conn, :edit, user))
    end

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      {:ok, conn, _admin} = Test.Mom.login_admin(conn)

      conn = get_edit(conn, user)
      assert html_response(conn, 200) =~ "Edit User"
    end

    test "requires admin", %{conn: conn, user: user} do
      conn |> assert_auth(:admin, fn conn -> get_edit(conn, user) end)
    end
  end

  describe "update user" do
    setup [:create_user]

    defp put_update(conn, user, opts \\ []) do
      put(conn, user_path(conn, :update, user), user: Mom.user_attrs("user", opts))
    end

    test "redirects when data is valid", %{conn: conn, user: user} do
      {:ok, conn, _admin} = Test.Mom.login_admin(conn)

      conn = put_update(conn, user, email: "new@example.com")
      assert redirected_to(conn) == user_path(conn, :show, user)

      conn = get(conn, user_path(conn, :show, user))
      assert html_response(conn, 200) =~ "new@example.com"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      {:ok, conn, _admin} = Test.Mom.login_admin(conn)

      conn = put_update(conn, user, email: "bad")
      assert html_response(conn, 200) =~ "Edit User"
    end

    test "requires admin", %{conn: conn, user: user} do
      conn |> assert_auth(:admin, fn conn -> put_update(conn, user) end)
    end
  end

  describe "delete user" do
    setup [:create_user]

    defp delete_delete(conn, user) do
      delete(conn, user_path(conn, :delete, user))
    end

    test "deletes chosen user", %{conn: conn, user: user} do
      {:ok, conn, _admin} = Test.Mom.login_admin(conn)

      conn = delete_delete(conn, user)
      assert redirected_to(conn) == user_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, user_path(conn, :show, user))
      end)
    end

    test "requires admin", %{conn: conn, user: user} do
      conn |> assert_auth(:admin, fn conn -> delete_delete(conn, user) end)
    end
  end

  defp create_user(_) do
    {:ok, user} = Mom.user_attrs("user") |> Accounts.create_user()
    [user: user]
  end
end
