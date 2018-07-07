defmodule CorexWeb.SessionControllerTest do
  use CorexWeb.ConnCase
  use Plug.Test

  alias Corex.Accounts
  alias Corex.Test
  alias CorexWeb.Endpoint
  alias CorexWeb.Session

  describe "new session" do
    test "renders form", %{conn: conn} do
      conn = get(conn, session_path(conn, :new))
      assert html_response(conn, 200) =~ "Log In"
    end
  end

  describe "create session" do
    test "logs user in when credentials are valid", %{conn: conn} do
      {:ok, user} = Test.Mom.user_attrs("test") |> Accounts.create_user()
      conn = post(conn, session_path(conn, :create), user: %{email: "test@example.com", password: "password123"})

      assert redirected_to(conn) == profile_path(conn, :show)

      conn = get(conn, user_path(conn, :show, user.id))
      assert html_response(conn, 200) =~ ~r|User \d+|

      assert conn |> Session.get_current_user_id() == user.id
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, user_path(conn, :create), user: Test.Mom.user_attrs("user") |> Map.put(:email, "bad"))
      assert html_response(conn, 200) =~ "Create User"
    end
  end

  describe "delete session" do
    test "logs user out", %{conn: conn} do
      {:ok, user} = Test.Mom.user_attrs("test") |> Accounts.create_user()
      conn = conn |> Test.Session.login(user)

      conn = delete(conn, session_path(Endpoint, :delete))
      assert redirected_to(conn) == landing_path(Endpoint, :index)
      assert conn |> Session.get_current_user_id() == nil
    end
  end
end
