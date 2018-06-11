defmodule CorexWeb.Test.Pages do
  use Wallaby.DSL

  import Corex.Test.Assertions
  import Wallaby.Element, only: [attr: 2]
  import Wallaby.Query, only: [css: 1]

  alias CorexWeb.Test.Pages

  def assert_logged_in(session, expected_current_user_tid) do
    session
    |> find(css("nav.navbar [data-role=account-link]"))
    |> attr("data-tid")
    |> assert_eq(expected_current_user_tid)

    session
  end

  def assert_logged_out(session) do
    session
    |> Pages.Nav.assert_log_in_button()

    session
  end
end
