defmodule CorexWeb.LandingController do
  use CorexWeb, :controller

  def index(conn, _params) do
    render conn, "index.html", hide_nav: true
  end
end
