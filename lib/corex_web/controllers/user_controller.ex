defmodule CorexWeb.UserController do
  use CorexWeb, :controller

  import CorexWeb.AuthGuards

  alias Corex.Accounts
  alias Corex.Accounts.User
  alias CorexWeb.Session

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, Session.get_current_user_role(conn)])
  end

  def index(conn, _params, role) when is_admin?(role) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params, _role) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}, _role) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn |> redirect(to: user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _role) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}, _role) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}, _role) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn |> redirect(to: user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _role) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn |> redirect(to: user_path(conn, :index))
  end
end
