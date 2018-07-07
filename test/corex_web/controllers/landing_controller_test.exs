defmodule CorexWeb.LandingControllerTest do
  use CorexWeb.ConnCase, async: true

  import Corex.Test.Auth, only: [assert_auth: 3]

  describe "get index" do
    defp get_index(conn) do
      get(conn, "/")
    end

    test "GET /", %{conn: conn} do
      conn = get_index(conn)
      assert html_response(conn, 200) =~ "Corex"
    end

    test "allows guest+", %{conn: conn} do
      conn |> assert_auth(:guest, &get_index/1)
    end
  end
end
