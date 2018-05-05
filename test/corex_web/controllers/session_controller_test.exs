defmodule CorexWeb.SessionControllerTest do
  use CorexWeb.ConnCase

  alias Corex.Accounts
  alias Corex.Test.Mom

  describe "new session" do
    test "renders form", %{conn: conn} do
      conn = get conn, session_path(conn, :new)
      assert html_response(conn, 200) =~ "Log In"
    end
  end

  describe "create session" do
    test "logs user in when credentials are valid", %{conn: conn} do
      {:ok, user} = Mom.user_attrs("test") |> Accounts.create_user
      conn = post conn, session_path(conn, :create), user: %{email: "test@example.com", password: "password123"}

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == user_path(conn, :show, id)

      conn = get conn, user_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show User"

      assert Plug.Conn.get_session(conn, :current_user_id) == user.id
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: Mom.user_attrs |> Map.put(:email, "bad")
      assert html_response(conn, 200) =~ "New User"
    end
  end
end
