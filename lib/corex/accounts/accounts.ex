defmodule Corex.Accounts do
  import Ecto.Query, warn: false
  alias Corex.Repo

  alias Corex.Accounts.User

  def list_users(), do: Repo.all(User)
  def get_user!(id), do: Repo.get!(User, id)
  def create_user(attrs \\ %{}), do: %User{} |> User.registration_changeset(attrs) |> Repo.insert()
  def update_user(%User{} = user, attrs), do: user |> User.changeset(attrs) |> Repo.update()
  def delete_user(%User{} = user), do: Repo.delete(user)
  def change_user(%User{} = user), do: User.changeset(user, %{})
end
