defmodule CorexWeb.LandingControllerTest do
  use CorexWeb.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Corex"
  end
end
