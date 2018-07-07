defmodule CorexWeb.LandingController do
  use CorexWeb, :controller

  alias CorexWeb.Session

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, Session.get_current_user_role(conn)])
  end

  def index(conn, _params, _role) do
    render(conn, "index.html", hide_nav: true)
  end
end
