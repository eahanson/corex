defmodule CorexWeb.WelcomeTest do
  use Corex.FeatureCase, async: true

  import Wallaby.Query, only: [css: 2]

  alias CorexWeb.Test.Pages

  @tag :skip
  test "go to the home page", %{session: session} do
    session
    |> Pages.Home.visit()
    |> assert_has(css("h1", text: "Coming Soon"))
  end
end
