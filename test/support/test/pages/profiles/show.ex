defmodule CorexWeb.Test.Pages.Profiles.Show do
  use Wallaby.DSL

  import Corex.Test.Assertions
  import Wallaby.Element, only: [attr: 2]
  import Wallaby.Query, only: [css: 1]

  def assert_user(session, expected_user_tid) do
    session
    |> find(css("[data-role=profile-detail-table]"))
    |> attr("data-tid")
    |> assert_eq(expected_user_tid)

    session
  end
end
