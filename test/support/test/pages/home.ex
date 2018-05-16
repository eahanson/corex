defmodule CorexWeb.Test.Pages.Home do
  use Wallaby.DSL

  import CorexWeb.Router.Helpers
  import Corex.Test.FeatureHelpers

  alias CorexWeb.Endpoint

  @navbar Query.css("nav.navbar")
  @log_in_button Query.css("a[data-role=log-in]")

  def visit(session) do
    session |> visit(landing_path(Endpoint, :index))
  end

  def click_log_in(session) do
    session |> find(@navbar, fn navbar -> navbar |> click(@log_in_button) end)
  end
end
