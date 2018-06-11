defmodule CorexWeb.SessionControllerTest do
  use CorexWeb.ConnCase
  use Plug.Test

  alias Corex.Accounts
  alias Corex.Test.Mom
  alias CorexWeb.Endpoint

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
      assert html_response(conn, 200) =~ ~r|User \d+|

      assert Plug.Conn.get_session(conn, :current_user_id) == user.id
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: Mom.user_attrs |> Map.put(:email, "bad")
      assert html_response(conn, 200) =~ "Create User"
    end
  end

  describe "delete session" do
    test "logs user out", %{conn: conn} do
      {:ok, user} = Mom.user_attrs("test") |> Accounts.create_user

      conn = init_test_session(conn, current_user_id: user.id)
      assert Plug.Conn.get_session(conn, :current_user_id) == user.id

      conn = delete conn, session_path(Endpoint, :delete)
      assert redirected_to(conn) == landing_path(Endpoint, :index)
      assert Plug.Conn.get_session(conn, :current_user_id) == nil
    end
  end
end
