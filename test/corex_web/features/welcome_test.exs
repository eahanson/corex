defmodule CorexWeb.WelcomeTest do
  use Corex.FeatureCase, async: true

  import Wallaby.Query, only: [css: 2]

  test "go to the home page", %{session: session} do
    session
    |> visit("/")
    |> assert_has(css("h1", text: "Coming Soon"))
  end
end
