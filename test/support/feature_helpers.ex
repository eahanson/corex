defmodule Corex.Test.FeatureHelpers do
  use Wallaby.DSL

  def save_and_open_screenshot(session) do
    new_session = take_screenshot(session)
    path = new_session.screenshots |> List.last()
    System.cmd("open", [path])
    new_session
  end

  def sos(session), do: save_and_open_screenshot(session)

  def save_and_open_page(session) do
    {:ok, path} = Briefly.create(extname: ".html")
    File.write!(path, Browser.page_source(session))
    System.cmd("open", [path])
    session
  end

  def sop(session), do: save_and_open_page(session)
end
