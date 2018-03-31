defmodule Corex.AccountsTest do
  use Corex.DataCase

  alias Corex.Accounts
  alias Corex.Extra
  alias Corex.Test.Mom

  describe "users" do
    alias Corex.Accounts.User

    test "list_users/0 returns all users" do
      "user1" |> Mom.user_attrs |> Accounts.create_user
      "user2" |> Mom.user_attrs |> Accounts.create_user
      assert Accounts.list_users() |> Extra.Enum.tids() == ~w{user1 user2}
    end

    test "get_user!/1 returns the user with given id" do
      {:ok, user} = "user1" |> Mom.user_attrs |> Accounts.create_user
      assert Accounts.get_user!(user.id).tid == "user1"
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(%{email: "foo@example.com", password: "password123"})
      assert user.email == "foo@example.com"
      assert user |> User.check_password("password123") == {:ok, user}
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(%{email: "bad", password: "short"})
      assert changeset.valid? == false
      assert changeset.errors[:email] == {"has invalid format", [validation: :format]}
    end

    test "update_user/2 with valid data updates the user" do
      {:ok, user} = Accounts.create_user(%{email: "foo@example.com", password: "password123"})
      assert {:ok, %User{} = user} = Accounts.update_user(user, %{email: "new@example.com"})
      assert user.email == "new@example.com"
    end

    test "update_user/2 with invalid data returns error changeset" do
      {:ok, user} = Accounts.create_user(%{email: "foo@example.com", password: "password123"})
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, %{email: "bad"})
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      {:ok, user} = Mom.user_attrs |> Accounts.create_user()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      {:ok, user} = Mom.user_attrs |> Accounts.create_user()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
