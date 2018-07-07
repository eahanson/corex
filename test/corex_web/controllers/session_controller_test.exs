defmodule CorexWeb.SessionControllerTest do
  use CorexWeb.ConnCase
  use Plug.Test

  import Corex.Test.Auth, only: [assert_auth: 3]

  alias Corex.Accounts
  alias Corex.Test
  alias CorexWeb.Endpoint
  alias CorexWeb.Session

  describe "new session" do
    defp get_new(conn) do
      get(conn, session_path(conn, :new))
    end

    test "renders form", %{conn: conn} do
      conn = get_new(conn)
      assert html_response(conn, 200) =~ "Log In"
    end

    test "allows guest+", %{conn: conn} do
      conn |> assert_auth(:guest, &get_new/1)
    end
  end

  describe "create session" do
    defp post_create(conn, opts \\ []) do
      post(conn, session_path(conn, :create), user: Test.Mom.user_attrs("test", opts))
    end

    test "logs user in when credentials are valid", %{conn: conn} do
      {:ok, user} = Test.Mom.user_attrs("test") |> Accounts.create_user()
      conn = post_create(conn)

      assert redirected_to(conn) == profile_path(conn, :show)

      conn = get(conn, user_path(conn, :show, user.id))
      assert html_response(conn, 200) =~ ~r|User \d+|

      assert conn |> Session.get_current_user_id() == user.id
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post_create(conn, email: "bad")
      assert html_response(conn, 200) =~ "Log In"
    end

    test "allows guest+", %{conn: conn} do
      conn |> assert_auth(:guest, fn conn -> post_create(conn) end)
    end
  end

  describe "delete session" do
    defp delete_delete(conn) do
      delete(conn, session_path(Endpoint, :delete))
    end

    test "logs user out", %{conn: conn} do
      {:ok, user} = Test.Mom.user_attrs("test") |> Accounts.create_user()
      conn = conn |> Test.Session.login(user)

      conn = delete_delete(conn)
      assert redirected_to(conn) == landing_path(Endpoint, :index)
      assert conn |> Session.get_current_user_id() == nil
    end

    test "requires member+", %{conn: conn} do
      conn |> assert_auth(:member, &delete_delete/1)
    end
  end
end
