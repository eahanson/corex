defmodule CorexWeb.ProfileController do
  use CorexWeb, :controller

  import CorexWeb.AuthGuards

  alias Corex.Accounts
  alias CorexWeb.Session

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, Session.get_current_user_role(conn)])
  end

  def show(conn, _params, role) when is_member?(role) do
    user =
      conn
      |> Session.get_current_user_id()
      |> Accounts.get_user!()

    render(conn, "show.html", user: user)
  end
end
