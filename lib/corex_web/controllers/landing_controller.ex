defmodule CorexWeb.LandingController do
  use CorexWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
