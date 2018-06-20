defmodule CorexWeb.SessionController do
  use CorexWeb, :controller

  alias Corex.Accounts
  alias Corex.Accounts.User
  alias CorexWeb.Session

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.get_user(email: email, password: password) do
      {:ok, user} ->
        conn
        |> Session.set_current_user(user)
        |> redirect(to: profile_path(conn, :show))

      {:error, _message} ->
        changeset = Accounts.User.unauthenticated_changeset(%{email: email, password: password})
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    conn
    |> Plug.Conn.clear_session()
    |> redirect(to: landing_path(conn, :index))
  end
end
