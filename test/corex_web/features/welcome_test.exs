defmodule CorexWeb.WelcomeTest do
  use Corex.FeatureCase, async: false

  import Wallaby.Query, only: [css: 2]

  alias CorexWeb.Test.Pages

  test "go to the home page", %{session: session} do
    session
    |> Pages.Home.visit()
    |> assert_has(css("h1", text: "Coming Soon"))
  end
end
