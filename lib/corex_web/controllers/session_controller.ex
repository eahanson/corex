defmodule CorexWeb.SessionController do
  use CorexWeb, :controller

  alias Corex.Accounts
  alias Corex.Accounts.User

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.get_user(email: email, password: password) do
      {:ok, user} ->
        conn
        |> Plug.Conn.put_session(:current_user_id, user.id)
        |> Plug.Conn.put_session(:current_user_tid, user.tid)
        |> redirect(to: user_path(conn, :show, user))

      {:error, _message} ->
        changeset = Accounts.change_user(%User{}, %{email: email})
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    conn
    |> Plug.Conn.clear_session()
    |> redirect(to: landing_path(conn, :index))
  end
end
