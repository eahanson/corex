defmodule Corex.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias Corex.Accounts.User

  schema "users" do
    field :encrypted_password, :string
    field :email, :string
    field :password, :string, virtual: true
    field :tid, :string

    timestamps()
  end

  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :tid])
    |> validate_required([:email, :password])
    |> put_encrypted_password()
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> unique_constraint(:email)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email, :encrypted_password])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  def check_password(%User{} = user, password) do
    user |> Comeonin.Pbkdf2.check_pass(password)
  end

  def hash_password(password) do
    Comeonin.Pbkdf2.hashpwsalt(password)
  end

  defp put_encrypted_password(changeset) do
    case get_change(changeset, :password) do
      nil ->
        changeset

      password ->
        changeset
        |> delete_change(:password)
        |> put_change(:encrypted_password, hash_password(password))
        |> validate_required([:encrypted_password])
    end
  end
end
