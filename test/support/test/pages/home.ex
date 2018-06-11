defmodule CorexWeb.Test.Pages.Home do
  use Wallaby.DSL

  import CorexWeb.Router.Helpers

  alias CorexWeb.Endpoint

  def visit(session) do
    session |> visit(landing_path(Endpoint, :index))
  end
end
