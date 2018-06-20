defmodule CorexWeb.ProfileControllerTest do
  use CorexWeb.ConnCase
  use Plug.Test

  alias Corex.Accounts
  alias Corex.Test

  describe "show profile" do
    test "shows profile when user is logged in", %{conn: conn} do
      {:ok, user} = Test.Mom.user_attrs("test") |> Accounts.create_user()
      conn = conn |> Test.Session.login(user)
      conn = get(conn, profile_path(conn, :show))
      assert html_response(conn, 200) =~ ~r|test@example.com|
    end

    test "blows up when user is not logged in", %{conn: conn} do
      assert_raise ArgumentError, "cannot perform Corex.Repo.get/2 because the given value is nil", fn ->
        get(conn, profile_path(conn, :show))
      end
    end
  end
end
