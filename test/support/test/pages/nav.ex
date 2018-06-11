defmodule CorexWeb.Test.Pages.Nav do
  use Wallaby.DSL

  import ExUnit.Assertions

  @navbar Query.css("nav.navbar")
  @log_in_button Query.css("a[data-role=log-in]")
  @log_out_button Query.css("a[data-role=log-out]")

  def assert_log_in_button(session) do
    session |> find(@navbar, fn navbar -> navbar |> find(@log_in_button) end) |> assert
  end

  def click_log_in(session) do
    session |> find(@navbar, fn navbar -> navbar |> click(@log_in_button) end)
  end

  def click_log_out(session) do
    session |> find(@navbar, fn navbar -> navbar |> click(@log_out_button) end)
  end
end
