defmodule CorexWeb.AuthenticatingTest do
  use Corex.FeatureCase, async: true

  alias CorexWeb.Test.Pages

  test "signing in", %{session: session} do
    session
    |> Pages.Home.visit()
    |> Pages.Home.click_log_in()
    |> Pages.Login.submit_form(email: "user@example.com", password: "password123")
#    |> Pages.assert_logged_in("user@example.com")

    # log out
  end

  @tag :skip
  test "sign in failure shows errors and does not log in" do

  end
end
