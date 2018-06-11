defmodule CorexWeb.AuthenticatingTest do
  use Corex.FeatureCase, async: false

  alias Corex.Accounts
  alias Corex.Test.Mom
  alias CorexWeb.Test.Pages

  test "signing in", %{session: session} do
    Mom.user_attrs("new-user") |> Accounts.create_user()

    session
    |> Pages.Home.visit()
    |> Pages.Nav.click_log_in()
    |> Pages.Login.submit_form(email: "new-user@example.com", password: "password123")
    |> Pages.assert_logged_in("new-user")
    |> Pages.Nav.click_log_out()
    |> Pages.assert_logged_out()
  end

  @tag :skip
  test "sign in failure shows errors and does not log in" do
  end
end
