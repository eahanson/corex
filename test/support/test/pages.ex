defmodule CorexWeb.Test.Pages do
  use Wallaby.DSL

  import Corex.Test.Assertions
  import Corex.Test.FeatureHelpers
  import Wallaby.Element, only: [attr: 2]
  import Wallaby.Query, only: [css: 1]

  alias Corex.Test

  def assert_logged_in(session, expected_current_user_tid) do
    session
    |> find(css("nav.navbar [data-role=account-link]"))
    |> attr("data-tid")
    |> assert_eq(expected_current_user_tid)
  end
end
