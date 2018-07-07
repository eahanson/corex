defmodule CorexWeb.ProfileControllerTest do
  use CorexWeb.ConnCase
  use Plug.Test

  import Corex.Test.Auth, only: [assert_auth: 3]

  alias Corex.Accounts
  alias Corex.Test

  describe "show profile" do
    defp get_show(conn) do
      get(conn, profile_path(conn, :show))
    end

    test "shows profile when user is logged in", %{conn: conn} do
      {:ok, user} = Test.Mom.user_attrs("test") |> Accounts.create_user()
      conn = conn |> Test.Session.login(user)
      conn = get_show(conn)
      assert html_response(conn, 200) =~ ~r|test@example.com|
    end

    test "requires member+", %{conn: conn} do
      conn |> assert_auth(:member, &get_show/1)
    end
  end
end
