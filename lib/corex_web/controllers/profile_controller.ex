defmodule CorexWeb.ProfileController do
  use CorexWeb, :controller

  alias Corex.Accounts
  alias CorexWeb.Session

  def show(conn, _params) do
    user =
      conn
      |> Session.get_current_user_id()
      |> Accounts.get_user!()

    render(conn, "show.html", user: user)
  end
end
