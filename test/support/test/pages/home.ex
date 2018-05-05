defmodule CorexWeb.Test.Pages.Home do
  use Wallaby.DSL

  import CorexWeb.Router.Helpers

  alias CorexWeb.Endpoint

  def visit(session) do
    session |> visit(landing_path(Endpoint, :index))
  end

  def click_log_in(session) do
    session |> click(Query.css("[data-role=log-in]"))
  end
end
